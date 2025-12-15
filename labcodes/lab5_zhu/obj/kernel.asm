
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
ffffffffc020004a:	00097517          	auipc	a0,0x97
ffffffffc020004e:	17e50513          	addi	a0,a0,382 # ffffffffc02971c8 <buf>
ffffffffc0200052:	0009b617          	auipc	a2,0x9b
ffffffffc0200056:	62660613          	addi	a2,a2,1574 # ffffffffc029b678 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0209ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	7aa050ef          	jal	ffffffffc020580c <memset>
    dtb_init();
ffffffffc0200066:	552000ef          	jal	ffffffffc02005b8 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	4dc000ef          	jal	ffffffffc0200546 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00005597          	auipc	a1,0x5
ffffffffc0200072:	7ca58593          	addi	a1,a1,1994 # ffffffffc0205838 <etext+0x2>
ffffffffc0200076:	00005517          	auipc	a0,0x5
ffffffffc020007a:	7e250513          	addi	a0,a0,2018 # ffffffffc0205858 <etext+0x22>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	1a4000ef          	jal	ffffffffc0200226 <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	754020ef          	jal	ffffffffc02027da <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	081000ef          	jal	ffffffffc020090a <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	07f000ef          	jal	ffffffffc020090c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	241030ef          	jal	ffffffffc0203ad2 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	6c1040ef          	jal	ffffffffc0204f56 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	45a000ef          	jal	ffffffffc02004f4 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	061000ef          	jal	ffffffffc02008fe <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	054050ef          	jal	ffffffffc02050f6 <cpu_idle>

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
ffffffffc02000b6:	00005517          	auipc	a0,0x5
ffffffffc02000ba:	7aa50513          	addi	a0,a0,1962 # ffffffffc0205860 <etext+0x2a>
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
ffffffffc02000ca:	10298993          	addi	s3,s3,258 # ffffffffc02971c8 <buf>
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
ffffffffc0200144:	08850513          	addi	a0,a0,136 # ffffffffc02971c8 <buf>
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
ffffffffc0200188:	26a050ef          	jal	ffffffffc02053f2 <vprintfmt>
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
ffffffffc02001bc:	236050ef          	jal	ffffffffc02053f2 <vprintfmt>
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
ffffffffc020022c:	64050513          	addi	a0,a0,1600 # ffffffffc0205868 <etext+0x32>
{
ffffffffc0200230:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200232:	f63ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200236:	00000597          	auipc	a1,0x0
ffffffffc020023a:	e1458593          	addi	a1,a1,-492 # ffffffffc020004a <kern_init>
ffffffffc020023e:	00005517          	auipc	a0,0x5
ffffffffc0200242:	64a50513          	addi	a0,a0,1610 # ffffffffc0205888 <etext+0x52>
ffffffffc0200246:	f4fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024a:	00005597          	auipc	a1,0x5
ffffffffc020024e:	5ec58593          	addi	a1,a1,1516 # ffffffffc0205836 <etext>
ffffffffc0200252:	00005517          	auipc	a0,0x5
ffffffffc0200256:	65650513          	addi	a0,a0,1622 # ffffffffc02058a8 <etext+0x72>
ffffffffc020025a:	f3bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc020025e:	00097597          	auipc	a1,0x97
ffffffffc0200262:	f6a58593          	addi	a1,a1,-150 # ffffffffc02971c8 <buf>
ffffffffc0200266:	00005517          	auipc	a0,0x5
ffffffffc020026a:	66250513          	addi	a0,a0,1634 # ffffffffc02058c8 <etext+0x92>
ffffffffc020026e:	f27ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200272:	0009b597          	auipc	a1,0x9b
ffffffffc0200276:	40658593          	addi	a1,a1,1030 # ffffffffc029b678 <end>
ffffffffc020027a:	00005517          	auipc	a0,0x5
ffffffffc020027e:	66e50513          	addi	a0,a0,1646 # ffffffffc02058e8 <etext+0xb2>
ffffffffc0200282:	f13ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200286:	00000717          	auipc	a4,0x0
ffffffffc020028a:	dc470713          	addi	a4,a4,-572 # ffffffffc020004a <kern_init>
ffffffffc020028e:	0009b797          	auipc	a5,0x9b
ffffffffc0200292:	7e978793          	addi	a5,a5,2025 # ffffffffc029ba77 <end+0x3ff>
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
ffffffffc02002aa:	66250513          	addi	a0,a0,1634 # ffffffffc0205908 <etext+0xd2>
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
ffffffffc02002b8:	68460613          	addi	a2,a2,1668 # ffffffffc0205938 <etext+0x102>
ffffffffc02002bc:	04f00593          	li	a1,79
ffffffffc02002c0:	00005517          	auipc	a0,0x5
ffffffffc02002c4:	69050513          	addi	a0,a0,1680 # ffffffffc0205950 <etext+0x11a>
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
ffffffffc02002da:	2ba40413          	addi	s0,s0,698 # ffffffffc0207590 <commands>
ffffffffc02002de:	00007497          	auipc	s1,0x7
ffffffffc02002e2:	2fa48493          	addi	s1,s1,762 # ffffffffc02075d8 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	6410                	ld	a2,8(s0)
ffffffffc02002e8:	600c                	ld	a1,0(s0)
ffffffffc02002ea:	00005517          	auipc	a0,0x5
ffffffffc02002ee:	67e50513          	addi	a0,a0,1662 # ffffffffc0205968 <etext+0x132>
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
ffffffffc0200332:	64a50513          	addi	a0,a0,1610 # ffffffffc0205978 <etext+0x142>
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
ffffffffc020034a:	65a50513          	addi	a0,a0,1626 # ffffffffc02059a0 <etext+0x16a>
ffffffffc020034e:	e47ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc0200352:	000a0563          	beqz	s4,ffffffffc020035c <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc0200356:	8552                	mv	a0,s4
ffffffffc0200358:	79c000ef          	jal	ffffffffc0200af4 <print_trapframe>
ffffffffc020035c:	00007a97          	auipc	s5,0x7
ffffffffc0200360:	234a8a93          	addi	s5,s5,564 # ffffffffc0207590 <commands>
        if (argc == MAXARGS - 1)
ffffffffc0200364:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL)
ffffffffc0200366:	00005517          	auipc	a0,0x5
ffffffffc020036a:	66250513          	addi	a0,a0,1634 # ffffffffc02059c8 <etext+0x192>
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
ffffffffc0200388:	20c48493          	addi	s1,s1,524 # ffffffffc0207590 <commands>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020038c:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc020038e:	6582                	ld	a1,0(sp)
ffffffffc0200390:	6088                	ld	a0,0(s1)
ffffffffc0200392:	40c050ef          	jal	ffffffffc020579e <strcmp>
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
ffffffffc02003a8:	65450513          	addi	a0,a0,1620 # ffffffffc02059f8 <etext+0x1c2>
ffffffffc02003ac:	de9ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc02003b0:	bf5d                	j	ffffffffc0200366 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003b2:	00005517          	auipc	a0,0x5
ffffffffc02003b6:	61e50513          	addi	a0,a0,1566 # ffffffffc02059d0 <etext+0x19a>
ffffffffc02003ba:	440050ef          	jal	ffffffffc02057fa <strchr>
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
ffffffffc02003f8:	5dc50513          	addi	a0,a0,1500 # ffffffffc02059d0 <etext+0x19a>
ffffffffc02003fc:	3fe050ef          	jal	ffffffffc02057fa <strchr>
ffffffffc0200400:	d575                	beqz	a0,ffffffffc02003ec <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200402:	00044583          	lbu	a1,0(s0)
ffffffffc0200406:	dda5                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc0200408:	b76d                	j	ffffffffc02003b2 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020040a:	45c1                	li	a1,16
ffffffffc020040c:	00005517          	auipc	a0,0x5
ffffffffc0200410:	5cc50513          	addi	a0,a0,1484 # ffffffffc02059d8 <etext+0x1a2>
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
ffffffffc0200446:	0009b317          	auipc	t1,0x9b
ffffffffc020044a:	1aa33303          	ld	t1,426(t1) # ffffffffc029b5f0 <is_panic>
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
ffffffffc0200470:	63450513          	addi	a0,a0,1588 # ffffffffc0205aa0 <etext+0x26a>
    is_panic = 1;
ffffffffc0200474:	0009b697          	auipc	a3,0x9b
ffffffffc0200478:	16e6be23          	sd	a4,380(a3) # ffffffffc029b5f0 <is_panic>
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
ffffffffc020048e:	63650513          	addi	a0,a0,1590 # ffffffffc0205ac0 <etext+0x28a>
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
ffffffffc02004c2:	60a50513          	addi	a0,a0,1546 # ffffffffc0205ac8 <etext+0x292>
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
ffffffffc02004e4:	5e050513          	addi	a0,a0,1504 # ffffffffc0205ac0 <etext+0x28a>
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
ffffffffc02004fe:	0ef73f23          	sd	a5,254(a4) # ffffffffc029b5f8 <timebase>
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
ffffffffc020051e:	5ce50513          	addi	a0,a0,1486 # ffffffffc0205ae8 <etext+0x2b2>
    ticks = 0;
ffffffffc0200522:	0009b797          	auipc	a5,0x9b
ffffffffc0200526:	0c07bf23          	sd	zero,222(a5) # ffffffffc029b600 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020052a:	b1ad                	j	ffffffffc0200194 <cprintf>

ffffffffc020052c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020052c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200530:	0009b797          	auipc	a5,0x9b
ffffffffc0200534:	0c87b783          	ld	a5,200(a5) # ffffffffc029b5f8 <timebase>
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
ffffffffc02005be:	54e50513          	addi	a0,a0,1358 # ffffffffc0205b08 <etext+0x2d2>
void dtb_init(void) {
ffffffffc02005c2:	f406                	sd	ra,40(sp)
ffffffffc02005c4:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc02005c6:	bcfff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005ca:	0000b597          	auipc	a1,0xb
ffffffffc02005ce:	a365b583          	ld	a1,-1482(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc02005d2:	00005517          	auipc	a0,0x5
ffffffffc02005d6:	54650513          	addi	a0,a0,1350 # ffffffffc0205b18 <etext+0x2e2>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005da:	0000b417          	auipc	s0,0xb
ffffffffc02005de:	a2e40413          	addi	s0,s0,-1490 # ffffffffc020b008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005e2:	bb3ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005e6:	600c                	ld	a1,0(s0)
ffffffffc02005e8:	00005517          	auipc	a0,0x5
ffffffffc02005ec:	54050513          	addi	a0,a0,1344 # ffffffffc0205b28 <etext+0x2f2>
ffffffffc02005f0:	ba5ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005f4:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005f6:	00005517          	auipc	a0,0x5
ffffffffc02005fa:	54a50513          	addi	a0,a0,1354 # ffffffffc0205b40 <etext+0x30a>
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
ffffffffc020060e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe44875>
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
ffffffffc02006ec:	52050513          	addi	a0,a0,1312 # ffffffffc0205c08 <etext+0x3d2>
ffffffffc02006f0:	aa5ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006f4:	64e2                	ld	s1,24(sp)
ffffffffc02006f6:	6942                	ld	s2,16(sp)
ffffffffc02006f8:	00005517          	auipc	a0,0x5
ffffffffc02006fc:	54850513          	addi	a0,a0,1352 # ffffffffc0205c40 <etext+0x40a>
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
ffffffffc0200710:	45450513          	addi	a0,a0,1108 # ffffffffc0205b60 <etext+0x32a>
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
ffffffffc0200752:	006050ef          	jal	ffffffffc0205758 <strlen>
ffffffffc0200756:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200758:	4619                	li	a2,6
ffffffffc020075a:	8522                	mv	a0,s0
ffffffffc020075c:	00005597          	auipc	a1,0x5
ffffffffc0200760:	42c58593          	addi	a1,a1,1068 # ffffffffc0205b88 <etext+0x352>
ffffffffc0200764:	06e050ef          	jal	ffffffffc02057d2 <strncmp>
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
ffffffffc020078c:	40858593          	addi	a1,a1,1032 # ffffffffc0205b90 <etext+0x35a>
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
ffffffffc02007be:	7e1040ef          	jal	ffffffffc020579e <strcmp>
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
ffffffffc02007e2:	3ba50513          	addi	a0,a0,954 # ffffffffc0205b98 <etext+0x362>
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
ffffffffc02008ac:	31050513          	addi	a0,a0,784 # ffffffffc0205bb8 <etext+0x382>
ffffffffc02008b0:	8e5ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02008b4:	01445613          	srli	a2,s0,0x14
ffffffffc02008b8:	85a2                	mv	a1,s0
ffffffffc02008ba:	00005517          	auipc	a0,0x5
ffffffffc02008be:	31650513          	addi	a0,a0,790 # ffffffffc0205bd0 <etext+0x39a>
ffffffffc02008c2:	8d3ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008c6:	009405b3          	add	a1,s0,s1
ffffffffc02008ca:	15fd                	addi	a1,a1,-1
ffffffffc02008cc:	00005517          	auipc	a0,0x5
ffffffffc02008d0:	32450513          	addi	a0,a0,804 # ffffffffc0205bf0 <etext+0x3ba>
ffffffffc02008d4:	8c1ff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc02008d8:	0009b797          	auipc	a5,0x9b
ffffffffc02008dc:	d297bc23          	sd	s1,-712(a5) # ffffffffc029b610 <memory_base>
        memory_size = mem_size;
ffffffffc02008e0:	0009b797          	auipc	a5,0x9b
ffffffffc02008e4:	d287b423          	sd	s0,-728(a5) # ffffffffc029b608 <memory_size>
ffffffffc02008e8:	b531                	j	ffffffffc02006f4 <dtb_init+0x13c>

ffffffffc02008ea <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008ea:	0009b517          	auipc	a0,0x9b
ffffffffc02008ee:	d2653503          	ld	a0,-730(a0) # ffffffffc029b610 <memory_base>
ffffffffc02008f2:	8082                	ret

ffffffffc02008f4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008f4:	0009b517          	auipc	a0,0x9b
ffffffffc02008f8:	d1453503          	ld	a0,-748(a0) # ffffffffc029b608 <memory_size>
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
ffffffffc0200914:	55078793          	addi	a5,a5,1360 # ffffffffc0200e60 <__alltraps>
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
ffffffffc0200932:	32a50513          	addi	a0,a0,810 # ffffffffc0205c58 <etext+0x422>
{
ffffffffc0200936:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200938:	85dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020093c:	640c                	ld	a1,8(s0)
ffffffffc020093e:	00005517          	auipc	a0,0x5
ffffffffc0200942:	33250513          	addi	a0,a0,818 # ffffffffc0205c70 <etext+0x43a>
ffffffffc0200946:	84fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020094a:	680c                	ld	a1,16(s0)
ffffffffc020094c:	00005517          	auipc	a0,0x5
ffffffffc0200950:	33c50513          	addi	a0,a0,828 # ffffffffc0205c88 <etext+0x452>
ffffffffc0200954:	841ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200958:	6c0c                	ld	a1,24(s0)
ffffffffc020095a:	00005517          	auipc	a0,0x5
ffffffffc020095e:	34650513          	addi	a0,a0,838 # ffffffffc0205ca0 <etext+0x46a>
ffffffffc0200962:	833ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200966:	700c                	ld	a1,32(s0)
ffffffffc0200968:	00005517          	auipc	a0,0x5
ffffffffc020096c:	35050513          	addi	a0,a0,848 # ffffffffc0205cb8 <etext+0x482>
ffffffffc0200970:	825ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200974:	740c                	ld	a1,40(s0)
ffffffffc0200976:	00005517          	auipc	a0,0x5
ffffffffc020097a:	35a50513          	addi	a0,a0,858 # ffffffffc0205cd0 <etext+0x49a>
ffffffffc020097e:	817ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200982:	780c                	ld	a1,48(s0)
ffffffffc0200984:	00005517          	auipc	a0,0x5
ffffffffc0200988:	36450513          	addi	a0,a0,868 # ffffffffc0205ce8 <etext+0x4b2>
ffffffffc020098c:	809ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200990:	7c0c                	ld	a1,56(s0)
ffffffffc0200992:	00005517          	auipc	a0,0x5
ffffffffc0200996:	36e50513          	addi	a0,a0,878 # ffffffffc0205d00 <etext+0x4ca>
ffffffffc020099a:	ffaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020099e:	602c                	ld	a1,64(s0)
ffffffffc02009a0:	00005517          	auipc	a0,0x5
ffffffffc02009a4:	37850513          	addi	a0,a0,888 # ffffffffc0205d18 <etext+0x4e2>
ffffffffc02009a8:	fecff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009ac:	642c                	ld	a1,72(s0)
ffffffffc02009ae:	00005517          	auipc	a0,0x5
ffffffffc02009b2:	38250513          	addi	a0,a0,898 # ffffffffc0205d30 <etext+0x4fa>
ffffffffc02009b6:	fdeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009ba:	682c                	ld	a1,80(s0)
ffffffffc02009bc:	00005517          	auipc	a0,0x5
ffffffffc02009c0:	38c50513          	addi	a0,a0,908 # ffffffffc0205d48 <etext+0x512>
ffffffffc02009c4:	fd0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009c8:	6c2c                	ld	a1,88(s0)
ffffffffc02009ca:	00005517          	auipc	a0,0x5
ffffffffc02009ce:	39650513          	addi	a0,a0,918 # ffffffffc0205d60 <etext+0x52a>
ffffffffc02009d2:	fc2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02009d6:	702c                	ld	a1,96(s0)
ffffffffc02009d8:	00005517          	auipc	a0,0x5
ffffffffc02009dc:	3a050513          	addi	a0,a0,928 # ffffffffc0205d78 <etext+0x542>
ffffffffc02009e0:	fb4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02009e4:	742c                	ld	a1,104(s0)
ffffffffc02009e6:	00005517          	auipc	a0,0x5
ffffffffc02009ea:	3aa50513          	addi	a0,a0,938 # ffffffffc0205d90 <etext+0x55a>
ffffffffc02009ee:	fa6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02009f2:	782c                	ld	a1,112(s0)
ffffffffc02009f4:	00005517          	auipc	a0,0x5
ffffffffc02009f8:	3b450513          	addi	a0,a0,948 # ffffffffc0205da8 <etext+0x572>
ffffffffc02009fc:	f98ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a00:	7c2c                	ld	a1,120(s0)
ffffffffc0200a02:	00005517          	auipc	a0,0x5
ffffffffc0200a06:	3be50513          	addi	a0,a0,958 # ffffffffc0205dc0 <etext+0x58a>
ffffffffc0200a0a:	f8aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a0e:	604c                	ld	a1,128(s0)
ffffffffc0200a10:	00005517          	auipc	a0,0x5
ffffffffc0200a14:	3c850513          	addi	a0,a0,968 # ffffffffc0205dd8 <etext+0x5a2>
ffffffffc0200a18:	f7cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a1c:	644c                	ld	a1,136(s0)
ffffffffc0200a1e:	00005517          	auipc	a0,0x5
ffffffffc0200a22:	3d250513          	addi	a0,a0,978 # ffffffffc0205df0 <etext+0x5ba>
ffffffffc0200a26:	f6eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a2a:	684c                	ld	a1,144(s0)
ffffffffc0200a2c:	00005517          	auipc	a0,0x5
ffffffffc0200a30:	3dc50513          	addi	a0,a0,988 # ffffffffc0205e08 <etext+0x5d2>
ffffffffc0200a34:	f60ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a38:	6c4c                	ld	a1,152(s0)
ffffffffc0200a3a:	00005517          	auipc	a0,0x5
ffffffffc0200a3e:	3e650513          	addi	a0,a0,998 # ffffffffc0205e20 <etext+0x5ea>
ffffffffc0200a42:	f52ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a46:	704c                	ld	a1,160(s0)
ffffffffc0200a48:	00005517          	auipc	a0,0x5
ffffffffc0200a4c:	3f050513          	addi	a0,a0,1008 # ffffffffc0205e38 <etext+0x602>
ffffffffc0200a50:	f44ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a54:	744c                	ld	a1,168(s0)
ffffffffc0200a56:	00005517          	auipc	a0,0x5
ffffffffc0200a5a:	3fa50513          	addi	a0,a0,1018 # ffffffffc0205e50 <etext+0x61a>
ffffffffc0200a5e:	f36ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a62:	784c                	ld	a1,176(s0)
ffffffffc0200a64:	00005517          	auipc	a0,0x5
ffffffffc0200a68:	40450513          	addi	a0,a0,1028 # ffffffffc0205e68 <etext+0x632>
ffffffffc0200a6c:	f28ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a70:	7c4c                	ld	a1,184(s0)
ffffffffc0200a72:	00005517          	auipc	a0,0x5
ffffffffc0200a76:	40e50513          	addi	a0,a0,1038 # ffffffffc0205e80 <etext+0x64a>
ffffffffc0200a7a:	f1aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200a7e:	606c                	ld	a1,192(s0)
ffffffffc0200a80:	00005517          	auipc	a0,0x5
ffffffffc0200a84:	41850513          	addi	a0,a0,1048 # ffffffffc0205e98 <etext+0x662>
ffffffffc0200a88:	f0cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200a8c:	646c                	ld	a1,200(s0)
ffffffffc0200a8e:	00005517          	auipc	a0,0x5
ffffffffc0200a92:	42250513          	addi	a0,a0,1058 # ffffffffc0205eb0 <etext+0x67a>
ffffffffc0200a96:	efeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200a9a:	686c                	ld	a1,208(s0)
ffffffffc0200a9c:	00005517          	auipc	a0,0x5
ffffffffc0200aa0:	42c50513          	addi	a0,a0,1068 # ffffffffc0205ec8 <etext+0x692>
ffffffffc0200aa4:	ef0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200aa8:	6c6c                	ld	a1,216(s0)
ffffffffc0200aaa:	00005517          	auipc	a0,0x5
ffffffffc0200aae:	43650513          	addi	a0,a0,1078 # ffffffffc0205ee0 <etext+0x6aa>
ffffffffc0200ab2:	ee2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200ab6:	706c                	ld	a1,224(s0)
ffffffffc0200ab8:	00005517          	auipc	a0,0x5
ffffffffc0200abc:	44050513          	addi	a0,a0,1088 # ffffffffc0205ef8 <etext+0x6c2>
ffffffffc0200ac0:	ed4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200ac4:	746c                	ld	a1,232(s0)
ffffffffc0200ac6:	00005517          	auipc	a0,0x5
ffffffffc0200aca:	44a50513          	addi	a0,a0,1098 # ffffffffc0205f10 <etext+0x6da>
ffffffffc0200ace:	ec6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200ad2:	786c                	ld	a1,240(s0)
ffffffffc0200ad4:	00005517          	auipc	a0,0x5
ffffffffc0200ad8:	45450513          	addi	a0,a0,1108 # ffffffffc0205f28 <etext+0x6f2>
ffffffffc0200adc:	eb8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae0:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200ae2:	6402                	ld	s0,0(sp)
ffffffffc0200ae4:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae6:	00005517          	auipc	a0,0x5
ffffffffc0200aea:	45a50513          	addi	a0,a0,1114 # ffffffffc0205f40 <etext+0x70a>
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
ffffffffc0200b00:	45c50513          	addi	a0,a0,1116 # ffffffffc0205f58 <etext+0x722>
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
ffffffffc0200b18:	45c50513          	addi	a0,a0,1116 # ffffffffc0205f70 <etext+0x73a>
ffffffffc0200b1c:	e78ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b20:	10843583          	ld	a1,264(s0)
ffffffffc0200b24:	00005517          	auipc	a0,0x5
ffffffffc0200b28:	46450513          	addi	a0,a0,1124 # ffffffffc0205f88 <etext+0x752>
ffffffffc0200b2c:	e68ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200b30:	11043583          	ld	a1,272(s0)
ffffffffc0200b34:	00005517          	auipc	a0,0x5
ffffffffc0200b38:	46c50513          	addi	a0,a0,1132 # ffffffffc0205fa0 <etext+0x76a>
ffffffffc0200b3c:	e58ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b40:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b44:	6402                	ld	s0,0(sp)
ffffffffc0200b46:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b48:	00005517          	auipc	a0,0x5
ffffffffc0200b4c:	46850513          	addi	a0,a0,1128 # ffffffffc0205fb0 <etext+0x77a>
}
ffffffffc0200b50:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b52:	e42ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b56 <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200b56:	11853783          	ld	a5,280(a0)
ffffffffc0200b5a:	472d                	li	a4,11
ffffffffc0200b5c:	0786                	slli	a5,a5,0x1
ffffffffc0200b5e:	8385                	srli	a5,a5,0x1
ffffffffc0200b60:	0af76663          	bltu	a4,a5,ffffffffc0200c0c <interrupt_handler+0xb6>
ffffffffc0200b64:	00007717          	auipc	a4,0x7
ffffffffc0200b68:	a7470713          	addi	a4,a4,-1420 # ffffffffc02075d8 <commands+0x48>
ffffffffc0200b6c:	078a                	slli	a5,a5,0x2
ffffffffc0200b6e:	97ba                	add	a5,a5,a4
ffffffffc0200b70:	439c                	lw	a5,0(a5)
ffffffffc0200b72:	97ba                	add	a5,a5,a4
ffffffffc0200b74:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	4b250513          	addi	a0,a0,1202 # ffffffffc0206028 <etext+0x7f2>
ffffffffc0200b7e:	e16ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200b82:	00005517          	auipc	a0,0x5
ffffffffc0200b86:	48650513          	addi	a0,a0,1158 # ffffffffc0206008 <etext+0x7d2>
ffffffffc0200b8a:	e0aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200b8e:	00005517          	auipc	a0,0x5
ffffffffc0200b92:	43a50513          	addi	a0,a0,1082 # ffffffffc0205fc8 <etext+0x792>
ffffffffc0200b96:	dfeff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200b9a:	00005517          	auipc	a0,0x5
ffffffffc0200b9e:	44e50513          	addi	a0,a0,1102 # ffffffffc0205fe8 <etext+0x7b2>
ffffffffc0200ba2:	df2ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200ba6:	1141                	addi	sp,sp,-16
ffffffffc0200ba8:	e406                	sd	ra,8(sp)
        break;
    case IRQ_U_TIMER:
        cprintf("User software interrupt\n");
        break;
    case IRQ_S_TIMER:{
        clock_set_next_event();   // 设定下次时钟中断
ffffffffc0200baa:	983ff0ef          	jal	ffffffffc020052c <clock_set_next_event>
        static int ticks = 0;
        static int num = 0;
        ticks++;
ffffffffc0200bae:	0009b697          	auipc	a3,0x9b
ffffffffc0200bb2:	a6e6a683          	lw	a3,-1426(a3) # ffffffffc029b61c <ticks.1>
ffffffffc0200bb6:	c28f6737          	lui	a4,0xc28f6
ffffffffc0200bba:	c297071b          	addiw	a4,a4,-983 # ffffffffc28f5c29 <end+0x265a5b1>
ffffffffc0200bbe:	2685                	addiw	a3,a3,1
ffffffffc0200bc0:	02d7073b          	mulw	a4,a4,a3
ffffffffc0200bc4:	051ec7b7          	lui	a5,0x51ec
ffffffffc0200bc8:	8507879b          	addiw	a5,a5,-1968 # 51eb850 <_binary_obj___user_exit_out_size+0x51e1698>
ffffffffc0200bcc:	0009b597          	auipc	a1,0x9b
ffffffffc0200bd0:	a4d5a823          	sw	a3,-1456(a1) # ffffffffc029b61c <ticks.1>

        if (ticks % TICK_NUM == 0) {  // 每100次打印一次
ffffffffc0200bd4:	028f66b7          	lui	a3,0x28f6
ffffffffc0200bd8:	c2868693          	addi	a3,a3,-984 # 28f5c28 <_binary_obj___user_exit_out_size+0x28eba70>
        ticks++;
ffffffffc0200bdc:	9fb9                	addw	a5,a5,a4
ffffffffc0200bde:	0027d71b          	srliw	a4,a5,0x2
ffffffffc0200be2:	01e7979b          	slliw	a5,a5,0x1e
ffffffffc0200be6:	9fb9                	addw	a5,a5,a4
        if (ticks % TICK_NUM == 0) {  // 每100次打印一次
ffffffffc0200be8:	02f6f363          	bgeu	a3,a5,ffffffffc0200c0e <interrupt_handler+0xb8>
        print_ticks();
        num++;
        }

        if (num == 10) {              // 打印10次后关机
ffffffffc0200bec:	0009b717          	auipc	a4,0x9b
ffffffffc0200bf0:	a2c72703          	lw	a4,-1492(a4) # ffffffffc029b618 <num.0>
ffffffffc0200bf4:	47a9                	li	a5,10
ffffffffc0200bf6:	04f70063          	beq	a4,a5,ffffffffc0200c36 <interrupt_handler+0xe0>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200bfa:	60a2                	ld	ra,8(sp)
ffffffffc0200bfc:	0141                	addi	sp,sp,16
ffffffffc0200bfe:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c00:	00005517          	auipc	a0,0x5
ffffffffc0200c04:	45850513          	addi	a0,a0,1112 # ffffffffc0206058 <etext+0x822>
ffffffffc0200c08:	d8cff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c0c:	b5e5                	j	ffffffffc0200af4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c0e:	06400593          	li	a1,100
ffffffffc0200c12:	00005517          	auipc	a0,0x5
ffffffffc0200c16:	43650513          	addi	a0,a0,1078 # ffffffffc0206048 <etext+0x812>
ffffffffc0200c1a:	d7aff0ef          	jal	ffffffffc0200194 <cprintf>
        num++;
ffffffffc0200c1e:	0009b797          	auipc	a5,0x9b
ffffffffc0200c22:	9fa7a783          	lw	a5,-1542(a5) # ffffffffc029b618 <num.0>
        if (num == 10) {              // 打印10次后关机
ffffffffc0200c26:	4729                	li	a4,10
        num++;
ffffffffc0200c28:	2785                	addiw	a5,a5,1
ffffffffc0200c2a:	0009b697          	auipc	a3,0x9b
ffffffffc0200c2e:	9ef6a723          	sw	a5,-1554(a3) # ffffffffc029b618 <num.0>
        if (num == 10) {              // 打印10次后关机
ffffffffc0200c32:	00e79863          	bne	a5,a4,ffffffffc0200c42 <interrupt_handler+0xec>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200c36:	4501                	li	a0,0
ffffffffc0200c38:	4581                	li	a1,0
ffffffffc0200c3a:	4601                	li	a2,0
ffffffffc0200c3c:	48a1                	li	a7,8
ffffffffc0200c3e:	00000073          	ecall
}
ffffffffc0200c42:	0009b797          	auipc	a5,0x9b
ffffffffc0200c46:	9da7a783          	lw	a5,-1574(a5) # ffffffffc029b61c <ticks.1>
ffffffffc0200c4a:	c28f6737          	lui	a4,0xc28f6
ffffffffc0200c4e:	c297071b          	addiw	a4,a4,-983 # ffffffffc28f5c29 <end+0x265a5b1>
ffffffffc0200c52:	02f7073b          	mulw	a4,a4,a5
ffffffffc0200c56:	051ec7b7          	lui	a5,0x51ec
ffffffffc0200c5a:	8507879b          	addiw	a5,a5,-1968 # 51eb850 <_binary_obj___user_exit_out_size+0x51e1698>
        if (ticks % 100 == 0 && current) {
ffffffffc0200c5e:	028f66b7          	lui	a3,0x28f6
ffffffffc0200c62:	c2868693          	addi	a3,a3,-984 # 28f5c28 <_binary_obj___user_exit_out_size+0x28eba70>
ffffffffc0200c66:	9fb9                	addw	a5,a5,a4
ffffffffc0200c68:	0027d71b          	srliw	a4,a5,0x2
ffffffffc0200c6c:	01e7979b          	slliw	a5,a5,0x1e
ffffffffc0200c70:	9fb9                	addw	a5,a5,a4
ffffffffc0200c72:	f8f6e4e3          	bltu	a3,a5,ffffffffc0200bfa <interrupt_handler+0xa4>
ffffffffc0200c76:	0009b797          	auipc	a5,0x9b
ffffffffc0200c7a:	9ea7b783          	ld	a5,-1558(a5) # ffffffffc029b660 <current>
ffffffffc0200c7e:	dfb5                	beqz	a5,ffffffffc0200bfa <interrupt_handler+0xa4>
            current->need_resched = 1;
ffffffffc0200c80:	4705                	li	a4,1
ffffffffc0200c82:	ef98                	sd	a4,24(a5)
ffffffffc0200c84:	bf9d                	j	ffffffffc0200bfa <interrupt_handler+0xa4>

ffffffffc0200c86 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c86:	11853783          	ld	a5,280(a0)
ffffffffc0200c8a:	473d                	li	a4,15
ffffffffc0200c8c:	14f76763          	bltu	a4,a5,ffffffffc0200dda <exception_handler+0x154>
ffffffffc0200c90:	00007717          	auipc	a4,0x7
ffffffffc0200c94:	97870713          	addi	a4,a4,-1672 # ffffffffc0207608 <commands+0x78>
ffffffffc0200c98:	078a                	slli	a5,a5,0x2
ffffffffc0200c9a:	97ba                	add	a5,a5,a4
ffffffffc0200c9c:	439c                	lw	a5,0(a5)
{
ffffffffc0200c9e:	1101                	addi	sp,sp,-32
ffffffffc0200ca0:	ec06                	sd	ra,24(sp)
    switch (tf->cause)
ffffffffc0200ca2:	97ba                	add	a5,a5,a4
ffffffffc0200ca4:	86aa                	mv	a3,a0
ffffffffc0200ca6:	8782                	jr	a5
ffffffffc0200ca8:	e42a                	sd	a0,8(sp)
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200caa:	00005517          	auipc	a0,0x5
ffffffffc0200cae:	4b650513          	addi	a0,a0,1206 # ffffffffc0206160 <etext+0x92a>
ffffffffc0200cb2:	ce2ff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cb6:	66a2                	ld	a3,8(sp)
ffffffffc0200cb8:	1086b783          	ld	a5,264(a3)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cbc:	60e2                	ld	ra,24(sp)
        tf->epc += 4;
ffffffffc0200cbe:	0791                	addi	a5,a5,4
ffffffffc0200cc0:	10f6b423          	sd	a5,264(a3)
}
ffffffffc0200cc4:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200cc6:	6340406f          	j	ffffffffc02052fa <syscall>
}
ffffffffc0200cca:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200ccc:	00005517          	auipc	a0,0x5
ffffffffc0200cd0:	4b450513          	addi	a0,a0,1204 # ffffffffc0206180 <etext+0x94a>
}
ffffffffc0200cd4:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200cd6:	cbeff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cda:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200cdc:	00005517          	auipc	a0,0x5
ffffffffc0200ce0:	4c450513          	addi	a0,a0,1220 # ffffffffc02061a0 <etext+0x96a>
}
ffffffffc0200ce4:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200ce6:	caeff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cea:	60e2                	ld	ra,24(sp)
        cprintf("Instruction page fault\n");
ffffffffc0200cec:	00005517          	auipc	a0,0x5
ffffffffc0200cf0:	4d450513          	addi	a0,a0,1236 # ffffffffc02061c0 <etext+0x98a>
}
ffffffffc0200cf4:	6105                	addi	sp,sp,32
        cprintf("Instruction page fault\n");
ffffffffc0200cf6:	c9eff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cfa:	60e2                	ld	ra,24(sp)
        cprintf("Load page fault\n");
ffffffffc0200cfc:	00005517          	auipc	a0,0x5
ffffffffc0200d00:	4dc50513          	addi	a0,a0,1244 # ffffffffc02061d8 <etext+0x9a2>
}
ffffffffc0200d04:	6105                	addi	sp,sp,32
        cprintf("Load page fault\n");
ffffffffc0200d06:	c8eff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d0a:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO page fault\n");
ffffffffc0200d0c:	00005517          	auipc	a0,0x5
ffffffffc0200d10:	4e450513          	addi	a0,a0,1252 # ffffffffc02061f0 <etext+0x9ba>
}
ffffffffc0200d14:	6105                	addi	sp,sp,32
        cprintf("Store/AMO page fault\n");
ffffffffc0200d16:	c7eff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d1a:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200d1c:	00005517          	auipc	a0,0x5
ffffffffc0200d20:	35c50513          	addi	a0,a0,860 # ffffffffc0206078 <etext+0x842>
}
ffffffffc0200d24:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200d26:	c6eff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d2a:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200d2c:	00005517          	auipc	a0,0x5
ffffffffc0200d30:	36c50513          	addi	a0,a0,876 # ffffffffc0206098 <etext+0x862>
}
ffffffffc0200d34:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200d36:	c5eff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d3a:	60e2                	ld	ra,24(sp)
        cprintf("Illegal instruction\n");
ffffffffc0200d3c:	00005517          	auipc	a0,0x5
ffffffffc0200d40:	37c50513          	addi	a0,a0,892 # ffffffffc02060b8 <etext+0x882>
}
ffffffffc0200d44:	6105                	addi	sp,sp,32
        cprintf("Illegal instruction\n");
ffffffffc0200d46:	c4eff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200d4a:	e42a                	sd	a0,8(sp)
        cprintf("Breakpoint\n");
ffffffffc0200d4c:	00005517          	auipc	a0,0x5
ffffffffc0200d50:	38450513          	addi	a0,a0,900 # ffffffffc02060d0 <etext+0x89a>
ffffffffc0200d54:	c40ff0ef          	jal	ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d58:	66a2                	ld	a3,8(sp)
ffffffffc0200d5a:	47a9                	li	a5,10
ffffffffc0200d5c:	66d8                	ld	a4,136(a3)
ffffffffc0200d5e:	04f70c63          	beq	a4,a5,ffffffffc0200db6 <exception_handler+0x130>
}
ffffffffc0200d62:	60e2                	ld	ra,24(sp)
ffffffffc0200d64:	6105                	addi	sp,sp,32
ffffffffc0200d66:	8082                	ret
ffffffffc0200d68:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200d6a:	00005517          	auipc	a0,0x5
ffffffffc0200d6e:	37650513          	addi	a0,a0,886 # ffffffffc02060e0 <etext+0x8aa>
}
ffffffffc0200d72:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200d74:	c20ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d78:	60e2                	ld	ra,24(sp)
        cprintf("Load access fault\n");
ffffffffc0200d7a:	00005517          	auipc	a0,0x5
ffffffffc0200d7e:	38650513          	addi	a0,a0,902 # ffffffffc0206100 <etext+0x8ca>
}
ffffffffc0200d82:	6105                	addi	sp,sp,32
        cprintf("Load access fault\n");
ffffffffc0200d84:	c10ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d88:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO access fault\n");
ffffffffc0200d8a:	00005517          	auipc	a0,0x5
ffffffffc0200d8e:	3be50513          	addi	a0,a0,958 # ffffffffc0206148 <etext+0x912>
}
ffffffffc0200d92:	6105                	addi	sp,sp,32
        cprintf("Store/AMO access fault\n");
ffffffffc0200d94:	c00ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d98:	60e2                	ld	ra,24(sp)
ffffffffc0200d9a:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200d9c:	bba1                	j	ffffffffc0200af4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d9e:	00005617          	auipc	a2,0x5
ffffffffc0200da2:	37a60613          	addi	a2,a2,890 # ffffffffc0206118 <etext+0x8e2>
ffffffffc0200da6:	0ca00593          	li	a1,202
ffffffffc0200daa:	00005517          	auipc	a0,0x5
ffffffffc0200dae:	38650513          	addi	a0,a0,902 # ffffffffc0206130 <etext+0x8fa>
ffffffffc0200db2:	e94ff0ef          	jal	ffffffffc0200446 <__panic>
            tf->epc += 4;
ffffffffc0200db6:	1086b783          	ld	a5,264(a3)
ffffffffc0200dba:	0791                	addi	a5,a5,4
ffffffffc0200dbc:	10f6b423          	sd	a5,264(a3)
            syscall();
ffffffffc0200dc0:	53a040ef          	jal	ffffffffc02052fa <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dc4:	0009b717          	auipc	a4,0x9b
ffffffffc0200dc8:	89c73703          	ld	a4,-1892(a4) # ffffffffc029b660 <current>
ffffffffc0200dcc:	6522                	ld	a0,8(sp)
}
ffffffffc0200dce:	60e2                	ld	ra,24(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dd0:	6b0c                	ld	a1,16(a4)
ffffffffc0200dd2:	6789                	lui	a5,0x2
ffffffffc0200dd4:	95be                	add	a1,a1,a5
}
ffffffffc0200dd6:	6105                	addi	sp,sp,32
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dd8:	aa99                	j	ffffffffc0200f2e <kernel_execve_ret>
        print_trapframe(tf);
ffffffffc0200dda:	bb29                	j	ffffffffc0200af4 <print_trapframe>

ffffffffc0200ddc <trap>:
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200ddc:	0009b717          	auipc	a4,0x9b
ffffffffc0200de0:	88473703          	ld	a4,-1916(a4) # ffffffffc029b660 <current>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200de4:	11853583          	ld	a1,280(a0)
    if (current == NULL)
ffffffffc0200de8:	cf21                	beqz	a4,ffffffffc0200e40 <trap+0x64>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dea:	10053603          	ld	a2,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200dee:	0a073803          	ld	a6,160(a4)
{
ffffffffc0200df2:	1101                	addi	sp,sp,-32
ffffffffc0200df4:	ec06                	sd	ra,24(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200df6:	10067613          	andi	a2,a2,256
        current->tf = tf;
ffffffffc0200dfa:	f348                	sd	a0,160(a4)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dfc:	e432                	sd	a2,8(sp)
ffffffffc0200dfe:	e042                	sd	a6,0(sp)
ffffffffc0200e00:	0205c763          	bltz	a1,ffffffffc0200e2e <trap+0x52>
        exception_handler(tf);
ffffffffc0200e04:	e83ff0ef          	jal	ffffffffc0200c86 <exception_handler>
ffffffffc0200e08:	6622                	ld	a2,8(sp)
ffffffffc0200e0a:	6802                	ld	a6,0(sp)
ffffffffc0200e0c:	0009b697          	auipc	a3,0x9b
ffffffffc0200e10:	85468693          	addi	a3,a3,-1964 # ffffffffc029b660 <current>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200e14:	6298                	ld	a4,0(a3)
ffffffffc0200e16:	0b073023          	sd	a6,160(a4)
        if (!in_kernel)
ffffffffc0200e1a:	e619                	bnez	a2,ffffffffc0200e28 <trap+0x4c>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e1c:	0b072783          	lw	a5,176(a4)
ffffffffc0200e20:	8b85                	andi	a5,a5,1
ffffffffc0200e22:	e79d                	bnez	a5,ffffffffc0200e50 <trap+0x74>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e24:	6f1c                	ld	a5,24(a4)
ffffffffc0200e26:	e38d                	bnez	a5,ffffffffc0200e48 <trap+0x6c>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e28:	60e2                	ld	ra,24(sp)
ffffffffc0200e2a:	6105                	addi	sp,sp,32
ffffffffc0200e2c:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e2e:	d29ff0ef          	jal	ffffffffc0200b56 <interrupt_handler>
ffffffffc0200e32:	6802                	ld	a6,0(sp)
ffffffffc0200e34:	6622                	ld	a2,8(sp)
ffffffffc0200e36:	0009b697          	auipc	a3,0x9b
ffffffffc0200e3a:	82a68693          	addi	a3,a3,-2006 # ffffffffc029b660 <current>
ffffffffc0200e3e:	bfd9                	j	ffffffffc0200e14 <trap+0x38>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e40:	0005c363          	bltz	a1,ffffffffc0200e46 <trap+0x6a>
        exception_handler(tf);
ffffffffc0200e44:	b589                	j	ffffffffc0200c86 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200e46:	bb01                	j	ffffffffc0200b56 <interrupt_handler>
}
ffffffffc0200e48:	60e2                	ld	ra,24(sp)
ffffffffc0200e4a:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e4c:	3c20406f          	j	ffffffffc020520e <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e50:	555d                	li	a0,-9
ffffffffc0200e52:	67c030ef          	jal	ffffffffc02044ce <do_exit>
            if (current->need_resched)
ffffffffc0200e56:	0009b717          	auipc	a4,0x9b
ffffffffc0200e5a:	80a73703          	ld	a4,-2038(a4) # ffffffffc029b660 <current>
ffffffffc0200e5e:	b7d9                	j	ffffffffc0200e24 <trap+0x48>

ffffffffc0200e60 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e60:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e64:	00011463          	bnez	sp,ffffffffc0200e6c <__alltraps+0xc>
ffffffffc0200e68:	14002173          	csrr	sp,sscratch
ffffffffc0200e6c:	712d                	addi	sp,sp,-288
ffffffffc0200e6e:	e002                	sd	zero,0(sp)
ffffffffc0200e70:	e406                	sd	ra,8(sp)
ffffffffc0200e72:	ec0e                	sd	gp,24(sp)
ffffffffc0200e74:	f012                	sd	tp,32(sp)
ffffffffc0200e76:	f416                	sd	t0,40(sp)
ffffffffc0200e78:	f81a                	sd	t1,48(sp)
ffffffffc0200e7a:	fc1e                	sd	t2,56(sp)
ffffffffc0200e7c:	e0a2                	sd	s0,64(sp)
ffffffffc0200e7e:	e4a6                	sd	s1,72(sp)
ffffffffc0200e80:	e8aa                	sd	a0,80(sp)
ffffffffc0200e82:	ecae                	sd	a1,88(sp)
ffffffffc0200e84:	f0b2                	sd	a2,96(sp)
ffffffffc0200e86:	f4b6                	sd	a3,104(sp)
ffffffffc0200e88:	f8ba                	sd	a4,112(sp)
ffffffffc0200e8a:	fcbe                	sd	a5,120(sp)
ffffffffc0200e8c:	e142                	sd	a6,128(sp)
ffffffffc0200e8e:	e546                	sd	a7,136(sp)
ffffffffc0200e90:	e94a                	sd	s2,144(sp)
ffffffffc0200e92:	ed4e                	sd	s3,152(sp)
ffffffffc0200e94:	f152                	sd	s4,160(sp)
ffffffffc0200e96:	f556                	sd	s5,168(sp)
ffffffffc0200e98:	f95a                	sd	s6,176(sp)
ffffffffc0200e9a:	fd5e                	sd	s7,184(sp)
ffffffffc0200e9c:	e1e2                	sd	s8,192(sp)
ffffffffc0200e9e:	e5e6                	sd	s9,200(sp)
ffffffffc0200ea0:	e9ea                	sd	s10,208(sp)
ffffffffc0200ea2:	edee                	sd	s11,216(sp)
ffffffffc0200ea4:	f1f2                	sd	t3,224(sp)
ffffffffc0200ea6:	f5f6                	sd	t4,232(sp)
ffffffffc0200ea8:	f9fa                	sd	t5,240(sp)
ffffffffc0200eaa:	fdfe                	sd	t6,248(sp)
ffffffffc0200eac:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200eb0:	100024f3          	csrr	s1,sstatus
ffffffffc0200eb4:	14102973          	csrr	s2,sepc
ffffffffc0200eb8:	143029f3          	csrr	s3,stval
ffffffffc0200ebc:	14202a73          	csrr	s4,scause
ffffffffc0200ec0:	e822                	sd	s0,16(sp)
ffffffffc0200ec2:	e226                	sd	s1,256(sp)
ffffffffc0200ec4:	e64a                	sd	s2,264(sp)
ffffffffc0200ec6:	ea4e                	sd	s3,272(sp)
ffffffffc0200ec8:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200eca:	850a                	mv	a0,sp
    jal trap
ffffffffc0200ecc:	f11ff0ef          	jal	ffffffffc0200ddc <trap>

ffffffffc0200ed0 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200ed0:	6492                	ld	s1,256(sp)
ffffffffc0200ed2:	6932                	ld	s2,264(sp)
ffffffffc0200ed4:	1004f413          	andi	s0,s1,256
ffffffffc0200ed8:	e401                	bnez	s0,ffffffffc0200ee0 <__trapret+0x10>
ffffffffc0200eda:	1200                	addi	s0,sp,288
ffffffffc0200edc:	14041073          	csrw	sscratch,s0
ffffffffc0200ee0:	10049073          	csrw	sstatus,s1
ffffffffc0200ee4:	14191073          	csrw	sepc,s2
ffffffffc0200ee8:	60a2                	ld	ra,8(sp)
ffffffffc0200eea:	61e2                	ld	gp,24(sp)
ffffffffc0200eec:	7202                	ld	tp,32(sp)
ffffffffc0200eee:	72a2                	ld	t0,40(sp)
ffffffffc0200ef0:	7342                	ld	t1,48(sp)
ffffffffc0200ef2:	73e2                	ld	t2,56(sp)
ffffffffc0200ef4:	6406                	ld	s0,64(sp)
ffffffffc0200ef6:	64a6                	ld	s1,72(sp)
ffffffffc0200ef8:	6546                	ld	a0,80(sp)
ffffffffc0200efa:	65e6                	ld	a1,88(sp)
ffffffffc0200efc:	7606                	ld	a2,96(sp)
ffffffffc0200efe:	76a6                	ld	a3,104(sp)
ffffffffc0200f00:	7746                	ld	a4,112(sp)
ffffffffc0200f02:	77e6                	ld	a5,120(sp)
ffffffffc0200f04:	680a                	ld	a6,128(sp)
ffffffffc0200f06:	68aa                	ld	a7,136(sp)
ffffffffc0200f08:	694a                	ld	s2,144(sp)
ffffffffc0200f0a:	69ea                	ld	s3,152(sp)
ffffffffc0200f0c:	7a0a                	ld	s4,160(sp)
ffffffffc0200f0e:	7aaa                	ld	s5,168(sp)
ffffffffc0200f10:	7b4a                	ld	s6,176(sp)
ffffffffc0200f12:	7bea                	ld	s7,184(sp)
ffffffffc0200f14:	6c0e                	ld	s8,192(sp)
ffffffffc0200f16:	6cae                	ld	s9,200(sp)
ffffffffc0200f18:	6d4e                	ld	s10,208(sp)
ffffffffc0200f1a:	6dee                	ld	s11,216(sp)
ffffffffc0200f1c:	7e0e                	ld	t3,224(sp)
ffffffffc0200f1e:	7eae                	ld	t4,232(sp)
ffffffffc0200f20:	7f4e                	ld	t5,240(sp)
ffffffffc0200f22:	7fee                	ld	t6,248(sp)
ffffffffc0200f24:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f26:	10200073          	sret

ffffffffc0200f2a <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f2a:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200f2c:	b755                	j	ffffffffc0200ed0 <__trapret>

ffffffffc0200f2e <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200f2e:	ee058593          	addi	a1,a1,-288

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200f32:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f36:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f3a:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f3e:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f42:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f46:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f4a:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f4e:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f52:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f54:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f56:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f58:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f5a:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f5c:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f5e:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f60:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f62:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f64:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f66:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f68:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f6a:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f6c:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f6e:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f70:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f72:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f74:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f76:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f78:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f7a:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f7c:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f7e:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f80:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f82:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f84:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f86:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f88:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f8a:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200f8c:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200f8e:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200f90:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200f92:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200f94:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200f96:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200f98:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200f9a:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200f9c:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200f9e:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200fa0:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200fa2:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200fa4:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200fa6:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200fa8:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200faa:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200fac:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200fae:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200fb0:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200fb2:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200fb4:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200fb6:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200fb8:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200fba:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200fbc:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200fbe:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200fc0:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200fc2:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200fc4:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200fc6:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200fc8:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200fca:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200fcc:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200fce:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200fd0:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200fd2:	812e                	mv	sp,a1
ffffffffc0200fd4:	bdf5                	j	ffffffffc0200ed0 <__trapret>

ffffffffc0200fd6 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200fd6:	00096797          	auipc	a5,0x96
ffffffffc0200fda:	5f278793          	addi	a5,a5,1522 # ffffffffc02975c8 <free_area>
ffffffffc0200fde:	e79c                	sd	a5,8(a5)
ffffffffc0200fe0:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200fe2:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200fe6:	8082                	ret

ffffffffc0200fe8 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200fe8:	00096517          	auipc	a0,0x96
ffffffffc0200fec:	5f056503          	lwu	a0,1520(a0) # ffffffffc02975d8 <free_area+0x10>
ffffffffc0200ff0:	8082                	ret

ffffffffc0200ff2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200ff2:	711d                	addi	sp,sp,-96
ffffffffc0200ff4:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200ff6:	00096917          	auipc	s2,0x96
ffffffffc0200ffa:	5d290913          	addi	s2,s2,1490 # ffffffffc02975c8 <free_area>
ffffffffc0200ffe:	00893783          	ld	a5,8(s2)
ffffffffc0201002:	ec86                	sd	ra,88(sp)
ffffffffc0201004:	e8a2                	sd	s0,80(sp)
ffffffffc0201006:	e4a6                	sd	s1,72(sp)
ffffffffc0201008:	fc4e                	sd	s3,56(sp)
ffffffffc020100a:	f852                	sd	s4,48(sp)
ffffffffc020100c:	f456                	sd	s5,40(sp)
ffffffffc020100e:	f05a                	sd	s6,32(sp)
ffffffffc0201010:	ec5e                	sd	s7,24(sp)
ffffffffc0201012:	e862                	sd	s8,16(sp)
ffffffffc0201014:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201016:	2f278363          	beq	a5,s2,ffffffffc02012fc <default_check+0x30a>
    int count = 0, total = 0;
ffffffffc020101a:	4401                	li	s0,0
ffffffffc020101c:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020101e:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201022:	8b09                	andi	a4,a4,2
ffffffffc0201024:	2e070063          	beqz	a4,ffffffffc0201304 <default_check+0x312>
        count++, total += p->property;
ffffffffc0201028:	ff87a703          	lw	a4,-8(a5)
ffffffffc020102c:	679c                	ld	a5,8(a5)
ffffffffc020102e:	2485                	addiw	s1,s1,1
ffffffffc0201030:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201032:	ff2796e3          	bne	a5,s2,ffffffffc020101e <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0201036:	89a2                	mv	s3,s0
ffffffffc0201038:	741000ef          	jal	ffffffffc0201f78 <nr_free_pages>
ffffffffc020103c:	73351463          	bne	a0,s3,ffffffffc0201764 <default_check+0x772>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201040:	4505                	li	a0,1
ffffffffc0201042:	6c5000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc0201046:	8a2a                	mv	s4,a0
ffffffffc0201048:	44050e63          	beqz	a0,ffffffffc02014a4 <default_check+0x4b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020104c:	4505                	li	a0,1
ffffffffc020104e:	6b9000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc0201052:	89aa                	mv	s3,a0
ffffffffc0201054:	72050863          	beqz	a0,ffffffffc0201784 <default_check+0x792>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201058:	4505                	li	a0,1
ffffffffc020105a:	6ad000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc020105e:	8aaa                	mv	s5,a0
ffffffffc0201060:	4c050263          	beqz	a0,ffffffffc0201524 <default_check+0x532>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201064:	40a987b3          	sub	a5,s3,a0
ffffffffc0201068:	40aa0733          	sub	a4,s4,a0
ffffffffc020106c:	0017b793          	seqz	a5,a5
ffffffffc0201070:	00173713          	seqz	a4,a4
ffffffffc0201074:	8fd9                	or	a5,a5,a4
ffffffffc0201076:	30079763          	bnez	a5,ffffffffc0201384 <default_check+0x392>
ffffffffc020107a:	313a0563          	beq	s4,s3,ffffffffc0201384 <default_check+0x392>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020107e:	000a2783          	lw	a5,0(s4)
ffffffffc0201082:	2a079163          	bnez	a5,ffffffffc0201324 <default_check+0x332>
ffffffffc0201086:	0009a783          	lw	a5,0(s3)
ffffffffc020108a:	28079d63          	bnez	a5,ffffffffc0201324 <default_check+0x332>
ffffffffc020108e:	411c                	lw	a5,0(a0)
ffffffffc0201090:	28079a63          	bnez	a5,ffffffffc0201324 <default_check+0x332>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201094:	0009a797          	auipc	a5,0x9a
ffffffffc0201098:	5bc7b783          	ld	a5,1468(a5) # ffffffffc029b650 <pages>
ffffffffc020109c:	00007617          	auipc	a2,0x7
ffffffffc02010a0:	90463603          	ld	a2,-1788(a2) # ffffffffc02079a0 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02010a4:	0009a697          	auipc	a3,0x9a
ffffffffc02010a8:	5a46b683          	ld	a3,1444(a3) # ffffffffc029b648 <npage>
ffffffffc02010ac:	40fa0733          	sub	a4,s4,a5
ffffffffc02010b0:	8719                	srai	a4,a4,0x6
ffffffffc02010b2:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc02010b4:	0732                	slli	a4,a4,0xc
ffffffffc02010b6:	06b2                	slli	a3,a3,0xc
ffffffffc02010b8:	2ad77663          	bgeu	a4,a3,ffffffffc0201364 <default_check+0x372>
    return page - pages + nbase;
ffffffffc02010bc:	40f98733          	sub	a4,s3,a5
ffffffffc02010c0:	8719                	srai	a4,a4,0x6
ffffffffc02010c2:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010c4:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02010c6:	4cd77f63          	bgeu	a4,a3,ffffffffc02015a4 <default_check+0x5b2>
    return page - pages + nbase;
ffffffffc02010ca:	40f507b3          	sub	a5,a0,a5
ffffffffc02010ce:	8799                	srai	a5,a5,0x6
ffffffffc02010d0:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010d2:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02010d4:	32d7f863          	bgeu	a5,a3,ffffffffc0201404 <default_check+0x412>
    assert(alloc_page() == NULL);
ffffffffc02010d8:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010da:	00093c03          	ld	s8,0(s2)
ffffffffc02010de:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc02010e2:	00096b17          	auipc	s6,0x96
ffffffffc02010e6:	4f6b2b03          	lw	s6,1270(s6) # ffffffffc02975d8 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc02010ea:	01293023          	sd	s2,0(s2)
ffffffffc02010ee:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc02010f2:	00096797          	auipc	a5,0x96
ffffffffc02010f6:	4e07a323          	sw	zero,1254(a5) # ffffffffc02975d8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010fa:	60d000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc02010fe:	2e051363          	bnez	a0,ffffffffc02013e4 <default_check+0x3f2>
    free_page(p0);
ffffffffc0201102:	8552                	mv	a0,s4
ffffffffc0201104:	4585                	li	a1,1
ffffffffc0201106:	63b000ef          	jal	ffffffffc0201f40 <free_pages>
    free_page(p1);
ffffffffc020110a:	854e                	mv	a0,s3
ffffffffc020110c:	4585                	li	a1,1
ffffffffc020110e:	633000ef          	jal	ffffffffc0201f40 <free_pages>
    free_page(p2);
ffffffffc0201112:	8556                	mv	a0,s5
ffffffffc0201114:	4585                	li	a1,1
ffffffffc0201116:	62b000ef          	jal	ffffffffc0201f40 <free_pages>
    assert(nr_free == 3);
ffffffffc020111a:	00096717          	auipc	a4,0x96
ffffffffc020111e:	4be72703          	lw	a4,1214(a4) # ffffffffc02975d8 <free_area+0x10>
ffffffffc0201122:	478d                	li	a5,3
ffffffffc0201124:	2af71063          	bne	a4,a5,ffffffffc02013c4 <default_check+0x3d2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201128:	4505                	li	a0,1
ffffffffc020112a:	5dd000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc020112e:	89aa                	mv	s3,a0
ffffffffc0201130:	26050a63          	beqz	a0,ffffffffc02013a4 <default_check+0x3b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201134:	4505                	li	a0,1
ffffffffc0201136:	5d1000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc020113a:	8aaa                	mv	s5,a0
ffffffffc020113c:	3c050463          	beqz	a0,ffffffffc0201504 <default_check+0x512>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201140:	4505                	li	a0,1
ffffffffc0201142:	5c5000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc0201146:	8a2a                	mv	s4,a0
ffffffffc0201148:	38050e63          	beqz	a0,ffffffffc02014e4 <default_check+0x4f2>
    assert(alloc_page() == NULL);
ffffffffc020114c:	4505                	li	a0,1
ffffffffc020114e:	5b9000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc0201152:	36051963          	bnez	a0,ffffffffc02014c4 <default_check+0x4d2>
    free_page(p0);
ffffffffc0201156:	4585                	li	a1,1
ffffffffc0201158:	854e                	mv	a0,s3
ffffffffc020115a:	5e7000ef          	jal	ffffffffc0201f40 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020115e:	00893783          	ld	a5,8(s2)
ffffffffc0201162:	1f278163          	beq	a5,s2,ffffffffc0201344 <default_check+0x352>
    assert((p = alloc_page()) == p0);
ffffffffc0201166:	4505                	li	a0,1
ffffffffc0201168:	59f000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc020116c:	8caa                	mv	s9,a0
ffffffffc020116e:	30a99b63          	bne	s3,a0,ffffffffc0201484 <default_check+0x492>
    assert(alloc_page() == NULL);
ffffffffc0201172:	4505                	li	a0,1
ffffffffc0201174:	593000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc0201178:	2e051663          	bnez	a0,ffffffffc0201464 <default_check+0x472>
    assert(nr_free == 0);
ffffffffc020117c:	00096797          	auipc	a5,0x96
ffffffffc0201180:	45c7a783          	lw	a5,1116(a5) # ffffffffc02975d8 <free_area+0x10>
ffffffffc0201184:	2c079063          	bnez	a5,ffffffffc0201444 <default_check+0x452>
    free_page(p);
ffffffffc0201188:	8566                	mv	a0,s9
ffffffffc020118a:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc020118c:	01893023          	sd	s8,0(s2)
ffffffffc0201190:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0201194:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0201198:	5a9000ef          	jal	ffffffffc0201f40 <free_pages>
    free_page(p1);
ffffffffc020119c:	8556                	mv	a0,s5
ffffffffc020119e:	4585                	li	a1,1
ffffffffc02011a0:	5a1000ef          	jal	ffffffffc0201f40 <free_pages>
    free_page(p2);
ffffffffc02011a4:	8552                	mv	a0,s4
ffffffffc02011a6:	4585                	li	a1,1
ffffffffc02011a8:	599000ef          	jal	ffffffffc0201f40 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02011ac:	4515                	li	a0,5
ffffffffc02011ae:	559000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc02011b2:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02011b4:	26050863          	beqz	a0,ffffffffc0201424 <default_check+0x432>
ffffffffc02011b8:	651c                	ld	a5,8(a0)
    assert(!PageProperty(p0));
ffffffffc02011ba:	8b89                	andi	a5,a5,2
ffffffffc02011bc:	54079463          	bnez	a5,ffffffffc0201704 <default_check+0x712>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02011c0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02011c2:	00093b83          	ld	s7,0(s2)
ffffffffc02011c6:	00893b03          	ld	s6,8(s2)
ffffffffc02011ca:	01293023          	sd	s2,0(s2)
ffffffffc02011ce:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc02011d2:	535000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc02011d6:	50051763          	bnez	a0,ffffffffc02016e4 <default_check+0x6f2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02011da:	08098a13          	addi	s4,s3,128
ffffffffc02011de:	8552                	mv	a0,s4
ffffffffc02011e0:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02011e2:	00096c17          	auipc	s8,0x96
ffffffffc02011e6:	3f6c2c03          	lw	s8,1014(s8) # ffffffffc02975d8 <free_area+0x10>
    nr_free = 0;
ffffffffc02011ea:	00096797          	auipc	a5,0x96
ffffffffc02011ee:	3e07a723          	sw	zero,1006(a5) # ffffffffc02975d8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02011f2:	54f000ef          	jal	ffffffffc0201f40 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02011f6:	4511                	li	a0,4
ffffffffc02011f8:	50f000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc02011fc:	4c051463          	bnez	a0,ffffffffc02016c4 <default_check+0x6d2>
ffffffffc0201200:	0889b783          	ld	a5,136(s3)
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201204:	8b89                	andi	a5,a5,2
ffffffffc0201206:	48078f63          	beqz	a5,ffffffffc02016a4 <default_check+0x6b2>
ffffffffc020120a:	0909a503          	lw	a0,144(s3)
ffffffffc020120e:	478d                	li	a5,3
ffffffffc0201210:	48f51a63          	bne	a0,a5,ffffffffc02016a4 <default_check+0x6b2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201214:	4f3000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc0201218:	8aaa                	mv	s5,a0
ffffffffc020121a:	46050563          	beqz	a0,ffffffffc0201684 <default_check+0x692>
    assert(alloc_page() == NULL);
ffffffffc020121e:	4505                	li	a0,1
ffffffffc0201220:	4e7000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc0201224:	44051063          	bnez	a0,ffffffffc0201664 <default_check+0x672>
    assert(p0 + 2 == p1);
ffffffffc0201228:	415a1e63          	bne	s4,s5,ffffffffc0201644 <default_check+0x652>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc020122c:	4585                	li	a1,1
ffffffffc020122e:	854e                	mv	a0,s3
ffffffffc0201230:	511000ef          	jal	ffffffffc0201f40 <free_pages>
    free_pages(p1, 3);
ffffffffc0201234:	8552                	mv	a0,s4
ffffffffc0201236:	458d                	li	a1,3
ffffffffc0201238:	509000ef          	jal	ffffffffc0201f40 <free_pages>
ffffffffc020123c:	0089b783          	ld	a5,8(s3)
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201240:	8b89                	andi	a5,a5,2
ffffffffc0201242:	3e078163          	beqz	a5,ffffffffc0201624 <default_check+0x632>
ffffffffc0201246:	0109aa83          	lw	s5,16(s3)
ffffffffc020124a:	4785                	li	a5,1
ffffffffc020124c:	3cfa9c63          	bne	s5,a5,ffffffffc0201624 <default_check+0x632>
ffffffffc0201250:	008a3783          	ld	a5,8(s4)
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201254:	8b89                	andi	a5,a5,2
ffffffffc0201256:	3a078763          	beqz	a5,ffffffffc0201604 <default_check+0x612>
ffffffffc020125a:	010a2703          	lw	a4,16(s4)
ffffffffc020125e:	478d                	li	a5,3
ffffffffc0201260:	3af71263          	bne	a4,a5,ffffffffc0201604 <default_check+0x612>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201264:	8556                	mv	a0,s5
ffffffffc0201266:	4a1000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc020126a:	36a99d63          	bne	s3,a0,ffffffffc02015e4 <default_check+0x5f2>
    free_page(p0);
ffffffffc020126e:	85d6                	mv	a1,s5
ffffffffc0201270:	4d1000ef          	jal	ffffffffc0201f40 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201274:	4509                	li	a0,2
ffffffffc0201276:	491000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc020127a:	34aa1563          	bne	s4,a0,ffffffffc02015c4 <default_check+0x5d2>

    free_pages(p0, 2);
ffffffffc020127e:	4589                	li	a1,2
ffffffffc0201280:	4c1000ef          	jal	ffffffffc0201f40 <free_pages>
    free_page(p2);
ffffffffc0201284:	04098513          	addi	a0,s3,64
ffffffffc0201288:	85d6                	mv	a1,s5
ffffffffc020128a:	4b7000ef          	jal	ffffffffc0201f40 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020128e:	4515                	li	a0,5
ffffffffc0201290:	477000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc0201294:	89aa                	mv	s3,a0
ffffffffc0201296:	48050763          	beqz	a0,ffffffffc0201724 <default_check+0x732>
    assert(alloc_page() == NULL);
ffffffffc020129a:	8556                	mv	a0,s5
ffffffffc020129c:	46b000ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc02012a0:	2e051263          	bnez	a0,ffffffffc0201584 <default_check+0x592>

    assert(nr_free == 0);
ffffffffc02012a4:	00096797          	auipc	a5,0x96
ffffffffc02012a8:	3347a783          	lw	a5,820(a5) # ffffffffc02975d8 <free_area+0x10>
ffffffffc02012ac:	2a079c63          	bnez	a5,ffffffffc0201564 <default_check+0x572>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02012b0:	854e                	mv	a0,s3
ffffffffc02012b2:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc02012b4:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc02012b8:	01793023          	sd	s7,0(s2)
ffffffffc02012bc:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc02012c0:	481000ef          	jal	ffffffffc0201f40 <free_pages>
    return listelm->next;
ffffffffc02012c4:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02012c8:	01278963          	beq	a5,s2,ffffffffc02012da <default_check+0x2e8>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02012cc:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012d0:	679c                	ld	a5,8(a5)
ffffffffc02012d2:	34fd                	addiw	s1,s1,-1
ffffffffc02012d4:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02012d6:	ff279be3          	bne	a5,s2,ffffffffc02012cc <default_check+0x2da>
    }
    assert(count == 0);
ffffffffc02012da:	26049563          	bnez	s1,ffffffffc0201544 <default_check+0x552>
    assert(total == 0);
ffffffffc02012de:	46041363          	bnez	s0,ffffffffc0201744 <default_check+0x752>
}
ffffffffc02012e2:	60e6                	ld	ra,88(sp)
ffffffffc02012e4:	6446                	ld	s0,80(sp)
ffffffffc02012e6:	64a6                	ld	s1,72(sp)
ffffffffc02012e8:	6906                	ld	s2,64(sp)
ffffffffc02012ea:	79e2                	ld	s3,56(sp)
ffffffffc02012ec:	7a42                	ld	s4,48(sp)
ffffffffc02012ee:	7aa2                	ld	s5,40(sp)
ffffffffc02012f0:	7b02                	ld	s6,32(sp)
ffffffffc02012f2:	6be2                	ld	s7,24(sp)
ffffffffc02012f4:	6c42                	ld	s8,16(sp)
ffffffffc02012f6:	6ca2                	ld	s9,8(sp)
ffffffffc02012f8:	6125                	addi	sp,sp,96
ffffffffc02012fa:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02012fc:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02012fe:	4401                	li	s0,0
ffffffffc0201300:	4481                	li	s1,0
ffffffffc0201302:	bb1d                	j	ffffffffc0201038 <default_check+0x46>
        assert(PageProperty(p));
ffffffffc0201304:	00005697          	auipc	a3,0x5
ffffffffc0201308:	f0468693          	addi	a3,a3,-252 # ffffffffc0206208 <etext+0x9d2>
ffffffffc020130c:	00005617          	auipc	a2,0x5
ffffffffc0201310:	f0c60613          	addi	a2,a2,-244 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201314:	11000593          	li	a1,272
ffffffffc0201318:	00005517          	auipc	a0,0x5
ffffffffc020131c:	f1850513          	addi	a0,a0,-232 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201320:	926ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201324:	00005697          	auipc	a3,0x5
ffffffffc0201328:	fcc68693          	addi	a3,a3,-52 # ffffffffc02062f0 <etext+0xaba>
ffffffffc020132c:	00005617          	auipc	a2,0x5
ffffffffc0201330:	eec60613          	addi	a2,a2,-276 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201334:	0dc00593          	li	a1,220
ffffffffc0201338:	00005517          	auipc	a0,0x5
ffffffffc020133c:	ef850513          	addi	a0,a0,-264 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201340:	906ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201344:	00005697          	auipc	a3,0x5
ffffffffc0201348:	07468693          	addi	a3,a3,116 # ffffffffc02063b8 <etext+0xb82>
ffffffffc020134c:	00005617          	auipc	a2,0x5
ffffffffc0201350:	ecc60613          	addi	a2,a2,-308 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201354:	0f700593          	li	a1,247
ffffffffc0201358:	00005517          	auipc	a0,0x5
ffffffffc020135c:	ed850513          	addi	a0,a0,-296 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201360:	8e6ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201364:	00005697          	auipc	a3,0x5
ffffffffc0201368:	fcc68693          	addi	a3,a3,-52 # ffffffffc0206330 <etext+0xafa>
ffffffffc020136c:	00005617          	auipc	a2,0x5
ffffffffc0201370:	eac60613          	addi	a2,a2,-340 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201374:	0de00593          	li	a1,222
ffffffffc0201378:	00005517          	auipc	a0,0x5
ffffffffc020137c:	eb850513          	addi	a0,a0,-328 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201380:	8c6ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201384:	00005697          	auipc	a3,0x5
ffffffffc0201388:	f4468693          	addi	a3,a3,-188 # ffffffffc02062c8 <etext+0xa92>
ffffffffc020138c:	00005617          	auipc	a2,0x5
ffffffffc0201390:	e8c60613          	addi	a2,a2,-372 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201394:	0db00593          	li	a1,219
ffffffffc0201398:	00005517          	auipc	a0,0x5
ffffffffc020139c:	e9850513          	addi	a0,a0,-360 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02013a0:	8a6ff0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02013a4:	00005697          	auipc	a3,0x5
ffffffffc02013a8:	ec468693          	addi	a3,a3,-316 # ffffffffc0206268 <etext+0xa32>
ffffffffc02013ac:	00005617          	auipc	a2,0x5
ffffffffc02013b0:	e6c60613          	addi	a2,a2,-404 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02013b4:	0f000593          	li	a1,240
ffffffffc02013b8:	00005517          	auipc	a0,0x5
ffffffffc02013bc:	e7850513          	addi	a0,a0,-392 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02013c0:	886ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 3);
ffffffffc02013c4:	00005697          	auipc	a3,0x5
ffffffffc02013c8:	fe468693          	addi	a3,a3,-28 # ffffffffc02063a8 <etext+0xb72>
ffffffffc02013cc:	00005617          	auipc	a2,0x5
ffffffffc02013d0:	e4c60613          	addi	a2,a2,-436 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02013d4:	0ee00593          	li	a1,238
ffffffffc02013d8:	00005517          	auipc	a0,0x5
ffffffffc02013dc:	e5850513          	addi	a0,a0,-424 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02013e0:	866ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013e4:	00005697          	auipc	a3,0x5
ffffffffc02013e8:	fac68693          	addi	a3,a3,-84 # ffffffffc0206390 <etext+0xb5a>
ffffffffc02013ec:	00005617          	auipc	a2,0x5
ffffffffc02013f0:	e2c60613          	addi	a2,a2,-468 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02013f4:	0e900593          	li	a1,233
ffffffffc02013f8:	00005517          	auipc	a0,0x5
ffffffffc02013fc:	e3850513          	addi	a0,a0,-456 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201400:	846ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201404:	00005697          	auipc	a3,0x5
ffffffffc0201408:	f6c68693          	addi	a3,a3,-148 # ffffffffc0206370 <etext+0xb3a>
ffffffffc020140c:	00005617          	auipc	a2,0x5
ffffffffc0201410:	e0c60613          	addi	a2,a2,-500 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201414:	0e000593          	li	a1,224
ffffffffc0201418:	00005517          	auipc	a0,0x5
ffffffffc020141c:	e1850513          	addi	a0,a0,-488 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201420:	826ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != NULL);
ffffffffc0201424:	00005697          	auipc	a3,0x5
ffffffffc0201428:	fdc68693          	addi	a3,a3,-36 # ffffffffc0206400 <etext+0xbca>
ffffffffc020142c:	00005617          	auipc	a2,0x5
ffffffffc0201430:	dec60613          	addi	a2,a2,-532 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201434:	11800593          	li	a1,280
ffffffffc0201438:	00005517          	auipc	a0,0x5
ffffffffc020143c:	df850513          	addi	a0,a0,-520 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201440:	806ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc0201444:	00005697          	auipc	a3,0x5
ffffffffc0201448:	fac68693          	addi	a3,a3,-84 # ffffffffc02063f0 <etext+0xbba>
ffffffffc020144c:	00005617          	auipc	a2,0x5
ffffffffc0201450:	dcc60613          	addi	a2,a2,-564 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201454:	0fd00593          	li	a1,253
ffffffffc0201458:	00005517          	auipc	a0,0x5
ffffffffc020145c:	dd850513          	addi	a0,a0,-552 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201460:	fe7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201464:	00005697          	auipc	a3,0x5
ffffffffc0201468:	f2c68693          	addi	a3,a3,-212 # ffffffffc0206390 <etext+0xb5a>
ffffffffc020146c:	00005617          	auipc	a2,0x5
ffffffffc0201470:	dac60613          	addi	a2,a2,-596 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201474:	0fb00593          	li	a1,251
ffffffffc0201478:	00005517          	auipc	a0,0x5
ffffffffc020147c:	db850513          	addi	a0,a0,-584 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201480:	fc7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201484:	00005697          	auipc	a3,0x5
ffffffffc0201488:	f4c68693          	addi	a3,a3,-180 # ffffffffc02063d0 <etext+0xb9a>
ffffffffc020148c:	00005617          	auipc	a2,0x5
ffffffffc0201490:	d8c60613          	addi	a2,a2,-628 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201494:	0fa00593          	li	a1,250
ffffffffc0201498:	00005517          	auipc	a0,0x5
ffffffffc020149c:	d9850513          	addi	a0,a0,-616 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02014a0:	fa7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02014a4:	00005697          	auipc	a3,0x5
ffffffffc02014a8:	dc468693          	addi	a3,a3,-572 # ffffffffc0206268 <etext+0xa32>
ffffffffc02014ac:	00005617          	auipc	a2,0x5
ffffffffc02014b0:	d6c60613          	addi	a2,a2,-660 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02014b4:	0d700593          	li	a1,215
ffffffffc02014b8:	00005517          	auipc	a0,0x5
ffffffffc02014bc:	d7850513          	addi	a0,a0,-648 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02014c0:	f87fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014c4:	00005697          	auipc	a3,0x5
ffffffffc02014c8:	ecc68693          	addi	a3,a3,-308 # ffffffffc0206390 <etext+0xb5a>
ffffffffc02014cc:	00005617          	auipc	a2,0x5
ffffffffc02014d0:	d4c60613          	addi	a2,a2,-692 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02014d4:	0f400593          	li	a1,244
ffffffffc02014d8:	00005517          	auipc	a0,0x5
ffffffffc02014dc:	d5850513          	addi	a0,a0,-680 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02014e0:	f67fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014e4:	00005697          	auipc	a3,0x5
ffffffffc02014e8:	dc468693          	addi	a3,a3,-572 # ffffffffc02062a8 <etext+0xa72>
ffffffffc02014ec:	00005617          	auipc	a2,0x5
ffffffffc02014f0:	d2c60613          	addi	a2,a2,-724 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02014f4:	0f200593          	li	a1,242
ffffffffc02014f8:	00005517          	auipc	a0,0x5
ffffffffc02014fc:	d3850513          	addi	a0,a0,-712 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201500:	f47fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201504:	00005697          	auipc	a3,0x5
ffffffffc0201508:	d8468693          	addi	a3,a3,-636 # ffffffffc0206288 <etext+0xa52>
ffffffffc020150c:	00005617          	auipc	a2,0x5
ffffffffc0201510:	d0c60613          	addi	a2,a2,-756 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201514:	0f100593          	li	a1,241
ffffffffc0201518:	00005517          	auipc	a0,0x5
ffffffffc020151c:	d1850513          	addi	a0,a0,-744 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201520:	f27fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201524:	00005697          	auipc	a3,0x5
ffffffffc0201528:	d8468693          	addi	a3,a3,-636 # ffffffffc02062a8 <etext+0xa72>
ffffffffc020152c:	00005617          	auipc	a2,0x5
ffffffffc0201530:	cec60613          	addi	a2,a2,-788 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201534:	0d900593          	li	a1,217
ffffffffc0201538:	00005517          	auipc	a0,0x5
ffffffffc020153c:	cf850513          	addi	a0,a0,-776 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201540:	f07fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(count == 0);
ffffffffc0201544:	00005697          	auipc	a3,0x5
ffffffffc0201548:	00c68693          	addi	a3,a3,12 # ffffffffc0206550 <etext+0xd1a>
ffffffffc020154c:	00005617          	auipc	a2,0x5
ffffffffc0201550:	ccc60613          	addi	a2,a2,-820 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201554:	14600593          	li	a1,326
ffffffffc0201558:	00005517          	auipc	a0,0x5
ffffffffc020155c:	cd850513          	addi	a0,a0,-808 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201560:	ee7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc0201564:	00005697          	auipc	a3,0x5
ffffffffc0201568:	e8c68693          	addi	a3,a3,-372 # ffffffffc02063f0 <etext+0xbba>
ffffffffc020156c:	00005617          	auipc	a2,0x5
ffffffffc0201570:	cac60613          	addi	a2,a2,-852 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201574:	13a00593          	li	a1,314
ffffffffc0201578:	00005517          	auipc	a0,0x5
ffffffffc020157c:	cb850513          	addi	a0,a0,-840 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201580:	ec7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201584:	00005697          	auipc	a3,0x5
ffffffffc0201588:	e0c68693          	addi	a3,a3,-500 # ffffffffc0206390 <etext+0xb5a>
ffffffffc020158c:	00005617          	auipc	a2,0x5
ffffffffc0201590:	c8c60613          	addi	a2,a2,-884 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201594:	13800593          	li	a1,312
ffffffffc0201598:	00005517          	auipc	a0,0x5
ffffffffc020159c:	c9850513          	addi	a0,a0,-872 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02015a0:	ea7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02015a4:	00005697          	auipc	a3,0x5
ffffffffc02015a8:	dac68693          	addi	a3,a3,-596 # ffffffffc0206350 <etext+0xb1a>
ffffffffc02015ac:	00005617          	auipc	a2,0x5
ffffffffc02015b0:	c6c60613          	addi	a2,a2,-916 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02015b4:	0df00593          	li	a1,223
ffffffffc02015b8:	00005517          	auipc	a0,0x5
ffffffffc02015bc:	c7850513          	addi	a0,a0,-904 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02015c0:	e87fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02015c4:	00005697          	auipc	a3,0x5
ffffffffc02015c8:	f4c68693          	addi	a3,a3,-180 # ffffffffc0206510 <etext+0xcda>
ffffffffc02015cc:	00005617          	auipc	a2,0x5
ffffffffc02015d0:	c4c60613          	addi	a2,a2,-948 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02015d4:	13200593          	li	a1,306
ffffffffc02015d8:	00005517          	auipc	a0,0x5
ffffffffc02015dc:	c5850513          	addi	a0,a0,-936 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02015e0:	e67fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02015e4:	00005697          	auipc	a3,0x5
ffffffffc02015e8:	f0c68693          	addi	a3,a3,-244 # ffffffffc02064f0 <etext+0xcba>
ffffffffc02015ec:	00005617          	auipc	a2,0x5
ffffffffc02015f0:	c2c60613          	addi	a2,a2,-980 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02015f4:	13000593          	li	a1,304
ffffffffc02015f8:	00005517          	auipc	a0,0x5
ffffffffc02015fc:	c3850513          	addi	a0,a0,-968 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201600:	e47fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201604:	00005697          	auipc	a3,0x5
ffffffffc0201608:	ec468693          	addi	a3,a3,-316 # ffffffffc02064c8 <etext+0xc92>
ffffffffc020160c:	00005617          	auipc	a2,0x5
ffffffffc0201610:	c0c60613          	addi	a2,a2,-1012 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201614:	12e00593          	li	a1,302
ffffffffc0201618:	00005517          	auipc	a0,0x5
ffffffffc020161c:	c1850513          	addi	a0,a0,-1000 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201620:	e27fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201624:	00005697          	auipc	a3,0x5
ffffffffc0201628:	e7c68693          	addi	a3,a3,-388 # ffffffffc02064a0 <etext+0xc6a>
ffffffffc020162c:	00005617          	auipc	a2,0x5
ffffffffc0201630:	bec60613          	addi	a2,a2,-1044 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201634:	12d00593          	li	a1,301
ffffffffc0201638:	00005517          	auipc	a0,0x5
ffffffffc020163c:	bf850513          	addi	a0,a0,-1032 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201640:	e07fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201644:	00005697          	auipc	a3,0x5
ffffffffc0201648:	e4c68693          	addi	a3,a3,-436 # ffffffffc0206490 <etext+0xc5a>
ffffffffc020164c:	00005617          	auipc	a2,0x5
ffffffffc0201650:	bcc60613          	addi	a2,a2,-1076 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201654:	12800593          	li	a1,296
ffffffffc0201658:	00005517          	auipc	a0,0x5
ffffffffc020165c:	bd850513          	addi	a0,a0,-1064 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201660:	de7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201664:	00005697          	auipc	a3,0x5
ffffffffc0201668:	d2c68693          	addi	a3,a3,-724 # ffffffffc0206390 <etext+0xb5a>
ffffffffc020166c:	00005617          	auipc	a2,0x5
ffffffffc0201670:	bac60613          	addi	a2,a2,-1108 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201674:	12700593          	li	a1,295
ffffffffc0201678:	00005517          	auipc	a0,0x5
ffffffffc020167c:	bb850513          	addi	a0,a0,-1096 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201680:	dc7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201684:	00005697          	auipc	a3,0x5
ffffffffc0201688:	dec68693          	addi	a3,a3,-532 # ffffffffc0206470 <etext+0xc3a>
ffffffffc020168c:	00005617          	auipc	a2,0x5
ffffffffc0201690:	b8c60613          	addi	a2,a2,-1140 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201694:	12600593          	li	a1,294
ffffffffc0201698:	00005517          	auipc	a0,0x5
ffffffffc020169c:	b9850513          	addi	a0,a0,-1128 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02016a0:	da7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02016a4:	00005697          	auipc	a3,0x5
ffffffffc02016a8:	d9c68693          	addi	a3,a3,-612 # ffffffffc0206440 <etext+0xc0a>
ffffffffc02016ac:	00005617          	auipc	a2,0x5
ffffffffc02016b0:	b6c60613          	addi	a2,a2,-1172 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02016b4:	12500593          	li	a1,293
ffffffffc02016b8:	00005517          	auipc	a0,0x5
ffffffffc02016bc:	b7850513          	addi	a0,a0,-1160 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02016c0:	d87fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02016c4:	00005697          	auipc	a3,0x5
ffffffffc02016c8:	d6468693          	addi	a3,a3,-668 # ffffffffc0206428 <etext+0xbf2>
ffffffffc02016cc:	00005617          	auipc	a2,0x5
ffffffffc02016d0:	b4c60613          	addi	a2,a2,-1204 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02016d4:	12400593          	li	a1,292
ffffffffc02016d8:	00005517          	auipc	a0,0x5
ffffffffc02016dc:	b5850513          	addi	a0,a0,-1192 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02016e0:	d67fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016e4:	00005697          	auipc	a3,0x5
ffffffffc02016e8:	cac68693          	addi	a3,a3,-852 # ffffffffc0206390 <etext+0xb5a>
ffffffffc02016ec:	00005617          	auipc	a2,0x5
ffffffffc02016f0:	b2c60613          	addi	a2,a2,-1236 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02016f4:	11e00593          	li	a1,286
ffffffffc02016f8:	00005517          	auipc	a0,0x5
ffffffffc02016fc:	b3850513          	addi	a0,a0,-1224 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201700:	d47fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201704:	00005697          	auipc	a3,0x5
ffffffffc0201708:	d0c68693          	addi	a3,a3,-756 # ffffffffc0206410 <etext+0xbda>
ffffffffc020170c:	00005617          	auipc	a2,0x5
ffffffffc0201710:	b0c60613          	addi	a2,a2,-1268 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201714:	11900593          	li	a1,281
ffffffffc0201718:	00005517          	auipc	a0,0x5
ffffffffc020171c:	b1850513          	addi	a0,a0,-1256 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201720:	d27fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201724:	00005697          	auipc	a3,0x5
ffffffffc0201728:	e0c68693          	addi	a3,a3,-500 # ffffffffc0206530 <etext+0xcfa>
ffffffffc020172c:	00005617          	auipc	a2,0x5
ffffffffc0201730:	aec60613          	addi	a2,a2,-1300 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201734:	13700593          	li	a1,311
ffffffffc0201738:	00005517          	auipc	a0,0x5
ffffffffc020173c:	af850513          	addi	a0,a0,-1288 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201740:	d07fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == 0);
ffffffffc0201744:	00005697          	auipc	a3,0x5
ffffffffc0201748:	e1c68693          	addi	a3,a3,-484 # ffffffffc0206560 <etext+0xd2a>
ffffffffc020174c:	00005617          	auipc	a2,0x5
ffffffffc0201750:	acc60613          	addi	a2,a2,-1332 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201754:	14700593          	li	a1,327
ffffffffc0201758:	00005517          	auipc	a0,0x5
ffffffffc020175c:	ad850513          	addi	a0,a0,-1320 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201760:	ce7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == nr_free_pages());
ffffffffc0201764:	00005697          	auipc	a3,0x5
ffffffffc0201768:	ae468693          	addi	a3,a3,-1308 # ffffffffc0206248 <etext+0xa12>
ffffffffc020176c:	00005617          	auipc	a2,0x5
ffffffffc0201770:	aac60613          	addi	a2,a2,-1364 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201774:	11300593          	li	a1,275
ffffffffc0201778:	00005517          	auipc	a0,0x5
ffffffffc020177c:	ab850513          	addi	a0,a0,-1352 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201780:	cc7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201784:	00005697          	auipc	a3,0x5
ffffffffc0201788:	b0468693          	addi	a3,a3,-1276 # ffffffffc0206288 <etext+0xa52>
ffffffffc020178c:	00005617          	auipc	a2,0x5
ffffffffc0201790:	a8c60613          	addi	a2,a2,-1396 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201794:	0d800593          	li	a1,216
ffffffffc0201798:	00005517          	auipc	a0,0x5
ffffffffc020179c:	a9850513          	addi	a0,a0,-1384 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02017a0:	ca7fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02017a4 <default_free_pages>:
{
ffffffffc02017a4:	1141                	addi	sp,sp,-16
ffffffffc02017a6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017a8:	14058663          	beqz	a1,ffffffffc02018f4 <default_free_pages+0x150>
    for (; p != base + n; p++)
ffffffffc02017ac:	00659713          	slli	a4,a1,0x6
ffffffffc02017b0:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02017b4:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc02017b6:	c30d                	beqz	a4,ffffffffc02017d8 <default_free_pages+0x34>
ffffffffc02017b8:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02017ba:	8b05                	andi	a4,a4,1
ffffffffc02017bc:	10071c63          	bnez	a4,ffffffffc02018d4 <default_free_pages+0x130>
ffffffffc02017c0:	6798                	ld	a4,8(a5)
ffffffffc02017c2:	8b09                	andi	a4,a4,2
ffffffffc02017c4:	10071863          	bnez	a4,ffffffffc02018d4 <default_free_pages+0x130>
        p->flags = 0;
ffffffffc02017c8:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02017cc:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02017d0:	04078793          	addi	a5,a5,64
ffffffffc02017d4:	fed792e3          	bne	a5,a3,ffffffffc02017b8 <default_free_pages+0x14>
    base->property = n;
ffffffffc02017d8:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02017da:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017de:	4789                	li	a5,2
ffffffffc02017e0:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02017e4:	00096717          	auipc	a4,0x96
ffffffffc02017e8:	df472703          	lw	a4,-524(a4) # ffffffffc02975d8 <free_area+0x10>
ffffffffc02017ec:	00096697          	auipc	a3,0x96
ffffffffc02017f0:	ddc68693          	addi	a3,a3,-548 # ffffffffc02975c8 <free_area>
    return list->next == list;
ffffffffc02017f4:	669c                	ld	a5,8(a3)
ffffffffc02017f6:	9f2d                	addw	a4,a4,a1
ffffffffc02017f8:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc02017fa:	0ad78163          	beq	a5,a3,ffffffffc020189c <default_free_pages+0xf8>
            struct Page *page = le2page(le, page_link);
ffffffffc02017fe:	fe878713          	addi	a4,a5,-24
ffffffffc0201802:	4581                	li	a1,0
ffffffffc0201804:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc0201808:	00e56a63          	bltu	a0,a4,ffffffffc020181c <default_free_pages+0x78>
    return listelm->next;
ffffffffc020180c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020180e:	04d70c63          	beq	a4,a3,ffffffffc0201866 <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc0201812:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201814:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201818:	fee57ae3          	bgeu	a0,a4,ffffffffc020180c <default_free_pages+0x68>
ffffffffc020181c:	c199                	beqz	a1,ffffffffc0201822 <default_free_pages+0x7e>
ffffffffc020181e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201822:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201824:	e390                	sd	a2,0(a5)
ffffffffc0201826:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc0201828:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc020182a:	f11c                	sd	a5,32(a0)
    if (le != &free_list)
ffffffffc020182c:	00d70d63          	beq	a4,a3,ffffffffc0201846 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201830:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201834:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201838:	02059813          	slli	a6,a1,0x20
ffffffffc020183c:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201840:	97b2                	add	a5,a5,a2
ffffffffc0201842:	02f50c63          	beq	a0,a5,ffffffffc020187a <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201846:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201848:	00d78c63          	beq	a5,a3,ffffffffc0201860 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc020184c:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc020184e:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201852:	02061593          	slli	a1,a2,0x20
ffffffffc0201856:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020185a:	972a                	add	a4,a4,a0
ffffffffc020185c:	04e68c63          	beq	a3,a4,ffffffffc02018b4 <default_free_pages+0x110>
}
ffffffffc0201860:	60a2                	ld	ra,8(sp)
ffffffffc0201862:	0141                	addi	sp,sp,16
ffffffffc0201864:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201866:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201868:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020186a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020186c:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc020186e:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201870:	02d70f63          	beq	a4,a3,ffffffffc02018ae <default_free_pages+0x10a>
ffffffffc0201874:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201876:	87ba                	mv	a5,a4
ffffffffc0201878:	bf71                	j	ffffffffc0201814 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020187a:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020187c:	5875                	li	a6,-3
ffffffffc020187e:	9fad                	addw	a5,a5,a1
ffffffffc0201880:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201884:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201888:	01853803          	ld	a6,24(a0)
ffffffffc020188c:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc020188e:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201890:	00b83423          	sd	a1,8(a6) # ff0008 <_binary_obj___user_exit_out_size+0xfe5e50>
    return listelm->next;
ffffffffc0201894:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201896:	0105b023          	sd	a6,0(a1)
ffffffffc020189a:	b77d                	j	ffffffffc0201848 <default_free_pages+0xa4>
}
ffffffffc020189c:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020189e:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc02018a2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02018a4:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc02018a6:	e398                	sd	a4,0(a5)
ffffffffc02018a8:	e798                	sd	a4,8(a5)
}
ffffffffc02018aa:	0141                	addi	sp,sp,16
ffffffffc02018ac:	8082                	ret
ffffffffc02018ae:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc02018b0:	873e                	mv	a4,a5
ffffffffc02018b2:	bfad                	j	ffffffffc020182c <default_free_pages+0x88>
            base->property += p->property;
ffffffffc02018b4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02018b8:	56f5                	li	a3,-3
ffffffffc02018ba:	9f31                	addw	a4,a4,a2
ffffffffc02018bc:	c918                	sw	a4,16(a0)
ffffffffc02018be:	ff078713          	addi	a4,a5,-16
ffffffffc02018c2:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018c6:	6398                	ld	a4,0(a5)
ffffffffc02018c8:	679c                	ld	a5,8(a5)
}
ffffffffc02018ca:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02018cc:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02018ce:	e398                	sd	a4,0(a5)
ffffffffc02018d0:	0141                	addi	sp,sp,16
ffffffffc02018d2:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02018d4:	00005697          	auipc	a3,0x5
ffffffffc02018d8:	ca468693          	addi	a3,a3,-860 # ffffffffc0206578 <etext+0xd42>
ffffffffc02018dc:	00005617          	auipc	a2,0x5
ffffffffc02018e0:	93c60613          	addi	a2,a2,-1732 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02018e4:	09400593          	li	a1,148
ffffffffc02018e8:	00005517          	auipc	a0,0x5
ffffffffc02018ec:	94850513          	addi	a0,a0,-1720 # ffffffffc0206230 <etext+0x9fa>
ffffffffc02018f0:	b57fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc02018f4:	00005697          	auipc	a3,0x5
ffffffffc02018f8:	c7c68693          	addi	a3,a3,-900 # ffffffffc0206570 <etext+0xd3a>
ffffffffc02018fc:	00005617          	auipc	a2,0x5
ffffffffc0201900:	91c60613          	addi	a2,a2,-1764 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201904:	09000593          	li	a1,144
ffffffffc0201908:	00005517          	auipc	a0,0x5
ffffffffc020190c:	92850513          	addi	a0,a0,-1752 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201910:	b37fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201914 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201914:	c951                	beqz	a0,ffffffffc02019a8 <default_alloc_pages+0x94>
    if (n > nr_free)
ffffffffc0201916:	00096597          	auipc	a1,0x96
ffffffffc020191a:	cc25a583          	lw	a1,-830(a1) # ffffffffc02975d8 <free_area+0x10>
ffffffffc020191e:	86aa                	mv	a3,a0
ffffffffc0201920:	02059793          	slli	a5,a1,0x20
ffffffffc0201924:	9381                	srli	a5,a5,0x20
ffffffffc0201926:	00a7ef63          	bltu	a5,a0,ffffffffc0201944 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc020192a:	00096617          	auipc	a2,0x96
ffffffffc020192e:	c9e60613          	addi	a2,a2,-866 # ffffffffc02975c8 <free_area>
ffffffffc0201932:	87b2                	mv	a5,a2
ffffffffc0201934:	a029                	j	ffffffffc020193e <default_alloc_pages+0x2a>
        if (p->property >= n)
ffffffffc0201936:	ff87e703          	lwu	a4,-8(a5)
ffffffffc020193a:	00d77763          	bgeu	a4,a3,ffffffffc0201948 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc020193e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201940:	fec79be3          	bne	a5,a2,ffffffffc0201936 <default_alloc_pages+0x22>
        return NULL;
ffffffffc0201944:	4501                	li	a0,0
}
ffffffffc0201946:	8082                	ret
        if (page->property > n)
ffffffffc0201948:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc020194c:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201950:	6798                	ld	a4,8(a5)
ffffffffc0201952:	02089313          	slli	t1,a7,0x20
ffffffffc0201956:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc020195a:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc020195e:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc0201962:	fe878513          	addi	a0,a5,-24
        if (page->property > n)
ffffffffc0201966:	0266fa63          	bgeu	a3,t1,ffffffffc020199a <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc020196a:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc020196e:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc0201972:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201974:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201978:	00870313          	addi	t1,a4,8
ffffffffc020197c:	4889                	li	a7,2
ffffffffc020197e:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201982:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc0201986:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc020198a:	0068b023          	sd	t1,0(a7)
ffffffffc020198e:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc0201992:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc0201996:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc020199a:	9d95                	subw	a1,a1,a3
ffffffffc020199c:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020199e:	5775                	li	a4,-3
ffffffffc02019a0:	17c1                	addi	a5,a5,-16
ffffffffc02019a2:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02019a6:	8082                	ret
{
ffffffffc02019a8:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02019aa:	00005697          	auipc	a3,0x5
ffffffffc02019ae:	bc668693          	addi	a3,a3,-1082 # ffffffffc0206570 <etext+0xd3a>
ffffffffc02019b2:	00005617          	auipc	a2,0x5
ffffffffc02019b6:	86660613          	addi	a2,a2,-1946 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02019ba:	06c00593          	li	a1,108
ffffffffc02019be:	00005517          	auipc	a0,0x5
ffffffffc02019c2:	87250513          	addi	a0,a0,-1934 # ffffffffc0206230 <etext+0x9fa>
{
ffffffffc02019c6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019c8:	a7ffe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02019cc <default_init_memmap>:
{
ffffffffc02019cc:	1141                	addi	sp,sp,-16
ffffffffc02019ce:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019d0:	c9e1                	beqz	a1,ffffffffc0201aa0 <default_init_memmap+0xd4>
    for (; p != base + n; p++)
ffffffffc02019d2:	00659713          	slli	a4,a1,0x6
ffffffffc02019d6:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02019da:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc02019dc:	cf11                	beqz	a4,ffffffffc02019f8 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02019de:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02019e0:	8b05                	andi	a4,a4,1
ffffffffc02019e2:	cf59                	beqz	a4,ffffffffc0201a80 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02019e4:	0007a823          	sw	zero,16(a5)
ffffffffc02019e8:	0007b423          	sd	zero,8(a5)
ffffffffc02019ec:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02019f0:	04078793          	addi	a5,a5,64
ffffffffc02019f4:	fed795e3          	bne	a5,a3,ffffffffc02019de <default_init_memmap+0x12>
    base->property = n;
ffffffffc02019f8:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019fa:	4789                	li	a5,2
ffffffffc02019fc:	00850713          	addi	a4,a0,8
ffffffffc0201a00:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201a04:	00096717          	auipc	a4,0x96
ffffffffc0201a08:	bd472703          	lw	a4,-1068(a4) # ffffffffc02975d8 <free_area+0x10>
ffffffffc0201a0c:	00096697          	auipc	a3,0x96
ffffffffc0201a10:	bbc68693          	addi	a3,a3,-1092 # ffffffffc02975c8 <free_area>
    return list->next == list;
ffffffffc0201a14:	669c                	ld	a5,8(a3)
ffffffffc0201a16:	9f2d                	addw	a4,a4,a1
ffffffffc0201a18:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc0201a1a:	04d78663          	beq	a5,a3,ffffffffc0201a66 <default_init_memmap+0x9a>
            struct Page *page = le2page(le, page_link);
ffffffffc0201a1e:	fe878713          	addi	a4,a5,-24
ffffffffc0201a22:	4581                	li	a1,0
ffffffffc0201a24:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc0201a28:	00e56a63          	bltu	a0,a4,ffffffffc0201a3c <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201a2c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201a2e:	02d70263          	beq	a4,a3,ffffffffc0201a52 <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc0201a32:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a34:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a38:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a2c <default_init_memmap+0x60>
ffffffffc0201a3c:	c199                	beqz	a1,ffffffffc0201a42 <default_init_memmap+0x76>
ffffffffc0201a3e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a42:	6398                	ld	a4,0(a5)
}
ffffffffc0201a44:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a46:	e390                	sd	a2,0(a5)
ffffffffc0201a48:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0201a4a:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201a4c:	f11c                	sd	a5,32(a0)
ffffffffc0201a4e:	0141                	addi	sp,sp,16
ffffffffc0201a50:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a52:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a54:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a56:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a58:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201a5a:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a5c:	00d70e63          	beq	a4,a3,ffffffffc0201a78 <default_init_memmap+0xac>
ffffffffc0201a60:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201a62:	87ba                	mv	a5,a4
ffffffffc0201a64:	bfc1                	j	ffffffffc0201a34 <default_init_memmap+0x68>
}
ffffffffc0201a66:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201a68:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201a6c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a6e:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201a70:	e398                	sd	a4,0(a5)
ffffffffc0201a72:	e798                	sd	a4,8(a5)
}
ffffffffc0201a74:	0141                	addi	sp,sp,16
ffffffffc0201a76:	8082                	ret
ffffffffc0201a78:	60a2                	ld	ra,8(sp)
ffffffffc0201a7a:	e290                	sd	a2,0(a3)
ffffffffc0201a7c:	0141                	addi	sp,sp,16
ffffffffc0201a7e:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a80:	00005697          	auipc	a3,0x5
ffffffffc0201a84:	b2068693          	addi	a3,a3,-1248 # ffffffffc02065a0 <etext+0xd6a>
ffffffffc0201a88:	00004617          	auipc	a2,0x4
ffffffffc0201a8c:	79060613          	addi	a2,a2,1936 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201a90:	04b00593          	li	a1,75
ffffffffc0201a94:	00004517          	auipc	a0,0x4
ffffffffc0201a98:	79c50513          	addi	a0,a0,1948 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201a9c:	9abfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc0201aa0:	00005697          	auipc	a3,0x5
ffffffffc0201aa4:	ad068693          	addi	a3,a3,-1328 # ffffffffc0206570 <etext+0xd3a>
ffffffffc0201aa8:	00004617          	auipc	a2,0x4
ffffffffc0201aac:	77060613          	addi	a2,a2,1904 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201ab0:	04700593          	li	a1,71
ffffffffc0201ab4:	00004517          	auipc	a0,0x4
ffffffffc0201ab8:	77c50513          	addi	a0,a0,1916 # ffffffffc0206230 <etext+0x9fa>
ffffffffc0201abc:	98bfe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201ac0 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201ac0:	c531                	beqz	a0,ffffffffc0201b0c <slob_free+0x4c>
		return;

	if (size)
ffffffffc0201ac2:	e9b9                	bnez	a1,ffffffffc0201b18 <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ac4:	100027f3          	csrr	a5,sstatus
ffffffffc0201ac8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201aca:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201acc:	efb1                	bnez	a5,ffffffffc0201b28 <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201ace:	00095797          	auipc	a5,0x95
ffffffffc0201ad2:	6ea7b783          	ld	a5,1770(a5) # ffffffffc02971b8 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ad6:	873e                	mv	a4,a5
ffffffffc0201ad8:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201ada:	02a77a63          	bgeu	a4,a0,ffffffffc0201b0e <slob_free+0x4e>
ffffffffc0201ade:	00f56463          	bltu	a0,a5,ffffffffc0201ae6 <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ae2:	fef76ae3          	bltu	a4,a5,ffffffffc0201ad6 <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc0201ae6:	4110                	lw	a2,0(a0)
ffffffffc0201ae8:	00461693          	slli	a3,a2,0x4
ffffffffc0201aec:	96aa                	add	a3,a3,a0
ffffffffc0201aee:	0ad78463          	beq	a5,a3,ffffffffc0201b96 <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201af2:	4310                	lw	a2,0(a4)
ffffffffc0201af4:	e51c                	sd	a5,8(a0)
ffffffffc0201af6:	00461693          	slli	a3,a2,0x4
ffffffffc0201afa:	96ba                	add	a3,a3,a4
ffffffffc0201afc:	08d50163          	beq	a0,a3,ffffffffc0201b7e <slob_free+0xbe>
ffffffffc0201b00:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc0201b02:	00095797          	auipc	a5,0x95
ffffffffc0201b06:	6ae7bb23          	sd	a4,1718(a5) # ffffffffc02971b8 <slobfree>
    if (flag)
ffffffffc0201b0a:	e9a5                	bnez	a1,ffffffffc0201b7a <slob_free+0xba>
ffffffffc0201b0c:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b0e:	fcf574e3          	bgeu	a0,a5,ffffffffc0201ad6 <slob_free+0x16>
ffffffffc0201b12:	fcf762e3          	bltu	a4,a5,ffffffffc0201ad6 <slob_free+0x16>
ffffffffc0201b16:	bfc1                	j	ffffffffc0201ae6 <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc0201b18:	25bd                	addiw	a1,a1,15
ffffffffc0201b1a:	8191                	srli	a1,a1,0x4
ffffffffc0201b1c:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b1e:	100027f3          	csrr	a5,sstatus
ffffffffc0201b22:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b24:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b26:	d7c5                	beqz	a5,ffffffffc0201ace <slob_free+0xe>
{
ffffffffc0201b28:	1101                	addi	sp,sp,-32
ffffffffc0201b2a:	e42a                	sd	a0,8(sp)
ffffffffc0201b2c:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201b2e:	dd7fe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201b32:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b34:	00095797          	auipc	a5,0x95
ffffffffc0201b38:	6847b783          	ld	a5,1668(a5) # ffffffffc02971b8 <slobfree>
ffffffffc0201b3c:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b3e:	873e                	mv	a4,a5
ffffffffc0201b40:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b42:	06a77663          	bgeu	a4,a0,ffffffffc0201bae <slob_free+0xee>
ffffffffc0201b46:	00f56463          	bltu	a0,a5,ffffffffc0201b4e <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b4a:	fef76ae3          	bltu	a4,a5,ffffffffc0201b3e <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc0201b4e:	4110                	lw	a2,0(a0)
ffffffffc0201b50:	00461693          	slli	a3,a2,0x4
ffffffffc0201b54:	96aa                	add	a3,a3,a0
ffffffffc0201b56:	06d78363          	beq	a5,a3,ffffffffc0201bbc <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc0201b5a:	4310                	lw	a2,0(a4)
ffffffffc0201b5c:	e51c                	sd	a5,8(a0)
ffffffffc0201b5e:	00461693          	slli	a3,a2,0x4
ffffffffc0201b62:	96ba                	add	a3,a3,a4
ffffffffc0201b64:	06d50163          	beq	a0,a3,ffffffffc0201bc6 <slob_free+0x106>
ffffffffc0201b68:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc0201b6a:	00095797          	auipc	a5,0x95
ffffffffc0201b6e:	64e7b723          	sd	a4,1614(a5) # ffffffffc02971b8 <slobfree>
    if (flag)
ffffffffc0201b72:	e1a9                	bnez	a1,ffffffffc0201bb4 <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201b74:	60e2                	ld	ra,24(sp)
ffffffffc0201b76:	6105                	addi	sp,sp,32
ffffffffc0201b78:	8082                	ret
        intr_enable();
ffffffffc0201b7a:	d85fe06f          	j	ffffffffc02008fe <intr_enable>
		cur->units += b->units;
ffffffffc0201b7e:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201b80:	853e                	mv	a0,a5
ffffffffc0201b82:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc0201b84:	00c687bb          	addw	a5,a3,a2
ffffffffc0201b88:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc0201b8a:	00095797          	auipc	a5,0x95
ffffffffc0201b8e:	62e7b723          	sd	a4,1582(a5) # ffffffffc02971b8 <slobfree>
    if (flag)
ffffffffc0201b92:	ddad                	beqz	a1,ffffffffc0201b0c <slob_free+0x4c>
ffffffffc0201b94:	b7dd                	j	ffffffffc0201b7a <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc0201b96:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b98:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b9a:	9eb1                	addw	a3,a3,a2
ffffffffc0201b9c:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc0201b9e:	4310                	lw	a2,0(a4)
ffffffffc0201ba0:	e51c                	sd	a5,8(a0)
ffffffffc0201ba2:	00461693          	slli	a3,a2,0x4
ffffffffc0201ba6:	96ba                	add	a3,a3,a4
ffffffffc0201ba8:	f4d51ce3          	bne	a0,a3,ffffffffc0201b00 <slob_free+0x40>
ffffffffc0201bac:	bfc9                	j	ffffffffc0201b7e <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201bae:	f8f56ee3          	bltu	a0,a5,ffffffffc0201b4a <slob_free+0x8a>
ffffffffc0201bb2:	b771                	j	ffffffffc0201b3e <slob_free+0x7e>
}
ffffffffc0201bb4:	60e2                	ld	ra,24(sp)
ffffffffc0201bb6:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201bb8:	d47fe06f          	j	ffffffffc02008fe <intr_enable>
		b->units += cur->next->units;
ffffffffc0201bbc:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201bbe:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201bc0:	9eb1                	addw	a3,a3,a2
ffffffffc0201bc2:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc0201bc4:	bf59                	j	ffffffffc0201b5a <slob_free+0x9a>
		cur->units += b->units;
ffffffffc0201bc6:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201bc8:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc0201bca:	00c687bb          	addw	a5,a3,a2
ffffffffc0201bce:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc0201bd0:	bf61                	j	ffffffffc0201b68 <slob_free+0xa8>

ffffffffc0201bd2 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bd2:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201bd4:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bd6:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201bda:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bdc:	32a000ef          	jal	ffffffffc0201f06 <alloc_pages>
	if (!page)
ffffffffc0201be0:	c91d                	beqz	a0,ffffffffc0201c16 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201be2:	0009a697          	auipc	a3,0x9a
ffffffffc0201be6:	a6e6b683          	ld	a3,-1426(a3) # ffffffffc029b650 <pages>
ffffffffc0201bea:	00006797          	auipc	a5,0x6
ffffffffc0201bee:	db67b783          	ld	a5,-586(a5) # ffffffffc02079a0 <nbase>
    return KADDR(page2pa(page));
ffffffffc0201bf2:	0009a717          	auipc	a4,0x9a
ffffffffc0201bf6:	a5673703          	ld	a4,-1450(a4) # ffffffffc029b648 <npage>
    return page - pages + nbase;
ffffffffc0201bfa:	8d15                	sub	a0,a0,a3
ffffffffc0201bfc:	8519                	srai	a0,a0,0x6
ffffffffc0201bfe:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201c00:	00c51793          	slli	a5,a0,0xc
ffffffffc0201c04:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c06:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201c08:	00e7fa63          	bgeu	a5,a4,ffffffffc0201c1c <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201c0c:	0009a797          	auipc	a5,0x9a
ffffffffc0201c10:	a347b783          	ld	a5,-1484(a5) # ffffffffc029b640 <va_pa_offset>
ffffffffc0201c14:	953e                	add	a0,a0,a5
}
ffffffffc0201c16:	60a2                	ld	ra,8(sp)
ffffffffc0201c18:	0141                	addi	sp,sp,16
ffffffffc0201c1a:	8082                	ret
ffffffffc0201c1c:	86aa                	mv	a3,a0
ffffffffc0201c1e:	00005617          	auipc	a2,0x5
ffffffffc0201c22:	9aa60613          	addi	a2,a2,-1622 # ffffffffc02065c8 <etext+0xd92>
ffffffffc0201c26:	07100593          	li	a1,113
ffffffffc0201c2a:	00005517          	auipc	a0,0x5
ffffffffc0201c2e:	9c650513          	addi	a0,a0,-1594 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0201c32:	815fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201c36 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201c36:	7179                	addi	sp,sp,-48
ffffffffc0201c38:	f406                	sd	ra,40(sp)
ffffffffc0201c3a:	f022                	sd	s0,32(sp)
ffffffffc0201c3c:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c3e:	01050713          	addi	a4,a0,16
ffffffffc0201c42:	6785                	lui	a5,0x1
ffffffffc0201c44:	0af77e63          	bgeu	a4,a5,ffffffffc0201d00 <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201c48:	00f50413          	addi	s0,a0,15
ffffffffc0201c4c:	8011                	srli	s0,s0,0x4
ffffffffc0201c4e:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c50:	100025f3          	csrr	a1,sstatus
ffffffffc0201c54:	8989                	andi	a1,a1,2
ffffffffc0201c56:	edd1                	bnez	a1,ffffffffc0201cf2 <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc0201c58:	00095497          	auipc	s1,0x95
ffffffffc0201c5c:	56048493          	addi	s1,s1,1376 # ffffffffc02971b8 <slobfree>
ffffffffc0201c60:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c62:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201c64:	4314                	lw	a3,0(a4)
ffffffffc0201c66:	0886da63          	bge	a3,s0,ffffffffc0201cfa <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc0201c6a:	00e60a63          	beq	a2,a4,ffffffffc0201c7e <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c6e:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201c70:	4394                	lw	a3,0(a5)
ffffffffc0201c72:	0286d863          	bge	a3,s0,ffffffffc0201ca2 <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc0201c76:	6090                	ld	a2,0(s1)
ffffffffc0201c78:	873e                	mv	a4,a5
ffffffffc0201c7a:	fee61ae3          	bne	a2,a4,ffffffffc0201c6e <slob_alloc.constprop.0+0x38>
    if (flag)
ffffffffc0201c7e:	e9b1                	bnez	a1,ffffffffc0201cd2 <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201c80:	4501                	li	a0,0
ffffffffc0201c82:	f51ff0ef          	jal	ffffffffc0201bd2 <__slob_get_free_pages.constprop.0>
ffffffffc0201c86:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc0201c88:	c915                	beqz	a0,ffffffffc0201cbc <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201c8a:	6585                	lui	a1,0x1
ffffffffc0201c8c:	e35ff0ef          	jal	ffffffffc0201ac0 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c90:	100025f3          	csrr	a1,sstatus
ffffffffc0201c94:	8989                	andi	a1,a1,2
ffffffffc0201c96:	e98d                	bnez	a1,ffffffffc0201cc8 <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc0201c98:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c9a:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201c9c:	4394                	lw	a3,0(a5)
ffffffffc0201c9e:	fc86cce3          	blt	a3,s0,ffffffffc0201c76 <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201ca2:	04d40563          	beq	s0,a3,ffffffffc0201cec <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc0201ca6:	00441613          	slli	a2,s0,0x4
ffffffffc0201caa:	963e                	add	a2,a2,a5
ffffffffc0201cac:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc0201cae:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201cb0:	9e81                	subw	a3,a3,s0
ffffffffc0201cb2:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201cb4:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201cb6:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201cb8:	e098                	sd	a4,0(s1)
    if (flag)
ffffffffc0201cba:	ed99                	bnez	a1,ffffffffc0201cd8 <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201cbc:	70a2                	ld	ra,40(sp)
ffffffffc0201cbe:	7402                	ld	s0,32(sp)
ffffffffc0201cc0:	64e2                	ld	s1,24(sp)
ffffffffc0201cc2:	853e                	mv	a0,a5
ffffffffc0201cc4:	6145                	addi	sp,sp,48
ffffffffc0201cc6:	8082                	ret
        intr_disable();
ffffffffc0201cc8:	c3dfe0ef          	jal	ffffffffc0200904 <intr_disable>
			cur = slobfree;
ffffffffc0201ccc:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201cce:	4585                	li	a1,1
ffffffffc0201cd0:	b7e9                	j	ffffffffc0201c9a <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201cd2:	c2dfe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201cd6:	b76d                	j	ffffffffc0201c80 <slob_alloc.constprop.0+0x4a>
ffffffffc0201cd8:	e43e                	sd	a5,8(sp)
ffffffffc0201cda:	c25fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201cde:	67a2                	ld	a5,8(sp)
}
ffffffffc0201ce0:	70a2                	ld	ra,40(sp)
ffffffffc0201ce2:	7402                	ld	s0,32(sp)
ffffffffc0201ce4:	64e2                	ld	s1,24(sp)
ffffffffc0201ce6:	853e                	mv	a0,a5
ffffffffc0201ce8:	6145                	addi	sp,sp,48
ffffffffc0201cea:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201cec:	6794                	ld	a3,8(a5)
ffffffffc0201cee:	e714                	sd	a3,8(a4)
ffffffffc0201cf0:	b7e1                	j	ffffffffc0201cb8 <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201cf2:	c13fe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201cf6:	4585                	li	a1,1
ffffffffc0201cf8:	b785                	j	ffffffffc0201c58 <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201cfa:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201cfc:	8732                	mv	a4,a2
ffffffffc0201cfe:	b755                	j	ffffffffc0201ca2 <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201d00:	00005697          	auipc	a3,0x5
ffffffffc0201d04:	90068693          	addi	a3,a3,-1792 # ffffffffc0206600 <etext+0xdca>
ffffffffc0201d08:	00004617          	auipc	a2,0x4
ffffffffc0201d0c:	51060613          	addi	a2,a2,1296 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0201d10:	06300593          	li	a1,99
ffffffffc0201d14:	00005517          	auipc	a0,0x5
ffffffffc0201d18:	90c50513          	addi	a0,a0,-1780 # ffffffffc0206620 <etext+0xdea>
ffffffffc0201d1c:	f2afe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201d20 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201d20:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201d22:	00005517          	auipc	a0,0x5
ffffffffc0201d26:	91650513          	addi	a0,a0,-1770 # ffffffffc0206638 <etext+0xe02>
{
ffffffffc0201d2a:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201d2c:	c68fe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201d30:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d32:	00005517          	auipc	a0,0x5
ffffffffc0201d36:	91e50513          	addi	a0,a0,-1762 # ffffffffc0206650 <etext+0xe1a>
}
ffffffffc0201d3a:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d3c:	c58fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201d40 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201d40:	4501                	li	a0,0
ffffffffc0201d42:	8082                	ret

ffffffffc0201d44 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201d44:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d46:	6685                	lui	a3,0x1
{
ffffffffc0201d48:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d4a:	16bd                	addi	a3,a3,-17 # fef <_binary_obj___user_softint_out_size-0x7bd9>
ffffffffc0201d4c:	04a6f963          	bgeu	a3,a0,ffffffffc0201d9e <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201d50:	e42a                	sd	a0,8(sp)
ffffffffc0201d52:	4561                	li	a0,24
ffffffffc0201d54:	e822                	sd	s0,16(sp)
ffffffffc0201d56:	ee1ff0ef          	jal	ffffffffc0201c36 <slob_alloc.constprop.0>
ffffffffc0201d5a:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201d5c:	c541                	beqz	a0,ffffffffc0201de4 <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201d5e:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201d60:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201d62:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201d64:	00f75763          	bge	a4,a5,ffffffffc0201d72 <kmalloc+0x2e>
ffffffffc0201d68:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201d6c:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201d6e:	fef74de3          	blt	a4,a5,ffffffffc0201d68 <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201d72:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d74:	e5fff0ef          	jal	ffffffffc0201bd2 <__slob_get_free_pages.constprop.0>
ffffffffc0201d78:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201d7a:	cd31                	beqz	a0,ffffffffc0201dd6 <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d7c:	100027f3          	csrr	a5,sstatus
ffffffffc0201d80:	8b89                	andi	a5,a5,2
ffffffffc0201d82:	eb85                	bnez	a5,ffffffffc0201db2 <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201d84:	0009a797          	auipc	a5,0x9a
ffffffffc0201d88:	89c7b783          	ld	a5,-1892(a5) # ffffffffc029b620 <bigblocks>
		bigblocks = bb;
ffffffffc0201d8c:	0009a717          	auipc	a4,0x9a
ffffffffc0201d90:	88873a23          	sd	s0,-1900(a4) # ffffffffc029b620 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201d94:	e81c                	sd	a5,16(s0)
    if (flag)
ffffffffc0201d96:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201d98:	60e2                	ld	ra,24(sp)
ffffffffc0201d9a:	6105                	addi	sp,sp,32
ffffffffc0201d9c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d9e:	0541                	addi	a0,a0,16
ffffffffc0201da0:	e97ff0ef          	jal	ffffffffc0201c36 <slob_alloc.constprop.0>
ffffffffc0201da4:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201da6:	0541                	addi	a0,a0,16
ffffffffc0201da8:	fbe5                	bnez	a5,ffffffffc0201d98 <kmalloc+0x54>
		return 0;
ffffffffc0201daa:	4501                	li	a0,0
}
ffffffffc0201dac:	60e2                	ld	ra,24(sp)
ffffffffc0201dae:	6105                	addi	sp,sp,32
ffffffffc0201db0:	8082                	ret
        intr_disable();
ffffffffc0201db2:	b53fe0ef          	jal	ffffffffc0200904 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201db6:	0009a797          	auipc	a5,0x9a
ffffffffc0201dba:	86a7b783          	ld	a5,-1942(a5) # ffffffffc029b620 <bigblocks>
		bigblocks = bb;
ffffffffc0201dbe:	0009a717          	auipc	a4,0x9a
ffffffffc0201dc2:	86873123          	sd	s0,-1950(a4) # ffffffffc029b620 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201dc6:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201dc8:	b37fe0ef          	jal	ffffffffc02008fe <intr_enable>
		return bb->pages;
ffffffffc0201dcc:	6408                	ld	a0,8(s0)
}
ffffffffc0201dce:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201dd0:	6442                	ld	s0,16(sp)
}
ffffffffc0201dd2:	6105                	addi	sp,sp,32
ffffffffc0201dd4:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201dd6:	8522                	mv	a0,s0
ffffffffc0201dd8:	45e1                	li	a1,24
ffffffffc0201dda:	ce7ff0ef          	jal	ffffffffc0201ac0 <slob_free>
		return 0;
ffffffffc0201dde:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201de0:	6442                	ld	s0,16(sp)
ffffffffc0201de2:	b7e9                	j	ffffffffc0201dac <kmalloc+0x68>
ffffffffc0201de4:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201de6:	4501                	li	a0,0
ffffffffc0201de8:	b7d1                	j	ffffffffc0201dac <kmalloc+0x68>

ffffffffc0201dea <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201dea:	c571                	beqz	a0,ffffffffc0201eb6 <kfree+0xcc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201dec:	03451793          	slli	a5,a0,0x34
ffffffffc0201df0:	e3e1                	bnez	a5,ffffffffc0201eb0 <kfree+0xc6>
{
ffffffffc0201df2:	1101                	addi	sp,sp,-32
ffffffffc0201df4:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201df6:	100027f3          	csrr	a5,sstatus
ffffffffc0201dfa:	8b89                	andi	a5,a5,2
ffffffffc0201dfc:	e7c1                	bnez	a5,ffffffffc0201e84 <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201dfe:	0009a797          	auipc	a5,0x9a
ffffffffc0201e02:	8227b783          	ld	a5,-2014(a5) # ffffffffc029b620 <bigblocks>
    return 0;
ffffffffc0201e06:	4581                	li	a1,0
ffffffffc0201e08:	cbad                	beqz	a5,ffffffffc0201e7a <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201e0a:	0009a617          	auipc	a2,0x9a
ffffffffc0201e0e:	81660613          	addi	a2,a2,-2026 # ffffffffc029b620 <bigblocks>
ffffffffc0201e12:	a021                	j	ffffffffc0201e1a <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e14:	01070613          	addi	a2,a4,16
ffffffffc0201e18:	c3a5                	beqz	a5,ffffffffc0201e78 <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201e1a:	6794                	ld	a3,8(a5)
ffffffffc0201e1c:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201e1e:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201e20:	fea69ae3          	bne	a3,a0,ffffffffc0201e14 <kfree+0x2a>
				*last = bb->next;
ffffffffc0201e24:	e21c                	sd	a5,0(a2)
    if (flag)
ffffffffc0201e26:	edb5                	bnez	a1,ffffffffc0201ea2 <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201e28:	c02007b7          	lui	a5,0xc0200
ffffffffc0201e2c:	0af56263          	bltu	a0,a5,ffffffffc0201ed0 <kfree+0xe6>
ffffffffc0201e30:	0009a797          	auipc	a5,0x9a
ffffffffc0201e34:	8107b783          	ld	a5,-2032(a5) # ffffffffc029b640 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201e38:	0009a697          	auipc	a3,0x9a
ffffffffc0201e3c:	8106b683          	ld	a3,-2032(a3) # ffffffffc029b648 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201e40:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201e42:	00c55793          	srli	a5,a0,0xc
ffffffffc0201e46:	06d7f963          	bgeu	a5,a3,ffffffffc0201eb8 <kfree+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e4a:	00006617          	auipc	a2,0x6
ffffffffc0201e4e:	b5663603          	ld	a2,-1194(a2) # ffffffffc02079a0 <nbase>
ffffffffc0201e52:	00099517          	auipc	a0,0x99
ffffffffc0201e56:	7fe53503          	ld	a0,2046(a0) # ffffffffc029b650 <pages>
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201e5a:	4314                	lw	a3,0(a4)
ffffffffc0201e5c:	8f91                	sub	a5,a5,a2
ffffffffc0201e5e:	079a                	slli	a5,a5,0x6
ffffffffc0201e60:	4585                	li	a1,1
ffffffffc0201e62:	953e                	add	a0,a0,a5
ffffffffc0201e64:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201e68:	e03a                	sd	a4,0(sp)
ffffffffc0201e6a:	0d6000ef          	jal	ffffffffc0201f40 <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e6e:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e70:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e72:	45e1                	li	a1,24
}
ffffffffc0201e74:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e76:	b1a9                	j	ffffffffc0201ac0 <slob_free>
ffffffffc0201e78:	e185                	bnez	a1,ffffffffc0201e98 <kfree+0xae>
}
ffffffffc0201e7a:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e7c:	1541                	addi	a0,a0,-16
ffffffffc0201e7e:	4581                	li	a1,0
}
ffffffffc0201e80:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e82:	b93d                	j	ffffffffc0201ac0 <slob_free>
        intr_disable();
ffffffffc0201e84:	e02a                	sd	a0,0(sp)
ffffffffc0201e86:	a7ffe0ef          	jal	ffffffffc0200904 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e8a:	00099797          	auipc	a5,0x99
ffffffffc0201e8e:	7967b783          	ld	a5,1942(a5) # ffffffffc029b620 <bigblocks>
ffffffffc0201e92:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201e94:	4585                	li	a1,1
ffffffffc0201e96:	fbb5                	bnez	a5,ffffffffc0201e0a <kfree+0x20>
ffffffffc0201e98:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201e9a:	a65fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201e9e:	6502                	ld	a0,0(sp)
ffffffffc0201ea0:	bfe9                	j	ffffffffc0201e7a <kfree+0x90>
ffffffffc0201ea2:	e42a                	sd	a0,8(sp)
ffffffffc0201ea4:	e03a                	sd	a4,0(sp)
ffffffffc0201ea6:	a59fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201eaa:	6522                	ld	a0,8(sp)
ffffffffc0201eac:	6702                	ld	a4,0(sp)
ffffffffc0201eae:	bfad                	j	ffffffffc0201e28 <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201eb0:	1541                	addi	a0,a0,-16
ffffffffc0201eb2:	4581                	li	a1,0
ffffffffc0201eb4:	b131                	j	ffffffffc0201ac0 <slob_free>
ffffffffc0201eb6:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201eb8:	00004617          	auipc	a2,0x4
ffffffffc0201ebc:	7e060613          	addi	a2,a2,2016 # ffffffffc0206698 <etext+0xe62>
ffffffffc0201ec0:	06900593          	li	a1,105
ffffffffc0201ec4:	00004517          	auipc	a0,0x4
ffffffffc0201ec8:	72c50513          	addi	a0,a0,1836 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0201ecc:	d7afe0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201ed0:	86aa                	mv	a3,a0
ffffffffc0201ed2:	00004617          	auipc	a2,0x4
ffffffffc0201ed6:	79e60613          	addi	a2,a2,1950 # ffffffffc0206670 <etext+0xe3a>
ffffffffc0201eda:	07700593          	li	a1,119
ffffffffc0201ede:	00004517          	auipc	a0,0x4
ffffffffc0201ee2:	71250513          	addi	a0,a0,1810 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0201ee6:	d60fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201eea <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201eea:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201eec:	00004617          	auipc	a2,0x4
ffffffffc0201ef0:	7ac60613          	addi	a2,a2,1964 # ffffffffc0206698 <etext+0xe62>
ffffffffc0201ef4:	06900593          	li	a1,105
ffffffffc0201ef8:	00004517          	auipc	a0,0x4
ffffffffc0201efc:	6f850513          	addi	a0,a0,1784 # ffffffffc02065f0 <etext+0xdba>
pa2page(uintptr_t pa)
ffffffffc0201f00:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201f02:	d44fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201f06 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f06:	100027f3          	csrr	a5,sstatus
ffffffffc0201f0a:	8b89                	andi	a5,a5,2
ffffffffc0201f0c:	e799                	bnez	a5,ffffffffc0201f1a <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f0e:	00099797          	auipc	a5,0x99
ffffffffc0201f12:	71a7b783          	ld	a5,1818(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc0201f16:	6f9c                	ld	a5,24(a5)
ffffffffc0201f18:	8782                	jr	a5
{
ffffffffc0201f1a:	1101                	addi	sp,sp,-32
ffffffffc0201f1c:	ec06                	sd	ra,24(sp)
ffffffffc0201f1e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201f20:	9e5fe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f24:	00099797          	auipc	a5,0x99
ffffffffc0201f28:	7047b783          	ld	a5,1796(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc0201f2c:	6522                	ld	a0,8(sp)
ffffffffc0201f2e:	6f9c                	ld	a5,24(a5)
ffffffffc0201f30:	9782                	jalr	a5
ffffffffc0201f32:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201f34:	9cbfe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201f38:	60e2                	ld	ra,24(sp)
ffffffffc0201f3a:	6522                	ld	a0,8(sp)
ffffffffc0201f3c:	6105                	addi	sp,sp,32
ffffffffc0201f3e:	8082                	ret

ffffffffc0201f40 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f40:	100027f3          	csrr	a5,sstatus
ffffffffc0201f44:	8b89                	andi	a5,a5,2
ffffffffc0201f46:	e799                	bnez	a5,ffffffffc0201f54 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201f48:	00099797          	auipc	a5,0x99
ffffffffc0201f4c:	6e07b783          	ld	a5,1760(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc0201f50:	739c                	ld	a5,32(a5)
ffffffffc0201f52:	8782                	jr	a5
{
ffffffffc0201f54:	1101                	addi	sp,sp,-32
ffffffffc0201f56:	ec06                	sd	ra,24(sp)
ffffffffc0201f58:	e42e                	sd	a1,8(sp)
ffffffffc0201f5a:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201f5c:	9a9fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f60:	00099797          	auipc	a5,0x99
ffffffffc0201f64:	6c87b783          	ld	a5,1736(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc0201f68:	65a2                	ld	a1,8(sp)
ffffffffc0201f6a:	6502                	ld	a0,0(sp)
ffffffffc0201f6c:	739c                	ld	a5,32(a5)
ffffffffc0201f6e:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201f70:	60e2                	ld	ra,24(sp)
ffffffffc0201f72:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f74:	98bfe06f          	j	ffffffffc02008fe <intr_enable>

ffffffffc0201f78 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f78:	100027f3          	csrr	a5,sstatus
ffffffffc0201f7c:	8b89                	andi	a5,a5,2
ffffffffc0201f7e:	e799                	bnez	a5,ffffffffc0201f8c <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f80:	00099797          	auipc	a5,0x99
ffffffffc0201f84:	6a87b783          	ld	a5,1704(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc0201f88:	779c                	ld	a5,40(a5)
ffffffffc0201f8a:	8782                	jr	a5
{
ffffffffc0201f8c:	1101                	addi	sp,sp,-32
ffffffffc0201f8e:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201f90:	975fe0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f94:	00099797          	auipc	a5,0x99
ffffffffc0201f98:	6947b783          	ld	a5,1684(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc0201f9c:	779c                	ld	a5,40(a5)
ffffffffc0201f9e:	9782                	jalr	a5
ffffffffc0201fa0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201fa2:	95dfe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201fa6:	60e2                	ld	ra,24(sp)
ffffffffc0201fa8:	6522                	ld	a0,8(sp)
ffffffffc0201faa:	6105                	addi	sp,sp,32
ffffffffc0201fac:	8082                	ret

ffffffffc0201fae <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201fae:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201fb2:	1ff7f793          	andi	a5,a5,511
ffffffffc0201fb6:	078e                	slli	a5,a5,0x3
ffffffffc0201fb8:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201fbc:	6314                	ld	a3,0(a4)
{
ffffffffc0201fbe:	7139                	addi	sp,sp,-64
ffffffffc0201fc0:	f822                	sd	s0,48(sp)
ffffffffc0201fc2:	f426                	sd	s1,40(sp)
ffffffffc0201fc4:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201fc6:	0016f793          	andi	a5,a3,1
{
ffffffffc0201fca:	842e                	mv	s0,a1
ffffffffc0201fcc:	8832                	mv	a6,a2
ffffffffc0201fce:	00099497          	auipc	s1,0x99
ffffffffc0201fd2:	67a48493          	addi	s1,s1,1658 # ffffffffc029b648 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201fd6:	ebd1                	bnez	a5,ffffffffc020206a <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fd8:	16060d63          	beqz	a2,ffffffffc0202152 <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201fdc:	100027f3          	csrr	a5,sstatus
ffffffffc0201fe0:	8b89                	andi	a5,a5,2
ffffffffc0201fe2:	16079e63          	bnez	a5,ffffffffc020215e <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201fe6:	00099797          	auipc	a5,0x99
ffffffffc0201fea:	6427b783          	ld	a5,1602(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc0201fee:	4505                	li	a0,1
ffffffffc0201ff0:	e43a                	sd	a4,8(sp)
ffffffffc0201ff2:	6f9c                	ld	a5,24(a5)
ffffffffc0201ff4:	e832                	sd	a2,16(sp)
ffffffffc0201ff6:	9782                	jalr	a5
ffffffffc0201ff8:	6722                	ld	a4,8(sp)
ffffffffc0201ffa:	6842                	ld	a6,16(sp)
ffffffffc0201ffc:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201ffe:	14078a63          	beqz	a5,ffffffffc0202152 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0202002:	00099517          	auipc	a0,0x99
ffffffffc0202006:	64e53503          	ld	a0,1614(a0) # ffffffffc029b650 <pages>
ffffffffc020200a:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020200e:	00099497          	auipc	s1,0x99
ffffffffc0202012:	63a48493          	addi	s1,s1,1594 # ffffffffc029b648 <npage>
ffffffffc0202016:	40a78533          	sub	a0,a5,a0
ffffffffc020201a:	8519                	srai	a0,a0,0x6
ffffffffc020201c:	9546                	add	a0,a0,a7
ffffffffc020201e:	6090                	ld	a2,0(s1)
ffffffffc0202020:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc0202024:	4585                	li	a1,1
ffffffffc0202026:	82b1                	srli	a3,a3,0xc
ffffffffc0202028:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc020202a:	0532                	slli	a0,a0,0xc
ffffffffc020202c:	1ac6f763          	bgeu	a3,a2,ffffffffc02021da <get_pte+0x22c>
ffffffffc0202030:	00099697          	auipc	a3,0x99
ffffffffc0202034:	6106b683          	ld	a3,1552(a3) # ffffffffc029b640 <va_pa_offset>
ffffffffc0202038:	6605                	lui	a2,0x1
ffffffffc020203a:	4581                	li	a1,0
ffffffffc020203c:	9536                	add	a0,a0,a3
ffffffffc020203e:	ec42                	sd	a6,24(sp)
ffffffffc0202040:	e83e                	sd	a5,16(sp)
ffffffffc0202042:	e43a                	sd	a4,8(sp)
ffffffffc0202044:	7c8030ef          	jal	ffffffffc020580c <memset>
    return page - pages + nbase;
ffffffffc0202048:	00099697          	auipc	a3,0x99
ffffffffc020204c:	6086b683          	ld	a3,1544(a3) # ffffffffc029b650 <pages>
ffffffffc0202050:	67c2                	ld	a5,16(sp)
ffffffffc0202052:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202056:	6722                	ld	a4,8(sp)
ffffffffc0202058:	40d786b3          	sub	a3,a5,a3
ffffffffc020205c:	8699                	srai	a3,a3,0x6
ffffffffc020205e:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202060:	06aa                	slli	a3,a3,0xa
ffffffffc0202062:	6862                	ld	a6,24(sp)
ffffffffc0202064:	0116e693          	ori	a3,a3,17
ffffffffc0202068:	e314                	sd	a3,0(a4)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020206a:	c006f693          	andi	a3,a3,-1024
ffffffffc020206e:	6098                	ld	a4,0(s1)
ffffffffc0202070:	068a                	slli	a3,a3,0x2
ffffffffc0202072:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202076:	14e7f663          	bgeu	a5,a4,ffffffffc02021c2 <get_pte+0x214>
ffffffffc020207a:	00099897          	auipc	a7,0x99
ffffffffc020207e:	5c688893          	addi	a7,a7,1478 # ffffffffc029b640 <va_pa_offset>
ffffffffc0202082:	0008b603          	ld	a2,0(a7)
ffffffffc0202086:	01545793          	srli	a5,s0,0x15
ffffffffc020208a:	1ff7f793          	andi	a5,a5,511
ffffffffc020208e:	96b2                	add	a3,a3,a2
ffffffffc0202090:	078e                	slli	a5,a5,0x3
ffffffffc0202092:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0202094:	6394                	ld	a3,0(a5)
ffffffffc0202096:	0016f613          	andi	a2,a3,1
ffffffffc020209a:	e659                	bnez	a2,ffffffffc0202128 <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020209c:	0a080b63          	beqz	a6,ffffffffc0202152 <get_pte+0x1a4>
ffffffffc02020a0:	10002773          	csrr	a4,sstatus
ffffffffc02020a4:	8b09                	andi	a4,a4,2
ffffffffc02020a6:	ef71                	bnez	a4,ffffffffc0202182 <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020a8:	00099717          	auipc	a4,0x99
ffffffffc02020ac:	58073703          	ld	a4,1408(a4) # ffffffffc029b628 <pmm_manager>
ffffffffc02020b0:	4505                	li	a0,1
ffffffffc02020b2:	e43e                	sd	a5,8(sp)
ffffffffc02020b4:	6f18                	ld	a4,24(a4)
ffffffffc02020b6:	9702                	jalr	a4
ffffffffc02020b8:	67a2                	ld	a5,8(sp)
ffffffffc02020ba:	872a                	mv	a4,a0
ffffffffc02020bc:	00099897          	auipc	a7,0x99
ffffffffc02020c0:	58488893          	addi	a7,a7,1412 # ffffffffc029b640 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02020c4:	c759                	beqz	a4,ffffffffc0202152 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc02020c6:	00099697          	auipc	a3,0x99
ffffffffc02020ca:	58a6b683          	ld	a3,1418(a3) # ffffffffc029b650 <pages>
ffffffffc02020ce:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02020d2:	608c                	ld	a1,0(s1)
ffffffffc02020d4:	40d706b3          	sub	a3,a4,a3
ffffffffc02020d8:	8699                	srai	a3,a3,0x6
ffffffffc02020da:	96c2                	add	a3,a3,a6
ffffffffc02020dc:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc02020e0:	4505                	li	a0,1
ffffffffc02020e2:	8231                	srli	a2,a2,0xc
ffffffffc02020e4:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc02020e6:	06b2                	slli	a3,a3,0xc
ffffffffc02020e8:	10b67663          	bgeu	a2,a1,ffffffffc02021f4 <get_pte+0x246>
ffffffffc02020ec:	0008b503          	ld	a0,0(a7)
ffffffffc02020f0:	6605                	lui	a2,0x1
ffffffffc02020f2:	4581                	li	a1,0
ffffffffc02020f4:	9536                	add	a0,a0,a3
ffffffffc02020f6:	e83a                	sd	a4,16(sp)
ffffffffc02020f8:	e43e                	sd	a5,8(sp)
ffffffffc02020fa:	712030ef          	jal	ffffffffc020580c <memset>
    return page - pages + nbase;
ffffffffc02020fe:	00099697          	auipc	a3,0x99
ffffffffc0202102:	5526b683          	ld	a3,1362(a3) # ffffffffc029b650 <pages>
ffffffffc0202106:	6742                	ld	a4,16(sp)
ffffffffc0202108:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020210c:	67a2                	ld	a5,8(sp)
ffffffffc020210e:	40d706b3          	sub	a3,a4,a3
ffffffffc0202112:	8699                	srai	a3,a3,0x6
ffffffffc0202114:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202116:	06aa                	slli	a3,a3,0xa
ffffffffc0202118:	0116e693          	ori	a3,a3,17
ffffffffc020211c:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020211e:	6098                	ld	a4,0(s1)
ffffffffc0202120:	00099897          	auipc	a7,0x99
ffffffffc0202124:	52088893          	addi	a7,a7,1312 # ffffffffc029b640 <va_pa_offset>
ffffffffc0202128:	c006f693          	andi	a3,a3,-1024
ffffffffc020212c:	068a                	slli	a3,a3,0x2
ffffffffc020212e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202132:	06e7fc63          	bgeu	a5,a4,ffffffffc02021aa <get_pte+0x1fc>
ffffffffc0202136:	0008b783          	ld	a5,0(a7)
ffffffffc020213a:	8031                	srli	s0,s0,0xc
ffffffffc020213c:	1ff47413          	andi	s0,s0,511
ffffffffc0202140:	040e                	slli	s0,s0,0x3
ffffffffc0202142:	96be                	add	a3,a3,a5
}
ffffffffc0202144:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202146:	00868533          	add	a0,a3,s0
}
ffffffffc020214a:	7442                	ld	s0,48(sp)
ffffffffc020214c:	74a2                	ld	s1,40(sp)
ffffffffc020214e:	6121                	addi	sp,sp,64
ffffffffc0202150:	8082                	ret
ffffffffc0202152:	70e2                	ld	ra,56(sp)
ffffffffc0202154:	7442                	ld	s0,48(sp)
ffffffffc0202156:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc0202158:	4501                	li	a0,0
}
ffffffffc020215a:	6121                	addi	sp,sp,64
ffffffffc020215c:	8082                	ret
        intr_disable();
ffffffffc020215e:	e83a                	sd	a4,16(sp)
ffffffffc0202160:	ec32                	sd	a2,24(sp)
ffffffffc0202162:	fa2fe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202166:	00099797          	auipc	a5,0x99
ffffffffc020216a:	4c27b783          	ld	a5,1218(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc020216e:	4505                	li	a0,1
ffffffffc0202170:	6f9c                	ld	a5,24(a5)
ffffffffc0202172:	9782                	jalr	a5
ffffffffc0202174:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202176:	f88fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020217a:	6862                	ld	a6,24(sp)
ffffffffc020217c:	6742                	ld	a4,16(sp)
ffffffffc020217e:	67a2                	ld	a5,8(sp)
ffffffffc0202180:	bdbd                	j	ffffffffc0201ffe <get_pte+0x50>
        intr_disable();
ffffffffc0202182:	e83e                	sd	a5,16(sp)
ffffffffc0202184:	f80fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202188:	00099717          	auipc	a4,0x99
ffffffffc020218c:	4a073703          	ld	a4,1184(a4) # ffffffffc029b628 <pmm_manager>
ffffffffc0202190:	4505                	li	a0,1
ffffffffc0202192:	6f18                	ld	a4,24(a4)
ffffffffc0202194:	9702                	jalr	a4
ffffffffc0202196:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202198:	f66fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020219c:	6722                	ld	a4,8(sp)
ffffffffc020219e:	67c2                	ld	a5,16(sp)
ffffffffc02021a0:	00099897          	auipc	a7,0x99
ffffffffc02021a4:	4a088893          	addi	a7,a7,1184 # ffffffffc029b640 <va_pa_offset>
ffffffffc02021a8:	bf31                	j	ffffffffc02020c4 <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02021aa:	00004617          	auipc	a2,0x4
ffffffffc02021ae:	41e60613          	addi	a2,a2,1054 # ffffffffc02065c8 <etext+0xd92>
ffffffffc02021b2:	0fa00593          	li	a1,250
ffffffffc02021b6:	00004517          	auipc	a0,0x4
ffffffffc02021ba:	50250513          	addi	a0,a0,1282 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02021be:	a88fe0ef          	jal	ffffffffc0200446 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02021c2:	00004617          	auipc	a2,0x4
ffffffffc02021c6:	40660613          	addi	a2,a2,1030 # ffffffffc02065c8 <etext+0xd92>
ffffffffc02021ca:	0ed00593          	li	a1,237
ffffffffc02021ce:	00004517          	auipc	a0,0x4
ffffffffc02021d2:	4ea50513          	addi	a0,a0,1258 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02021d6:	a70fe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021da:	86aa                	mv	a3,a0
ffffffffc02021dc:	00004617          	auipc	a2,0x4
ffffffffc02021e0:	3ec60613          	addi	a2,a2,1004 # ffffffffc02065c8 <etext+0xd92>
ffffffffc02021e4:	0e900593          	li	a1,233
ffffffffc02021e8:	00004517          	auipc	a0,0x4
ffffffffc02021ec:	4d050513          	addi	a0,a0,1232 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02021f0:	a56fe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021f4:	00004617          	auipc	a2,0x4
ffffffffc02021f8:	3d460613          	addi	a2,a2,980 # ffffffffc02065c8 <etext+0xd92>
ffffffffc02021fc:	0f700593          	li	a1,247
ffffffffc0202200:	00004517          	auipc	a0,0x4
ffffffffc0202204:	4b850513          	addi	a0,a0,1208 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202208:	a3efe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020220c <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc020220c:	1141                	addi	sp,sp,-16
ffffffffc020220e:	e022                	sd	s0,0(sp)
ffffffffc0202210:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202212:	4601                	li	a2,0
{
ffffffffc0202214:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202216:	d99ff0ef          	jal	ffffffffc0201fae <get_pte>
    if (ptep_store != NULL)
ffffffffc020221a:	c011                	beqz	s0,ffffffffc020221e <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc020221c:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020221e:	c511                	beqz	a0,ffffffffc020222a <get_page+0x1e>
ffffffffc0202220:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202222:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202224:	0017f713          	andi	a4,a5,1
ffffffffc0202228:	e709                	bnez	a4,ffffffffc0202232 <get_page+0x26>
}
ffffffffc020222a:	60a2                	ld	ra,8(sp)
ffffffffc020222c:	6402                	ld	s0,0(sp)
ffffffffc020222e:	0141                	addi	sp,sp,16
ffffffffc0202230:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202232:	00099717          	auipc	a4,0x99
ffffffffc0202236:	41673703          	ld	a4,1046(a4) # ffffffffc029b648 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020223a:	078a                	slli	a5,a5,0x2
ffffffffc020223c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020223e:	00e7ff63          	bgeu	a5,a4,ffffffffc020225c <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc0202242:	00099517          	auipc	a0,0x99
ffffffffc0202246:	40e53503          	ld	a0,1038(a0) # ffffffffc029b650 <pages>
ffffffffc020224a:	60a2                	ld	ra,8(sp)
ffffffffc020224c:	6402                	ld	s0,0(sp)
ffffffffc020224e:	079a                	slli	a5,a5,0x6
ffffffffc0202250:	fe000737          	lui	a4,0xfe000
ffffffffc0202254:	97ba                	add	a5,a5,a4
ffffffffc0202256:	953e                	add	a0,a0,a5
ffffffffc0202258:	0141                	addi	sp,sp,16
ffffffffc020225a:	8082                	ret
ffffffffc020225c:	c8fff0ef          	jal	ffffffffc0201eea <pa2page.part.0>

ffffffffc0202260 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202260:	715d                	addi	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202262:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202266:	e486                	sd	ra,72(sp)
ffffffffc0202268:	e0a2                	sd	s0,64(sp)
ffffffffc020226a:	fc26                	sd	s1,56(sp)
ffffffffc020226c:	f84a                	sd	s2,48(sp)
ffffffffc020226e:	f44e                	sd	s3,40(sp)
ffffffffc0202270:	f052                	sd	s4,32(sp)
ffffffffc0202272:	ec56                	sd	s5,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202274:	03479713          	slli	a4,a5,0x34
ffffffffc0202278:	ef61                	bnez	a4,ffffffffc0202350 <unmap_range+0xf0>
    assert(USER_ACCESS(start, end));
ffffffffc020227a:	00200a37          	lui	s4,0x200
ffffffffc020227e:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202282:	0145b733          	sltu	a4,a1,s4
ffffffffc0202286:	0017b793          	seqz	a5,a5
ffffffffc020228a:	8fd9                	or	a5,a5,a4
ffffffffc020228c:	842e                	mv	s0,a1
ffffffffc020228e:	84b2                	mv	s1,a2
ffffffffc0202290:	e3e5                	bnez	a5,ffffffffc0202370 <unmap_range+0x110>
ffffffffc0202292:	4785                	li	a5,1
ffffffffc0202294:	07fe                	slli	a5,a5,0x1f
ffffffffc0202296:	0785                	addi	a5,a5,1
ffffffffc0202298:	892a                	mv	s2,a0
ffffffffc020229a:	6985                	lui	s3,0x1
    do
    {
        pte_t *ptep = get_pte(pgdir, start, 0);
        if (ptep == NULL)
        {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020229c:	ffe00ab7          	lui	s5,0xffe00
    assert(USER_ACCESS(start, end));
ffffffffc02022a0:	0cf67863          	bgeu	a2,a5,ffffffffc0202370 <unmap_range+0x110>
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc02022a4:	4601                	li	a2,0
ffffffffc02022a6:	85a2                	mv	a1,s0
ffffffffc02022a8:	854a                	mv	a0,s2
ffffffffc02022aa:	d05ff0ef          	jal	ffffffffc0201fae <get_pte>
ffffffffc02022ae:	87aa                	mv	a5,a0
        if (ptep == NULL)
ffffffffc02022b0:	cd31                	beqz	a0,ffffffffc020230c <unmap_range+0xac>
            continue;
        }
        if (*ptep != 0)
ffffffffc02022b2:	6118                	ld	a4,0(a0)
ffffffffc02022b4:	ef11                	bnez	a4,ffffffffc02022d0 <unmap_range+0x70>
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02022b6:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc02022b8:	c019                	beqz	s0,ffffffffc02022be <unmap_range+0x5e>
ffffffffc02022ba:	fe9465e3          	bltu	s0,s1,ffffffffc02022a4 <unmap_range+0x44>
}
ffffffffc02022be:	60a6                	ld	ra,72(sp)
ffffffffc02022c0:	6406                	ld	s0,64(sp)
ffffffffc02022c2:	74e2                	ld	s1,56(sp)
ffffffffc02022c4:	7942                	ld	s2,48(sp)
ffffffffc02022c6:	79a2                	ld	s3,40(sp)
ffffffffc02022c8:	7a02                	ld	s4,32(sp)
ffffffffc02022ca:	6ae2                	ld	s5,24(sp)
ffffffffc02022cc:	6161                	addi	sp,sp,80
ffffffffc02022ce:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02022d0:	00177693          	andi	a3,a4,1
ffffffffc02022d4:	d2ed                	beqz	a3,ffffffffc02022b6 <unmap_range+0x56>
    if (PPN(pa) >= npage)
ffffffffc02022d6:	00099697          	auipc	a3,0x99
ffffffffc02022da:	3726b683          	ld	a3,882(a3) # ffffffffc029b648 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02022de:	070a                	slli	a4,a4,0x2
ffffffffc02022e0:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc02022e2:	0ad77763          	bgeu	a4,a3,ffffffffc0202390 <unmap_range+0x130>
    return &pages[PPN(pa) - nbase];
ffffffffc02022e6:	00099517          	auipc	a0,0x99
ffffffffc02022ea:	36a53503          	ld	a0,874(a0) # ffffffffc029b650 <pages>
ffffffffc02022ee:	071a                	slli	a4,a4,0x6
ffffffffc02022f0:	fe0006b7          	lui	a3,0xfe000
ffffffffc02022f4:	9736                	add	a4,a4,a3
ffffffffc02022f6:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc02022f8:	4118                	lw	a4,0(a0)
ffffffffc02022fa:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd64987>
ffffffffc02022fc:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02022fe:	cb19                	beqz	a4,ffffffffc0202314 <unmap_range+0xb4>
        *ptep = 0;
ffffffffc0202300:	0007b023          	sd	zero,0(a5)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202304:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202308:	944e                	add	s0,s0,s3
ffffffffc020230a:	b77d                	j	ffffffffc02022b8 <unmap_range+0x58>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020230c:	9452                	add	s0,s0,s4
ffffffffc020230e:	01547433          	and	s0,s0,s5
            continue;
ffffffffc0202312:	b75d                	j	ffffffffc02022b8 <unmap_range+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202314:	10002773          	csrr	a4,sstatus
ffffffffc0202318:	8b09                	andi	a4,a4,2
ffffffffc020231a:	eb19                	bnez	a4,ffffffffc0202330 <unmap_range+0xd0>
        pmm_manager->free_pages(base, n);
ffffffffc020231c:	00099717          	auipc	a4,0x99
ffffffffc0202320:	30c73703          	ld	a4,780(a4) # ffffffffc029b628 <pmm_manager>
ffffffffc0202324:	4585                	li	a1,1
ffffffffc0202326:	e03e                	sd	a5,0(sp)
ffffffffc0202328:	7318                	ld	a4,32(a4)
ffffffffc020232a:	9702                	jalr	a4
    if (flag)
ffffffffc020232c:	6782                	ld	a5,0(sp)
ffffffffc020232e:	bfc9                	j	ffffffffc0202300 <unmap_range+0xa0>
        intr_disable();
ffffffffc0202330:	e43e                	sd	a5,8(sp)
ffffffffc0202332:	e02a                	sd	a0,0(sp)
ffffffffc0202334:	dd0fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202338:	00099717          	auipc	a4,0x99
ffffffffc020233c:	2f073703          	ld	a4,752(a4) # ffffffffc029b628 <pmm_manager>
ffffffffc0202340:	6502                	ld	a0,0(sp)
ffffffffc0202342:	4585                	li	a1,1
ffffffffc0202344:	7318                	ld	a4,32(a4)
ffffffffc0202346:	9702                	jalr	a4
        intr_enable();
ffffffffc0202348:	db6fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020234c:	67a2                	ld	a5,8(sp)
ffffffffc020234e:	bf4d                	j	ffffffffc0202300 <unmap_range+0xa0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202350:	00004697          	auipc	a3,0x4
ffffffffc0202354:	37868693          	addi	a3,a3,888 # ffffffffc02066c8 <etext+0xe92>
ffffffffc0202358:	00004617          	auipc	a2,0x4
ffffffffc020235c:	ec060613          	addi	a2,a2,-320 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0202360:	12000593          	li	a1,288
ffffffffc0202364:	00004517          	auipc	a0,0x4
ffffffffc0202368:	35450513          	addi	a0,a0,852 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020236c:	8dafe0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202370:	00004697          	auipc	a3,0x4
ffffffffc0202374:	38868693          	addi	a3,a3,904 # ffffffffc02066f8 <etext+0xec2>
ffffffffc0202378:	00004617          	auipc	a2,0x4
ffffffffc020237c:	ea060613          	addi	a2,a2,-352 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0202380:	12100593          	li	a1,289
ffffffffc0202384:	00004517          	auipc	a0,0x4
ffffffffc0202388:	33450513          	addi	a0,a0,820 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020238c:	8bafe0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202390:	b5bff0ef          	jal	ffffffffc0201eea <pa2page.part.0>

ffffffffc0202394 <exit_range>:
{
ffffffffc0202394:	7135                	addi	sp,sp,-160
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202396:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020239a:	ed06                	sd	ra,152(sp)
ffffffffc020239c:	e922                	sd	s0,144(sp)
ffffffffc020239e:	e526                	sd	s1,136(sp)
ffffffffc02023a0:	e14a                	sd	s2,128(sp)
ffffffffc02023a2:	fcce                	sd	s3,120(sp)
ffffffffc02023a4:	f8d2                	sd	s4,112(sp)
ffffffffc02023a6:	f4d6                	sd	s5,104(sp)
ffffffffc02023a8:	f0da                	sd	s6,96(sp)
ffffffffc02023aa:	ecde                	sd	s7,88(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023ac:	17d2                	slli	a5,a5,0x34
ffffffffc02023ae:	22079263          	bnez	a5,ffffffffc02025d2 <exit_range+0x23e>
    assert(USER_ACCESS(start, end));
ffffffffc02023b2:	00200937          	lui	s2,0x200
ffffffffc02023b6:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc02023ba:	0125b733          	sltu	a4,a1,s2
ffffffffc02023be:	0017b793          	seqz	a5,a5
ffffffffc02023c2:	8fd9                	or	a5,a5,a4
ffffffffc02023c4:	26079263          	bnez	a5,ffffffffc0202628 <exit_range+0x294>
ffffffffc02023c8:	4785                	li	a5,1
ffffffffc02023ca:	07fe                	slli	a5,a5,0x1f
ffffffffc02023cc:	0785                	addi	a5,a5,1
ffffffffc02023ce:	24f67d63          	bgeu	a2,a5,ffffffffc0202628 <exit_range+0x294>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02023d2:	c00004b7          	lui	s1,0xc0000
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023d6:	ffe007b7          	lui	a5,0xffe00
ffffffffc02023da:	8a2a                	mv	s4,a0
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02023dc:	8ced                	and	s1,s1,a1
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023de:	00f5f833          	and	a6,a1,a5
    if (PPN(pa) >= npage)
ffffffffc02023e2:	00099a97          	auipc	s5,0x99
ffffffffc02023e6:	266a8a93          	addi	s5,s5,614 # ffffffffc029b648 <npage>
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02023ea:	400009b7          	lui	s3,0x40000
ffffffffc02023ee:	a809                	j	ffffffffc0202400 <exit_range+0x6c>
        d1start += PDSIZE;
ffffffffc02023f0:	013487b3          	add	a5,s1,s3
ffffffffc02023f4:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc02023f8:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc02023fa:	c3f1                	beqz	a5,ffffffffc02024be <exit_range+0x12a>
ffffffffc02023fc:	0cc7f163          	bgeu	a5,a2,ffffffffc02024be <exit_range+0x12a>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202400:	01e4d413          	srli	s0,s1,0x1e
ffffffffc0202404:	1ff47413          	andi	s0,s0,511
ffffffffc0202408:	040e                	slli	s0,s0,0x3
ffffffffc020240a:	9452                	add	s0,s0,s4
ffffffffc020240c:	00043883          	ld	a7,0(s0)
        if (pde1 & PTE_V)
ffffffffc0202410:	0018f793          	andi	a5,a7,1
ffffffffc0202414:	dff1                	beqz	a5,ffffffffc02023f0 <exit_range+0x5c>
ffffffffc0202416:	000ab783          	ld	a5,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc020241a:	088a                	slli	a7,a7,0x2
ffffffffc020241c:	00c8d893          	srli	a7,a7,0xc
    if (PPN(pa) >= npage)
ffffffffc0202420:	20f8f263          	bgeu	a7,a5,ffffffffc0202624 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc0202424:	fff802b7          	lui	t0,0xfff80
ffffffffc0202428:	00588f33          	add	t5,a7,t0
    return page - pages + nbase;
ffffffffc020242c:	000803b7          	lui	t2,0x80
ffffffffc0202430:	007f0733          	add	a4,t5,t2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202434:	00c71e13          	slli	t3,a4,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202438:	0f1a                	slli	t5,t5,0x6
    return KADDR(page2pa(page));
ffffffffc020243a:	1cf77863          	bgeu	a4,a5,ffffffffc020260a <exit_range+0x276>
ffffffffc020243e:	00099f97          	auipc	t6,0x99
ffffffffc0202442:	202f8f93          	addi	t6,t6,514 # ffffffffc029b640 <va_pa_offset>
ffffffffc0202446:	000fb783          	ld	a5,0(t6)
            free_pd0 = 1;
ffffffffc020244a:	4e85                	li	t4,1
ffffffffc020244c:	6b05                	lui	s6,0x1
ffffffffc020244e:	9e3e                	add	t3,t3,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202450:	01348333          	add	t1,s1,s3
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202454:	01585713          	srli	a4,a6,0x15
ffffffffc0202458:	1ff77713          	andi	a4,a4,511
ffffffffc020245c:	070e                	slli	a4,a4,0x3
ffffffffc020245e:	9772                	add	a4,a4,t3
ffffffffc0202460:	631c                	ld	a5,0(a4)
                if (pde0 & PTE_V)
ffffffffc0202462:	0017f693          	andi	a3,a5,1
ffffffffc0202466:	e6bd                	bnez	a3,ffffffffc02024d4 <exit_range+0x140>
                    free_pd0 = 0;
ffffffffc0202468:	4e81                	li	t4,0
                d0start += PTSIZE;
ffffffffc020246a:	984a                	add	a6,a6,s2
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020246c:	00080863          	beqz	a6,ffffffffc020247c <exit_range+0xe8>
ffffffffc0202470:	879a                	mv	a5,t1
ffffffffc0202472:	00667363          	bgeu	a2,t1,ffffffffc0202478 <exit_range+0xe4>
ffffffffc0202476:	87b2                	mv	a5,a2
ffffffffc0202478:	fcf86ee3          	bltu	a6,a5,ffffffffc0202454 <exit_range+0xc0>
            if (free_pd0)
ffffffffc020247c:	f60e8ae3          	beqz	t4,ffffffffc02023f0 <exit_range+0x5c>
    if (PPN(pa) >= npage)
ffffffffc0202480:	000ab783          	ld	a5,0(s5)
ffffffffc0202484:	1af8f063          	bgeu	a7,a5,ffffffffc0202624 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc0202488:	00099517          	auipc	a0,0x99
ffffffffc020248c:	1c853503          	ld	a0,456(a0) # ffffffffc029b650 <pages>
ffffffffc0202490:	957a                	add	a0,a0,t5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202492:	100027f3          	csrr	a5,sstatus
ffffffffc0202496:	8b89                	andi	a5,a5,2
ffffffffc0202498:	10079b63          	bnez	a5,ffffffffc02025ae <exit_range+0x21a>
        pmm_manager->free_pages(base, n);
ffffffffc020249c:	00099797          	auipc	a5,0x99
ffffffffc02024a0:	18c7b783          	ld	a5,396(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc02024a4:	4585                	li	a1,1
ffffffffc02024a6:	e432                	sd	a2,8(sp)
ffffffffc02024a8:	739c                	ld	a5,32(a5)
ffffffffc02024aa:	9782                	jalr	a5
ffffffffc02024ac:	6622                	ld	a2,8(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc02024ae:	00043023          	sd	zero,0(s0)
        d1start += PDSIZE;
ffffffffc02024b2:	013487b3          	add	a5,s1,s3
ffffffffc02024b6:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc02024ba:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc02024bc:	f3a1                	bnez	a5,ffffffffc02023fc <exit_range+0x68>
}
ffffffffc02024be:	60ea                	ld	ra,152(sp)
ffffffffc02024c0:	644a                	ld	s0,144(sp)
ffffffffc02024c2:	64aa                	ld	s1,136(sp)
ffffffffc02024c4:	690a                	ld	s2,128(sp)
ffffffffc02024c6:	79e6                	ld	s3,120(sp)
ffffffffc02024c8:	7a46                	ld	s4,112(sp)
ffffffffc02024ca:	7aa6                	ld	s5,104(sp)
ffffffffc02024cc:	7b06                	ld	s6,96(sp)
ffffffffc02024ce:	6be6                	ld	s7,88(sp)
ffffffffc02024d0:	610d                	addi	sp,sp,160
ffffffffc02024d2:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02024d4:	000ab503          	ld	a0,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024d8:	078a                	slli	a5,a5,0x2
ffffffffc02024da:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024dc:	14a7f463          	bgeu	a5,a0,ffffffffc0202624 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02024e0:	9796                	add	a5,a5,t0
    return page - pages + nbase;
ffffffffc02024e2:	00778bb3          	add	s7,a5,t2
    return &pages[PPN(pa) - nbase];
ffffffffc02024e6:	00679593          	slli	a1,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02024ea:	00cb9693          	slli	a3,s7,0xc
    return KADDR(page2pa(page));
ffffffffc02024ee:	10abf263          	bgeu	s7,a0,ffffffffc02025f2 <exit_range+0x25e>
ffffffffc02024f2:	000fb783          	ld	a5,0(t6)
ffffffffc02024f6:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02024f8:	01668533          	add	a0,a3,s6
                        if (pt[i] & PTE_V)
ffffffffc02024fc:	629c                	ld	a5,0(a3)
ffffffffc02024fe:	8b85                	andi	a5,a5,1
ffffffffc0202500:	f7ad                	bnez	a5,ffffffffc020246a <exit_range+0xd6>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202502:	06a1                	addi	a3,a3,8
ffffffffc0202504:	fea69ce3          	bne	a3,a0,ffffffffc02024fc <exit_range+0x168>
    return &pages[PPN(pa) - nbase];
ffffffffc0202508:	00099517          	auipc	a0,0x99
ffffffffc020250c:	14853503          	ld	a0,328(a0) # ffffffffc029b650 <pages>
ffffffffc0202510:	952e                	add	a0,a0,a1
ffffffffc0202512:	100027f3          	csrr	a5,sstatus
ffffffffc0202516:	8b89                	andi	a5,a5,2
ffffffffc0202518:	e3b9                	bnez	a5,ffffffffc020255e <exit_range+0x1ca>
        pmm_manager->free_pages(base, n);
ffffffffc020251a:	00099797          	auipc	a5,0x99
ffffffffc020251e:	10e7b783          	ld	a5,270(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc0202522:	4585                	li	a1,1
ffffffffc0202524:	e0b2                	sd	a2,64(sp)
ffffffffc0202526:	739c                	ld	a5,32(a5)
ffffffffc0202528:	fc1a                	sd	t1,56(sp)
ffffffffc020252a:	f846                	sd	a7,48(sp)
ffffffffc020252c:	f47a                	sd	t5,40(sp)
ffffffffc020252e:	f072                	sd	t3,32(sp)
ffffffffc0202530:	ec76                	sd	t4,24(sp)
ffffffffc0202532:	e842                	sd	a6,16(sp)
ffffffffc0202534:	e43a                	sd	a4,8(sp)
ffffffffc0202536:	9782                	jalr	a5
    if (flag)
ffffffffc0202538:	6722                	ld	a4,8(sp)
ffffffffc020253a:	6842                	ld	a6,16(sp)
ffffffffc020253c:	6ee2                	ld	t4,24(sp)
ffffffffc020253e:	7e02                	ld	t3,32(sp)
ffffffffc0202540:	7f22                	ld	t5,40(sp)
ffffffffc0202542:	78c2                	ld	a7,48(sp)
ffffffffc0202544:	7362                	ld	t1,56(sp)
ffffffffc0202546:	6606                	ld	a2,64(sp)
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202548:	fff802b7          	lui	t0,0xfff80
ffffffffc020254c:	000803b7          	lui	t2,0x80
ffffffffc0202550:	00099f97          	auipc	t6,0x99
ffffffffc0202554:	0f0f8f93          	addi	t6,t6,240 # ffffffffc029b640 <va_pa_offset>
ffffffffc0202558:	00073023          	sd	zero,0(a4)
ffffffffc020255c:	b739                	j	ffffffffc020246a <exit_range+0xd6>
        intr_disable();
ffffffffc020255e:	e4b2                	sd	a2,72(sp)
ffffffffc0202560:	e09a                	sd	t1,64(sp)
ffffffffc0202562:	fc46                	sd	a7,56(sp)
ffffffffc0202564:	f47a                	sd	t5,40(sp)
ffffffffc0202566:	f072                	sd	t3,32(sp)
ffffffffc0202568:	ec76                	sd	t4,24(sp)
ffffffffc020256a:	e842                	sd	a6,16(sp)
ffffffffc020256c:	e43a                	sd	a4,8(sp)
ffffffffc020256e:	f82a                	sd	a0,48(sp)
ffffffffc0202570:	b94fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202574:	00099797          	auipc	a5,0x99
ffffffffc0202578:	0b47b783          	ld	a5,180(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc020257c:	7542                	ld	a0,48(sp)
ffffffffc020257e:	4585                	li	a1,1
ffffffffc0202580:	739c                	ld	a5,32(a5)
ffffffffc0202582:	9782                	jalr	a5
        intr_enable();
ffffffffc0202584:	b7afe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202588:	6722                	ld	a4,8(sp)
ffffffffc020258a:	6626                	ld	a2,72(sp)
ffffffffc020258c:	6306                	ld	t1,64(sp)
ffffffffc020258e:	78e2                	ld	a7,56(sp)
ffffffffc0202590:	7f22                	ld	t5,40(sp)
ffffffffc0202592:	7e02                	ld	t3,32(sp)
ffffffffc0202594:	6ee2                	ld	t4,24(sp)
ffffffffc0202596:	6842                	ld	a6,16(sp)
ffffffffc0202598:	00099f97          	auipc	t6,0x99
ffffffffc020259c:	0a8f8f93          	addi	t6,t6,168 # ffffffffc029b640 <va_pa_offset>
ffffffffc02025a0:	000803b7          	lui	t2,0x80
ffffffffc02025a4:	fff802b7          	lui	t0,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc02025a8:	00073023          	sd	zero,0(a4)
ffffffffc02025ac:	bd7d                	j	ffffffffc020246a <exit_range+0xd6>
        intr_disable();
ffffffffc02025ae:	e832                	sd	a2,16(sp)
ffffffffc02025b0:	e42a                	sd	a0,8(sp)
ffffffffc02025b2:	b52fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025b6:	00099797          	auipc	a5,0x99
ffffffffc02025ba:	0727b783          	ld	a5,114(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc02025be:	6522                	ld	a0,8(sp)
ffffffffc02025c0:	4585                	li	a1,1
ffffffffc02025c2:	739c                	ld	a5,32(a5)
ffffffffc02025c4:	9782                	jalr	a5
        intr_enable();
ffffffffc02025c6:	b38fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02025ca:	6642                	ld	a2,16(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc02025cc:	00043023          	sd	zero,0(s0)
ffffffffc02025d0:	b5cd                	j	ffffffffc02024b2 <exit_range+0x11e>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02025d2:	00004697          	auipc	a3,0x4
ffffffffc02025d6:	0f668693          	addi	a3,a3,246 # ffffffffc02066c8 <etext+0xe92>
ffffffffc02025da:	00004617          	auipc	a2,0x4
ffffffffc02025de:	c3e60613          	addi	a2,a2,-962 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02025e2:	13500593          	li	a1,309
ffffffffc02025e6:	00004517          	auipc	a0,0x4
ffffffffc02025ea:	0d250513          	addi	a0,a0,210 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02025ee:	e59fd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc02025f2:	00004617          	auipc	a2,0x4
ffffffffc02025f6:	fd660613          	addi	a2,a2,-42 # ffffffffc02065c8 <etext+0xd92>
ffffffffc02025fa:	07100593          	li	a1,113
ffffffffc02025fe:	00004517          	auipc	a0,0x4
ffffffffc0202602:	ff250513          	addi	a0,a0,-14 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0202606:	e41fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc020260a:	86f2                	mv	a3,t3
ffffffffc020260c:	00004617          	auipc	a2,0x4
ffffffffc0202610:	fbc60613          	addi	a2,a2,-68 # ffffffffc02065c8 <etext+0xd92>
ffffffffc0202614:	07100593          	li	a1,113
ffffffffc0202618:	00004517          	auipc	a0,0x4
ffffffffc020261c:	fd850513          	addi	a0,a0,-40 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0202620:	e27fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202624:	8c7ff0ef          	jal	ffffffffc0201eea <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202628:	00004697          	auipc	a3,0x4
ffffffffc020262c:	0d068693          	addi	a3,a3,208 # ffffffffc02066f8 <etext+0xec2>
ffffffffc0202630:	00004617          	auipc	a2,0x4
ffffffffc0202634:	be860613          	addi	a2,a2,-1048 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0202638:	13600593          	li	a1,310
ffffffffc020263c:	00004517          	auipc	a0,0x4
ffffffffc0202640:	07c50513          	addi	a0,a0,124 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202644:	e03fd0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0202648 <page_remove>:
{
ffffffffc0202648:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020264a:	4601                	li	a2,0
{
ffffffffc020264c:	e822                	sd	s0,16(sp)
ffffffffc020264e:	ec06                	sd	ra,24(sp)
ffffffffc0202650:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202652:	95dff0ef          	jal	ffffffffc0201fae <get_pte>
    if (ptep != NULL)
ffffffffc0202656:	c511                	beqz	a0,ffffffffc0202662 <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc0202658:	6118                	ld	a4,0(a0)
ffffffffc020265a:	87aa                	mv	a5,a0
ffffffffc020265c:	00177693          	andi	a3,a4,1
ffffffffc0202660:	e689                	bnez	a3,ffffffffc020266a <page_remove+0x22>
}
ffffffffc0202662:	60e2                	ld	ra,24(sp)
ffffffffc0202664:	6442                	ld	s0,16(sp)
ffffffffc0202666:	6105                	addi	sp,sp,32
ffffffffc0202668:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc020266a:	00099697          	auipc	a3,0x99
ffffffffc020266e:	fde6b683          	ld	a3,-34(a3) # ffffffffc029b648 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202672:	070a                	slli	a4,a4,0x2
ffffffffc0202674:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202676:	06d77563          	bgeu	a4,a3,ffffffffc02026e0 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc020267a:	00099517          	auipc	a0,0x99
ffffffffc020267e:	fd653503          	ld	a0,-42(a0) # ffffffffc029b650 <pages>
ffffffffc0202682:	071a                	slli	a4,a4,0x6
ffffffffc0202684:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202688:	9736                	add	a4,a4,a3
ffffffffc020268a:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc020268c:	4118                	lw	a4,0(a0)
ffffffffc020268e:	377d                	addiw	a4,a4,-1
ffffffffc0202690:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202692:	cb09                	beqz	a4,ffffffffc02026a4 <page_remove+0x5c>
        *ptep = 0;
ffffffffc0202694:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202698:	12040073          	sfence.vma	s0
}
ffffffffc020269c:	60e2                	ld	ra,24(sp)
ffffffffc020269e:	6442                	ld	s0,16(sp)
ffffffffc02026a0:	6105                	addi	sp,sp,32
ffffffffc02026a2:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026a4:	10002773          	csrr	a4,sstatus
ffffffffc02026a8:	8b09                	andi	a4,a4,2
ffffffffc02026aa:	eb19                	bnez	a4,ffffffffc02026c0 <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc02026ac:	00099717          	auipc	a4,0x99
ffffffffc02026b0:	f7c73703          	ld	a4,-132(a4) # ffffffffc029b628 <pmm_manager>
ffffffffc02026b4:	4585                	li	a1,1
ffffffffc02026b6:	e03e                	sd	a5,0(sp)
ffffffffc02026b8:	7318                	ld	a4,32(a4)
ffffffffc02026ba:	9702                	jalr	a4
    if (flag)
ffffffffc02026bc:	6782                	ld	a5,0(sp)
ffffffffc02026be:	bfd9                	j	ffffffffc0202694 <page_remove+0x4c>
        intr_disable();
ffffffffc02026c0:	e43e                	sd	a5,8(sp)
ffffffffc02026c2:	e02a                	sd	a0,0(sp)
ffffffffc02026c4:	a40fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc02026c8:	00099717          	auipc	a4,0x99
ffffffffc02026cc:	f6073703          	ld	a4,-160(a4) # ffffffffc029b628 <pmm_manager>
ffffffffc02026d0:	6502                	ld	a0,0(sp)
ffffffffc02026d2:	4585                	li	a1,1
ffffffffc02026d4:	7318                	ld	a4,32(a4)
ffffffffc02026d6:	9702                	jalr	a4
        intr_enable();
ffffffffc02026d8:	a26fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02026dc:	67a2                	ld	a5,8(sp)
ffffffffc02026de:	bf5d                	j	ffffffffc0202694 <page_remove+0x4c>
ffffffffc02026e0:	80bff0ef          	jal	ffffffffc0201eea <pa2page.part.0>

ffffffffc02026e4 <page_insert>:
{
ffffffffc02026e4:	7139                	addi	sp,sp,-64
ffffffffc02026e6:	f426                	sd	s1,40(sp)
ffffffffc02026e8:	84b2                	mv	s1,a2
ffffffffc02026ea:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026ec:	4605                	li	a2,1
{
ffffffffc02026ee:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026f0:	85a6                	mv	a1,s1
{
ffffffffc02026f2:	fc06                	sd	ra,56(sp)
ffffffffc02026f4:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026f6:	8b9ff0ef          	jal	ffffffffc0201fae <get_pte>
    if (ptep == NULL)
ffffffffc02026fa:	cd61                	beqz	a0,ffffffffc02027d2 <page_insert+0xee>
    page->ref += 1;
ffffffffc02026fc:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc02026fe:	611c                	ld	a5,0(a0)
ffffffffc0202700:	66a2                	ld	a3,8(sp)
ffffffffc0202702:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_obj___user_softint_out_size-0x7bc7>
ffffffffc0202706:	c010                	sw	a2,0(s0)
ffffffffc0202708:	0017f613          	andi	a2,a5,1
ffffffffc020270c:	872a                	mv	a4,a0
ffffffffc020270e:	e61d                	bnez	a2,ffffffffc020273c <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc0202710:	00099617          	auipc	a2,0x99
ffffffffc0202714:	f4063603          	ld	a2,-192(a2) # ffffffffc029b650 <pages>
    return page - pages + nbase;
ffffffffc0202718:	8c11                	sub	s0,s0,a2
ffffffffc020271a:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020271c:	200007b7          	lui	a5,0x20000
ffffffffc0202720:	042a                	slli	s0,s0,0xa
ffffffffc0202722:	943e                	add	s0,s0,a5
ffffffffc0202724:	8ec1                	or	a3,a3,s0
ffffffffc0202726:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc020272a:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020272c:	12048073          	sfence.vma	s1
    return 0;
ffffffffc0202730:	4501                	li	a0,0
}
ffffffffc0202732:	70e2                	ld	ra,56(sp)
ffffffffc0202734:	7442                	ld	s0,48(sp)
ffffffffc0202736:	74a2                	ld	s1,40(sp)
ffffffffc0202738:	6121                	addi	sp,sp,64
ffffffffc020273a:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc020273c:	00099617          	auipc	a2,0x99
ffffffffc0202740:	f0c63603          	ld	a2,-244(a2) # ffffffffc029b648 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202744:	078a                	slli	a5,a5,0x2
ffffffffc0202746:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202748:	08c7f763          	bgeu	a5,a2,ffffffffc02027d6 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc020274c:	00099617          	auipc	a2,0x99
ffffffffc0202750:	f0463603          	ld	a2,-252(a2) # ffffffffc029b650 <pages>
ffffffffc0202754:	fe000537          	lui	a0,0xfe000
ffffffffc0202758:	079a                	slli	a5,a5,0x6
ffffffffc020275a:	97aa                	add	a5,a5,a0
ffffffffc020275c:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc0202760:	00a40963          	beq	s0,a0,ffffffffc0202772 <page_insert+0x8e>
    page->ref -= 1;
ffffffffc0202764:	411c                	lw	a5,0(a0)
ffffffffc0202766:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_obj___user_exit_out_size+0x1fff5e47>
ffffffffc0202768:	c11c                	sw	a5,0(a0)
        if (page_ref(page) == 0)
ffffffffc020276a:	c791                	beqz	a5,ffffffffc0202776 <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020276c:	12048073          	sfence.vma	s1
}
ffffffffc0202770:	b765                	j	ffffffffc0202718 <page_insert+0x34>
ffffffffc0202772:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc0202774:	b755                	j	ffffffffc0202718 <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202776:	100027f3          	csrr	a5,sstatus
ffffffffc020277a:	8b89                	andi	a5,a5,2
ffffffffc020277c:	e39d                	bnez	a5,ffffffffc02027a2 <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc020277e:	00099797          	auipc	a5,0x99
ffffffffc0202782:	eaa7b783          	ld	a5,-342(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc0202786:	4585                	li	a1,1
ffffffffc0202788:	e83a                	sd	a4,16(sp)
ffffffffc020278a:	739c                	ld	a5,32(a5)
ffffffffc020278c:	e436                	sd	a3,8(sp)
ffffffffc020278e:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202790:	00099617          	auipc	a2,0x99
ffffffffc0202794:	ec063603          	ld	a2,-320(a2) # ffffffffc029b650 <pages>
ffffffffc0202798:	66a2                	ld	a3,8(sp)
ffffffffc020279a:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020279c:	12048073          	sfence.vma	s1
ffffffffc02027a0:	bfa5                	j	ffffffffc0202718 <page_insert+0x34>
        intr_disable();
ffffffffc02027a2:	ec3a                	sd	a4,24(sp)
ffffffffc02027a4:	e836                	sd	a3,16(sp)
ffffffffc02027a6:	e42a                	sd	a0,8(sp)
ffffffffc02027a8:	95cfe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02027ac:	00099797          	auipc	a5,0x99
ffffffffc02027b0:	e7c7b783          	ld	a5,-388(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc02027b4:	6522                	ld	a0,8(sp)
ffffffffc02027b6:	4585                	li	a1,1
ffffffffc02027b8:	739c                	ld	a5,32(a5)
ffffffffc02027ba:	9782                	jalr	a5
        intr_enable();
ffffffffc02027bc:	942fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02027c0:	00099617          	auipc	a2,0x99
ffffffffc02027c4:	e9063603          	ld	a2,-368(a2) # ffffffffc029b650 <pages>
ffffffffc02027c8:	6762                	ld	a4,24(sp)
ffffffffc02027ca:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02027cc:	12048073          	sfence.vma	s1
ffffffffc02027d0:	b7a1                	j	ffffffffc0202718 <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc02027d2:	5571                	li	a0,-4
ffffffffc02027d4:	bfb9                	j	ffffffffc0202732 <page_insert+0x4e>
ffffffffc02027d6:	f14ff0ef          	jal	ffffffffc0201eea <pa2page.part.0>

ffffffffc02027da <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02027da:	00005797          	auipc	a5,0x5
ffffffffc02027de:	e6e78793          	addi	a5,a5,-402 # ffffffffc0207648 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027e2:	638c                	ld	a1,0(a5)
{
ffffffffc02027e4:	7159                	addi	sp,sp,-112
ffffffffc02027e6:	f486                	sd	ra,104(sp)
ffffffffc02027e8:	e8ca                	sd	s2,80(sp)
ffffffffc02027ea:	e4ce                	sd	s3,72(sp)
ffffffffc02027ec:	f85a                	sd	s6,48(sp)
ffffffffc02027ee:	f0a2                	sd	s0,96(sp)
ffffffffc02027f0:	eca6                	sd	s1,88(sp)
ffffffffc02027f2:	e0d2                	sd	s4,64(sp)
ffffffffc02027f4:	fc56                	sd	s5,56(sp)
ffffffffc02027f6:	f45e                	sd	s7,40(sp)
ffffffffc02027f8:	f062                	sd	s8,32(sp)
ffffffffc02027fa:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02027fc:	00099b17          	auipc	s6,0x99
ffffffffc0202800:	e2cb0b13          	addi	s6,s6,-468 # ffffffffc029b628 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202804:	00004517          	auipc	a0,0x4
ffffffffc0202808:	f0c50513          	addi	a0,a0,-244 # ffffffffc0206710 <etext+0xeda>
    pmm_manager = &default_pmm_manager;
ffffffffc020280c:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202810:	985fd0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202814:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202818:	00099997          	auipc	s3,0x99
ffffffffc020281c:	e2898993          	addi	s3,s3,-472 # ffffffffc029b640 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202820:	679c                	ld	a5,8(a5)
ffffffffc0202822:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202824:	57f5                	li	a5,-3
ffffffffc0202826:	07fa                	slli	a5,a5,0x1e
ffffffffc0202828:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc020282c:	8befe0ef          	jal	ffffffffc02008ea <get_memory_base>
ffffffffc0202830:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc0202832:	8c2fe0ef          	jal	ffffffffc02008f4 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202836:	70050e63          	beqz	a0,ffffffffc0202f52 <pmm_init+0x778>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc020283a:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc020283c:	00004517          	auipc	a0,0x4
ffffffffc0202840:	f0c50513          	addi	a0,a0,-244 # ffffffffc0206748 <etext+0xf12>
ffffffffc0202844:	951fd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202848:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc020284c:	864a                	mv	a2,s2
ffffffffc020284e:	85a6                	mv	a1,s1
ffffffffc0202850:	fff40693          	addi	a3,s0,-1
ffffffffc0202854:	00004517          	auipc	a0,0x4
ffffffffc0202858:	f0c50513          	addi	a0,a0,-244 # ffffffffc0206760 <etext+0xf2a>
ffffffffc020285c:	939fd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc0202860:	c80007b7          	lui	a5,0xc8000
ffffffffc0202864:	8522                	mv	a0,s0
ffffffffc0202866:	5287ed63          	bltu	a5,s0,ffffffffc0202da0 <pmm_init+0x5c6>
ffffffffc020286a:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020286c:	0009a617          	auipc	a2,0x9a
ffffffffc0202870:	e0b60613          	addi	a2,a2,-501 # ffffffffc029c677 <end+0xfff>
ffffffffc0202874:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc0202876:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202878:	00099b97          	auipc	s7,0x99
ffffffffc020287c:	dd8b8b93          	addi	s7,s7,-552 # ffffffffc029b650 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202880:	00099497          	auipc	s1,0x99
ffffffffc0202884:	dc848493          	addi	s1,s1,-568 # ffffffffc029b648 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202888:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc020288c:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020288e:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202892:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202894:	02f50763          	beq	a0,a5,ffffffffc02028c2 <pmm_init+0xe8>
ffffffffc0202898:	4701                	li	a4,0
ffffffffc020289a:	4585                	li	a1,1
ffffffffc020289c:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02028a0:	00671793          	slli	a5,a4,0x6
ffffffffc02028a4:	97b2                	add	a5,a5,a2
ffffffffc02028a6:	07a1                	addi	a5,a5,8 # 80008 <_binary_obj___user_exit_out_size+0x75e50>
ffffffffc02028a8:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02028ac:	6088                	ld	a0,0(s1)
ffffffffc02028ae:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02028b0:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02028b4:	00d507b3          	add	a5,a0,a3
ffffffffc02028b8:	fef764e3          	bltu	a4,a5,ffffffffc02028a0 <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02028bc:	079a                	slli	a5,a5,0x6
ffffffffc02028be:	00f606b3          	add	a3,a2,a5
ffffffffc02028c2:	c02007b7          	lui	a5,0xc0200
ffffffffc02028c6:	16f6eee3          	bltu	a3,a5,ffffffffc0203242 <pmm_init+0xa68>
ffffffffc02028ca:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02028ce:	77fd                	lui	a5,0xfffff
ffffffffc02028d0:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02028d2:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc02028d4:	4e86ed63          	bltu	a3,s0,ffffffffc0202dce <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02028d8:	00004517          	auipc	a0,0x4
ffffffffc02028dc:	eb050513          	addi	a0,a0,-336 # ffffffffc0206788 <etext+0xf52>
ffffffffc02028e0:	8b5fd0ef          	jal	ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc02028e4:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02028e8:	00099917          	auipc	s2,0x99
ffffffffc02028ec:	d5090913          	addi	s2,s2,-688 # ffffffffc029b638 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02028f0:	7b9c                	ld	a5,48(a5)
ffffffffc02028f2:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02028f4:	00004517          	auipc	a0,0x4
ffffffffc02028f8:	eac50513          	addi	a0,a0,-340 # ffffffffc02067a0 <etext+0xf6a>
ffffffffc02028fc:	899fd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202900:	00007697          	auipc	a3,0x7
ffffffffc0202904:	70068693          	addi	a3,a3,1792 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202908:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020290c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202910:	2af6eee3          	bltu	a3,a5,ffffffffc02033cc <pmm_init+0xbf2>
ffffffffc0202914:	0009b783          	ld	a5,0(s3)
ffffffffc0202918:	8e9d                	sub	a3,a3,a5
ffffffffc020291a:	00099797          	auipc	a5,0x99
ffffffffc020291e:	d0d7bb23          	sd	a3,-746(a5) # ffffffffc029b630 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202922:	100027f3          	csrr	a5,sstatus
ffffffffc0202926:	8b89                	andi	a5,a5,2
ffffffffc0202928:	48079963          	bnez	a5,ffffffffc0202dba <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc020292c:	000b3783          	ld	a5,0(s6)
ffffffffc0202930:	779c                	ld	a5,40(a5)
ffffffffc0202932:	9782                	jalr	a5
ffffffffc0202934:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202936:	6098                	ld	a4,0(s1)
ffffffffc0202938:	c80007b7          	lui	a5,0xc8000
ffffffffc020293c:	83b1                	srli	a5,a5,0xc
ffffffffc020293e:	66e7e663          	bltu	a5,a4,ffffffffc0202faa <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202942:	00093503          	ld	a0,0(s2)
ffffffffc0202946:	64050263          	beqz	a0,ffffffffc0202f8a <pmm_init+0x7b0>
ffffffffc020294a:	03451793          	slli	a5,a0,0x34
ffffffffc020294e:	62079e63          	bnez	a5,ffffffffc0202f8a <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202952:	4601                	li	a2,0
ffffffffc0202954:	4581                	li	a1,0
ffffffffc0202956:	8b7ff0ef          	jal	ffffffffc020220c <get_page>
ffffffffc020295a:	240519e3          	bnez	a0,ffffffffc02033ac <pmm_init+0xbd2>
ffffffffc020295e:	100027f3          	csrr	a5,sstatus
ffffffffc0202962:	8b89                	andi	a5,a5,2
ffffffffc0202964:	44079063          	bnez	a5,ffffffffc0202da4 <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202968:	000b3783          	ld	a5,0(s6)
ffffffffc020296c:	4505                	li	a0,1
ffffffffc020296e:	6f9c                	ld	a5,24(a5)
ffffffffc0202970:	9782                	jalr	a5
ffffffffc0202972:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202974:	00093503          	ld	a0,0(s2)
ffffffffc0202978:	4681                	li	a3,0
ffffffffc020297a:	4601                	li	a2,0
ffffffffc020297c:	85d2                	mv	a1,s4
ffffffffc020297e:	d67ff0ef          	jal	ffffffffc02026e4 <page_insert>
ffffffffc0202982:	280511e3          	bnez	a0,ffffffffc0203404 <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202986:	00093503          	ld	a0,0(s2)
ffffffffc020298a:	4601                	li	a2,0
ffffffffc020298c:	4581                	li	a1,0
ffffffffc020298e:	e20ff0ef          	jal	ffffffffc0201fae <get_pte>
ffffffffc0202992:	240509e3          	beqz	a0,ffffffffc02033e4 <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc0202996:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202998:	0017f713          	andi	a4,a5,1
ffffffffc020299c:	58070f63          	beqz	a4,ffffffffc0202f3a <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc02029a0:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02029a2:	078a                	slli	a5,a5,0x2
ffffffffc02029a4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029a6:	58e7f863          	bgeu	a5,a4,ffffffffc0202f36 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02029aa:	000bb683          	ld	a3,0(s7)
ffffffffc02029ae:	079a                	slli	a5,a5,0x6
ffffffffc02029b0:	fe000637          	lui	a2,0xfe000
ffffffffc02029b4:	97b2                	add	a5,a5,a2
ffffffffc02029b6:	97b6                	add	a5,a5,a3
ffffffffc02029b8:	14fa1ae3          	bne	s4,a5,ffffffffc020330c <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc02029bc:	000a2683          	lw	a3,0(s4) # 200000 <_binary_obj___user_exit_out_size+0x1f5e48>
ffffffffc02029c0:	4785                	li	a5,1
ffffffffc02029c2:	12f695e3          	bne	a3,a5,ffffffffc02032ec <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02029c6:	00093503          	ld	a0,0(s2)
ffffffffc02029ca:	77fd                	lui	a5,0xfffff
ffffffffc02029cc:	6114                	ld	a3,0(a0)
ffffffffc02029ce:	068a                	slli	a3,a3,0x2
ffffffffc02029d0:	8efd                	and	a3,a3,a5
ffffffffc02029d2:	00c6d613          	srli	a2,a3,0xc
ffffffffc02029d6:	0ee67fe3          	bgeu	a2,a4,ffffffffc02032d4 <pmm_init+0xafa>
ffffffffc02029da:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029de:	96e2                	add	a3,a3,s8
ffffffffc02029e0:	0006ba83          	ld	s5,0(a3)
ffffffffc02029e4:	0a8a                	slli	s5,s5,0x2
ffffffffc02029e6:	00fafab3          	and	s5,s5,a5
ffffffffc02029ea:	00cad793          	srli	a5,s5,0xc
ffffffffc02029ee:	0ce7f6e3          	bgeu	a5,a4,ffffffffc02032ba <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029f2:	4601                	li	a2,0
ffffffffc02029f4:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029f6:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029f8:	db6ff0ef          	jal	ffffffffc0201fae <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029fc:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029fe:	05851ee3          	bne	a0,s8,ffffffffc020325a <pmm_init+0xa80>
ffffffffc0202a02:	100027f3          	csrr	a5,sstatus
ffffffffc0202a06:	8b89                	andi	a5,a5,2
ffffffffc0202a08:	3e079b63          	bnez	a5,ffffffffc0202dfe <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a0c:	000b3783          	ld	a5,0(s6)
ffffffffc0202a10:	4505                	li	a0,1
ffffffffc0202a12:	6f9c                	ld	a5,24(a5)
ffffffffc0202a14:	9782                	jalr	a5
ffffffffc0202a16:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202a18:	00093503          	ld	a0,0(s2)
ffffffffc0202a1c:	46d1                	li	a3,20
ffffffffc0202a1e:	6605                	lui	a2,0x1
ffffffffc0202a20:	85e2                	mv	a1,s8
ffffffffc0202a22:	cc3ff0ef          	jal	ffffffffc02026e4 <page_insert>
ffffffffc0202a26:	06051ae3          	bnez	a0,ffffffffc020329a <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202a2a:	00093503          	ld	a0,0(s2)
ffffffffc0202a2e:	4601                	li	a2,0
ffffffffc0202a30:	6585                	lui	a1,0x1
ffffffffc0202a32:	d7cff0ef          	jal	ffffffffc0201fae <get_pte>
ffffffffc0202a36:	040502e3          	beqz	a0,ffffffffc020327a <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc0202a3a:	611c                	ld	a5,0(a0)
ffffffffc0202a3c:	0107f713          	andi	a4,a5,16
ffffffffc0202a40:	7e070163          	beqz	a4,ffffffffc0203222 <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc0202a44:	8b91                	andi	a5,a5,4
ffffffffc0202a46:	7a078e63          	beqz	a5,ffffffffc0203202 <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202a4a:	00093503          	ld	a0,0(s2)
ffffffffc0202a4e:	611c                	ld	a5,0(a0)
ffffffffc0202a50:	8bc1                	andi	a5,a5,16
ffffffffc0202a52:	78078863          	beqz	a5,ffffffffc02031e2 <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc0202a56:	000c2703          	lw	a4,0(s8)
ffffffffc0202a5a:	4785                	li	a5,1
ffffffffc0202a5c:	76f71363          	bne	a4,a5,ffffffffc02031c2 <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202a60:	4681                	li	a3,0
ffffffffc0202a62:	6605                	lui	a2,0x1
ffffffffc0202a64:	85d2                	mv	a1,s4
ffffffffc0202a66:	c7fff0ef          	jal	ffffffffc02026e4 <page_insert>
ffffffffc0202a6a:	72051c63          	bnez	a0,ffffffffc02031a2 <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc0202a6e:	000a2703          	lw	a4,0(s4)
ffffffffc0202a72:	4789                	li	a5,2
ffffffffc0202a74:	70f71763          	bne	a4,a5,ffffffffc0203182 <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc0202a78:	000c2783          	lw	a5,0(s8)
ffffffffc0202a7c:	6e079363          	bnez	a5,ffffffffc0203162 <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202a80:	00093503          	ld	a0,0(s2)
ffffffffc0202a84:	4601                	li	a2,0
ffffffffc0202a86:	6585                	lui	a1,0x1
ffffffffc0202a88:	d26ff0ef          	jal	ffffffffc0201fae <get_pte>
ffffffffc0202a8c:	6a050b63          	beqz	a0,ffffffffc0203142 <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a90:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202a92:	00177793          	andi	a5,a4,1
ffffffffc0202a96:	4a078263          	beqz	a5,ffffffffc0202f3a <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202a9a:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a9c:	00271793          	slli	a5,a4,0x2
ffffffffc0202aa0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202aa2:	48d7fa63          	bgeu	a5,a3,ffffffffc0202f36 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202aa6:	000bb683          	ld	a3,0(s7)
ffffffffc0202aaa:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202aae:	97d6                	add	a5,a5,s5
ffffffffc0202ab0:	079a                	slli	a5,a5,0x6
ffffffffc0202ab2:	97b6                	add	a5,a5,a3
ffffffffc0202ab4:	66fa1763          	bne	s4,a5,ffffffffc0203122 <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202ab8:	8b41                	andi	a4,a4,16
ffffffffc0202aba:	64071463          	bnez	a4,ffffffffc0203102 <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202abe:	00093503          	ld	a0,0(s2)
ffffffffc0202ac2:	4581                	li	a1,0
ffffffffc0202ac4:	b85ff0ef          	jal	ffffffffc0202648 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202ac8:	000a2c83          	lw	s9,0(s4)
ffffffffc0202acc:	4785                	li	a5,1
ffffffffc0202ace:	60fc9a63          	bne	s9,a5,ffffffffc02030e2 <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc0202ad2:	000c2783          	lw	a5,0(s8)
ffffffffc0202ad6:	5e079663          	bnez	a5,ffffffffc02030c2 <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202ada:	00093503          	ld	a0,0(s2)
ffffffffc0202ade:	6585                	lui	a1,0x1
ffffffffc0202ae0:	b69ff0ef          	jal	ffffffffc0202648 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202ae4:	000a2783          	lw	a5,0(s4)
ffffffffc0202ae8:	52079d63          	bnez	a5,ffffffffc0203022 <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc0202aec:	000c2783          	lw	a5,0(s8)
ffffffffc0202af0:	50079963          	bnez	a5,ffffffffc0203002 <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202af4:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202af8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202afa:	000a3783          	ld	a5,0(s4)
ffffffffc0202afe:	078a                	slli	a5,a5,0x2
ffffffffc0202b00:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b02:	42e7fa63          	bgeu	a5,a4,ffffffffc0202f36 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b06:	000bb503          	ld	a0,0(s7)
ffffffffc0202b0a:	97d6                	add	a5,a5,s5
ffffffffc0202b0c:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc0202b0e:	00f506b3          	add	a3,a0,a5
ffffffffc0202b12:	4294                	lw	a3,0(a3)
ffffffffc0202b14:	4d969763          	bne	a3,s9,ffffffffc0202fe2 <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc0202b18:	8799                	srai	a5,a5,0x6
ffffffffc0202b1a:	00080637          	lui	a2,0x80
ffffffffc0202b1e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b20:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202b24:	4ae7f363          	bgeu	a5,a4,ffffffffc0202fca <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202b28:	0009b783          	ld	a5,0(s3)
ffffffffc0202b2c:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b2e:	639c                	ld	a5,0(a5)
ffffffffc0202b30:	078a                	slli	a5,a5,0x2
ffffffffc0202b32:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b34:	40e7f163          	bgeu	a5,a4,ffffffffc0202f36 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b38:	8f91                	sub	a5,a5,a2
ffffffffc0202b3a:	079a                	slli	a5,a5,0x6
ffffffffc0202b3c:	953e                	add	a0,a0,a5
ffffffffc0202b3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b42:	8b89                	andi	a5,a5,2
ffffffffc0202b44:	30079863          	bnez	a5,ffffffffc0202e54 <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc0202b48:	000b3783          	ld	a5,0(s6)
ffffffffc0202b4c:	4585                	li	a1,1
ffffffffc0202b4e:	739c                	ld	a5,32(a5)
ffffffffc0202b50:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b52:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202b56:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b58:	078a                	slli	a5,a5,0x2
ffffffffc0202b5a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b5c:	3ce7fd63          	bgeu	a5,a4,ffffffffc0202f36 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b60:	000bb503          	ld	a0,0(s7)
ffffffffc0202b64:	fe000737          	lui	a4,0xfe000
ffffffffc0202b68:	079a                	slli	a5,a5,0x6
ffffffffc0202b6a:	97ba                	add	a5,a5,a4
ffffffffc0202b6c:	953e                	add	a0,a0,a5
ffffffffc0202b6e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b72:	8b89                	andi	a5,a5,2
ffffffffc0202b74:	2c079463          	bnez	a5,ffffffffc0202e3c <pmm_init+0x662>
ffffffffc0202b78:	000b3783          	ld	a5,0(s6)
ffffffffc0202b7c:	4585                	li	a1,1
ffffffffc0202b7e:	739c                	ld	a5,32(a5)
ffffffffc0202b80:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202b82:	00093783          	ld	a5,0(s2)
ffffffffc0202b86:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd63988>
    asm volatile("sfence.vma");
ffffffffc0202b8a:	12000073          	sfence.vma
ffffffffc0202b8e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b92:	8b89                	andi	a5,a5,2
ffffffffc0202b94:	28079a63          	bnez	a5,ffffffffc0202e28 <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b98:	000b3783          	ld	a5,0(s6)
ffffffffc0202b9c:	779c                	ld	a5,40(a5)
ffffffffc0202b9e:	9782                	jalr	a5
ffffffffc0202ba0:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202ba2:	4d441063          	bne	s0,s4,ffffffffc0203062 <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202ba6:	00004517          	auipc	a0,0x4
ffffffffc0202baa:	f4a50513          	addi	a0,a0,-182 # ffffffffc0206af0 <etext+0x12ba>
ffffffffc0202bae:	de6fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202bb2:	100027f3          	csrr	a5,sstatus
ffffffffc0202bb6:	8b89                	andi	a5,a5,2
ffffffffc0202bb8:	24079e63          	bnez	a5,ffffffffc0202e14 <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202bbc:	000b3783          	ld	a5,0(s6)
ffffffffc0202bc0:	779c                	ld	a5,40(a5)
ffffffffc0202bc2:	9782                	jalr	a5
ffffffffc0202bc4:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202bc6:	609c                	ld	a5,0(s1)
ffffffffc0202bc8:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202bcc:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202bce:	00c79713          	slli	a4,a5,0xc
ffffffffc0202bd2:	6a85                	lui	s5,0x1
ffffffffc0202bd4:	02e47c63          	bgeu	s0,a4,ffffffffc0202c0c <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202bd8:	00c45713          	srli	a4,s0,0xc
ffffffffc0202bdc:	30f77063          	bgeu	a4,a5,ffffffffc0202edc <pmm_init+0x702>
ffffffffc0202be0:	0009b583          	ld	a1,0(s3)
ffffffffc0202be4:	00093503          	ld	a0,0(s2)
ffffffffc0202be8:	4601                	li	a2,0
ffffffffc0202bea:	95a2                	add	a1,a1,s0
ffffffffc0202bec:	bc2ff0ef          	jal	ffffffffc0201fae <get_pte>
ffffffffc0202bf0:	32050363          	beqz	a0,ffffffffc0202f16 <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202bf4:	611c                	ld	a5,0(a0)
ffffffffc0202bf6:	078a                	slli	a5,a5,0x2
ffffffffc0202bf8:	0147f7b3          	and	a5,a5,s4
ffffffffc0202bfc:	2e879d63          	bne	a5,s0,ffffffffc0202ef6 <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202c00:	609c                	ld	a5,0(s1)
ffffffffc0202c02:	9456                	add	s0,s0,s5
ffffffffc0202c04:	00c79713          	slli	a4,a5,0xc
ffffffffc0202c08:	fce468e3          	bltu	s0,a4,ffffffffc0202bd8 <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202c0c:	00093783          	ld	a5,0(s2)
ffffffffc0202c10:	639c                	ld	a5,0(a5)
ffffffffc0202c12:	42079863          	bnez	a5,ffffffffc0203042 <pmm_init+0x868>
ffffffffc0202c16:	100027f3          	csrr	a5,sstatus
ffffffffc0202c1a:	8b89                	andi	a5,a5,2
ffffffffc0202c1c:	24079863          	bnez	a5,ffffffffc0202e6c <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c20:	000b3783          	ld	a5,0(s6)
ffffffffc0202c24:	4505                	li	a0,1
ffffffffc0202c26:	6f9c                	ld	a5,24(a5)
ffffffffc0202c28:	9782                	jalr	a5
ffffffffc0202c2a:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202c2c:	00093503          	ld	a0,0(s2)
ffffffffc0202c30:	4699                	li	a3,6
ffffffffc0202c32:	10000613          	li	a2,256
ffffffffc0202c36:	85a2                	mv	a1,s0
ffffffffc0202c38:	aadff0ef          	jal	ffffffffc02026e4 <page_insert>
ffffffffc0202c3c:	46051363          	bnez	a0,ffffffffc02030a2 <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc0202c40:	4018                	lw	a4,0(s0)
ffffffffc0202c42:	4785                	li	a5,1
ffffffffc0202c44:	42f71f63          	bne	a4,a5,ffffffffc0203082 <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202c48:	00093503          	ld	a0,0(s2)
ffffffffc0202c4c:	6605                	lui	a2,0x1
ffffffffc0202c4e:	10060613          	addi	a2,a2,256 # 1100 <_binary_obj___user_softint_out_size-0x7ac8>
ffffffffc0202c52:	4699                	li	a3,6
ffffffffc0202c54:	85a2                	mv	a1,s0
ffffffffc0202c56:	a8fff0ef          	jal	ffffffffc02026e4 <page_insert>
ffffffffc0202c5a:	72051963          	bnez	a0,ffffffffc020338c <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc0202c5e:	4018                	lw	a4,0(s0)
ffffffffc0202c60:	4789                	li	a5,2
ffffffffc0202c62:	70f71563          	bne	a4,a5,ffffffffc020336c <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202c66:	00004597          	auipc	a1,0x4
ffffffffc0202c6a:	fd258593          	addi	a1,a1,-46 # ffffffffc0206c38 <etext+0x1402>
ffffffffc0202c6e:	10000513          	li	a0,256
ffffffffc0202c72:	31b020ef          	jal	ffffffffc020578c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202c76:	6585                	lui	a1,0x1
ffffffffc0202c78:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x7ac8>
ffffffffc0202c7c:	10000513          	li	a0,256
ffffffffc0202c80:	31f020ef          	jal	ffffffffc020579e <strcmp>
ffffffffc0202c84:	6c051463          	bnez	a0,ffffffffc020334c <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc0202c88:	000bb683          	ld	a3,0(s7)
ffffffffc0202c8c:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202c90:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202c92:	40d406b3          	sub	a3,s0,a3
ffffffffc0202c96:	8699                	srai	a3,a3,0x6
ffffffffc0202c98:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202c9a:	00c69793          	slli	a5,a3,0xc
ffffffffc0202c9e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ca0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202ca2:	32e7f463          	bgeu	a5,a4,ffffffffc0202fca <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202ca6:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202caa:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202cae:	97b6                	add	a5,a5,a3
ffffffffc0202cb0:	10078023          	sb	zero,256(a5) # 80100 <_binary_obj___user_exit_out_size+0x75f48>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202cb4:	2a5020ef          	jal	ffffffffc0205758 <strlen>
ffffffffc0202cb8:	66051a63          	bnez	a0,ffffffffc020332c <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202cbc:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202cc0:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cc2:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd63988>
ffffffffc0202cc6:	078a                	slli	a5,a5,0x2
ffffffffc0202cc8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cca:	26e7f663          	bgeu	a5,a4,ffffffffc0202f36 <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202cce:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202cd2:	2ee7fc63          	bgeu	a5,a4,ffffffffc0202fca <pmm_init+0x7f0>
ffffffffc0202cd6:	0009b783          	ld	a5,0(s3)
ffffffffc0202cda:	00f689b3          	add	s3,a3,a5
ffffffffc0202cde:	100027f3          	csrr	a5,sstatus
ffffffffc0202ce2:	8b89                	andi	a5,a5,2
ffffffffc0202ce4:	1e079163          	bnez	a5,ffffffffc0202ec6 <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc0202ce8:	000b3783          	ld	a5,0(s6)
ffffffffc0202cec:	8522                	mv	a0,s0
ffffffffc0202cee:	4585                	li	a1,1
ffffffffc0202cf0:	739c                	ld	a5,32(a5)
ffffffffc0202cf2:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cf4:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202cf8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cfa:	078a                	slli	a5,a5,0x2
ffffffffc0202cfc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cfe:	22e7fc63          	bgeu	a5,a4,ffffffffc0202f36 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d02:	000bb503          	ld	a0,0(s7)
ffffffffc0202d06:	fe000737          	lui	a4,0xfe000
ffffffffc0202d0a:	079a                	slli	a5,a5,0x6
ffffffffc0202d0c:	97ba                	add	a5,a5,a4
ffffffffc0202d0e:	953e                	add	a0,a0,a5
ffffffffc0202d10:	100027f3          	csrr	a5,sstatus
ffffffffc0202d14:	8b89                	andi	a5,a5,2
ffffffffc0202d16:	18079c63          	bnez	a5,ffffffffc0202eae <pmm_init+0x6d4>
ffffffffc0202d1a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d1e:	4585                	li	a1,1
ffffffffc0202d20:	739c                	ld	a5,32(a5)
ffffffffc0202d22:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d24:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202d28:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d2a:	078a                	slli	a5,a5,0x2
ffffffffc0202d2c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d2e:	20e7f463          	bgeu	a5,a4,ffffffffc0202f36 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d32:	000bb503          	ld	a0,0(s7)
ffffffffc0202d36:	fe000737          	lui	a4,0xfe000
ffffffffc0202d3a:	079a                	slli	a5,a5,0x6
ffffffffc0202d3c:	97ba                	add	a5,a5,a4
ffffffffc0202d3e:	953e                	add	a0,a0,a5
ffffffffc0202d40:	100027f3          	csrr	a5,sstatus
ffffffffc0202d44:	8b89                	andi	a5,a5,2
ffffffffc0202d46:	14079863          	bnez	a5,ffffffffc0202e96 <pmm_init+0x6bc>
ffffffffc0202d4a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d4e:	4585                	li	a1,1
ffffffffc0202d50:	739c                	ld	a5,32(a5)
ffffffffc0202d52:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202d54:	00093783          	ld	a5,0(s2)
ffffffffc0202d58:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202d5c:	12000073          	sfence.vma
ffffffffc0202d60:	100027f3          	csrr	a5,sstatus
ffffffffc0202d64:	8b89                	andi	a5,a5,2
ffffffffc0202d66:	10079e63          	bnez	a5,ffffffffc0202e82 <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d6a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d6e:	779c                	ld	a5,40(a5)
ffffffffc0202d70:	9782                	jalr	a5
ffffffffc0202d72:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202d74:	1e8c1b63          	bne	s8,s0,ffffffffc0202f6a <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202d78:	00004517          	auipc	a0,0x4
ffffffffc0202d7c:	f3850513          	addi	a0,a0,-200 # ffffffffc0206cb0 <etext+0x147a>
ffffffffc0202d80:	c14fd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0202d84:	7406                	ld	s0,96(sp)
ffffffffc0202d86:	70a6                	ld	ra,104(sp)
ffffffffc0202d88:	64e6                	ld	s1,88(sp)
ffffffffc0202d8a:	6946                	ld	s2,80(sp)
ffffffffc0202d8c:	69a6                	ld	s3,72(sp)
ffffffffc0202d8e:	6a06                	ld	s4,64(sp)
ffffffffc0202d90:	7ae2                	ld	s5,56(sp)
ffffffffc0202d92:	7b42                	ld	s6,48(sp)
ffffffffc0202d94:	7ba2                	ld	s7,40(sp)
ffffffffc0202d96:	7c02                	ld	s8,32(sp)
ffffffffc0202d98:	6ce2                	ld	s9,24(sp)
ffffffffc0202d9a:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202d9c:	f85fe06f          	j	ffffffffc0201d20 <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202da0:	853e                	mv	a0,a5
ffffffffc0202da2:	b4e1                	j	ffffffffc020286a <pmm_init+0x90>
        intr_disable();
ffffffffc0202da4:	b61fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202da8:	000b3783          	ld	a5,0(s6)
ffffffffc0202dac:	4505                	li	a0,1
ffffffffc0202dae:	6f9c                	ld	a5,24(a5)
ffffffffc0202db0:	9782                	jalr	a5
ffffffffc0202db2:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202db4:	b4bfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202db8:	be75                	j	ffffffffc0202974 <pmm_init+0x19a>
        intr_disable();
ffffffffc0202dba:	b4bfd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202dbe:	000b3783          	ld	a5,0(s6)
ffffffffc0202dc2:	779c                	ld	a5,40(a5)
ffffffffc0202dc4:	9782                	jalr	a5
ffffffffc0202dc6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202dc8:	b37fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202dcc:	b6ad                	j	ffffffffc0202936 <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202dce:	6705                	lui	a4,0x1
ffffffffc0202dd0:	177d                	addi	a4,a4,-1 # fff <_binary_obj___user_softint_out_size-0x7bc9>
ffffffffc0202dd2:	96ba                	add	a3,a3,a4
ffffffffc0202dd4:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202dd6:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202dda:	14a77e63          	bgeu	a4,a0,ffffffffc0202f36 <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc0202dde:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202de2:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202de4:	071a                	slli	a4,a4,0x6
ffffffffc0202de6:	fe0007b7          	lui	a5,0xfe000
ffffffffc0202dea:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc0202dec:	6a9c                	ld	a5,16(a3)
ffffffffc0202dee:	00c45593          	srli	a1,s0,0xc
ffffffffc0202df2:	00e60533          	add	a0,a2,a4
ffffffffc0202df6:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202df8:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202dfc:	bcf1                	j	ffffffffc02028d8 <pmm_init+0xfe>
        intr_disable();
ffffffffc0202dfe:	b07fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e02:	000b3783          	ld	a5,0(s6)
ffffffffc0202e06:	4505                	li	a0,1
ffffffffc0202e08:	6f9c                	ld	a5,24(a5)
ffffffffc0202e0a:	9782                	jalr	a5
ffffffffc0202e0c:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202e0e:	af1fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e12:	b119                	j	ffffffffc0202a18 <pmm_init+0x23e>
        intr_disable();
ffffffffc0202e14:	af1fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e18:	000b3783          	ld	a5,0(s6)
ffffffffc0202e1c:	779c                	ld	a5,40(a5)
ffffffffc0202e1e:	9782                	jalr	a5
ffffffffc0202e20:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202e22:	addfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e26:	b345                	j	ffffffffc0202bc6 <pmm_init+0x3ec>
        intr_disable();
ffffffffc0202e28:	addfd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e2c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e30:	779c                	ld	a5,40(a5)
ffffffffc0202e32:	9782                	jalr	a5
ffffffffc0202e34:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202e36:	ac9fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e3a:	b3a5                	j	ffffffffc0202ba2 <pmm_init+0x3c8>
ffffffffc0202e3c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e3e:	ac7fd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e42:	000b3783          	ld	a5,0(s6)
ffffffffc0202e46:	6522                	ld	a0,8(sp)
ffffffffc0202e48:	4585                	li	a1,1
ffffffffc0202e4a:	739c                	ld	a5,32(a5)
ffffffffc0202e4c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e4e:	ab1fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e52:	bb05                	j	ffffffffc0202b82 <pmm_init+0x3a8>
ffffffffc0202e54:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e56:	aaffd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e5a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e5e:	6522                	ld	a0,8(sp)
ffffffffc0202e60:	4585                	li	a1,1
ffffffffc0202e62:	739c                	ld	a5,32(a5)
ffffffffc0202e64:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e66:	a99fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e6a:	b1e5                	j	ffffffffc0202b52 <pmm_init+0x378>
        intr_disable();
ffffffffc0202e6c:	a99fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e70:	000b3783          	ld	a5,0(s6)
ffffffffc0202e74:	4505                	li	a0,1
ffffffffc0202e76:	6f9c                	ld	a5,24(a5)
ffffffffc0202e78:	9782                	jalr	a5
ffffffffc0202e7a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e7c:	a83fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e80:	b375                	j	ffffffffc0202c2c <pmm_init+0x452>
        intr_disable();
ffffffffc0202e82:	a83fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e86:	000b3783          	ld	a5,0(s6)
ffffffffc0202e8a:	779c                	ld	a5,40(a5)
ffffffffc0202e8c:	9782                	jalr	a5
ffffffffc0202e8e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e90:	a6ffd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e94:	b5c5                	j	ffffffffc0202d74 <pmm_init+0x59a>
ffffffffc0202e96:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e98:	a6dfd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e9c:	000b3783          	ld	a5,0(s6)
ffffffffc0202ea0:	6522                	ld	a0,8(sp)
ffffffffc0202ea2:	4585                	li	a1,1
ffffffffc0202ea4:	739c                	ld	a5,32(a5)
ffffffffc0202ea6:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ea8:	a57fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202eac:	b565                	j	ffffffffc0202d54 <pmm_init+0x57a>
ffffffffc0202eae:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202eb0:	a55fd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202eb4:	000b3783          	ld	a5,0(s6)
ffffffffc0202eb8:	6522                	ld	a0,8(sp)
ffffffffc0202eba:	4585                	li	a1,1
ffffffffc0202ebc:	739c                	ld	a5,32(a5)
ffffffffc0202ebe:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ec0:	a3ffd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202ec4:	b585                	j	ffffffffc0202d24 <pmm_init+0x54a>
        intr_disable();
ffffffffc0202ec6:	a3ffd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202eca:	000b3783          	ld	a5,0(s6)
ffffffffc0202ece:	8522                	mv	a0,s0
ffffffffc0202ed0:	4585                	li	a1,1
ffffffffc0202ed2:	739c                	ld	a5,32(a5)
ffffffffc0202ed4:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ed6:	a29fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202eda:	bd29                	j	ffffffffc0202cf4 <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202edc:	86a2                	mv	a3,s0
ffffffffc0202ede:	00003617          	auipc	a2,0x3
ffffffffc0202ee2:	6ea60613          	addi	a2,a2,1770 # ffffffffc02065c8 <etext+0xd92>
ffffffffc0202ee6:	25300593          	li	a1,595
ffffffffc0202eea:	00003517          	auipc	a0,0x3
ffffffffc0202eee:	7ce50513          	addi	a0,a0,1998 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202ef2:	d54fd0ef          	jal	ffffffffc0200446 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202ef6:	00004697          	auipc	a3,0x4
ffffffffc0202efa:	c5a68693          	addi	a3,a3,-934 # ffffffffc0206b50 <etext+0x131a>
ffffffffc0202efe:	00003617          	auipc	a2,0x3
ffffffffc0202f02:	31a60613          	addi	a2,a2,794 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0202f06:	25400593          	li	a1,596
ffffffffc0202f0a:	00003517          	auipc	a0,0x3
ffffffffc0202f0e:	7ae50513          	addi	a0,a0,1966 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202f12:	d34fd0ef          	jal	ffffffffc0200446 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202f16:	00004697          	auipc	a3,0x4
ffffffffc0202f1a:	bfa68693          	addi	a3,a3,-1030 # ffffffffc0206b10 <etext+0x12da>
ffffffffc0202f1e:	00003617          	auipc	a2,0x3
ffffffffc0202f22:	2fa60613          	addi	a2,a2,762 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0202f26:	25300593          	li	a1,595
ffffffffc0202f2a:	00003517          	auipc	a0,0x3
ffffffffc0202f2e:	78e50513          	addi	a0,a0,1934 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202f32:	d14fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202f36:	fb5fe0ef          	jal	ffffffffc0201eea <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc0202f3a:	00004617          	auipc	a2,0x4
ffffffffc0202f3e:	97660613          	addi	a2,a2,-1674 # ffffffffc02068b0 <etext+0x107a>
ffffffffc0202f42:	07f00593          	li	a1,127
ffffffffc0202f46:	00003517          	auipc	a0,0x3
ffffffffc0202f4a:	6aa50513          	addi	a0,a0,1706 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0202f4e:	cf8fd0ef          	jal	ffffffffc0200446 <__panic>
        panic("DTB memory info not available");
ffffffffc0202f52:	00003617          	auipc	a2,0x3
ffffffffc0202f56:	7d660613          	addi	a2,a2,2006 # ffffffffc0206728 <etext+0xef2>
ffffffffc0202f5a:	06500593          	li	a1,101
ffffffffc0202f5e:	00003517          	auipc	a0,0x3
ffffffffc0202f62:	75a50513          	addi	a0,a0,1882 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202f66:	ce0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202f6a:	00004697          	auipc	a3,0x4
ffffffffc0202f6e:	b5e68693          	addi	a3,a3,-1186 # ffffffffc0206ac8 <etext+0x1292>
ffffffffc0202f72:	00003617          	auipc	a2,0x3
ffffffffc0202f76:	2a660613          	addi	a2,a2,678 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0202f7a:	26e00593          	li	a1,622
ffffffffc0202f7e:	00003517          	auipc	a0,0x3
ffffffffc0202f82:	73a50513          	addi	a0,a0,1850 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202f86:	cc0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202f8a:	00004697          	auipc	a3,0x4
ffffffffc0202f8e:	85668693          	addi	a3,a3,-1962 # ffffffffc02067e0 <etext+0xfaa>
ffffffffc0202f92:	00003617          	auipc	a2,0x3
ffffffffc0202f96:	28660613          	addi	a2,a2,646 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0202f9a:	21500593          	li	a1,533
ffffffffc0202f9e:	00003517          	auipc	a0,0x3
ffffffffc0202fa2:	71a50513          	addi	a0,a0,1818 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202fa6:	ca0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202faa:	00004697          	auipc	a3,0x4
ffffffffc0202fae:	81668693          	addi	a3,a3,-2026 # ffffffffc02067c0 <etext+0xf8a>
ffffffffc0202fb2:	00003617          	auipc	a2,0x3
ffffffffc0202fb6:	26660613          	addi	a2,a2,614 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0202fba:	21400593          	li	a1,532
ffffffffc0202fbe:	00003517          	auipc	a0,0x3
ffffffffc0202fc2:	6fa50513          	addi	a0,a0,1786 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202fc6:	c80fd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202fca:	00003617          	auipc	a2,0x3
ffffffffc0202fce:	5fe60613          	addi	a2,a2,1534 # ffffffffc02065c8 <etext+0xd92>
ffffffffc0202fd2:	07100593          	li	a1,113
ffffffffc0202fd6:	00003517          	auipc	a0,0x3
ffffffffc0202fda:	61a50513          	addi	a0,a0,1562 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0202fde:	c68fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202fe2:	00004697          	auipc	a3,0x4
ffffffffc0202fe6:	ab668693          	addi	a3,a3,-1354 # ffffffffc0206a98 <etext+0x1262>
ffffffffc0202fea:	00003617          	auipc	a2,0x3
ffffffffc0202fee:	22e60613          	addi	a2,a2,558 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0202ff2:	23c00593          	li	a1,572
ffffffffc0202ff6:	00003517          	auipc	a0,0x3
ffffffffc0202ffa:	6c250513          	addi	a0,a0,1730 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0202ffe:	c48fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203002:	00004697          	auipc	a3,0x4
ffffffffc0203006:	a4e68693          	addi	a3,a3,-1458 # ffffffffc0206a50 <etext+0x121a>
ffffffffc020300a:	00003617          	auipc	a2,0x3
ffffffffc020300e:	20e60613          	addi	a2,a2,526 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203012:	23a00593          	li	a1,570
ffffffffc0203016:	00003517          	auipc	a0,0x3
ffffffffc020301a:	6a250513          	addi	a0,a0,1698 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020301e:	c28fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203022:	00004697          	auipc	a3,0x4
ffffffffc0203026:	a5e68693          	addi	a3,a3,-1442 # ffffffffc0206a80 <etext+0x124a>
ffffffffc020302a:	00003617          	auipc	a2,0x3
ffffffffc020302e:	1ee60613          	addi	a2,a2,494 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203032:	23900593          	li	a1,569
ffffffffc0203036:	00003517          	auipc	a0,0x3
ffffffffc020303a:	68250513          	addi	a0,a0,1666 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020303e:	c08fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0203042:	00004697          	auipc	a3,0x4
ffffffffc0203046:	b2668693          	addi	a3,a3,-1242 # ffffffffc0206b68 <etext+0x1332>
ffffffffc020304a:	00003617          	auipc	a2,0x3
ffffffffc020304e:	1ce60613          	addi	a2,a2,462 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203052:	25700593          	li	a1,599
ffffffffc0203056:	00003517          	auipc	a0,0x3
ffffffffc020305a:	66250513          	addi	a0,a0,1634 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020305e:	be8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203062:	00004697          	auipc	a3,0x4
ffffffffc0203066:	a6668693          	addi	a3,a3,-1434 # ffffffffc0206ac8 <etext+0x1292>
ffffffffc020306a:	00003617          	auipc	a2,0x3
ffffffffc020306e:	1ae60613          	addi	a2,a2,430 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203072:	24400593          	li	a1,580
ffffffffc0203076:	00003517          	auipc	a0,0x3
ffffffffc020307a:	64250513          	addi	a0,a0,1602 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020307e:	bc8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203082:	00004697          	auipc	a3,0x4
ffffffffc0203086:	b3e68693          	addi	a3,a3,-1218 # ffffffffc0206bc0 <etext+0x138a>
ffffffffc020308a:	00003617          	auipc	a2,0x3
ffffffffc020308e:	18e60613          	addi	a2,a2,398 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203092:	25c00593          	li	a1,604
ffffffffc0203096:	00003517          	auipc	a0,0x3
ffffffffc020309a:	62250513          	addi	a0,a0,1570 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020309e:	ba8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02030a2:	00004697          	auipc	a3,0x4
ffffffffc02030a6:	ade68693          	addi	a3,a3,-1314 # ffffffffc0206b80 <etext+0x134a>
ffffffffc02030aa:	00003617          	auipc	a2,0x3
ffffffffc02030ae:	16e60613          	addi	a2,a2,366 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02030b2:	25b00593          	li	a1,603
ffffffffc02030b6:	00003517          	auipc	a0,0x3
ffffffffc02030ba:	60250513          	addi	a0,a0,1538 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02030be:	b88fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02030c2:	00004697          	auipc	a3,0x4
ffffffffc02030c6:	98e68693          	addi	a3,a3,-1650 # ffffffffc0206a50 <etext+0x121a>
ffffffffc02030ca:	00003617          	auipc	a2,0x3
ffffffffc02030ce:	14e60613          	addi	a2,a2,334 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02030d2:	23600593          	li	a1,566
ffffffffc02030d6:	00003517          	auipc	a0,0x3
ffffffffc02030da:	5e250513          	addi	a0,a0,1506 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02030de:	b68fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02030e2:	00004697          	auipc	a3,0x4
ffffffffc02030e6:	80e68693          	addi	a3,a3,-2034 # ffffffffc02068f0 <etext+0x10ba>
ffffffffc02030ea:	00003617          	auipc	a2,0x3
ffffffffc02030ee:	12e60613          	addi	a2,a2,302 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02030f2:	23500593          	li	a1,565
ffffffffc02030f6:	00003517          	auipc	a0,0x3
ffffffffc02030fa:	5c250513          	addi	a0,a0,1474 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02030fe:	b48fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203102:	00004697          	auipc	a3,0x4
ffffffffc0203106:	96668693          	addi	a3,a3,-1690 # ffffffffc0206a68 <etext+0x1232>
ffffffffc020310a:	00003617          	auipc	a2,0x3
ffffffffc020310e:	10e60613          	addi	a2,a2,270 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203112:	23200593          	li	a1,562
ffffffffc0203116:	00003517          	auipc	a0,0x3
ffffffffc020311a:	5a250513          	addi	a0,a0,1442 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020311e:	b28fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203122:	00003697          	auipc	a3,0x3
ffffffffc0203126:	7b668693          	addi	a3,a3,1974 # ffffffffc02068d8 <etext+0x10a2>
ffffffffc020312a:	00003617          	auipc	a2,0x3
ffffffffc020312e:	0ee60613          	addi	a2,a2,238 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203132:	23100593          	li	a1,561
ffffffffc0203136:	00003517          	auipc	a0,0x3
ffffffffc020313a:	58250513          	addi	a0,a0,1410 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020313e:	b08fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203142:	00004697          	auipc	a3,0x4
ffffffffc0203146:	83668693          	addi	a3,a3,-1994 # ffffffffc0206978 <etext+0x1142>
ffffffffc020314a:	00003617          	auipc	a2,0x3
ffffffffc020314e:	0ce60613          	addi	a2,a2,206 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203152:	23000593          	li	a1,560
ffffffffc0203156:	00003517          	auipc	a0,0x3
ffffffffc020315a:	56250513          	addi	a0,a0,1378 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020315e:	ae8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203162:	00004697          	auipc	a3,0x4
ffffffffc0203166:	8ee68693          	addi	a3,a3,-1810 # ffffffffc0206a50 <etext+0x121a>
ffffffffc020316a:	00003617          	auipc	a2,0x3
ffffffffc020316e:	0ae60613          	addi	a2,a2,174 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203172:	22f00593          	li	a1,559
ffffffffc0203176:	00003517          	auipc	a0,0x3
ffffffffc020317a:	54250513          	addi	a0,a0,1346 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020317e:	ac8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203182:	00004697          	auipc	a3,0x4
ffffffffc0203186:	8b668693          	addi	a3,a3,-1866 # ffffffffc0206a38 <etext+0x1202>
ffffffffc020318a:	00003617          	auipc	a2,0x3
ffffffffc020318e:	08e60613          	addi	a2,a2,142 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203192:	22e00593          	li	a1,558
ffffffffc0203196:	00003517          	auipc	a0,0x3
ffffffffc020319a:	52250513          	addi	a0,a0,1314 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020319e:	aa8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02031a2:	00004697          	auipc	a3,0x4
ffffffffc02031a6:	86668693          	addi	a3,a3,-1946 # ffffffffc0206a08 <etext+0x11d2>
ffffffffc02031aa:	00003617          	auipc	a2,0x3
ffffffffc02031ae:	06e60613          	addi	a2,a2,110 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02031b2:	22d00593          	li	a1,557
ffffffffc02031b6:	00003517          	auipc	a0,0x3
ffffffffc02031ba:	50250513          	addi	a0,a0,1282 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02031be:	a88fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02031c2:	00004697          	auipc	a3,0x4
ffffffffc02031c6:	82e68693          	addi	a3,a3,-2002 # ffffffffc02069f0 <etext+0x11ba>
ffffffffc02031ca:	00003617          	auipc	a2,0x3
ffffffffc02031ce:	04e60613          	addi	a2,a2,78 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02031d2:	22b00593          	li	a1,555
ffffffffc02031d6:	00003517          	auipc	a0,0x3
ffffffffc02031da:	4e250513          	addi	a0,a0,1250 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02031de:	a68fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02031e2:	00003697          	auipc	a3,0x3
ffffffffc02031e6:	7ee68693          	addi	a3,a3,2030 # ffffffffc02069d0 <etext+0x119a>
ffffffffc02031ea:	00003617          	auipc	a2,0x3
ffffffffc02031ee:	02e60613          	addi	a2,a2,46 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02031f2:	22a00593          	li	a1,554
ffffffffc02031f6:	00003517          	auipc	a0,0x3
ffffffffc02031fa:	4c250513          	addi	a0,a0,1218 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02031fe:	a48fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203202:	00003697          	auipc	a3,0x3
ffffffffc0203206:	7be68693          	addi	a3,a3,1982 # ffffffffc02069c0 <etext+0x118a>
ffffffffc020320a:	00003617          	auipc	a2,0x3
ffffffffc020320e:	00e60613          	addi	a2,a2,14 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203212:	22900593          	li	a1,553
ffffffffc0203216:	00003517          	auipc	a0,0x3
ffffffffc020321a:	4a250513          	addi	a0,a0,1186 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020321e:	a28fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203222:	00003697          	auipc	a3,0x3
ffffffffc0203226:	78e68693          	addi	a3,a3,1934 # ffffffffc02069b0 <etext+0x117a>
ffffffffc020322a:	00003617          	auipc	a2,0x3
ffffffffc020322e:	fee60613          	addi	a2,a2,-18 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203232:	22800593          	li	a1,552
ffffffffc0203236:	00003517          	auipc	a0,0x3
ffffffffc020323a:	48250513          	addi	a0,a0,1154 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020323e:	a08fd0ef          	jal	ffffffffc0200446 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203242:	00003617          	auipc	a2,0x3
ffffffffc0203246:	42e60613          	addi	a2,a2,1070 # ffffffffc0206670 <etext+0xe3a>
ffffffffc020324a:	08100593          	li	a1,129
ffffffffc020324e:	00003517          	auipc	a0,0x3
ffffffffc0203252:	46a50513          	addi	a0,a0,1130 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203256:	9f0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020325a:	00003697          	auipc	a3,0x3
ffffffffc020325e:	6ae68693          	addi	a3,a3,1710 # ffffffffc0206908 <etext+0x10d2>
ffffffffc0203262:	00003617          	auipc	a2,0x3
ffffffffc0203266:	fb660613          	addi	a2,a2,-74 # ffffffffc0206218 <etext+0x9e2>
ffffffffc020326a:	22300593          	li	a1,547
ffffffffc020326e:	00003517          	auipc	a0,0x3
ffffffffc0203272:	44a50513          	addi	a0,a0,1098 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203276:	9d0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020327a:	00003697          	auipc	a3,0x3
ffffffffc020327e:	6fe68693          	addi	a3,a3,1790 # ffffffffc0206978 <etext+0x1142>
ffffffffc0203282:	00003617          	auipc	a2,0x3
ffffffffc0203286:	f9660613          	addi	a2,a2,-106 # ffffffffc0206218 <etext+0x9e2>
ffffffffc020328a:	22700593          	li	a1,551
ffffffffc020328e:	00003517          	auipc	a0,0x3
ffffffffc0203292:	42a50513          	addi	a0,a0,1066 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203296:	9b0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020329a:	00003697          	auipc	a3,0x3
ffffffffc020329e:	69e68693          	addi	a3,a3,1694 # ffffffffc0206938 <etext+0x1102>
ffffffffc02032a2:	00003617          	auipc	a2,0x3
ffffffffc02032a6:	f7660613          	addi	a2,a2,-138 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02032aa:	22600593          	li	a1,550
ffffffffc02032ae:	00003517          	auipc	a0,0x3
ffffffffc02032b2:	40a50513          	addi	a0,a0,1034 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02032b6:	990fd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02032ba:	86d6                	mv	a3,s5
ffffffffc02032bc:	00003617          	auipc	a2,0x3
ffffffffc02032c0:	30c60613          	addi	a2,a2,780 # ffffffffc02065c8 <etext+0xd92>
ffffffffc02032c4:	22200593          	li	a1,546
ffffffffc02032c8:	00003517          	auipc	a0,0x3
ffffffffc02032cc:	3f050513          	addi	a0,a0,1008 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02032d0:	976fd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02032d4:	00003617          	auipc	a2,0x3
ffffffffc02032d8:	2f460613          	addi	a2,a2,756 # ffffffffc02065c8 <etext+0xd92>
ffffffffc02032dc:	22100593          	li	a1,545
ffffffffc02032e0:	00003517          	auipc	a0,0x3
ffffffffc02032e4:	3d850513          	addi	a0,a0,984 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02032e8:	95efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02032ec:	00003697          	auipc	a3,0x3
ffffffffc02032f0:	60468693          	addi	a3,a3,1540 # ffffffffc02068f0 <etext+0x10ba>
ffffffffc02032f4:	00003617          	auipc	a2,0x3
ffffffffc02032f8:	f2460613          	addi	a2,a2,-220 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02032fc:	21f00593          	li	a1,543
ffffffffc0203300:	00003517          	auipc	a0,0x3
ffffffffc0203304:	3b850513          	addi	a0,a0,952 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203308:	93efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020330c:	00003697          	auipc	a3,0x3
ffffffffc0203310:	5cc68693          	addi	a3,a3,1484 # ffffffffc02068d8 <etext+0x10a2>
ffffffffc0203314:	00003617          	auipc	a2,0x3
ffffffffc0203318:	f0460613          	addi	a2,a2,-252 # ffffffffc0206218 <etext+0x9e2>
ffffffffc020331c:	21e00593          	li	a1,542
ffffffffc0203320:	00003517          	auipc	a0,0x3
ffffffffc0203324:	39850513          	addi	a0,a0,920 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203328:	91efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc020332c:	00004697          	auipc	a3,0x4
ffffffffc0203330:	95c68693          	addi	a3,a3,-1700 # ffffffffc0206c88 <etext+0x1452>
ffffffffc0203334:	00003617          	auipc	a2,0x3
ffffffffc0203338:	ee460613          	addi	a2,a2,-284 # ffffffffc0206218 <etext+0x9e2>
ffffffffc020333c:	26500593          	li	a1,613
ffffffffc0203340:	00003517          	auipc	a0,0x3
ffffffffc0203344:	37850513          	addi	a0,a0,888 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203348:	8fefd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc020334c:	00004697          	auipc	a3,0x4
ffffffffc0203350:	90468693          	addi	a3,a3,-1788 # ffffffffc0206c50 <etext+0x141a>
ffffffffc0203354:	00003617          	auipc	a2,0x3
ffffffffc0203358:	ec460613          	addi	a2,a2,-316 # ffffffffc0206218 <etext+0x9e2>
ffffffffc020335c:	26200593          	li	a1,610
ffffffffc0203360:	00003517          	auipc	a0,0x3
ffffffffc0203364:	35850513          	addi	a0,a0,856 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203368:	8defd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 2);
ffffffffc020336c:	00004697          	auipc	a3,0x4
ffffffffc0203370:	8b468693          	addi	a3,a3,-1868 # ffffffffc0206c20 <etext+0x13ea>
ffffffffc0203374:	00003617          	auipc	a2,0x3
ffffffffc0203378:	ea460613          	addi	a2,a2,-348 # ffffffffc0206218 <etext+0x9e2>
ffffffffc020337c:	25e00593          	li	a1,606
ffffffffc0203380:	00003517          	auipc	a0,0x3
ffffffffc0203384:	33850513          	addi	a0,a0,824 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203388:	8befd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc020338c:	00004697          	auipc	a3,0x4
ffffffffc0203390:	84c68693          	addi	a3,a3,-1972 # ffffffffc0206bd8 <etext+0x13a2>
ffffffffc0203394:	00003617          	auipc	a2,0x3
ffffffffc0203398:	e8460613          	addi	a2,a2,-380 # ffffffffc0206218 <etext+0x9e2>
ffffffffc020339c:	25d00593          	li	a1,605
ffffffffc02033a0:	00003517          	auipc	a0,0x3
ffffffffc02033a4:	31850513          	addi	a0,a0,792 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02033a8:	89efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02033ac:	00003697          	auipc	a3,0x3
ffffffffc02033b0:	47468693          	addi	a3,a3,1140 # ffffffffc0206820 <etext+0xfea>
ffffffffc02033b4:	00003617          	auipc	a2,0x3
ffffffffc02033b8:	e6460613          	addi	a2,a2,-412 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02033bc:	21600593          	li	a1,534
ffffffffc02033c0:	00003517          	auipc	a0,0x3
ffffffffc02033c4:	2f850513          	addi	a0,a0,760 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02033c8:	87efd0ef          	jal	ffffffffc0200446 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02033cc:	00003617          	auipc	a2,0x3
ffffffffc02033d0:	2a460613          	addi	a2,a2,676 # ffffffffc0206670 <etext+0xe3a>
ffffffffc02033d4:	0c900593          	li	a1,201
ffffffffc02033d8:	00003517          	auipc	a0,0x3
ffffffffc02033dc:	2e050513          	addi	a0,a0,736 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02033e0:	866fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02033e4:	00003697          	auipc	a3,0x3
ffffffffc02033e8:	49c68693          	addi	a3,a3,1180 # ffffffffc0206880 <etext+0x104a>
ffffffffc02033ec:	00003617          	auipc	a2,0x3
ffffffffc02033f0:	e2c60613          	addi	a2,a2,-468 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02033f4:	21d00593          	li	a1,541
ffffffffc02033f8:	00003517          	auipc	a0,0x3
ffffffffc02033fc:	2c050513          	addi	a0,a0,704 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203400:	846fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203404:	00003697          	auipc	a3,0x3
ffffffffc0203408:	44c68693          	addi	a3,a3,1100 # ffffffffc0206850 <etext+0x101a>
ffffffffc020340c:	00003617          	auipc	a2,0x3
ffffffffc0203410:	e0c60613          	addi	a2,a2,-500 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203414:	21a00593          	li	a1,538
ffffffffc0203418:	00003517          	auipc	a0,0x3
ffffffffc020341c:	2a050513          	addi	a0,a0,672 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203420:	826fd0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203424 <copy_range>:
{
ffffffffc0203424:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203426:	00d667b3          	or	a5,a2,a3
{
ffffffffc020342a:	f486                	sd	ra,104(sp)
ffffffffc020342c:	f0a2                	sd	s0,96(sp)
ffffffffc020342e:	eca6                	sd	s1,88(sp)
ffffffffc0203430:	e8ca                	sd	s2,80(sp)
ffffffffc0203432:	e4ce                	sd	s3,72(sp)
ffffffffc0203434:	e0d2                	sd	s4,64(sp)
ffffffffc0203436:	fc56                	sd	s5,56(sp)
ffffffffc0203438:	f85a                	sd	s6,48(sp)
ffffffffc020343a:	f45e                	sd	s7,40(sp)
ffffffffc020343c:	f062                	sd	s8,32(sp)
ffffffffc020343e:	ec66                	sd	s9,24(sp)
ffffffffc0203440:	e86a                	sd	s10,16(sp)
ffffffffc0203442:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203444:	03479713          	slli	a4,a5,0x34
ffffffffc0203448:	20071f63          	bnez	a4,ffffffffc0203666 <copy_range+0x242>
    assert(USER_ACCESS(start, end));
ffffffffc020344c:	002007b7          	lui	a5,0x200
ffffffffc0203450:	00d63733          	sltu	a4,a2,a3
ffffffffc0203454:	00f637b3          	sltu	a5,a2,a5
ffffffffc0203458:	00173713          	seqz	a4,a4
ffffffffc020345c:	8fd9                	or	a5,a5,a4
ffffffffc020345e:	8432                	mv	s0,a2
ffffffffc0203460:	8936                	mv	s2,a3
ffffffffc0203462:	1e079263          	bnez	a5,ffffffffc0203646 <copy_range+0x222>
ffffffffc0203466:	4785                	li	a5,1
ffffffffc0203468:	07fe                	slli	a5,a5,0x1f
ffffffffc020346a:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e49>
ffffffffc020346c:	1cf6fd63          	bgeu	a3,a5,ffffffffc0203646 <copy_range+0x222>
ffffffffc0203470:	5b7d                	li	s6,-1
ffffffffc0203472:	8baa                	mv	s7,a0
ffffffffc0203474:	8a2e                	mv	s4,a1
ffffffffc0203476:	6a85                	lui	s5,0x1
ffffffffc0203478:	00cb5b13          	srli	s6,s6,0xc
    if (PPN(pa) >= npage)
ffffffffc020347c:	00098c97          	auipc	s9,0x98
ffffffffc0203480:	1ccc8c93          	addi	s9,s9,460 # ffffffffc029b648 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203484:	00098c17          	auipc	s8,0x98
ffffffffc0203488:	1ccc0c13          	addi	s8,s8,460 # ffffffffc029b650 <pages>
ffffffffc020348c:	fff80d37          	lui	s10,0xfff80
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203490:	4601                	li	a2,0
ffffffffc0203492:	85a2                	mv	a1,s0
ffffffffc0203494:	8552                	mv	a0,s4
ffffffffc0203496:	b19fe0ef          	jal	ffffffffc0201fae <get_pte>
ffffffffc020349a:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020349c:	0e050a63          	beqz	a0,ffffffffc0203590 <copy_range+0x16c>
        if (*ptep & PTE_V)
ffffffffc02034a0:	611c                	ld	a5,0(a0)
ffffffffc02034a2:	8b85                	andi	a5,a5,1
ffffffffc02034a4:	e78d                	bnez	a5,ffffffffc02034ce <copy_range+0xaa>
        start += PGSIZE;
ffffffffc02034a6:	9456                	add	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02034a8:	c019                	beqz	s0,ffffffffc02034ae <copy_range+0x8a>
ffffffffc02034aa:	ff2463e3          	bltu	s0,s2,ffffffffc0203490 <copy_range+0x6c>
    return 0;
ffffffffc02034ae:	4501                	li	a0,0
}
ffffffffc02034b0:	70a6                	ld	ra,104(sp)
ffffffffc02034b2:	7406                	ld	s0,96(sp)
ffffffffc02034b4:	64e6                	ld	s1,88(sp)
ffffffffc02034b6:	6946                	ld	s2,80(sp)
ffffffffc02034b8:	69a6                	ld	s3,72(sp)
ffffffffc02034ba:	6a06                	ld	s4,64(sp)
ffffffffc02034bc:	7ae2                	ld	s5,56(sp)
ffffffffc02034be:	7b42                	ld	s6,48(sp)
ffffffffc02034c0:	7ba2                	ld	s7,40(sp)
ffffffffc02034c2:	7c02                	ld	s8,32(sp)
ffffffffc02034c4:	6ce2                	ld	s9,24(sp)
ffffffffc02034c6:	6d42                	ld	s10,16(sp)
ffffffffc02034c8:	6da2                	ld	s11,8(sp)
ffffffffc02034ca:	6165                	addi	sp,sp,112
ffffffffc02034cc:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02034ce:	4605                	li	a2,1
ffffffffc02034d0:	85a2                	mv	a1,s0
ffffffffc02034d2:	855e                	mv	a0,s7
ffffffffc02034d4:	adbfe0ef          	jal	ffffffffc0201fae <get_pte>
ffffffffc02034d8:	c165                	beqz	a0,ffffffffc02035b8 <copy_range+0x194>
            uint32_t perm = (*ptep & 0x3FF);  // 提取所有权限位（低10位）
ffffffffc02034da:	0004b983          	ld	s3,0(s1)
    if (!(pte & PTE_V))
ffffffffc02034de:	0019f793          	andi	a5,s3,1
ffffffffc02034e2:	14078663          	beqz	a5,ffffffffc020362e <copy_range+0x20a>
    if (PPN(pa) >= npage)
ffffffffc02034e6:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02034ea:	00299793          	slli	a5,s3,0x2
ffffffffc02034ee:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02034f0:	12e7f363          	bgeu	a5,a4,ffffffffc0203616 <copy_range+0x1f2>
    return &pages[PPN(pa) - nbase];
ffffffffc02034f4:	000c3483          	ld	s1,0(s8)
ffffffffc02034f8:	97ea                	add	a5,a5,s10
ffffffffc02034fa:	079a                	slli	a5,a5,0x6
ffffffffc02034fc:	94be                	add	s1,s1,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02034fe:	100027f3          	csrr	a5,sstatus
ffffffffc0203502:	8b89                	andi	a5,a5,2
ffffffffc0203504:	efc9                	bnez	a5,ffffffffc020359e <copy_range+0x17a>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203506:	00098797          	auipc	a5,0x98
ffffffffc020350a:	1227b783          	ld	a5,290(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc020350e:	4505                	li	a0,1
ffffffffc0203510:	6f9c                	ld	a5,24(a5)
ffffffffc0203512:	9782                	jalr	a5
ffffffffc0203514:	8daa                	mv	s11,a0
            assert(page != NULL);
ffffffffc0203516:	c0e5                	beqz	s1,ffffffffc02035f6 <copy_range+0x1d2>
            assert(npage != NULL);
ffffffffc0203518:	0a0d8f63          	beqz	s11,ffffffffc02035d6 <copy_range+0x1b2>
    return page - pages + nbase;
ffffffffc020351c:	000c3783          	ld	a5,0(s8)
ffffffffc0203520:	00080637          	lui	a2,0x80
    return KADDR(page2pa(page));
ffffffffc0203524:	000cb703          	ld	a4,0(s9)
    return page - pages + nbase;
ffffffffc0203528:	40f486b3          	sub	a3,s1,a5
ffffffffc020352c:	8699                	srai	a3,a3,0x6
ffffffffc020352e:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0203530:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203534:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203536:	08e5f463          	bgeu	a1,a4,ffffffffc02035be <copy_range+0x19a>
    return page - pages + nbase;
ffffffffc020353a:	40fd87b3          	sub	a5,s11,a5
ffffffffc020353e:	8799                	srai	a5,a5,0x6
ffffffffc0203540:	97b2                	add	a5,a5,a2
    return KADDR(page2pa(page));
ffffffffc0203542:	0167f633          	and	a2,a5,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203546:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203548:	06e67a63          	bgeu	a2,a4,ffffffffc02035bc <copy_range+0x198>
ffffffffc020354c:	00098517          	auipc	a0,0x98
ffffffffc0203550:	0f453503          	ld	a0,244(a0) # ffffffffc029b640 <va_pa_offset>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203554:	6605                	lui	a2,0x1
ffffffffc0203556:	00a685b3          	add	a1,a3,a0
ffffffffc020355a:	953e                	add	a0,a0,a5
ffffffffc020355c:	2c2020ef          	jal	ffffffffc020581e <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc0203560:	3ff9f693          	andi	a3,s3,1023
ffffffffc0203564:	85ee                	mv	a1,s11
ffffffffc0203566:	8622                	mv	a2,s0
ffffffffc0203568:	855e                	mv	a0,s7
ffffffffc020356a:	97aff0ef          	jal	ffffffffc02026e4 <page_insert>
            assert(ret == 0);
ffffffffc020356e:	dd05                	beqz	a0,ffffffffc02034a6 <copy_range+0x82>
ffffffffc0203570:	00003697          	auipc	a3,0x3
ffffffffc0203574:	78068693          	addi	a3,a3,1920 # ffffffffc0206cf0 <etext+0x14ba>
ffffffffc0203578:	00003617          	auipc	a2,0x3
ffffffffc020357c:	ca060613          	addi	a2,a2,-864 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203580:	1b200593          	li	a1,434
ffffffffc0203584:	00003517          	auipc	a0,0x3
ffffffffc0203588:	13450513          	addi	a0,a0,308 # ffffffffc02066b8 <etext+0xe82>
ffffffffc020358c:	ebbfc0ef          	jal	ffffffffc0200446 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203590:	002007b7          	lui	a5,0x200
ffffffffc0203594:	97a2                	add	a5,a5,s0
ffffffffc0203596:	ffe00437          	lui	s0,0xffe00
ffffffffc020359a:	8c7d                	and	s0,s0,a5
            continue;
ffffffffc020359c:	b731                	j	ffffffffc02034a8 <copy_range+0x84>
        intr_disable();
ffffffffc020359e:	b66fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02035a2:	00098797          	auipc	a5,0x98
ffffffffc02035a6:	0867b783          	ld	a5,134(a5) # ffffffffc029b628 <pmm_manager>
ffffffffc02035aa:	4505                	li	a0,1
ffffffffc02035ac:	6f9c                	ld	a5,24(a5)
ffffffffc02035ae:	9782                	jalr	a5
ffffffffc02035b0:	8daa                	mv	s11,a0
        intr_enable();
ffffffffc02035b2:	b4cfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02035b6:	b785                	j	ffffffffc0203516 <copy_range+0xf2>
                return -E_NO_MEM;
ffffffffc02035b8:	5571                	li	a0,-4
ffffffffc02035ba:	bddd                	j	ffffffffc02034b0 <copy_range+0x8c>
ffffffffc02035bc:	86be                	mv	a3,a5
ffffffffc02035be:	00003617          	auipc	a2,0x3
ffffffffc02035c2:	00a60613          	addi	a2,a2,10 # ffffffffc02065c8 <etext+0xd92>
ffffffffc02035c6:	07100593          	li	a1,113
ffffffffc02035ca:	00003517          	auipc	a0,0x3
ffffffffc02035ce:	02650513          	addi	a0,a0,38 # ffffffffc02065f0 <etext+0xdba>
ffffffffc02035d2:	e75fc0ef          	jal	ffffffffc0200446 <__panic>
            assert(npage != NULL);
ffffffffc02035d6:	00003697          	auipc	a3,0x3
ffffffffc02035da:	70a68693          	addi	a3,a3,1802 # ffffffffc0206ce0 <etext+0x14aa>
ffffffffc02035de:	00003617          	auipc	a2,0x3
ffffffffc02035e2:	c3a60613          	addi	a2,a2,-966 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02035e6:	19500593          	li	a1,405
ffffffffc02035ea:	00003517          	auipc	a0,0x3
ffffffffc02035ee:	0ce50513          	addi	a0,a0,206 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02035f2:	e55fc0ef          	jal	ffffffffc0200446 <__panic>
            assert(page != NULL);
ffffffffc02035f6:	00003697          	auipc	a3,0x3
ffffffffc02035fa:	6da68693          	addi	a3,a3,1754 # ffffffffc0206cd0 <etext+0x149a>
ffffffffc02035fe:	00003617          	auipc	a2,0x3
ffffffffc0203602:	c1a60613          	addi	a2,a2,-998 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203606:	19400593          	li	a1,404
ffffffffc020360a:	00003517          	auipc	a0,0x3
ffffffffc020360e:	0ae50513          	addi	a0,a0,174 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203612:	e35fc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203616:	00003617          	auipc	a2,0x3
ffffffffc020361a:	08260613          	addi	a2,a2,130 # ffffffffc0206698 <etext+0xe62>
ffffffffc020361e:	06900593          	li	a1,105
ffffffffc0203622:	00003517          	auipc	a0,0x3
ffffffffc0203626:	fce50513          	addi	a0,a0,-50 # ffffffffc02065f0 <etext+0xdba>
ffffffffc020362a:	e1dfc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc020362e:	00003617          	auipc	a2,0x3
ffffffffc0203632:	28260613          	addi	a2,a2,642 # ffffffffc02068b0 <etext+0x107a>
ffffffffc0203636:	07f00593          	li	a1,127
ffffffffc020363a:	00003517          	auipc	a0,0x3
ffffffffc020363e:	fb650513          	addi	a0,a0,-74 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0203642:	e05fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203646:	00003697          	auipc	a3,0x3
ffffffffc020364a:	0b268693          	addi	a3,a3,178 # ffffffffc02066f8 <etext+0xec2>
ffffffffc020364e:	00003617          	auipc	a2,0x3
ffffffffc0203652:	bca60613          	addi	a2,a2,-1078 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203656:	17c00593          	li	a1,380
ffffffffc020365a:	00003517          	auipc	a0,0x3
ffffffffc020365e:	05e50513          	addi	a0,a0,94 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203662:	de5fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203666:	00003697          	auipc	a3,0x3
ffffffffc020366a:	06268693          	addi	a3,a3,98 # ffffffffc02066c8 <etext+0xe92>
ffffffffc020366e:	00003617          	auipc	a2,0x3
ffffffffc0203672:	baa60613          	addi	a2,a2,-1110 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203676:	17b00593          	li	a1,379
ffffffffc020367a:	00003517          	auipc	a0,0x3
ffffffffc020367e:	03e50513          	addi	a0,a0,62 # ffffffffc02066b8 <etext+0xe82>
ffffffffc0203682:	dc5fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203686 <pgdir_alloc_page>:
{
ffffffffc0203686:	7139                	addi	sp,sp,-64
ffffffffc0203688:	f426                	sd	s1,40(sp)
ffffffffc020368a:	f04a                	sd	s2,32(sp)
ffffffffc020368c:	ec4e                	sd	s3,24(sp)
ffffffffc020368e:	fc06                	sd	ra,56(sp)
ffffffffc0203690:	f822                	sd	s0,48(sp)
ffffffffc0203692:	892a                	mv	s2,a0
ffffffffc0203694:	84ae                	mv	s1,a1
ffffffffc0203696:	89b2                	mv	s3,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203698:	100027f3          	csrr	a5,sstatus
ffffffffc020369c:	8b89                	andi	a5,a5,2
ffffffffc020369e:	ebb5                	bnez	a5,ffffffffc0203712 <pgdir_alloc_page+0x8c>
        page = pmm_manager->alloc_pages(n);
ffffffffc02036a0:	00098417          	auipc	s0,0x98
ffffffffc02036a4:	f8840413          	addi	s0,s0,-120 # ffffffffc029b628 <pmm_manager>
ffffffffc02036a8:	601c                	ld	a5,0(s0)
ffffffffc02036aa:	4505                	li	a0,1
ffffffffc02036ac:	6f9c                	ld	a5,24(a5)
ffffffffc02036ae:	9782                	jalr	a5
ffffffffc02036b0:	85aa                	mv	a1,a0
    if (page != NULL)
ffffffffc02036b2:	c5b9                	beqz	a1,ffffffffc0203700 <pgdir_alloc_page+0x7a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc02036b4:	86ce                	mv	a3,s3
ffffffffc02036b6:	854a                	mv	a0,s2
ffffffffc02036b8:	8626                	mv	a2,s1
ffffffffc02036ba:	e42e                	sd	a1,8(sp)
ffffffffc02036bc:	828ff0ef          	jal	ffffffffc02026e4 <page_insert>
ffffffffc02036c0:	65a2                	ld	a1,8(sp)
ffffffffc02036c2:	e515                	bnez	a0,ffffffffc02036ee <pgdir_alloc_page+0x68>
        assert(page_ref(page) == 1);
ffffffffc02036c4:	4198                	lw	a4,0(a1)
        page->pra_vaddr = la;
ffffffffc02036c6:	fd84                	sd	s1,56(a1)
        assert(page_ref(page) == 1);
ffffffffc02036c8:	4785                	li	a5,1
ffffffffc02036ca:	02f70c63          	beq	a4,a5,ffffffffc0203702 <pgdir_alloc_page+0x7c>
ffffffffc02036ce:	00003697          	auipc	a3,0x3
ffffffffc02036d2:	63268693          	addi	a3,a3,1586 # ffffffffc0206d00 <etext+0x14ca>
ffffffffc02036d6:	00003617          	auipc	a2,0x3
ffffffffc02036da:	b4260613          	addi	a2,a2,-1214 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02036de:	1fb00593          	li	a1,507
ffffffffc02036e2:	00003517          	auipc	a0,0x3
ffffffffc02036e6:	fd650513          	addi	a0,a0,-42 # ffffffffc02066b8 <etext+0xe82>
ffffffffc02036ea:	d5dfc0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02036ee:	100027f3          	csrr	a5,sstatus
ffffffffc02036f2:	8b89                	andi	a5,a5,2
ffffffffc02036f4:	ef95                	bnez	a5,ffffffffc0203730 <pgdir_alloc_page+0xaa>
        pmm_manager->free_pages(base, n);
ffffffffc02036f6:	601c                	ld	a5,0(s0)
ffffffffc02036f8:	852e                	mv	a0,a1
ffffffffc02036fa:	4585                	li	a1,1
ffffffffc02036fc:	739c                	ld	a5,32(a5)
ffffffffc02036fe:	9782                	jalr	a5
            return NULL;
ffffffffc0203700:	4581                	li	a1,0
}
ffffffffc0203702:	70e2                	ld	ra,56(sp)
ffffffffc0203704:	7442                	ld	s0,48(sp)
ffffffffc0203706:	74a2                	ld	s1,40(sp)
ffffffffc0203708:	7902                	ld	s2,32(sp)
ffffffffc020370a:	69e2                	ld	s3,24(sp)
ffffffffc020370c:	852e                	mv	a0,a1
ffffffffc020370e:	6121                	addi	sp,sp,64
ffffffffc0203710:	8082                	ret
        intr_disable();
ffffffffc0203712:	9f2fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203716:	00098417          	auipc	s0,0x98
ffffffffc020371a:	f1240413          	addi	s0,s0,-238 # ffffffffc029b628 <pmm_manager>
ffffffffc020371e:	601c                	ld	a5,0(s0)
ffffffffc0203720:	4505                	li	a0,1
ffffffffc0203722:	6f9c                	ld	a5,24(a5)
ffffffffc0203724:	9782                	jalr	a5
ffffffffc0203726:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0203728:	9d6fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020372c:	65a2                	ld	a1,8(sp)
ffffffffc020372e:	b751                	j	ffffffffc02036b2 <pgdir_alloc_page+0x2c>
        intr_disable();
ffffffffc0203730:	9d4fd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203734:	601c                	ld	a5,0(s0)
ffffffffc0203736:	6522                	ld	a0,8(sp)
ffffffffc0203738:	4585                	li	a1,1
ffffffffc020373a:	739c                	ld	a5,32(a5)
ffffffffc020373c:	9782                	jalr	a5
        intr_enable();
ffffffffc020373e:	9c0fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0203742:	bf7d                	j	ffffffffc0203700 <pgdir_alloc_page+0x7a>

ffffffffc0203744 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203744:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0203746:	00003697          	auipc	a3,0x3
ffffffffc020374a:	5d268693          	addi	a3,a3,1490 # ffffffffc0206d18 <etext+0x14e2>
ffffffffc020374e:	00003617          	auipc	a2,0x3
ffffffffc0203752:	aca60613          	addi	a2,a2,-1334 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203756:	07400593          	li	a1,116
ffffffffc020375a:	00003517          	auipc	a0,0x3
ffffffffc020375e:	5de50513          	addi	a0,a0,1502 # ffffffffc0206d38 <etext+0x1502>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203762:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0203764:	ce3fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203768 <mm_create>:
{
ffffffffc0203768:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020376a:	04000513          	li	a0,64
{
ffffffffc020376e:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203770:	dd4fe0ef          	jal	ffffffffc0201d44 <kmalloc>
    if (mm != NULL)
ffffffffc0203774:	cd19                	beqz	a0,ffffffffc0203792 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc0203776:	e508                	sd	a0,8(a0)
ffffffffc0203778:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc020377a:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc020377e:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203782:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203786:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc020378a:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc020378e:	02053c23          	sd	zero,56(a0)
}
ffffffffc0203792:	60a2                	ld	ra,8(sp)
ffffffffc0203794:	0141                	addi	sp,sp,16
ffffffffc0203796:	8082                	ret

ffffffffc0203798 <find_vma>:
    if (mm != NULL)
ffffffffc0203798:	c505                	beqz	a0,ffffffffc02037c0 <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc020379a:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020379c:	c781                	beqz	a5,ffffffffc02037a4 <find_vma+0xc>
ffffffffc020379e:	6798                	ld	a4,8(a5)
ffffffffc02037a0:	02e5f363          	bgeu	a1,a4,ffffffffc02037c6 <find_vma+0x2e>
    return listelm->next;
ffffffffc02037a4:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc02037a6:	00f50d63          	beq	a0,a5,ffffffffc02037c0 <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02037aa:	fe87b703          	ld	a4,-24(a5)
ffffffffc02037ae:	00e5e663          	bltu	a1,a4,ffffffffc02037ba <find_vma+0x22>
ffffffffc02037b2:	ff07b703          	ld	a4,-16(a5)
ffffffffc02037b6:	00e5ee63          	bltu	a1,a4,ffffffffc02037d2 <find_vma+0x3a>
ffffffffc02037ba:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc02037bc:	fef517e3          	bne	a0,a5,ffffffffc02037aa <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc02037c0:	4781                	li	a5,0
}
ffffffffc02037c2:	853e                	mv	a0,a5
ffffffffc02037c4:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02037c6:	6b98                	ld	a4,16(a5)
ffffffffc02037c8:	fce5fee3          	bgeu	a1,a4,ffffffffc02037a4 <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc02037cc:	e91c                	sd	a5,16(a0)
}
ffffffffc02037ce:	853e                	mv	a0,a5
ffffffffc02037d0:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc02037d2:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc02037d4:	e91c                	sd	a5,16(a0)
ffffffffc02037d6:	bfe5                	j	ffffffffc02037ce <find_vma+0x36>

ffffffffc02037d8 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037d8:	6590                	ld	a2,8(a1)
ffffffffc02037da:	0105b803          	ld	a6,16(a1)
{
ffffffffc02037de:	1141                	addi	sp,sp,-16
ffffffffc02037e0:	e406                	sd	ra,8(sp)
ffffffffc02037e2:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037e4:	01066763          	bltu	a2,a6,ffffffffc02037f2 <insert_vma_struct+0x1a>
ffffffffc02037e8:	a8b9                	j	ffffffffc0203846 <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc02037ea:	fe87b703          	ld	a4,-24(a5)
ffffffffc02037ee:	04e66763          	bltu	a2,a4,ffffffffc020383c <insert_vma_struct+0x64>
ffffffffc02037f2:	86be                	mv	a3,a5
ffffffffc02037f4:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc02037f6:	fef51ae3          	bne	a0,a5,ffffffffc02037ea <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc02037fa:	02a68463          	beq	a3,a0,ffffffffc0203822 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc02037fe:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203802:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203806:	08e8f063          	bgeu	a7,a4,ffffffffc0203886 <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020380a:	04e66e63          	bltu	a2,a4,ffffffffc0203866 <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc020380e:	00f50a63          	beq	a0,a5,ffffffffc0203822 <insert_vma_struct+0x4a>
ffffffffc0203812:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203816:	05076863          	bltu	a4,a6,ffffffffc0203866 <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc020381a:	ff07b603          	ld	a2,-16(a5)
ffffffffc020381e:	02c77263          	bgeu	a4,a2,ffffffffc0203842 <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203822:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203824:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203826:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc020382a:	e390                	sd	a2,0(a5)
ffffffffc020382c:	e690                	sd	a2,8(a3)
}
ffffffffc020382e:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203830:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203832:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203834:	2705                	addiw	a4,a4,1
ffffffffc0203836:	d118                	sw	a4,32(a0)
}
ffffffffc0203838:	0141                	addi	sp,sp,16
ffffffffc020383a:	8082                	ret
    if (le_prev != list)
ffffffffc020383c:	fca691e3          	bne	a3,a0,ffffffffc02037fe <insert_vma_struct+0x26>
ffffffffc0203840:	bfd9                	j	ffffffffc0203816 <insert_vma_struct+0x3e>
ffffffffc0203842:	f03ff0ef          	jal	ffffffffc0203744 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203846:	00003697          	auipc	a3,0x3
ffffffffc020384a:	50268693          	addi	a3,a3,1282 # ffffffffc0206d48 <etext+0x1512>
ffffffffc020384e:	00003617          	auipc	a2,0x3
ffffffffc0203852:	9ca60613          	addi	a2,a2,-1590 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203856:	07a00593          	li	a1,122
ffffffffc020385a:	00003517          	auipc	a0,0x3
ffffffffc020385e:	4de50513          	addi	a0,a0,1246 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203862:	be5fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203866:	00003697          	auipc	a3,0x3
ffffffffc020386a:	52268693          	addi	a3,a3,1314 # ffffffffc0206d88 <etext+0x1552>
ffffffffc020386e:	00003617          	auipc	a2,0x3
ffffffffc0203872:	9aa60613          	addi	a2,a2,-1622 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203876:	07300593          	li	a1,115
ffffffffc020387a:	00003517          	auipc	a0,0x3
ffffffffc020387e:	4be50513          	addi	a0,a0,1214 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203882:	bc5fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203886:	00003697          	auipc	a3,0x3
ffffffffc020388a:	4e268693          	addi	a3,a3,1250 # ffffffffc0206d68 <etext+0x1532>
ffffffffc020388e:	00003617          	auipc	a2,0x3
ffffffffc0203892:	98a60613          	addi	a2,a2,-1654 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203896:	07200593          	li	a1,114
ffffffffc020389a:	00003517          	auipc	a0,0x3
ffffffffc020389e:	49e50513          	addi	a0,a0,1182 # ffffffffc0206d38 <etext+0x1502>
ffffffffc02038a2:	ba5fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02038a6 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc02038a6:	591c                	lw	a5,48(a0)
{
ffffffffc02038a8:	1141                	addi	sp,sp,-16
ffffffffc02038aa:	e406                	sd	ra,8(sp)
ffffffffc02038ac:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02038ae:	e78d                	bnez	a5,ffffffffc02038d8 <mm_destroy+0x32>
ffffffffc02038b0:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02038b2:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc02038b4:	00a40c63          	beq	s0,a0,ffffffffc02038cc <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02038b8:	6118                	ld	a4,0(a0)
ffffffffc02038ba:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc02038bc:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02038be:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02038c0:	e398                	sd	a4,0(a5)
ffffffffc02038c2:	d28fe0ef          	jal	ffffffffc0201dea <kfree>
    return listelm->next;
ffffffffc02038c6:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc02038c8:	fea418e3          	bne	s0,a0,ffffffffc02038b8 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc02038cc:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc02038ce:	6402                	ld	s0,0(sp)
ffffffffc02038d0:	60a2                	ld	ra,8(sp)
ffffffffc02038d2:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc02038d4:	d16fe06f          	j	ffffffffc0201dea <kfree>
    assert(mm_count(mm) == 0);
ffffffffc02038d8:	00003697          	auipc	a3,0x3
ffffffffc02038dc:	4d068693          	addi	a3,a3,1232 # ffffffffc0206da8 <etext+0x1572>
ffffffffc02038e0:	00003617          	auipc	a2,0x3
ffffffffc02038e4:	93860613          	addi	a2,a2,-1736 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02038e8:	09e00593          	li	a1,158
ffffffffc02038ec:	00003517          	auipc	a0,0x3
ffffffffc02038f0:	44c50513          	addi	a0,a0,1100 # ffffffffc0206d38 <etext+0x1502>
ffffffffc02038f4:	b53fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02038f8 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02038f8:	6785                	lui	a5,0x1
ffffffffc02038fa:	17fd                	addi	a5,a5,-1 # fff <_binary_obj___user_softint_out_size-0x7bc9>
ffffffffc02038fc:	963e                	add	a2,a2,a5
    if (!USER_ACCESS(start, end))
ffffffffc02038fe:	4785                	li	a5,1
{
ffffffffc0203900:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203902:	962e                	add	a2,a2,a1
ffffffffc0203904:	787d                	lui	a6,0xfffff
    if (!USER_ACCESS(start, end))
ffffffffc0203906:	07fe                	slli	a5,a5,0x1f
{
ffffffffc0203908:	f822                	sd	s0,48(sp)
ffffffffc020390a:	f426                	sd	s1,40(sp)
ffffffffc020390c:	01067433          	and	s0,a2,a6
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203910:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end))
ffffffffc0203914:	0785                	addi	a5,a5,1
ffffffffc0203916:	0084b633          	sltu	a2,s1,s0
ffffffffc020391a:	00f437b3          	sltu	a5,s0,a5
ffffffffc020391e:	00163613          	seqz	a2,a2
ffffffffc0203922:	0017b793          	seqz	a5,a5
{
ffffffffc0203926:	fc06                	sd	ra,56(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203928:	8fd1                	or	a5,a5,a2
ffffffffc020392a:	ebbd                	bnez	a5,ffffffffc02039a0 <mm_map+0xa8>
ffffffffc020392c:	002007b7          	lui	a5,0x200
ffffffffc0203930:	06f4e863          	bltu	s1,a5,ffffffffc02039a0 <mm_map+0xa8>
ffffffffc0203934:	f04a                	sd	s2,32(sp)
ffffffffc0203936:	ec4e                	sd	s3,24(sp)
ffffffffc0203938:	e852                	sd	s4,16(sp)
ffffffffc020393a:	892a                	mv	s2,a0
ffffffffc020393c:	89ba                	mv	s3,a4
ffffffffc020393e:	8a36                	mv	s4,a3
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203940:	c135                	beqz	a0,ffffffffc02039a4 <mm_map+0xac>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203942:	85a6                	mv	a1,s1
ffffffffc0203944:	e55ff0ef          	jal	ffffffffc0203798 <find_vma>
ffffffffc0203948:	c501                	beqz	a0,ffffffffc0203950 <mm_map+0x58>
ffffffffc020394a:	651c                	ld	a5,8(a0)
ffffffffc020394c:	0487e763          	bltu	a5,s0,ffffffffc020399a <mm_map+0xa2>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203950:	03000513          	li	a0,48
ffffffffc0203954:	bf0fe0ef          	jal	ffffffffc0201d44 <kmalloc>
ffffffffc0203958:	85aa                	mv	a1,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc020395a:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc020395c:	c59d                	beqz	a1,ffffffffc020398a <mm_map+0x92>
        vma->vm_start = vm_start;
ffffffffc020395e:	e584                	sd	s1,8(a1)
        vma->vm_end = vm_end;
ffffffffc0203960:	e980                	sd	s0,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203962:	0145ac23          	sw	s4,24(a1)

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203966:	854a                	mv	a0,s2
ffffffffc0203968:	e42e                	sd	a1,8(sp)
ffffffffc020396a:	e6fff0ef          	jal	ffffffffc02037d8 <insert_vma_struct>
    if (vma_store != NULL)
ffffffffc020396e:	65a2                	ld	a1,8(sp)
ffffffffc0203970:	00098463          	beqz	s3,ffffffffc0203978 <mm_map+0x80>
    {
        *vma_store = vma;
ffffffffc0203974:	00b9b023          	sd	a1,0(s3)
ffffffffc0203978:	7902                	ld	s2,32(sp)
ffffffffc020397a:	69e2                	ld	s3,24(sp)
ffffffffc020397c:	6a42                	ld	s4,16(sp)
    }
    ret = 0;
ffffffffc020397e:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc0203980:	70e2                	ld	ra,56(sp)
ffffffffc0203982:	7442                	ld	s0,48(sp)
ffffffffc0203984:	74a2                	ld	s1,40(sp)
ffffffffc0203986:	6121                	addi	sp,sp,64
ffffffffc0203988:	8082                	ret
ffffffffc020398a:	70e2                	ld	ra,56(sp)
ffffffffc020398c:	7442                	ld	s0,48(sp)
ffffffffc020398e:	7902                	ld	s2,32(sp)
ffffffffc0203990:	69e2                	ld	s3,24(sp)
ffffffffc0203992:	6a42                	ld	s4,16(sp)
ffffffffc0203994:	74a2                	ld	s1,40(sp)
ffffffffc0203996:	6121                	addi	sp,sp,64
ffffffffc0203998:	8082                	ret
ffffffffc020399a:	7902                	ld	s2,32(sp)
ffffffffc020399c:	69e2                	ld	s3,24(sp)
ffffffffc020399e:	6a42                	ld	s4,16(sp)
        return -E_INVAL;
ffffffffc02039a0:	5575                	li	a0,-3
ffffffffc02039a2:	bff9                	j	ffffffffc0203980 <mm_map+0x88>
    assert(mm != NULL);
ffffffffc02039a4:	00003697          	auipc	a3,0x3
ffffffffc02039a8:	41c68693          	addi	a3,a3,1052 # ffffffffc0206dc0 <etext+0x158a>
ffffffffc02039ac:	00003617          	auipc	a2,0x3
ffffffffc02039b0:	86c60613          	addi	a2,a2,-1940 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02039b4:	0b300593          	li	a1,179
ffffffffc02039b8:	00003517          	auipc	a0,0x3
ffffffffc02039bc:	38050513          	addi	a0,a0,896 # ffffffffc0206d38 <etext+0x1502>
ffffffffc02039c0:	a87fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02039c4 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc02039c4:	7139                	addi	sp,sp,-64
ffffffffc02039c6:	fc06                	sd	ra,56(sp)
ffffffffc02039c8:	f822                	sd	s0,48(sp)
ffffffffc02039ca:	f426                	sd	s1,40(sp)
ffffffffc02039cc:	f04a                	sd	s2,32(sp)
ffffffffc02039ce:	ec4e                	sd	s3,24(sp)
ffffffffc02039d0:	e852                	sd	s4,16(sp)
ffffffffc02039d2:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc02039d4:	c525                	beqz	a0,ffffffffc0203a3c <dup_mmap+0x78>
ffffffffc02039d6:	892a                	mv	s2,a0
ffffffffc02039d8:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc02039da:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc02039dc:	c1a5                	beqz	a1,ffffffffc0203a3c <dup_mmap+0x78>
    return listelm->prev;
ffffffffc02039de:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc02039e0:	04848c63          	beq	s1,s0,ffffffffc0203a38 <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02039e4:	03000513          	li	a0,48
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc02039e8:	fe843a83          	ld	s5,-24(s0)
ffffffffc02039ec:	ff043a03          	ld	s4,-16(s0)
ffffffffc02039f0:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02039f4:	b50fe0ef          	jal	ffffffffc0201d44 <kmalloc>
    if (vma != NULL)
ffffffffc02039f8:	c515                	beqz	a0,ffffffffc0203a24 <dup_mmap+0x60>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc02039fa:	85aa                	mv	a1,a0
        vma->vm_start = vm_start;
ffffffffc02039fc:	01553423          	sd	s5,8(a0)
ffffffffc0203a00:	01453823          	sd	s4,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a04:	01352c23          	sw	s3,24(a0)
        insert_vma_struct(to, nvma);
ffffffffc0203a08:	854a                	mv	a0,s2
ffffffffc0203a0a:	dcfff0ef          	jal	ffffffffc02037d8 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203a0e:	ff043683          	ld	a3,-16(s0)
ffffffffc0203a12:	fe843603          	ld	a2,-24(s0)
ffffffffc0203a16:	6c8c                	ld	a1,24(s1)
ffffffffc0203a18:	01893503          	ld	a0,24(s2)
ffffffffc0203a1c:	4701                	li	a4,0
ffffffffc0203a1e:	a07ff0ef          	jal	ffffffffc0203424 <copy_range>
ffffffffc0203a22:	dd55                	beqz	a0,ffffffffc02039de <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc0203a24:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203a26:	70e2                	ld	ra,56(sp)
ffffffffc0203a28:	7442                	ld	s0,48(sp)
ffffffffc0203a2a:	74a2                	ld	s1,40(sp)
ffffffffc0203a2c:	7902                	ld	s2,32(sp)
ffffffffc0203a2e:	69e2                	ld	s3,24(sp)
ffffffffc0203a30:	6a42                	ld	s4,16(sp)
ffffffffc0203a32:	6aa2                	ld	s5,8(sp)
ffffffffc0203a34:	6121                	addi	sp,sp,64
ffffffffc0203a36:	8082                	ret
    return 0;
ffffffffc0203a38:	4501                	li	a0,0
ffffffffc0203a3a:	b7f5                	j	ffffffffc0203a26 <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc0203a3c:	00003697          	auipc	a3,0x3
ffffffffc0203a40:	39468693          	addi	a3,a3,916 # ffffffffc0206dd0 <etext+0x159a>
ffffffffc0203a44:	00002617          	auipc	a2,0x2
ffffffffc0203a48:	7d460613          	addi	a2,a2,2004 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203a4c:	0cf00593          	li	a1,207
ffffffffc0203a50:	00003517          	auipc	a0,0x3
ffffffffc0203a54:	2e850513          	addi	a0,a0,744 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203a58:	9effc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203a5c <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203a5c:	1101                	addi	sp,sp,-32
ffffffffc0203a5e:	ec06                	sd	ra,24(sp)
ffffffffc0203a60:	e822                	sd	s0,16(sp)
ffffffffc0203a62:	e426                	sd	s1,8(sp)
ffffffffc0203a64:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203a66:	c531                	beqz	a0,ffffffffc0203ab2 <exit_mmap+0x56>
ffffffffc0203a68:	591c                	lw	a5,48(a0)
ffffffffc0203a6a:	84aa                	mv	s1,a0
ffffffffc0203a6c:	e3b9                	bnez	a5,ffffffffc0203ab2 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203a6e:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203a70:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203a74:	02850663          	beq	a0,s0,ffffffffc0203aa0 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203a78:	ff043603          	ld	a2,-16(s0)
ffffffffc0203a7c:	fe843583          	ld	a1,-24(s0)
ffffffffc0203a80:	854a                	mv	a0,s2
ffffffffc0203a82:	fdefe0ef          	jal	ffffffffc0202260 <unmap_range>
ffffffffc0203a86:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203a88:	fe8498e3          	bne	s1,s0,ffffffffc0203a78 <exit_mmap+0x1c>
ffffffffc0203a8c:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203a8e:	00848c63          	beq	s1,s0,ffffffffc0203aa6 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203a92:	ff043603          	ld	a2,-16(s0)
ffffffffc0203a96:	fe843583          	ld	a1,-24(s0)
ffffffffc0203a9a:	854a                	mv	a0,s2
ffffffffc0203a9c:	8f9fe0ef          	jal	ffffffffc0202394 <exit_range>
ffffffffc0203aa0:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203aa2:	fe8498e3          	bne	s1,s0,ffffffffc0203a92 <exit_mmap+0x36>
    }
}
ffffffffc0203aa6:	60e2                	ld	ra,24(sp)
ffffffffc0203aa8:	6442                	ld	s0,16(sp)
ffffffffc0203aaa:	64a2                	ld	s1,8(sp)
ffffffffc0203aac:	6902                	ld	s2,0(sp)
ffffffffc0203aae:	6105                	addi	sp,sp,32
ffffffffc0203ab0:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203ab2:	00003697          	auipc	a3,0x3
ffffffffc0203ab6:	33e68693          	addi	a3,a3,830 # ffffffffc0206df0 <etext+0x15ba>
ffffffffc0203aba:	00002617          	auipc	a2,0x2
ffffffffc0203abe:	75e60613          	addi	a2,a2,1886 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203ac2:	0e800593          	li	a1,232
ffffffffc0203ac6:	00003517          	auipc	a0,0x3
ffffffffc0203aca:	27250513          	addi	a0,a0,626 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203ace:	979fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203ad2 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203ad2:	7179                	addi	sp,sp,-48
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203ad4:	04000513          	li	a0,64
{
ffffffffc0203ad8:	f406                	sd	ra,40(sp)
ffffffffc0203ada:	f022                	sd	s0,32(sp)
ffffffffc0203adc:	ec26                	sd	s1,24(sp)
ffffffffc0203ade:	e84a                	sd	s2,16(sp)
ffffffffc0203ae0:	e44e                	sd	s3,8(sp)
ffffffffc0203ae2:	e052                	sd	s4,0(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203ae4:	a60fe0ef          	jal	ffffffffc0201d44 <kmalloc>
    if (mm != NULL)
ffffffffc0203ae8:	16050c63          	beqz	a0,ffffffffc0203c60 <vmm_init+0x18e>
ffffffffc0203aec:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0203aee:	e508                	sd	a0,8(a0)
ffffffffc0203af0:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203af2:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203af6:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203afa:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203afe:	02053423          	sd	zero,40(a0)
ffffffffc0203b02:	02052823          	sw	zero,48(a0)
ffffffffc0203b06:	02053c23          	sd	zero,56(a0)
ffffffffc0203b0a:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b0e:	03000513          	li	a0,48
ffffffffc0203b12:	a32fe0ef          	jal	ffffffffc0201d44 <kmalloc>
    if (vma != NULL)
ffffffffc0203b16:	12050563          	beqz	a0,ffffffffc0203c40 <vmm_init+0x16e>
        vma->vm_end = vm_end;
ffffffffc0203b1a:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203b1e:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203b20:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203b24:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203b26:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc0203b28:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc0203b2a:	8522                	mv	a0,s0
ffffffffc0203b2c:	cadff0ef          	jal	ffffffffc02037d8 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203b30:	fcf9                	bnez	s1,ffffffffc0203b0e <vmm_init+0x3c>
ffffffffc0203b32:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b36:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b3a:	03000513          	li	a0,48
ffffffffc0203b3e:	a06fe0ef          	jal	ffffffffc0201d44 <kmalloc>
    if (vma != NULL)
ffffffffc0203b42:	12050f63          	beqz	a0,ffffffffc0203c80 <vmm_init+0x1ae>
        vma->vm_end = vm_end;
ffffffffc0203b46:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203b4a:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203b4c:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203b50:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203b52:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b54:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0203b56:	8522                	mv	a0,s0
ffffffffc0203b58:	c81ff0ef          	jal	ffffffffc02037d8 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b5c:	fd249fe3          	bne	s1,s2,ffffffffc0203b3a <vmm_init+0x68>
    return listelm->next;
ffffffffc0203b60:	641c                	ld	a5,8(s0)
ffffffffc0203b62:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203b64:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203b68:	1ef40c63          	beq	s0,a5,ffffffffc0203d60 <vmm_init+0x28e>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b6c:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f5e30>
ffffffffc0203b70:	ffe70693          	addi	a3,a4,-2
ffffffffc0203b74:	12d61663          	bne	a2,a3,ffffffffc0203ca0 <vmm_init+0x1ce>
ffffffffc0203b78:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203b7c:	12e69263          	bne	a3,a4,ffffffffc0203ca0 <vmm_init+0x1ce>
    for (i = 1; i <= step2; i++)
ffffffffc0203b80:	0715                	addi	a4,a4,5
ffffffffc0203b82:	679c                	ld	a5,8(a5)
ffffffffc0203b84:	feb712e3          	bne	a4,a1,ffffffffc0203b68 <vmm_init+0x96>
ffffffffc0203b88:	491d                	li	s2,7
ffffffffc0203b8a:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203b8c:	85a6                	mv	a1,s1
ffffffffc0203b8e:	8522                	mv	a0,s0
ffffffffc0203b90:	c09ff0ef          	jal	ffffffffc0203798 <find_vma>
ffffffffc0203b94:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc0203b96:	20050563          	beqz	a0,ffffffffc0203da0 <vmm_init+0x2ce>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203b9a:	00148593          	addi	a1,s1,1
ffffffffc0203b9e:	8522                	mv	a0,s0
ffffffffc0203ba0:	bf9ff0ef          	jal	ffffffffc0203798 <find_vma>
ffffffffc0203ba4:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203ba6:	1c050d63          	beqz	a0,ffffffffc0203d80 <vmm_init+0x2ae>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203baa:	85ca                	mv	a1,s2
ffffffffc0203bac:	8522                	mv	a0,s0
ffffffffc0203bae:	bebff0ef          	jal	ffffffffc0203798 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203bb2:	18051763          	bnez	a0,ffffffffc0203d40 <vmm_init+0x26e>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203bb6:	00348593          	addi	a1,s1,3
ffffffffc0203bba:	8522                	mv	a0,s0
ffffffffc0203bbc:	bddff0ef          	jal	ffffffffc0203798 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203bc0:	16051063          	bnez	a0,ffffffffc0203d20 <vmm_init+0x24e>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203bc4:	00448593          	addi	a1,s1,4
ffffffffc0203bc8:	8522                	mv	a0,s0
ffffffffc0203bca:	bcfff0ef          	jal	ffffffffc0203798 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203bce:	12051963          	bnez	a0,ffffffffc0203d00 <vmm_init+0x22e>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203bd2:	008a3783          	ld	a5,8(s4)
ffffffffc0203bd6:	10979563          	bne	a5,s1,ffffffffc0203ce0 <vmm_init+0x20e>
ffffffffc0203bda:	010a3783          	ld	a5,16(s4)
ffffffffc0203bde:	11279163          	bne	a5,s2,ffffffffc0203ce0 <vmm_init+0x20e>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203be2:	0089b783          	ld	a5,8(s3)
ffffffffc0203be6:	0c979d63          	bne	a5,s1,ffffffffc0203cc0 <vmm_init+0x1ee>
ffffffffc0203bea:	0109b783          	ld	a5,16(s3)
ffffffffc0203bee:	0d279963          	bne	a5,s2,ffffffffc0203cc0 <vmm_init+0x1ee>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203bf2:	0495                	addi	s1,s1,5
ffffffffc0203bf4:	1f900793          	li	a5,505
ffffffffc0203bf8:	0915                	addi	s2,s2,5
ffffffffc0203bfa:	f8f499e3          	bne	s1,a5,ffffffffc0203b8c <vmm_init+0xba>
ffffffffc0203bfe:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203c00:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203c02:	85a6                	mv	a1,s1
ffffffffc0203c04:	8522                	mv	a0,s0
ffffffffc0203c06:	b93ff0ef          	jal	ffffffffc0203798 <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203c0a:	1a051b63          	bnez	a0,ffffffffc0203dc0 <vmm_init+0x2ee>
    for (i = 4; i >= 0; i--)
ffffffffc0203c0e:	14fd                	addi	s1,s1,-1
ffffffffc0203c10:	ff2499e3          	bne	s1,s2,ffffffffc0203c02 <vmm_init+0x130>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
ffffffffc0203c14:	8522                	mv	a0,s0
ffffffffc0203c16:	c91ff0ef          	jal	ffffffffc02038a6 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203c1a:	00003517          	auipc	a0,0x3
ffffffffc0203c1e:	34650513          	addi	a0,a0,838 # ffffffffc0206f60 <etext+0x172a>
ffffffffc0203c22:	d72fc0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0203c26:	7402                	ld	s0,32(sp)
ffffffffc0203c28:	70a2                	ld	ra,40(sp)
ffffffffc0203c2a:	64e2                	ld	s1,24(sp)
ffffffffc0203c2c:	6942                	ld	s2,16(sp)
ffffffffc0203c2e:	69a2                	ld	s3,8(sp)
ffffffffc0203c30:	6a02                	ld	s4,0(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203c32:	00003517          	auipc	a0,0x3
ffffffffc0203c36:	34e50513          	addi	a0,a0,846 # ffffffffc0206f80 <etext+0x174a>
}
ffffffffc0203c3a:	6145                	addi	sp,sp,48
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203c3c:	d58fc06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc0203c40:	00003697          	auipc	a3,0x3
ffffffffc0203c44:	1d068693          	addi	a3,a3,464 # ffffffffc0206e10 <etext+0x15da>
ffffffffc0203c48:	00002617          	auipc	a2,0x2
ffffffffc0203c4c:	5d060613          	addi	a2,a2,1488 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203c50:	12c00593          	li	a1,300
ffffffffc0203c54:	00003517          	auipc	a0,0x3
ffffffffc0203c58:	0e450513          	addi	a0,a0,228 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203c5c:	feafc0ef          	jal	ffffffffc0200446 <__panic>
    assert(mm != NULL);
ffffffffc0203c60:	00003697          	auipc	a3,0x3
ffffffffc0203c64:	16068693          	addi	a3,a3,352 # ffffffffc0206dc0 <etext+0x158a>
ffffffffc0203c68:	00002617          	auipc	a2,0x2
ffffffffc0203c6c:	5b060613          	addi	a2,a2,1456 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203c70:	12400593          	li	a1,292
ffffffffc0203c74:	00003517          	auipc	a0,0x3
ffffffffc0203c78:	0c450513          	addi	a0,a0,196 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203c7c:	fcafc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma != NULL);
ffffffffc0203c80:	00003697          	auipc	a3,0x3
ffffffffc0203c84:	19068693          	addi	a3,a3,400 # ffffffffc0206e10 <etext+0x15da>
ffffffffc0203c88:	00002617          	auipc	a2,0x2
ffffffffc0203c8c:	59060613          	addi	a2,a2,1424 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203c90:	13300593          	li	a1,307
ffffffffc0203c94:	00003517          	auipc	a0,0x3
ffffffffc0203c98:	0a450513          	addi	a0,a0,164 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203c9c:	faafc0ef          	jal	ffffffffc0200446 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203ca0:	00003697          	auipc	a3,0x3
ffffffffc0203ca4:	19868693          	addi	a3,a3,408 # ffffffffc0206e38 <etext+0x1602>
ffffffffc0203ca8:	00002617          	auipc	a2,0x2
ffffffffc0203cac:	57060613          	addi	a2,a2,1392 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203cb0:	13d00593          	li	a1,317
ffffffffc0203cb4:	00003517          	auipc	a0,0x3
ffffffffc0203cb8:	08450513          	addi	a0,a0,132 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203cbc:	f8afc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203cc0:	00003697          	auipc	a3,0x3
ffffffffc0203cc4:	23068693          	addi	a3,a3,560 # ffffffffc0206ef0 <etext+0x16ba>
ffffffffc0203cc8:	00002617          	auipc	a2,0x2
ffffffffc0203ccc:	55060613          	addi	a2,a2,1360 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203cd0:	14f00593          	li	a1,335
ffffffffc0203cd4:	00003517          	auipc	a0,0x3
ffffffffc0203cd8:	06450513          	addi	a0,a0,100 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203cdc:	f6afc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203ce0:	00003697          	auipc	a3,0x3
ffffffffc0203ce4:	1e068693          	addi	a3,a3,480 # ffffffffc0206ec0 <etext+0x168a>
ffffffffc0203ce8:	00002617          	auipc	a2,0x2
ffffffffc0203cec:	53060613          	addi	a2,a2,1328 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203cf0:	14e00593          	li	a1,334
ffffffffc0203cf4:	00003517          	auipc	a0,0x3
ffffffffc0203cf8:	04450513          	addi	a0,a0,68 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203cfc:	f4afc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma5 == NULL);
ffffffffc0203d00:	00003697          	auipc	a3,0x3
ffffffffc0203d04:	1b068693          	addi	a3,a3,432 # ffffffffc0206eb0 <etext+0x167a>
ffffffffc0203d08:	00002617          	auipc	a2,0x2
ffffffffc0203d0c:	51060613          	addi	a2,a2,1296 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203d10:	14c00593          	li	a1,332
ffffffffc0203d14:	00003517          	auipc	a0,0x3
ffffffffc0203d18:	02450513          	addi	a0,a0,36 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203d1c:	f2afc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma4 == NULL);
ffffffffc0203d20:	00003697          	auipc	a3,0x3
ffffffffc0203d24:	18068693          	addi	a3,a3,384 # ffffffffc0206ea0 <etext+0x166a>
ffffffffc0203d28:	00002617          	auipc	a2,0x2
ffffffffc0203d2c:	4f060613          	addi	a2,a2,1264 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203d30:	14a00593          	li	a1,330
ffffffffc0203d34:	00003517          	auipc	a0,0x3
ffffffffc0203d38:	00450513          	addi	a0,a0,4 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203d3c:	f0afc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma3 == NULL);
ffffffffc0203d40:	00003697          	auipc	a3,0x3
ffffffffc0203d44:	15068693          	addi	a3,a3,336 # ffffffffc0206e90 <etext+0x165a>
ffffffffc0203d48:	00002617          	auipc	a2,0x2
ffffffffc0203d4c:	4d060613          	addi	a2,a2,1232 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203d50:	14800593          	li	a1,328
ffffffffc0203d54:	00003517          	auipc	a0,0x3
ffffffffc0203d58:	fe450513          	addi	a0,a0,-28 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203d5c:	eeafc0ef          	jal	ffffffffc0200446 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203d60:	00003697          	auipc	a3,0x3
ffffffffc0203d64:	0c068693          	addi	a3,a3,192 # ffffffffc0206e20 <etext+0x15ea>
ffffffffc0203d68:	00002617          	auipc	a2,0x2
ffffffffc0203d6c:	4b060613          	addi	a2,a2,1200 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203d70:	13b00593          	li	a1,315
ffffffffc0203d74:	00003517          	auipc	a0,0x3
ffffffffc0203d78:	fc450513          	addi	a0,a0,-60 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203d7c:	ecafc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2 != NULL);
ffffffffc0203d80:	00003697          	auipc	a3,0x3
ffffffffc0203d84:	10068693          	addi	a3,a3,256 # ffffffffc0206e80 <etext+0x164a>
ffffffffc0203d88:	00002617          	auipc	a2,0x2
ffffffffc0203d8c:	49060613          	addi	a2,a2,1168 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203d90:	14600593          	li	a1,326
ffffffffc0203d94:	00003517          	auipc	a0,0x3
ffffffffc0203d98:	fa450513          	addi	a0,a0,-92 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203d9c:	eaafc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1 != NULL);
ffffffffc0203da0:	00003697          	auipc	a3,0x3
ffffffffc0203da4:	0d068693          	addi	a3,a3,208 # ffffffffc0206e70 <etext+0x163a>
ffffffffc0203da8:	00002617          	auipc	a2,0x2
ffffffffc0203dac:	47060613          	addi	a2,a2,1136 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203db0:	14400593          	li	a1,324
ffffffffc0203db4:	00003517          	auipc	a0,0x3
ffffffffc0203db8:	f8450513          	addi	a0,a0,-124 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203dbc:	e8afc0ef          	jal	ffffffffc0200446 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203dc0:	6914                	ld	a3,16(a0)
ffffffffc0203dc2:	6510                	ld	a2,8(a0)
ffffffffc0203dc4:	0004859b          	sext.w	a1,s1
ffffffffc0203dc8:	00003517          	auipc	a0,0x3
ffffffffc0203dcc:	15850513          	addi	a0,a0,344 # ffffffffc0206f20 <etext+0x16ea>
ffffffffc0203dd0:	bc4fc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203dd4:	00003697          	auipc	a3,0x3
ffffffffc0203dd8:	17468693          	addi	a3,a3,372 # ffffffffc0206f48 <etext+0x1712>
ffffffffc0203ddc:	00002617          	auipc	a2,0x2
ffffffffc0203de0:	43c60613          	addi	a2,a2,1084 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0203de4:	15900593          	li	a1,345
ffffffffc0203de8:	00003517          	auipc	a0,0x3
ffffffffc0203dec:	f5050513          	addi	a0,a0,-176 # ffffffffc0206d38 <etext+0x1502>
ffffffffc0203df0:	e56fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203df4 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203df4:	7179                	addi	sp,sp,-48
ffffffffc0203df6:	f022                	sd	s0,32(sp)
ffffffffc0203df8:	f406                	sd	ra,40(sp)
ffffffffc0203dfa:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203dfc:	c52d                	beqz	a0,ffffffffc0203e66 <user_mem_check+0x72>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203dfe:	002007b7          	lui	a5,0x200
ffffffffc0203e02:	04f5ed63          	bltu	a1,a5,ffffffffc0203e5c <user_mem_check+0x68>
ffffffffc0203e06:	ec26                	sd	s1,24(sp)
ffffffffc0203e08:	00c584b3          	add	s1,a1,a2
ffffffffc0203e0c:	0695ff63          	bgeu	a1,s1,ffffffffc0203e8a <user_mem_check+0x96>
ffffffffc0203e10:	4785                	li	a5,1
ffffffffc0203e12:	07fe                	slli	a5,a5,0x1f
ffffffffc0203e14:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e49>
ffffffffc0203e16:	06f4fa63          	bgeu	s1,a5,ffffffffc0203e8a <user_mem_check+0x96>
ffffffffc0203e1a:	e84a                	sd	s2,16(sp)
ffffffffc0203e1c:	e44e                	sd	s3,8(sp)
ffffffffc0203e1e:	8936                	mv	s2,a3
ffffffffc0203e20:	89aa                	mv	s3,a0
ffffffffc0203e22:	a829                	j	ffffffffc0203e3c <user_mem_check+0x48>
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203e24:	6685                	lui	a3,0x1
ffffffffc0203e26:	9736                	add	a4,a4,a3
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e28:	0027f693          	andi	a3,a5,2
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203e2c:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e2e:	c685                	beqz	a3,ffffffffc0203e56 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203e30:	c399                	beqz	a5,ffffffffc0203e36 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203e32:	02e46263          	bltu	s0,a4,ffffffffc0203e56 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203e36:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203e38:	04947b63          	bgeu	s0,s1,ffffffffc0203e8e <user_mem_check+0x9a>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203e3c:	85a2                	mv	a1,s0
ffffffffc0203e3e:	854e                	mv	a0,s3
ffffffffc0203e40:	959ff0ef          	jal	ffffffffc0203798 <find_vma>
ffffffffc0203e44:	c909                	beqz	a0,ffffffffc0203e56 <user_mem_check+0x62>
ffffffffc0203e46:	6518                	ld	a4,8(a0)
ffffffffc0203e48:	00e46763          	bltu	s0,a4,ffffffffc0203e56 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e4c:	4d1c                	lw	a5,24(a0)
ffffffffc0203e4e:	fc091be3          	bnez	s2,ffffffffc0203e24 <user_mem_check+0x30>
ffffffffc0203e52:	8b85                	andi	a5,a5,1
ffffffffc0203e54:	f3ed                	bnez	a5,ffffffffc0203e36 <user_mem_check+0x42>
ffffffffc0203e56:	64e2                	ld	s1,24(sp)
ffffffffc0203e58:	6942                	ld	s2,16(sp)
ffffffffc0203e5a:	69a2                	ld	s3,8(sp)
            return 0;
ffffffffc0203e5c:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203e5e:	70a2                	ld	ra,40(sp)
ffffffffc0203e60:	7402                	ld	s0,32(sp)
ffffffffc0203e62:	6145                	addi	sp,sp,48
ffffffffc0203e64:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203e66:	c02007b7          	lui	a5,0xc0200
ffffffffc0203e6a:	fef5eae3          	bltu	a1,a5,ffffffffc0203e5e <user_mem_check+0x6a>
ffffffffc0203e6e:	c80007b7          	lui	a5,0xc8000
ffffffffc0203e72:	962e                	add	a2,a2,a1
ffffffffc0203e74:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d64989>
ffffffffc0203e76:	00c5b433          	sltu	s0,a1,a2
ffffffffc0203e7a:	00f63633          	sltu	a2,a2,a5
ffffffffc0203e7e:	70a2                	ld	ra,40(sp)
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203e80:	00867533          	and	a0,a2,s0
ffffffffc0203e84:	7402                	ld	s0,32(sp)
ffffffffc0203e86:	6145                	addi	sp,sp,48
ffffffffc0203e88:	8082                	ret
ffffffffc0203e8a:	64e2                	ld	s1,24(sp)
ffffffffc0203e8c:	bfc1                	j	ffffffffc0203e5c <user_mem_check+0x68>
ffffffffc0203e8e:	64e2                	ld	s1,24(sp)
ffffffffc0203e90:	6942                	ld	s2,16(sp)
ffffffffc0203e92:	69a2                	ld	s3,8(sp)
        return 1;
ffffffffc0203e94:	4505                	li	a0,1
ffffffffc0203e96:	b7e1                	j	ffffffffc0203e5e <user_mem_check+0x6a>

ffffffffc0203e98 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203e98:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203e9a:	9402                	jalr	s0

	jal do_exit
ffffffffc0203e9c:	632000ef          	jal	ffffffffc02044ce <do_exit>

ffffffffc0203ea0 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203ea0:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203ea2:	10800513          	li	a0,264
{
ffffffffc0203ea6:	e022                	sd	s0,0(sp)
ffffffffc0203ea8:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203eaa:	e9bfd0ef          	jal	ffffffffc0201d44 <kmalloc>
ffffffffc0203eae:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203eb0:	c525                	beqz	a0,ffffffffc0203f18 <alloc_proc+0x78>
    {
        proc->state = PROC_UNINIT;
ffffffffc0203eb2:	57fd                	li	a5,-1
ffffffffc0203eb4:	1782                	slli	a5,a5,0x20
ffffffffc0203eb6:	e11c                	sd	a5,0(a0)
        proc->pid = -1;
        proc->runs = 0;
ffffffffc0203eb8:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203ebc:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203ec0:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203ec4:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203ec8:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203ecc:	07000613          	li	a2,112
ffffffffc0203ed0:	4581                	li	a1,0
ffffffffc0203ed2:	03050513          	addi	a0,a0,48
ffffffffc0203ed6:	137010ef          	jal	ffffffffc020580c <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203eda:	00097797          	auipc	a5,0x97
ffffffffc0203ede:	7567b783          	ld	a5,1878(a5) # ffffffffc029b630 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc0203ee2:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203ee6:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203eea:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203eec:	0b440513          	addi	a0,s0,180
ffffffffc0203ef0:	4641                	li	a2,16
ffffffffc0203ef2:	4581                	li	a1,0
ffffffffc0203ef4:	119010ef          	jal	ffffffffc020580c <memset>
        list_init(&(proc->list_link));
ffffffffc0203ef8:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203efc:	0d840793          	addi	a5,s0,216
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->wait_state = 0;
ffffffffc0203f00:	0e042623          	sw	zero,236(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc0203f04:	10043023          	sd	zero,256(s0)
ffffffffc0203f08:	0e043c23          	sd	zero,248(s0)
ffffffffc0203f0c:	0e043823          	sd	zero,240(s0)
    elm->prev = elm->next = elm;
ffffffffc0203f10:	e878                	sd	a4,208(s0)
ffffffffc0203f12:	e478                	sd	a4,200(s0)
ffffffffc0203f14:	f07c                	sd	a5,224(s0)
ffffffffc0203f16:	ec7c                	sd	a5,216(s0)
    }
    return proc;
}
ffffffffc0203f18:	60a2                	ld	ra,8(sp)
ffffffffc0203f1a:	8522                	mv	a0,s0
ffffffffc0203f1c:	6402                	ld	s0,0(sp)
ffffffffc0203f1e:	0141                	addi	sp,sp,16
ffffffffc0203f20:	8082                	ret

ffffffffc0203f22 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203f22:	00097797          	auipc	a5,0x97
ffffffffc0203f26:	73e7b783          	ld	a5,1854(a5) # ffffffffc029b660 <current>
ffffffffc0203f2a:	73c8                	ld	a0,160(a5)
ffffffffc0203f2c:	ffffc06f          	j	ffffffffc0200f2a <forkrets>

ffffffffc0203f30 <user_main>:
static int
user_main(void *arg)
{
#ifdef TEST
    // 测试模式：执行通过TEST、TESTSTART、TESTSIZE指定的程序
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203f30:	00097797          	auipc	a5,0x97
ffffffffc0203f34:	7307b783          	ld	a5,1840(a5) # ffffffffc029b660 <current>
{
ffffffffc0203f38:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203f3a:	00003617          	auipc	a2,0x3
ffffffffc0203f3e:	05e60613          	addi	a2,a2,94 # ffffffffc0206f98 <etext+0x1762>
ffffffffc0203f42:	43cc                	lw	a1,4(a5)
ffffffffc0203f44:	00003517          	auipc	a0,0x3
ffffffffc0203f48:	05c50513          	addi	a0,a0,92 # ffffffffc0206fa0 <etext+0x176a>
{
ffffffffc0203f4c:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203f4e:	a46fc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0203f52:	3fe06797          	auipc	a5,0x3fe06
ffffffffc0203f56:	91e78793          	addi	a5,a5,-1762 # 9870 <_binary_obj___user_testbss_out_size>
ffffffffc0203f5a:	e43e                	sd	a5,8(sp)
kernel_execve(const char *name, unsigned char *binary, size_t size)
ffffffffc0203f5c:	00003517          	auipc	a0,0x3
ffffffffc0203f60:	03c50513          	addi	a0,a0,60 # ffffffffc0206f98 <etext+0x1762>
ffffffffc0203f64:	00077797          	auipc	a5,0x77
ffffffffc0203f68:	9ac78793          	addi	a5,a5,-1620 # ffffffffc027a910 <_binary_obj___user_testbss_out_start>
ffffffffc0203f6c:	f03e                	sd	a5,32(sp)
ffffffffc0203f6e:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203f70:	e802                	sd	zero,16(sp)
ffffffffc0203f72:	7e6010ef          	jal	ffffffffc0205758 <strlen>
ffffffffc0203f76:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203f78:	4511                	li	a0,4
ffffffffc0203f7a:	55a2                	lw	a1,40(sp)
ffffffffc0203f7c:	4662                	lw	a2,24(sp)
ffffffffc0203f7e:	5682                	lw	a3,32(sp)
ffffffffc0203f80:	4722                	lw	a4,8(sp)
ffffffffc0203f82:	48a9                	li	a7,10
ffffffffc0203f84:	9002                	ebreak
ffffffffc0203f86:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203f88:	65c2                	ld	a1,16(sp)
ffffffffc0203f8a:	00003517          	auipc	a0,0x3
ffffffffc0203f8e:	03e50513          	addi	a0,a0,62 # ffffffffc0206fc8 <etext+0x1792>
ffffffffc0203f92:	a02fc0ef          	jal	ffffffffc0200194 <cprintf>
#else
    // 默认模式：执行exit用户程序
    KERNEL_EXECVE(exit);
#endif
    // 如果execve返回，说明执行失败
    panic("user_main execve failed.\n");
ffffffffc0203f96:	00003617          	auipc	a2,0x3
ffffffffc0203f9a:	04260613          	addi	a2,a2,66 # ffffffffc0206fd8 <etext+0x17a2>
ffffffffc0203f9e:	3de00593          	li	a1,990
ffffffffc0203fa2:	00003517          	auipc	a0,0x3
ffffffffc0203fa6:	05650513          	addi	a0,a0,86 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0203faa:	c9cfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203fae <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203fae:	6d14                	ld	a3,24(a0)
{
ffffffffc0203fb0:	1141                	addi	sp,sp,-16
ffffffffc0203fb2:	e406                	sd	ra,8(sp)
ffffffffc0203fb4:	c02007b7          	lui	a5,0xc0200
ffffffffc0203fb8:	02f6ee63          	bltu	a3,a5,ffffffffc0203ff4 <put_pgdir+0x46>
ffffffffc0203fbc:	00097717          	auipc	a4,0x97
ffffffffc0203fc0:	68473703          	ld	a4,1668(a4) # ffffffffc029b640 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0203fc4:	00097797          	auipc	a5,0x97
ffffffffc0203fc8:	6847b783          	ld	a5,1668(a5) # ffffffffc029b648 <npage>
    return pa2page(PADDR(kva));
ffffffffc0203fcc:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc0203fce:	82b1                	srli	a3,a3,0xc
ffffffffc0203fd0:	02f6fe63          	bgeu	a3,a5,ffffffffc020400c <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203fd4:	00004797          	auipc	a5,0x4
ffffffffc0203fd8:	9cc7b783          	ld	a5,-1588(a5) # ffffffffc02079a0 <nbase>
ffffffffc0203fdc:	00097517          	auipc	a0,0x97
ffffffffc0203fe0:	67453503          	ld	a0,1652(a0) # ffffffffc029b650 <pages>
}
ffffffffc0203fe4:	60a2                	ld	ra,8(sp)
ffffffffc0203fe6:	8e9d                	sub	a3,a3,a5
ffffffffc0203fe8:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203fea:	4585                	li	a1,1
ffffffffc0203fec:	9536                	add	a0,a0,a3
}
ffffffffc0203fee:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203ff0:	f51fd06f          	j	ffffffffc0201f40 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203ff4:	00002617          	auipc	a2,0x2
ffffffffc0203ff8:	67c60613          	addi	a2,a2,1660 # ffffffffc0206670 <etext+0xe3a>
ffffffffc0203ffc:	07700593          	li	a1,119
ffffffffc0204000:	00002517          	auipc	a0,0x2
ffffffffc0204004:	5f050513          	addi	a0,a0,1520 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0204008:	c3efc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020400c:	00002617          	auipc	a2,0x2
ffffffffc0204010:	68c60613          	addi	a2,a2,1676 # ffffffffc0206698 <etext+0xe62>
ffffffffc0204014:	06900593          	li	a1,105
ffffffffc0204018:	00002517          	auipc	a0,0x2
ffffffffc020401c:	5d850513          	addi	a0,a0,1496 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0204020:	c26fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204024 <proc_run>:
    if (proc != current)
ffffffffc0204024:	00097697          	auipc	a3,0x97
ffffffffc0204028:	63c6b683          	ld	a3,1596(a3) # ffffffffc029b660 <current>
ffffffffc020402c:	04a68463          	beq	a3,a0,ffffffffc0204074 <proc_run+0x50>
{
ffffffffc0204030:	1101                	addi	sp,sp,-32
ffffffffc0204032:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204034:	100027f3          	csrr	a5,sstatus
ffffffffc0204038:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020403a:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020403c:	ef8d                	bnez	a5,ffffffffc0204076 <proc_run+0x52>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc020403e:	755c                	ld	a5,168(a0)
ffffffffc0204040:	577d                	li	a4,-1
ffffffffc0204042:	177e                	slli	a4,a4,0x3f
ffffffffc0204044:	83b1                	srli	a5,a5,0xc
ffffffffc0204046:	e032                	sd	a2,0(sp)
        current = proc;
ffffffffc0204048:	00097597          	auipc	a1,0x97
ffffffffc020404c:	60a5bc23          	sd	a0,1560(a1) # ffffffffc029b660 <current>
ffffffffc0204050:	8fd9                	or	a5,a5,a4
ffffffffc0204052:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(proc->context));
ffffffffc0204056:	03050593          	addi	a1,a0,48
ffffffffc020405a:	03068513          	addi	a0,a3,48
ffffffffc020405e:	0b2010ef          	jal	ffffffffc0205110 <switch_to>
    if (flag)
ffffffffc0204062:	6602                	ld	a2,0(sp)
ffffffffc0204064:	e601                	bnez	a2,ffffffffc020406c <proc_run+0x48>
}
ffffffffc0204066:	60e2                	ld	ra,24(sp)
ffffffffc0204068:	6105                	addi	sp,sp,32
ffffffffc020406a:	8082                	ret
ffffffffc020406c:	60e2                	ld	ra,24(sp)
ffffffffc020406e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0204070:	88ffc06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc0204074:	8082                	ret
ffffffffc0204076:	e42a                	sd	a0,8(sp)
ffffffffc0204078:	e036                	sd	a3,0(sp)
        intr_disable();
ffffffffc020407a:	88bfc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc020407e:	6522                	ld	a0,8(sp)
ffffffffc0204080:	6682                	ld	a3,0(sp)
ffffffffc0204082:	4605                	li	a2,1
ffffffffc0204084:	bf6d                	j	ffffffffc020403e <proc_run+0x1a>

ffffffffc0204086 <do_fork>:
    if (nr_process >= MAX_PROCESS)
ffffffffc0204086:	00097717          	auipc	a4,0x97
ffffffffc020408a:	5d272703          	lw	a4,1490(a4) # ffffffffc029b658 <nr_process>
ffffffffc020408e:	6785                	lui	a5,0x1
ffffffffc0204090:	32f75663          	bge	a4,a5,ffffffffc02043bc <do_fork+0x336>
{
ffffffffc0204094:	711d                	addi	sp,sp,-96
ffffffffc0204096:	e8a2                	sd	s0,80(sp)
ffffffffc0204098:	e4a6                	sd	s1,72(sp)
ffffffffc020409a:	e0ca                	sd	s2,64(sp)
ffffffffc020409c:	e06a                	sd	s10,0(sp)
ffffffffc020409e:	ec86                	sd	ra,88(sp)
ffffffffc02040a0:	892e                	mv	s2,a1
ffffffffc02040a2:	84b2                	mv	s1,a2
ffffffffc02040a4:	8d2a                	mv	s10,a0
    if ((proc = alloc_proc()) == NULL) {
ffffffffc02040a6:	dfbff0ef          	jal	ffffffffc0203ea0 <alloc_proc>
ffffffffc02040aa:	842a                	mv	s0,a0
ffffffffc02040ac:	2e050863          	beqz	a0,ffffffffc020439c <do_fork+0x316>
    proc->parent = current;
ffffffffc02040b0:	f05a                	sd	s6,32(sp)
ffffffffc02040b2:	00097b17          	auipc	s6,0x97
ffffffffc02040b6:	5aeb0b13          	addi	s6,s6,1454 # ffffffffc029b660 <current>
ffffffffc02040ba:	000b3783          	ld	a5,0(s6)
    assert(current->wait_state == 0);
ffffffffc02040be:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_softint_out_size-0x7adc>
    proc->parent = current;
ffffffffc02040c2:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc02040c4:	36071b63          	bnez	a4,ffffffffc020443a <do_fork+0x3b4>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02040c8:	4509                	li	a0,2
ffffffffc02040ca:	e3dfd0ef          	jal	ffffffffc0201f06 <alloc_pages>
    if (page != NULL)
ffffffffc02040ce:	2c050363          	beqz	a0,ffffffffc0204394 <do_fork+0x30e>
ffffffffc02040d2:	fc4e                	sd	s3,56(sp)
    return page - pages + nbase;
ffffffffc02040d4:	00097997          	auipc	s3,0x97
ffffffffc02040d8:	57c98993          	addi	s3,s3,1404 # ffffffffc029b650 <pages>
ffffffffc02040dc:	0009b783          	ld	a5,0(s3)
ffffffffc02040e0:	f852                	sd	s4,48(sp)
ffffffffc02040e2:	00004a17          	auipc	s4,0x4
ffffffffc02040e6:	8bea0a13          	addi	s4,s4,-1858 # ffffffffc02079a0 <nbase>
ffffffffc02040ea:	e466                	sd	s9,8(sp)
ffffffffc02040ec:	000a3c83          	ld	s9,0(s4)
ffffffffc02040f0:	40f506b3          	sub	a3,a0,a5
ffffffffc02040f4:	f456                	sd	s5,40(sp)
    return KADDR(page2pa(page));
ffffffffc02040f6:	00097a97          	auipc	s5,0x97
ffffffffc02040fa:	552a8a93          	addi	s5,s5,1362 # ffffffffc029b648 <npage>
ffffffffc02040fe:	e862                	sd	s8,16(sp)
    return page - pages + nbase;
ffffffffc0204100:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204102:	5c7d                	li	s8,-1
ffffffffc0204104:	000ab783          	ld	a5,0(s5)
    return page - pages + nbase;
ffffffffc0204108:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc020410a:	00cc5c13          	srli	s8,s8,0xc
ffffffffc020410e:	0186f733          	and	a4,a3,s8
ffffffffc0204112:	ec5e                	sd	s7,24(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc0204114:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204116:	2cf77163          	bgeu	a4,a5,ffffffffc02043d8 <do_fork+0x352>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc020411a:	000b3703          	ld	a4,0(s6)
ffffffffc020411e:	00097b17          	auipc	s6,0x97
ffffffffc0204122:	522b0b13          	addi	s6,s6,1314 # ffffffffc029b640 <va_pa_offset>
ffffffffc0204126:	000b3783          	ld	a5,0(s6)
ffffffffc020412a:	02873b83          	ld	s7,40(a4)
ffffffffc020412e:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204130:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc0204132:	020b8863          	beqz	s7,ffffffffc0204162 <do_fork+0xdc>
    if (clone_flags & CLONE_VM)
ffffffffc0204136:	100d7793          	andi	a5,s10,256
ffffffffc020413a:	18078363          	beqz	a5,ffffffffc02042c0 <do_fork+0x23a>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc020413e:	030ba703          	lw	a4,48(s7)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204142:	018bb783          	ld	a5,24(s7)
ffffffffc0204146:	c02006b7          	lui	a3,0xc0200
ffffffffc020414a:	2705                	addiw	a4,a4,1
ffffffffc020414c:	02eba823          	sw	a4,48(s7)
    proc->mm = mm;
ffffffffc0204150:	03743423          	sd	s7,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204154:	28d7ee63          	bltu	a5,a3,ffffffffc02043f0 <do_fork+0x36a>
ffffffffc0204158:	000b3703          	ld	a4,0(s6)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020415c:	6814                	ld	a3,16(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020415e:	8f99                	sub	a5,a5,a4
ffffffffc0204160:	f45c                	sd	a5,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204162:	6789                	lui	a5,0x2
ffffffffc0204164:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x6ce8>
ffffffffc0204168:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc020416a:	8626                	mv	a2,s1
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020416c:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc020416e:	87b6                	mv	a5,a3
ffffffffc0204170:	12048713          	addi	a4,s1,288
ffffffffc0204174:	6a0c                	ld	a1,16(a2)
ffffffffc0204176:	00063803          	ld	a6,0(a2)
ffffffffc020417a:	6608                	ld	a0,8(a2)
ffffffffc020417c:	eb8c                	sd	a1,16(a5)
ffffffffc020417e:	0107b023          	sd	a6,0(a5)
ffffffffc0204182:	e788                	sd	a0,8(a5)
ffffffffc0204184:	6e0c                	ld	a1,24(a2)
ffffffffc0204186:	02060613          	addi	a2,a2,32
ffffffffc020418a:	02078793          	addi	a5,a5,32
ffffffffc020418e:	feb7bc23          	sd	a1,-8(a5)
ffffffffc0204192:	fee611e3          	bne	a2,a4,ffffffffc0204174 <do_fork+0xee>
    proc->tf->gpr.a0 = 0;
ffffffffc0204196:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020419a:	20090363          	beqz	s2,ffffffffc02043a0 <do_fork+0x31a>
    if (++last_pid >= MAX_PID)
ffffffffc020419e:	00093517          	auipc	a0,0x93
ffffffffc02041a2:	02652503          	lw	a0,38(a0) # ffffffffc02971c4 <last_pid.1>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02041a6:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02041aa:	00000797          	auipc	a5,0x0
ffffffffc02041ae:	d7878793          	addi	a5,a5,-648 # ffffffffc0203f22 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc02041b2:	2505                	addiw	a0,a0,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02041b4:	f81c                	sd	a5,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02041b6:	fc14                	sd	a3,56(s0)
    if (++last_pid >= MAX_PID)
ffffffffc02041b8:	00093717          	auipc	a4,0x93
ffffffffc02041bc:	00a72623          	sw	a0,12(a4) # ffffffffc02971c4 <last_pid.1>
ffffffffc02041c0:	6789                	lui	a5,0x2
ffffffffc02041c2:	1ef55163          	bge	a0,a5,ffffffffc02043a4 <do_fork+0x31e>
    if (last_pid >= next_safe)
ffffffffc02041c6:	00093797          	auipc	a5,0x93
ffffffffc02041ca:	ffa7a783          	lw	a5,-6(a5) # ffffffffc02971c0 <next_safe.0>
ffffffffc02041ce:	00097497          	auipc	s1,0x97
ffffffffc02041d2:	41248493          	addi	s1,s1,1042 # ffffffffc029b5e0 <proc_list>
ffffffffc02041d6:	06f54563          	blt	a0,a5,ffffffffc0204240 <do_fork+0x1ba>
    return listelm->next;
ffffffffc02041da:	00097497          	auipc	s1,0x97
ffffffffc02041de:	40648493          	addi	s1,s1,1030 # ffffffffc029b5e0 <proc_list>
ffffffffc02041e2:	0084b883          	ld	a7,8(s1)
        next_safe = MAX_PID;
ffffffffc02041e6:	6789                	lui	a5,0x2
ffffffffc02041e8:	00093717          	auipc	a4,0x93
ffffffffc02041ec:	fcf72c23          	sw	a5,-40(a4) # ffffffffc02971c0 <next_safe.0>
ffffffffc02041f0:	86aa                	mv	a3,a0
ffffffffc02041f2:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02041f4:	04988063          	beq	a7,s1,ffffffffc0204234 <do_fork+0x1ae>
ffffffffc02041f8:	882e                	mv	a6,a1
ffffffffc02041fa:	87c6                	mv	a5,a7
ffffffffc02041fc:	6609                	lui	a2,0x2
ffffffffc02041fe:	a811                	j	ffffffffc0204212 <do_fork+0x18c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204200:	00e6d663          	bge	a3,a4,ffffffffc020420c <do_fork+0x186>
ffffffffc0204204:	00c75463          	bge	a4,a2,ffffffffc020420c <do_fork+0x186>
                next_safe = proc->pid;
ffffffffc0204208:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020420a:	4805                	li	a6,1
ffffffffc020420c:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020420e:	00978d63          	beq	a5,s1,ffffffffc0204228 <do_fork+0x1a2>
            if (proc->pid == last_pid)
ffffffffc0204212:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_softint_out_size-0x6c8c>
ffffffffc0204216:	fed715e3          	bne	a4,a3,ffffffffc0204200 <do_fork+0x17a>
                if (++last_pid >= next_safe)
ffffffffc020421a:	2685                	addiw	a3,a3,1
ffffffffc020421c:	18c6da63          	bge	a3,a2,ffffffffc02043b0 <do_fork+0x32a>
ffffffffc0204220:	679c                	ld	a5,8(a5)
ffffffffc0204222:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204224:	fe9797e3          	bne	a5,s1,ffffffffc0204212 <do_fork+0x18c>
ffffffffc0204228:	00080663          	beqz	a6,ffffffffc0204234 <do_fork+0x1ae>
ffffffffc020422c:	00093797          	auipc	a5,0x93
ffffffffc0204230:	f8c7aa23          	sw	a2,-108(a5) # ffffffffc02971c0 <next_safe.0>
ffffffffc0204234:	c591                	beqz	a1,ffffffffc0204240 <do_fork+0x1ba>
ffffffffc0204236:	00093797          	auipc	a5,0x93
ffffffffc020423a:	f8d7a723          	sw	a3,-114(a5) # ffffffffc02971c4 <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020423e:	8536                	mv	a0,a3
    proc->pid = get_pid();
ffffffffc0204240:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204242:	45a9                	li	a1,10
ffffffffc0204244:	132010ef          	jal	ffffffffc0205376 <hash32>
ffffffffc0204248:	02051793          	slli	a5,a0,0x20
ffffffffc020424c:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204250:	00093797          	auipc	a5,0x93
ffffffffc0204254:	39078793          	addi	a5,a5,912 # ffffffffc02975e0 <hash_list>
ffffffffc0204258:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc020425a:	6518                	ld	a4,8(a0)
ffffffffc020425c:	0d840793          	addi	a5,s0,216
ffffffffc0204260:	6490                	ld	a2,8(s1)
    prev->next = next->prev = elm;
ffffffffc0204262:	e31c                	sd	a5,0(a4)
ffffffffc0204264:	e51c                	sd	a5,8(a0)
    elm->next = next;
ffffffffc0204266:	f078                	sd	a4,224(s0)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204268:	0c840793          	addi	a5,s0,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020426c:	7018                	ld	a4,32(s0)
    elm->prev = prev;
ffffffffc020426e:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc0204270:	e21c                	sd	a5,0(a2)
    proc->yptr = NULL;
ffffffffc0204272:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204276:	7b74                	ld	a3,240(a4)
ffffffffc0204278:	e49c                	sd	a5,8(s1)
    elm->next = next;
ffffffffc020427a:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc020427c:	e464                	sd	s1,200(s0)
ffffffffc020427e:	10d43023          	sd	a3,256(s0)
ffffffffc0204282:	c299                	beqz	a3,ffffffffc0204288 <do_fork+0x202>
        proc->optr->yptr = proc;
ffffffffc0204284:	fee0                	sd	s0,248(a3)
    proc->parent->cptr = proc;
ffffffffc0204286:	7018                	ld	a4,32(s0)
    nr_process++;
ffffffffc0204288:	00097797          	auipc	a5,0x97
ffffffffc020428c:	3d07a783          	lw	a5,976(a5) # ffffffffc029b658 <nr_process>
    proc->parent->cptr = proc;
ffffffffc0204290:	fb60                	sd	s0,240(a4)
    wakeup_proc(proc);
ffffffffc0204292:	8522                	mv	a0,s0
    nr_process++;
ffffffffc0204294:	2785                	addiw	a5,a5,1
ffffffffc0204296:	00097717          	auipc	a4,0x97
ffffffffc020429a:	3cf72123          	sw	a5,962(a4) # ffffffffc029b658 <nr_process>
    wakeup_proc(proc);
ffffffffc020429e:	6dd000ef          	jal	ffffffffc020517a <wakeup_proc>
    ret = proc->pid;
ffffffffc02042a2:	4048                	lw	a0,4(s0)
    goto fork_out;
ffffffffc02042a4:	79e2                	ld	s3,56(sp)
ffffffffc02042a6:	7a42                	ld	s4,48(sp)
ffffffffc02042a8:	7aa2                	ld	s5,40(sp)
ffffffffc02042aa:	7b02                	ld	s6,32(sp)
ffffffffc02042ac:	6be2                	ld	s7,24(sp)
ffffffffc02042ae:	6c42                	ld	s8,16(sp)
ffffffffc02042b0:	6ca2                	ld	s9,8(sp)
}
ffffffffc02042b2:	60e6                	ld	ra,88(sp)
ffffffffc02042b4:	6446                	ld	s0,80(sp)
ffffffffc02042b6:	64a6                	ld	s1,72(sp)
ffffffffc02042b8:	6906                	ld	s2,64(sp)
ffffffffc02042ba:	6d02                	ld	s10,0(sp)
ffffffffc02042bc:	6125                	addi	sp,sp,96
ffffffffc02042be:	8082                	ret
    if ((mm = mm_create()) == NULL)
ffffffffc02042c0:	ca8ff0ef          	jal	ffffffffc0203768 <mm_create>
ffffffffc02042c4:	8d2a                	mv	s10,a0
ffffffffc02042c6:	c949                	beqz	a0,ffffffffc0204358 <do_fork+0x2d2>
    if ((page = alloc_page()) == NULL)
ffffffffc02042c8:	4505                	li	a0,1
ffffffffc02042ca:	c3dfd0ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc02042ce:	c151                	beqz	a0,ffffffffc0204352 <do_fork+0x2cc>
    return page - pages + nbase;
ffffffffc02042d0:	0009b703          	ld	a4,0(s3)
    return KADDR(page2pa(page));
ffffffffc02042d4:	000ab783          	ld	a5,0(s5)
    return page - pages + nbase;
ffffffffc02042d8:	40e506b3          	sub	a3,a0,a4
ffffffffc02042dc:	8699                	srai	a3,a3,0x6
ffffffffc02042de:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc02042e0:	0186fc33          	and	s8,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc02042e4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02042e6:	12fc7263          	bgeu	s8,a5,ffffffffc020440a <do_fork+0x384>
ffffffffc02042ea:	000b3783          	ld	a5,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02042ee:	00097597          	auipc	a1,0x97
ffffffffc02042f2:	34a5b583          	ld	a1,842(a1) # ffffffffc029b638 <boot_pgdir_va>
ffffffffc02042f6:	6605                	lui	a2,0x1
ffffffffc02042f8:	00f68c33          	add	s8,a3,a5
ffffffffc02042fc:	8562                	mv	a0,s8
ffffffffc02042fe:	520010ef          	jal	ffffffffc020581e <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204302:	038b8c93          	addi	s9,s7,56
    mm->pgdir = pgdir;
ffffffffc0204306:	018d3c23          	sd	s8,24(s10) # fffffffffff80018 <end+0x3fce49a0>
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020430a:	4c05                	li	s8,1
ffffffffc020430c:	418cb7af          	amoor.d	a5,s8,(s9)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204310:	03f79713          	slli	a4,a5,0x3f
ffffffffc0204314:	03f75793          	srli	a5,a4,0x3f
ffffffffc0204318:	cb91                	beqz	a5,ffffffffc020432c <do_fork+0x2a6>
    {
        schedule();
ffffffffc020431a:	6f5000ef          	jal	ffffffffc020520e <schedule>
ffffffffc020431e:	418cb7af          	amoor.d	a5,s8,(s9)
    while (!try_lock(lock))
ffffffffc0204322:	03f79713          	slli	a4,a5,0x3f
ffffffffc0204326:	03f75793          	srli	a5,a4,0x3f
ffffffffc020432a:	fbe5                	bnez	a5,ffffffffc020431a <do_fork+0x294>
        ret = dup_mmap(mm, oldmm);
ffffffffc020432c:	85de                	mv	a1,s7
ffffffffc020432e:	856a                	mv	a0,s10
ffffffffc0204330:	e94ff0ef          	jal	ffffffffc02039c4 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0204334:	57f9                	li	a5,-2
ffffffffc0204336:	60fcb7af          	amoand.d	a5,a5,(s9)
ffffffffc020433a:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc020433c:	0e078363          	beqz	a5,ffffffffc0204422 <do_fork+0x39c>
    if ((mm = mm_create()) == NULL)
ffffffffc0204340:	8bea                	mv	s7,s10
    if (ret != 0)
ffffffffc0204342:	de050ee3          	beqz	a0,ffffffffc020413e <do_fork+0xb8>
    exit_mmap(mm);
ffffffffc0204346:	856a                	mv	a0,s10
ffffffffc0204348:	f14ff0ef          	jal	ffffffffc0203a5c <exit_mmap>
    put_pgdir(mm);
ffffffffc020434c:	856a                	mv	a0,s10
ffffffffc020434e:	c61ff0ef          	jal	ffffffffc0203fae <put_pgdir>
    mm_destroy(mm);
ffffffffc0204352:	856a                	mv	a0,s10
ffffffffc0204354:	d52ff0ef          	jal	ffffffffc02038a6 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204358:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc020435a:	c02007b7          	lui	a5,0xc0200
ffffffffc020435e:	10f6e463          	bltu	a3,a5,ffffffffc0204466 <do_fork+0x3e0>
ffffffffc0204362:	000b3783          	ld	a5,0(s6)
    if (PPN(pa) >= npage)
ffffffffc0204366:	000ab703          	ld	a4,0(s5)
    return pa2page(PADDR(kva));
ffffffffc020436a:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc020436e:	83b1                	srli	a5,a5,0xc
ffffffffc0204370:	04e7f863          	bgeu	a5,a4,ffffffffc02043c0 <do_fork+0x33a>
    return &pages[PPN(pa) - nbase];
ffffffffc0204374:	000a3703          	ld	a4,0(s4)
ffffffffc0204378:	0009b503          	ld	a0,0(s3)
ffffffffc020437c:	4589                	li	a1,2
ffffffffc020437e:	8f99                	sub	a5,a5,a4
ffffffffc0204380:	079a                	slli	a5,a5,0x6
ffffffffc0204382:	953e                	add	a0,a0,a5
ffffffffc0204384:	bbdfd0ef          	jal	ffffffffc0201f40 <free_pages>
}
ffffffffc0204388:	79e2                	ld	s3,56(sp)
ffffffffc020438a:	7a42                	ld	s4,48(sp)
ffffffffc020438c:	7aa2                	ld	s5,40(sp)
ffffffffc020438e:	6be2                	ld	s7,24(sp)
ffffffffc0204390:	6c42                	ld	s8,16(sp)
ffffffffc0204392:	6ca2                	ld	s9,8(sp)
    kfree(proc);
ffffffffc0204394:	8522                	mv	a0,s0
ffffffffc0204396:	a55fd0ef          	jal	ffffffffc0201dea <kfree>
ffffffffc020439a:	7b02                	ld	s6,32(sp)
    ret = -E_NO_MEM;
ffffffffc020439c:	5571                	li	a0,-4
    return ret;
ffffffffc020439e:	bf11                	j	ffffffffc02042b2 <do_fork+0x22c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02043a0:	8936                	mv	s2,a3
ffffffffc02043a2:	bbf5                	j	ffffffffc020419e <do_fork+0x118>
        last_pid = 1;
ffffffffc02043a4:	4505                	li	a0,1
ffffffffc02043a6:	00093797          	auipc	a5,0x93
ffffffffc02043aa:	e0a7af23          	sw	a0,-482(a5) # ffffffffc02971c4 <last_pid.1>
        goto inside;
ffffffffc02043ae:	b535                	j	ffffffffc02041da <do_fork+0x154>
                    if (last_pid >= MAX_PID)
ffffffffc02043b0:	6789                	lui	a5,0x2
ffffffffc02043b2:	00f6c363          	blt	a3,a5,ffffffffc02043b8 <do_fork+0x332>
                        last_pid = 1;
ffffffffc02043b6:	4685                	li	a3,1
                    goto repeat;
ffffffffc02043b8:	4585                	li	a1,1
ffffffffc02043ba:	bd2d                	j	ffffffffc02041f4 <do_fork+0x16e>
    int ret = -E_NO_FREE_PROC;
ffffffffc02043bc:	556d                	li	a0,-5
}
ffffffffc02043be:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc02043c0:	00002617          	auipc	a2,0x2
ffffffffc02043c4:	2d860613          	addi	a2,a2,728 # ffffffffc0206698 <etext+0xe62>
ffffffffc02043c8:	06900593          	li	a1,105
ffffffffc02043cc:	00002517          	auipc	a0,0x2
ffffffffc02043d0:	22450513          	addi	a0,a0,548 # ffffffffc02065f0 <etext+0xdba>
ffffffffc02043d4:	872fc0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc02043d8:	00002617          	auipc	a2,0x2
ffffffffc02043dc:	1f060613          	addi	a2,a2,496 # ffffffffc02065c8 <etext+0xd92>
ffffffffc02043e0:	07100593          	li	a1,113
ffffffffc02043e4:	00002517          	auipc	a0,0x2
ffffffffc02043e8:	20c50513          	addi	a0,a0,524 # ffffffffc02065f0 <etext+0xdba>
ffffffffc02043ec:	85afc0ef          	jal	ffffffffc0200446 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02043f0:	86be                	mv	a3,a5
ffffffffc02043f2:	00002617          	auipc	a2,0x2
ffffffffc02043f6:	27e60613          	addi	a2,a2,638 # ffffffffc0206670 <etext+0xe3a>
ffffffffc02043fa:	19300593          	li	a1,403
ffffffffc02043fe:	00003517          	auipc	a0,0x3
ffffffffc0204402:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204406:	840fc0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc020440a:	00002617          	auipc	a2,0x2
ffffffffc020440e:	1be60613          	addi	a2,a2,446 # ffffffffc02065c8 <etext+0xd92>
ffffffffc0204412:	07100593          	li	a1,113
ffffffffc0204416:	00002517          	auipc	a0,0x2
ffffffffc020441a:	1da50513          	addi	a0,a0,474 # ffffffffc02065f0 <etext+0xdba>
ffffffffc020441e:	828fc0ef          	jal	ffffffffc0200446 <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc0204422:	00003617          	auipc	a2,0x3
ffffffffc0204426:	c0e60613          	addi	a2,a2,-1010 # ffffffffc0207030 <etext+0x17fa>
ffffffffc020442a:	03f00593          	li	a1,63
ffffffffc020442e:	00003517          	auipc	a0,0x3
ffffffffc0204432:	c1250513          	addi	a0,a0,-1006 # ffffffffc0207040 <etext+0x180a>
ffffffffc0204436:	810fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(current->wait_state == 0);
ffffffffc020443a:	00003697          	auipc	a3,0x3
ffffffffc020443e:	bd668693          	addi	a3,a3,-1066 # ffffffffc0207010 <etext+0x17da>
ffffffffc0204442:	00002617          	auipc	a2,0x2
ffffffffc0204446:	dd660613          	addi	a2,a2,-554 # ffffffffc0206218 <etext+0x9e2>
ffffffffc020444a:	1c300593          	li	a1,451
ffffffffc020444e:	00003517          	auipc	a0,0x3
ffffffffc0204452:	baa50513          	addi	a0,a0,-1110 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204456:	fc4e                	sd	s3,56(sp)
ffffffffc0204458:	f852                	sd	s4,48(sp)
ffffffffc020445a:	f456                	sd	s5,40(sp)
ffffffffc020445c:	ec5e                	sd	s7,24(sp)
ffffffffc020445e:	e862                	sd	s8,16(sp)
ffffffffc0204460:	e466                	sd	s9,8(sp)
ffffffffc0204462:	fe5fb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204466:	00002617          	auipc	a2,0x2
ffffffffc020446a:	20a60613          	addi	a2,a2,522 # ffffffffc0206670 <etext+0xe3a>
ffffffffc020446e:	07700593          	li	a1,119
ffffffffc0204472:	00002517          	auipc	a0,0x2
ffffffffc0204476:	17e50513          	addi	a0,a0,382 # ffffffffc02065f0 <etext+0xdba>
ffffffffc020447a:	fcdfb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020447e <kernel_thread>:
{
ffffffffc020447e:	7129                	addi	sp,sp,-320
ffffffffc0204480:	fa22                	sd	s0,304(sp)
ffffffffc0204482:	f626                	sd	s1,296(sp)
ffffffffc0204484:	f24a                	sd	s2,288(sp)
ffffffffc0204486:	842a                	mv	s0,a0
ffffffffc0204488:	84ae                	mv	s1,a1
ffffffffc020448a:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020448c:	850a                	mv	a0,sp
ffffffffc020448e:	12000613          	li	a2,288
ffffffffc0204492:	4581                	li	a1,0
{
ffffffffc0204494:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204496:	376010ef          	jal	ffffffffc020580c <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc020449a:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc020449c:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc020449e:	100027f3          	csrr	a5,sstatus
ffffffffc02044a2:	edd7f793          	andi	a5,a5,-291
ffffffffc02044a6:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02044aa:	860a                	mv	a2,sp
ffffffffc02044ac:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02044b0:	00000717          	auipc	a4,0x0
ffffffffc02044b4:	9e870713          	addi	a4,a4,-1560 # ffffffffc0203e98 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02044b8:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02044ba:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02044bc:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02044be:	bc9ff0ef          	jal	ffffffffc0204086 <do_fork>
}
ffffffffc02044c2:	70f2                	ld	ra,312(sp)
ffffffffc02044c4:	7452                	ld	s0,304(sp)
ffffffffc02044c6:	74b2                	ld	s1,296(sp)
ffffffffc02044c8:	7912                	ld	s2,288(sp)
ffffffffc02044ca:	6131                	addi	sp,sp,320
ffffffffc02044cc:	8082                	ret

ffffffffc02044ce <do_exit>:
{
ffffffffc02044ce:	7179                	addi	sp,sp,-48
ffffffffc02044d0:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc02044d2:	00097417          	auipc	s0,0x97
ffffffffc02044d6:	18e40413          	addi	s0,s0,398 # ffffffffc029b660 <current>
ffffffffc02044da:	601c                	ld	a5,0(s0)
ffffffffc02044dc:	00097717          	auipc	a4,0x97
ffffffffc02044e0:	19473703          	ld	a4,404(a4) # ffffffffc029b670 <idleproc>
{
ffffffffc02044e4:	f406                	sd	ra,40(sp)
ffffffffc02044e6:	ec26                	sd	s1,24(sp)
    if (current == idleproc)
ffffffffc02044e8:	0ce78b63          	beq	a5,a4,ffffffffc02045be <do_exit+0xf0>
    if (current == initproc)
ffffffffc02044ec:	00097497          	auipc	s1,0x97
ffffffffc02044f0:	17c48493          	addi	s1,s1,380 # ffffffffc029b668 <initproc>
ffffffffc02044f4:	6098                	ld	a4,0(s1)
ffffffffc02044f6:	e84a                	sd	s2,16(sp)
ffffffffc02044f8:	0ee78a63          	beq	a5,a4,ffffffffc02045ec <do_exit+0x11e>
ffffffffc02044fc:	892a                	mv	s2,a0
    struct mm_struct *mm = current->mm;
ffffffffc02044fe:	7788                	ld	a0,40(a5)
    if (mm != NULL)
ffffffffc0204500:	c115                	beqz	a0,ffffffffc0204524 <do_exit+0x56>
ffffffffc0204502:	00097797          	auipc	a5,0x97
ffffffffc0204506:	12e7b783          	ld	a5,302(a5) # ffffffffc029b630 <boot_pgdir_pa>
ffffffffc020450a:	577d                	li	a4,-1
ffffffffc020450c:	177e                	slli	a4,a4,0x3f
ffffffffc020450e:	83b1                	srli	a5,a5,0xc
ffffffffc0204510:	8fd9                	or	a5,a5,a4
ffffffffc0204512:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204516:	591c                	lw	a5,48(a0)
ffffffffc0204518:	37fd                	addiw	a5,a5,-1
ffffffffc020451a:	d91c                	sw	a5,48(a0)
        if (mm_count_dec(mm) == 0)
ffffffffc020451c:	cfd5                	beqz	a5,ffffffffc02045d8 <do_exit+0x10a>
        current->mm = NULL;
ffffffffc020451e:	601c                	ld	a5,0(s0)
ffffffffc0204520:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204524:	470d                	li	a4,3
    current->exit_code = error_code;
ffffffffc0204526:	0f27a423          	sw	s2,232(a5)
    current->state = PROC_ZOMBIE;
ffffffffc020452a:	c398                	sw	a4,0(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020452c:	100027f3          	csrr	a5,sstatus
ffffffffc0204530:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204532:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204534:	ebe1                	bnez	a5,ffffffffc0204604 <do_exit+0x136>
        proc = current->parent;
ffffffffc0204536:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204538:	800007b7          	lui	a5,0x80000
ffffffffc020453c:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
        proc = current->parent;
ffffffffc020453e:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204540:	0ec52703          	lw	a4,236(a0)
ffffffffc0204544:	0cf70463          	beq	a4,a5,ffffffffc020460c <do_exit+0x13e>
        while (current->cptr != NULL)
ffffffffc0204548:	6018                	ld	a4,0(s0)
                if (initproc->wait_state == WT_CHILD)
ffffffffc020454a:	800005b7          	lui	a1,0x80000
ffffffffc020454e:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
        while (current->cptr != NULL)
ffffffffc0204550:	7b7c                	ld	a5,240(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204552:	460d                	li	a2,3
        while (current->cptr != NULL)
ffffffffc0204554:	e789                	bnez	a5,ffffffffc020455e <do_exit+0x90>
ffffffffc0204556:	a83d                	j	ffffffffc0204594 <do_exit+0xc6>
ffffffffc0204558:	6018                	ld	a4,0(s0)
ffffffffc020455a:	7b7c                	ld	a5,240(a4)
ffffffffc020455c:	cf85                	beqz	a5,ffffffffc0204594 <do_exit+0xc6>
            current->cptr = proc->optr;
ffffffffc020455e:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204562:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc0204564:	fb74                	sd	a3,240(a4)
            proc->yptr = NULL;
ffffffffc0204566:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020456a:	7978                	ld	a4,240(a0)
ffffffffc020456c:	10e7b023          	sd	a4,256(a5)
ffffffffc0204570:	c311                	beqz	a4,ffffffffc0204574 <do_exit+0xa6>
                initproc->cptr->yptr = proc;
ffffffffc0204572:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204574:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0204576:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0204578:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc020457a:	fcc71fe3          	bne	a4,a2,ffffffffc0204558 <do_exit+0x8a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc020457e:	0ec52783          	lw	a5,236(a0)
ffffffffc0204582:	fcb79be3          	bne	a5,a1,ffffffffc0204558 <do_exit+0x8a>
                    wakeup_proc(initproc);
ffffffffc0204586:	3f5000ef          	jal	ffffffffc020517a <wakeup_proc>
ffffffffc020458a:	800005b7          	lui	a1,0x80000
ffffffffc020458e:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
ffffffffc0204590:	460d                	li	a2,3
ffffffffc0204592:	b7d9                	j	ffffffffc0204558 <do_exit+0x8a>
    if (flag)
ffffffffc0204594:	02091263          	bnez	s2,ffffffffc02045b8 <do_exit+0xea>
    schedule();
ffffffffc0204598:	477000ef          	jal	ffffffffc020520e <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc020459c:	601c                	ld	a5,0(s0)
ffffffffc020459e:	00003617          	auipc	a2,0x3
ffffffffc02045a2:	ada60613          	addi	a2,a2,-1318 # ffffffffc0207078 <etext+0x1842>
ffffffffc02045a6:	24a00593          	li	a1,586
ffffffffc02045aa:	43d4                	lw	a3,4(a5)
ffffffffc02045ac:	00003517          	auipc	a0,0x3
ffffffffc02045b0:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc02045b4:	e93fb0ef          	jal	ffffffffc0200446 <__panic>
        intr_enable();
ffffffffc02045b8:	b46fc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02045bc:	bff1                	j	ffffffffc0204598 <do_exit+0xca>
        panic("idleproc exit.\n");
ffffffffc02045be:	00003617          	auipc	a2,0x3
ffffffffc02045c2:	a9a60613          	addi	a2,a2,-1382 # ffffffffc0207058 <etext+0x1822>
ffffffffc02045c6:	21600593          	li	a1,534
ffffffffc02045ca:	00003517          	auipc	a0,0x3
ffffffffc02045ce:	a2e50513          	addi	a0,a0,-1490 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc02045d2:	e84a                	sd	s2,16(sp)
ffffffffc02045d4:	e73fb0ef          	jal	ffffffffc0200446 <__panic>
            exit_mmap(mm);
ffffffffc02045d8:	e42a                	sd	a0,8(sp)
ffffffffc02045da:	c82ff0ef          	jal	ffffffffc0203a5c <exit_mmap>
            put_pgdir(mm);
ffffffffc02045de:	6522                	ld	a0,8(sp)
ffffffffc02045e0:	9cfff0ef          	jal	ffffffffc0203fae <put_pgdir>
            mm_destroy(mm);
ffffffffc02045e4:	6522                	ld	a0,8(sp)
ffffffffc02045e6:	ac0ff0ef          	jal	ffffffffc02038a6 <mm_destroy>
ffffffffc02045ea:	bf15                	j	ffffffffc020451e <do_exit+0x50>
        panic("initproc exit.\n");
ffffffffc02045ec:	00003617          	auipc	a2,0x3
ffffffffc02045f0:	a7c60613          	addi	a2,a2,-1412 # ffffffffc0207068 <etext+0x1832>
ffffffffc02045f4:	21a00593          	li	a1,538
ffffffffc02045f8:	00003517          	auipc	a0,0x3
ffffffffc02045fc:	a0050513          	addi	a0,a0,-1536 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204600:	e47fb0ef          	jal	ffffffffc0200446 <__panic>
        intr_disable();
ffffffffc0204604:	b00fc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0204608:	4905                	li	s2,1
ffffffffc020460a:	b735                	j	ffffffffc0204536 <do_exit+0x68>
            wakeup_proc(proc);
ffffffffc020460c:	36f000ef          	jal	ffffffffc020517a <wakeup_proc>
ffffffffc0204610:	bf25                	j	ffffffffc0204548 <do_exit+0x7a>

ffffffffc0204612 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc0204612:	7179                	addi	sp,sp,-48
ffffffffc0204614:	ec26                	sd	s1,24(sp)
ffffffffc0204616:	e84a                	sd	s2,16(sp)
ffffffffc0204618:	e44e                	sd	s3,8(sp)
ffffffffc020461a:	f406                	sd	ra,40(sp)
ffffffffc020461c:	f022                	sd	s0,32(sp)
ffffffffc020461e:	84aa                	mv	s1,a0
ffffffffc0204620:	892e                	mv	s2,a1
ffffffffc0204622:	00097997          	auipc	s3,0x97
ffffffffc0204626:	03e98993          	addi	s3,s3,62 # ffffffffc029b660 <current>
    if (pid != 0)
ffffffffc020462a:	cd19                	beqz	a0,ffffffffc0204648 <do_wait.part.0+0x36>
    if (0 < pid && pid < MAX_PID)
ffffffffc020462c:	6789                	lui	a5,0x2
ffffffffc020462e:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bca>
ffffffffc0204630:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204634:	12e7f563          	bgeu	a5,a4,ffffffffc020475e <do_wait.part.0+0x14c>
}
ffffffffc0204638:	70a2                	ld	ra,40(sp)
ffffffffc020463a:	7402                	ld	s0,32(sp)
ffffffffc020463c:	64e2                	ld	s1,24(sp)
ffffffffc020463e:	6942                	ld	s2,16(sp)
ffffffffc0204640:	69a2                	ld	s3,8(sp)
    return -E_BAD_PROC;
ffffffffc0204642:	5579                	li	a0,-2
}
ffffffffc0204644:	6145                	addi	sp,sp,48
ffffffffc0204646:	8082                	ret
        proc = current->cptr;
ffffffffc0204648:	0009b703          	ld	a4,0(s3)
ffffffffc020464c:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr)
ffffffffc020464e:	d46d                	beqz	s0,ffffffffc0204638 <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204650:	468d                	li	a3,3
ffffffffc0204652:	a021                	j	ffffffffc020465a <do_wait.part.0+0x48>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204654:	10043403          	ld	s0,256(s0)
ffffffffc0204658:	c075                	beqz	s0,ffffffffc020473c <do_wait.part.0+0x12a>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020465a:	401c                	lw	a5,0(s0)
ffffffffc020465c:	fed79ce3          	bne	a5,a3,ffffffffc0204654 <do_wait.part.0+0x42>
    if (proc == idleproc || proc == initproc)
ffffffffc0204660:	00097797          	auipc	a5,0x97
ffffffffc0204664:	0107b783          	ld	a5,16(a5) # ffffffffc029b670 <idleproc>
ffffffffc0204668:	14878263          	beq	a5,s0,ffffffffc02047ac <do_wait.part.0+0x19a>
ffffffffc020466c:	00097797          	auipc	a5,0x97
ffffffffc0204670:	ffc7b783          	ld	a5,-4(a5) # ffffffffc029b668 <initproc>
ffffffffc0204674:	12f40c63          	beq	s0,a5,ffffffffc02047ac <do_wait.part.0+0x19a>
    if (code_store != NULL)
ffffffffc0204678:	00090663          	beqz	s2,ffffffffc0204684 <do_wait.part.0+0x72>
        *code_store = proc->exit_code;
ffffffffc020467c:	0e842783          	lw	a5,232(s0)
ffffffffc0204680:	00f92023          	sw	a5,0(s2)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204684:	100027f3          	csrr	a5,sstatus
ffffffffc0204688:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020468a:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020468c:	10079963          	bnez	a5,ffffffffc020479e <do_wait.part.0+0x18c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204690:	6c74                	ld	a3,216(s0)
ffffffffc0204692:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL)
ffffffffc0204694:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc0204698:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc020469a:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc020469c:	6474                	ld	a3,200(s0)
ffffffffc020469e:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc02046a0:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02046a2:	e314                	sd	a3,0(a4)
ffffffffc02046a4:	c789                	beqz	a5,ffffffffc02046ae <do_wait.part.0+0x9c>
        proc->optr->yptr = proc->yptr;
ffffffffc02046a6:	7c78                	ld	a4,248(s0)
ffffffffc02046a8:	fff8                	sd	a4,248(a5)
        proc->yptr->optr = proc->optr;
ffffffffc02046aa:	10043783          	ld	a5,256(s0)
    if (proc->yptr != NULL)
ffffffffc02046ae:	7c78                	ld	a4,248(s0)
ffffffffc02046b0:	c36d                	beqz	a4,ffffffffc0204792 <do_wait.part.0+0x180>
        proc->yptr->optr = proc->optr;
ffffffffc02046b2:	10f73023          	sd	a5,256(a4)
    nr_process--;
ffffffffc02046b6:	00097797          	auipc	a5,0x97
ffffffffc02046ba:	fa27a783          	lw	a5,-94(a5) # ffffffffc029b658 <nr_process>
ffffffffc02046be:	37fd                	addiw	a5,a5,-1
ffffffffc02046c0:	00097717          	auipc	a4,0x97
ffffffffc02046c4:	f8f72c23          	sw	a5,-104(a4) # ffffffffc029b658 <nr_process>
    if (flag)
ffffffffc02046c8:	e271                	bnez	a2,ffffffffc020478c <do_wait.part.0+0x17a>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02046ca:	6814                	ld	a3,16(s0)
ffffffffc02046cc:	c02007b7          	lui	a5,0xc0200
ffffffffc02046d0:	10f6e663          	bltu	a3,a5,ffffffffc02047dc <do_wait.part.0+0x1ca>
ffffffffc02046d4:	00097717          	auipc	a4,0x97
ffffffffc02046d8:	f6c73703          	ld	a4,-148(a4) # ffffffffc029b640 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc02046dc:	00097797          	auipc	a5,0x97
ffffffffc02046e0:	f6c7b783          	ld	a5,-148(a5) # ffffffffc029b648 <npage>
    return pa2page(PADDR(kva));
ffffffffc02046e4:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc02046e6:	82b1                	srli	a3,a3,0xc
ffffffffc02046e8:	0cf6fe63          	bgeu	a3,a5,ffffffffc02047c4 <do_wait.part.0+0x1b2>
    return &pages[PPN(pa) - nbase];
ffffffffc02046ec:	00003797          	auipc	a5,0x3
ffffffffc02046f0:	2b47b783          	ld	a5,692(a5) # ffffffffc02079a0 <nbase>
ffffffffc02046f4:	00097517          	auipc	a0,0x97
ffffffffc02046f8:	f5c53503          	ld	a0,-164(a0) # ffffffffc029b650 <pages>
ffffffffc02046fc:	4589                	li	a1,2
ffffffffc02046fe:	8e9d                	sub	a3,a3,a5
ffffffffc0204700:	069a                	slli	a3,a3,0x6
ffffffffc0204702:	9536                	add	a0,a0,a3
ffffffffc0204704:	83dfd0ef          	jal	ffffffffc0201f40 <free_pages>
    kfree(proc);
ffffffffc0204708:	8522                	mv	a0,s0
ffffffffc020470a:	ee0fd0ef          	jal	ffffffffc0201dea <kfree>
}
ffffffffc020470e:	70a2                	ld	ra,40(sp)
ffffffffc0204710:	7402                	ld	s0,32(sp)
ffffffffc0204712:	64e2                	ld	s1,24(sp)
ffffffffc0204714:	6942                	ld	s2,16(sp)
ffffffffc0204716:	69a2                	ld	s3,8(sp)
    return 0;
ffffffffc0204718:	4501                	li	a0,0
}
ffffffffc020471a:	6145                	addi	sp,sp,48
ffffffffc020471c:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc020471e:	00097997          	auipc	s3,0x97
ffffffffc0204722:	f4298993          	addi	s3,s3,-190 # ffffffffc029b660 <current>
ffffffffc0204726:	0009b703          	ld	a4,0(s3)
ffffffffc020472a:	f487b683          	ld	a3,-184(a5)
ffffffffc020472e:	f0e695e3          	bne	a3,a4,ffffffffc0204638 <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204732:	f287a603          	lw	a2,-216(a5)
ffffffffc0204736:	468d                	li	a3,3
ffffffffc0204738:	06d60063          	beq	a2,a3,ffffffffc0204798 <do_wait.part.0+0x186>
        current->wait_state = WT_CHILD;
ffffffffc020473c:	800007b7          	lui	a5,0x80000
ffffffffc0204740:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
        current->state = PROC_SLEEPING;
ffffffffc0204742:	4685                	li	a3,1
        current->wait_state = WT_CHILD;
ffffffffc0204744:	0ef72623          	sw	a5,236(a4)
        current->state = PROC_SLEEPING;
ffffffffc0204748:	c314                	sw	a3,0(a4)
        schedule();
ffffffffc020474a:	2c5000ef          	jal	ffffffffc020520e <schedule>
        if (current->flags & PF_EXITING)
ffffffffc020474e:	0009b783          	ld	a5,0(s3)
ffffffffc0204752:	0b07a783          	lw	a5,176(a5)
ffffffffc0204756:	8b85                	andi	a5,a5,1
ffffffffc0204758:	e7b9                	bnez	a5,ffffffffc02047a6 <do_wait.part.0+0x194>
    if (pid != 0)
ffffffffc020475a:	ee0487e3          	beqz	s1,ffffffffc0204648 <do_wait.part.0+0x36>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020475e:	45a9                	li	a1,10
ffffffffc0204760:	8526                	mv	a0,s1
ffffffffc0204762:	415000ef          	jal	ffffffffc0205376 <hash32>
ffffffffc0204766:	02051793          	slli	a5,a0,0x20
ffffffffc020476a:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020476e:	00093797          	auipc	a5,0x93
ffffffffc0204772:	e7278793          	addi	a5,a5,-398 # ffffffffc02975e0 <hash_list>
ffffffffc0204776:	953e                	add	a0,a0,a5
ffffffffc0204778:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc020477a:	a029                	j	ffffffffc0204784 <do_wait.part.0+0x172>
            if (proc->pid == pid)
ffffffffc020477c:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204780:	f8970fe3          	beq	a4,s1,ffffffffc020471e <do_wait.part.0+0x10c>
    return listelm->next;
ffffffffc0204784:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204786:	fef51be3          	bne	a0,a5,ffffffffc020477c <do_wait.part.0+0x16a>
ffffffffc020478a:	b57d                	j	ffffffffc0204638 <do_wait.part.0+0x26>
        intr_enable();
ffffffffc020478c:	972fc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0204790:	bf2d                	j	ffffffffc02046ca <do_wait.part.0+0xb8>
        proc->parent->cptr = proc->optr;
ffffffffc0204792:	7018                	ld	a4,32(s0)
ffffffffc0204794:	fb7c                	sd	a5,240(a4)
ffffffffc0204796:	b705                	j	ffffffffc02046b6 <do_wait.part.0+0xa4>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204798:	f2878413          	addi	s0,a5,-216
ffffffffc020479c:	b5d1                	j	ffffffffc0204660 <do_wait.part.0+0x4e>
        intr_disable();
ffffffffc020479e:	966fc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc02047a2:	4605                	li	a2,1
ffffffffc02047a4:	b5f5                	j	ffffffffc0204690 <do_wait.part.0+0x7e>
            do_exit(-E_KILLED);
ffffffffc02047a6:	555d                	li	a0,-9
ffffffffc02047a8:	d27ff0ef          	jal	ffffffffc02044ce <do_exit>
        panic("wait idleproc or initproc.\n");
ffffffffc02047ac:	00003617          	auipc	a2,0x3
ffffffffc02047b0:	8ec60613          	addi	a2,a2,-1812 # ffffffffc0207098 <etext+0x1862>
ffffffffc02047b4:	37000593          	li	a1,880
ffffffffc02047b8:	00003517          	auipc	a0,0x3
ffffffffc02047bc:	84050513          	addi	a0,a0,-1984 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc02047c0:	c87fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02047c4:	00002617          	auipc	a2,0x2
ffffffffc02047c8:	ed460613          	addi	a2,a2,-300 # ffffffffc0206698 <etext+0xe62>
ffffffffc02047cc:	06900593          	li	a1,105
ffffffffc02047d0:	00002517          	auipc	a0,0x2
ffffffffc02047d4:	e2050513          	addi	a0,a0,-480 # ffffffffc02065f0 <etext+0xdba>
ffffffffc02047d8:	c6ffb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02047dc:	00002617          	auipc	a2,0x2
ffffffffc02047e0:	e9460613          	addi	a2,a2,-364 # ffffffffc0206670 <etext+0xe3a>
ffffffffc02047e4:	07700593          	li	a1,119
ffffffffc02047e8:	00002517          	auipc	a0,0x2
ffffffffc02047ec:	e0850513          	addi	a0,a0,-504 # ffffffffc02065f0 <etext+0xdba>
ffffffffc02047f0:	c57fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02047f4 <init_main>:

// init_main - the second kernel thread used to create user_main kernel threads
// init_main - 第二个内核线程，用于创建用户态主线程并管理其生命周期
static int
init_main(void *arg)
{
ffffffffc02047f4:	1141                	addi	sp,sp,-16
ffffffffc02047f6:	e406                	sd	ra,8(sp)
    // 保存当前系统的空闲页面数，用于后续内存泄漏检测
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc02047f8:	f80fd0ef          	jal	ffffffffc0201f78 <nr_free_pages>
    // 保存当前内核已分配的内存量，用于后续内存泄漏检测
    size_t kernel_allocated_store = kallocated();
ffffffffc02047fc:	d44fd0ef          	jal	ffffffffc0201d40 <kallocated>

    // 创建user_main内核线程，该线程负责启动所有用户态进程
    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204800:	4601                	li	a2,0
ffffffffc0204802:	4581                	li	a1,0
ffffffffc0204804:	fffff517          	auipc	a0,0xfffff
ffffffffc0204808:	72c50513          	addi	a0,a0,1836 # ffffffffc0203f30 <user_main>
ffffffffc020480c:	c73ff0ef          	jal	ffffffffc020447e <kernel_thread>
    if (pid <= 0)
ffffffffc0204810:	00a04563          	bgtz	a0,ffffffffc020481a <init_main+0x26>
ffffffffc0204814:	a041                	j	ffffffffc0204894 <init_main+0xa0>
    // 循环等待所有子进程退出
    // do_wait(0, NULL)会等待任意一个子进程结束，返回0表示还有子进程在运行
    // 当所有子进程都退出后，do_wait返回非0值，循环结束
    while (do_wait(0, NULL) == 0)
    {
        schedule();  // 让出CPU，调度其他进程运行
ffffffffc0204816:	1f9000ef          	jal	ffffffffc020520e <schedule>
    if (code_store != NULL)
ffffffffc020481a:	4581                	li	a1,0
ffffffffc020481c:	4501                	li	a0,0
ffffffffc020481e:	df5ff0ef          	jal	ffffffffc0204612 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204822:	d975                	beqz	a0,ffffffffc0204816 <init_main+0x22>
    }

    // 所有用户态进程已经退出
    cprintf("all user-mode processes have quit.\n");
ffffffffc0204824:	00003517          	auipc	a0,0x3
ffffffffc0204828:	8b450513          	addi	a0,a0,-1868 # ffffffffc02070d8 <etext+0x18a2>
ffffffffc020482c:	969fb0ef          	jal	ffffffffc0200194 <cprintf>
    
    // 检查initproc进程状态是否正确
    // cptr: child pointer，子进程指针应为NULL（无子进程）
    // yptr: younger sibling pointer，弟进程指针应为NULL（无弟进程）
    // optr: older sibling pointer，兄进程指针应为NULL（无兄进程）
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204830:	00097797          	auipc	a5,0x97
ffffffffc0204834:	e387b783          	ld	a5,-456(a5) # ffffffffc029b668 <initproc>
ffffffffc0204838:	7bf8                	ld	a4,240(a5)
ffffffffc020483a:	c30d                	beqz	a4,ffffffffc020485c <init_main+0x68>
ffffffffc020483c:	00003697          	auipc	a3,0x3
ffffffffc0204840:	8c468693          	addi	a3,a3,-1852 # ffffffffc0207100 <etext+0x18ca>
ffffffffc0204844:	00002617          	auipc	a2,0x2
ffffffffc0204848:	9d460613          	addi	a2,a2,-1580 # ffffffffc0206218 <etext+0x9e2>
ffffffffc020484c:	40100593          	li	a1,1025
ffffffffc0204850:	00002517          	auipc	a0,0x2
ffffffffc0204854:	7a850513          	addi	a0,a0,1960 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204858:	beffb0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc020485c:	7ff8                	ld	a4,248(a5)
ffffffffc020485e:	ff79                	bnez	a4,ffffffffc020483c <init_main+0x48>
ffffffffc0204860:	1007b703          	ld	a4,256(a5)
ffffffffc0204864:	ff61                	bnez	a4,ffffffffc020483c <init_main+0x48>
    
    // 检查当前系统只剩下2个进程：idleproc和initproc
    assert(nr_process == 2);
ffffffffc0204866:	00097697          	auipc	a3,0x97
ffffffffc020486a:	df26a683          	lw	a3,-526(a3) # ffffffffc029b658 <nr_process>
ffffffffc020486e:	4709                	li	a4,2
ffffffffc0204870:	02e68e63          	beq	a3,a4,ffffffffc02048ac <init_main+0xb8>
ffffffffc0204874:	00003697          	auipc	a3,0x3
ffffffffc0204878:	8dc68693          	addi	a3,a3,-1828 # ffffffffc0207150 <etext+0x191a>
ffffffffc020487c:	00002617          	auipc	a2,0x2
ffffffffc0204880:	99c60613          	addi	a2,a2,-1636 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0204884:	40400593          	li	a1,1028
ffffffffc0204888:	00002517          	auipc	a0,0x2
ffffffffc020488c:	77050513          	addi	a0,a0,1904 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204890:	bb7fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("create user_main failed.\n");
ffffffffc0204894:	00003617          	auipc	a2,0x3
ffffffffc0204898:	82460613          	addi	a2,a2,-2012 # ffffffffc02070b8 <etext+0x1882>
ffffffffc020489c:	3ef00593          	li	a1,1007
ffffffffc02048a0:	00002517          	auipc	a0,0x2
ffffffffc02048a4:	75850513          	addi	a0,a0,1880 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc02048a8:	b9ffb0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02048ac:	00097717          	auipc	a4,0x97
ffffffffc02048b0:	d3470713          	addi	a4,a4,-716 # ffffffffc029b5e0 <proc_list>
    
    // 检查进程链表中只有initproc一个进程节点
    // list_next应该指向initproc的list_link（只有一个节点时，next指向自己）
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02048b4:	6714                	ld	a3,8(a4)
ffffffffc02048b6:	0c878793          	addi	a5,a5,200
ffffffffc02048ba:	02d78263          	beq	a5,a3,ffffffffc02048de <init_main+0xea>
ffffffffc02048be:	00003697          	auipc	a3,0x3
ffffffffc02048c2:	8a268693          	addi	a3,a3,-1886 # ffffffffc0207160 <etext+0x192a>
ffffffffc02048c6:	00002617          	auipc	a2,0x2
ffffffffc02048ca:	95260613          	addi	a2,a2,-1710 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02048ce:	40800593          	li	a1,1032
ffffffffc02048d2:	00002517          	auipc	a0,0x2
ffffffffc02048d6:	72650513          	addi	a0,a0,1830 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc02048da:	b6dfb0ef          	jal	ffffffffc0200446 <__panic>
    // list_prev应该指向initproc的list_link（只有一个节点时，prev指向自己）
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02048de:	6318                	ld	a4,0(a4)
ffffffffc02048e0:	02e78263          	beq	a5,a4,ffffffffc0204904 <init_main+0x110>
ffffffffc02048e4:	00003697          	auipc	a3,0x3
ffffffffc02048e8:	8ac68693          	addi	a3,a3,-1876 # ffffffffc0207190 <etext+0x195a>
ffffffffc02048ec:	00002617          	auipc	a2,0x2
ffffffffc02048f0:	92c60613          	addi	a2,a2,-1748 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02048f4:	40a00593          	li	a1,1034
ffffffffc02048f8:	00002517          	auipc	a0,0x2
ffffffffc02048fc:	70050513          	addi	a0,a0,1792 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204900:	b47fb0ef          	jal	ffffffffc0200446 <__panic>

    // 内存检查通过（暗示没有内存泄漏）
    cprintf("init check memory pass.\n");
ffffffffc0204904:	00003517          	auipc	a0,0x3
ffffffffc0204908:	8bc50513          	addi	a0,a0,-1860 # ffffffffc02071c0 <etext+0x198a>
ffffffffc020490c:	889fb0ef          	jal	ffffffffc0200194 <cprintf>
    while (1);
ffffffffc0204910:	a001                	j	ffffffffc0204910 <init_main+0x11c>

ffffffffc0204912 <do_execve>:
{
ffffffffc0204912:	7171                	addi	sp,sp,-176
ffffffffc0204914:	e8ea                	sd	s10,80(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204916:	00097d17          	auipc	s10,0x97
ffffffffc020491a:	d4ad0d13          	addi	s10,s10,-694 # ffffffffc029b660 <current>
ffffffffc020491e:	000d3783          	ld	a5,0(s10)
{
ffffffffc0204922:	ed26                	sd	s1,152(sp)
ffffffffc0204924:	f122                	sd	s0,160(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204926:	7784                	ld	s1,40(a5)
{
ffffffffc0204928:	842e                	mv	s0,a1
ffffffffc020492a:	e94a                	sd	s2,144(sp)
ffffffffc020492c:	ec32                	sd	a2,24(sp)
ffffffffc020492e:	892a                	mv	s2,a0
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204930:	85aa                	mv	a1,a0
ffffffffc0204932:	8622                	mv	a2,s0
ffffffffc0204934:	8526                	mv	a0,s1
ffffffffc0204936:	4681                	li	a3,0
{
ffffffffc0204938:	f506                	sd	ra,168(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020493a:	cbaff0ef          	jal	ffffffffc0203df4 <user_mem_check>
ffffffffc020493e:	46050363          	beqz	a0,ffffffffc0204da4 <do_execve+0x492>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204942:	4641                	li	a2,16
ffffffffc0204944:	1808                	addi	a0,sp,48
ffffffffc0204946:	4581                	li	a1,0
ffffffffc0204948:	6c5000ef          	jal	ffffffffc020580c <memset>
    if (len > PROC_NAME_LEN)
ffffffffc020494c:	47bd                	li	a5,15
ffffffffc020494e:	8622                	mv	a2,s0
ffffffffc0204950:	0e87ec63          	bltu	a5,s0,ffffffffc0204a48 <do_execve+0x136>
    memcpy(local_name, name, len);
ffffffffc0204954:	85ca                	mv	a1,s2
ffffffffc0204956:	1808                	addi	a0,sp,48
ffffffffc0204958:	6c7000ef          	jal	ffffffffc020581e <memcpy>
    if (mm != NULL)
ffffffffc020495c:	0e048d63          	beqz	s1,ffffffffc0204a56 <do_execve+0x144>
        cputs("mm != NULL");
ffffffffc0204960:	00002517          	auipc	a0,0x2
ffffffffc0204964:	46050513          	addi	a0,a0,1120 # ffffffffc0206dc0 <etext+0x158a>
ffffffffc0204968:	863fb0ef          	jal	ffffffffc02001ca <cputs>
ffffffffc020496c:	00097797          	auipc	a5,0x97
ffffffffc0204970:	cc47b783          	ld	a5,-828(a5) # ffffffffc029b630 <boot_pgdir_pa>
ffffffffc0204974:	577d                	li	a4,-1
ffffffffc0204976:	177e                	slli	a4,a4,0x3f
ffffffffc0204978:	83b1                	srli	a5,a5,0xc
ffffffffc020497a:	8fd9                	or	a5,a5,a4
ffffffffc020497c:	18079073          	csrw	satp,a5
ffffffffc0204980:	589c                	lw	a5,48(s1)
ffffffffc0204982:	37fd                	addiw	a5,a5,-1
ffffffffc0204984:	d89c                	sw	a5,48(s1)
        if (mm_count_dec(mm) == 0)
ffffffffc0204986:	2e078c63          	beqz	a5,ffffffffc0204c7e <do_execve+0x36c>
        current->mm = NULL;
ffffffffc020498a:	000d3783          	ld	a5,0(s10)
ffffffffc020498e:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204992:	dd7fe0ef          	jal	ffffffffc0203768 <mm_create>
ffffffffc0204996:	84aa                	mv	s1,a0
ffffffffc0204998:	20050863          	beqz	a0,ffffffffc0204ba8 <do_execve+0x296>
    if ((page = alloc_page()) == NULL)
ffffffffc020499c:	4505                	li	a0,1
ffffffffc020499e:	d68fd0ef          	jal	ffffffffc0201f06 <alloc_pages>
ffffffffc02049a2:	40050663          	beqz	a0,ffffffffc0204dae <do_execve+0x49c>
    return page - pages + nbase;
ffffffffc02049a6:	f4de                	sd	s7,104(sp)
ffffffffc02049a8:	00097b97          	auipc	s7,0x97
ffffffffc02049ac:	ca8b8b93          	addi	s7,s7,-856 # ffffffffc029b650 <pages>
ffffffffc02049b0:	000bb783          	ld	a5,0(s7)
ffffffffc02049b4:	f8da                	sd	s6,112(sp)
ffffffffc02049b6:	00003b17          	auipc	s6,0x3
ffffffffc02049ba:	feab3b03          	ld	s6,-22(s6) # ffffffffc02079a0 <nbase>
ffffffffc02049be:	40f506b3          	sub	a3,a0,a5
ffffffffc02049c2:	f0e2                	sd	s8,96(sp)
    return KADDR(page2pa(page));
ffffffffc02049c4:	00097c17          	auipc	s8,0x97
ffffffffc02049c8:	c84c0c13          	addi	s8,s8,-892 # ffffffffc029b648 <npage>
ffffffffc02049cc:	fcd6                	sd	s5,120(sp)
    return page - pages + nbase;
ffffffffc02049ce:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02049d0:	5afd                	li	s5,-1
ffffffffc02049d2:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc02049d6:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc02049d8:	00cad713          	srli	a4,s5,0xc
ffffffffc02049dc:	e83a                	sd	a4,16(sp)
ffffffffc02049de:	e152                	sd	s4,128(sp)
ffffffffc02049e0:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc02049e2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02049e4:	3ef77863          	bgeu	a4,a5,ffffffffc0204dd4 <do_execve+0x4c2>
ffffffffc02049e8:	00097a17          	auipc	s4,0x97
ffffffffc02049ec:	c58a0a13          	addi	s4,s4,-936 # ffffffffc029b640 <va_pa_offset>
ffffffffc02049f0:	000a3783          	ld	a5,0(s4)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02049f4:	00097597          	auipc	a1,0x97
ffffffffc02049f8:	c445b583          	ld	a1,-956(a1) # ffffffffc029b638 <boot_pgdir_va>
ffffffffc02049fc:	6605                	lui	a2,0x1
ffffffffc02049fe:	00f68433          	add	s0,a3,a5
ffffffffc0204a02:	8522                	mv	a0,s0
ffffffffc0204a04:	61b000ef          	jal	ffffffffc020581e <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204a08:	66e2                	ld	a3,24(sp)
ffffffffc0204a0a:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204a0e:	ec80                	sd	s0,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204a10:	4298                	lw	a4,0(a3)
ffffffffc0204a12:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464ba3c7>
ffffffffc0204a16:	06f70863          	beq	a4,a5,ffffffffc0204a86 <do_execve+0x174>
        ret = -E_INVAL_ELF;
ffffffffc0204a1a:	5461                	li	s0,-8
    put_pgdir(mm);
ffffffffc0204a1c:	8526                	mv	a0,s1
ffffffffc0204a1e:	d90ff0ef          	jal	ffffffffc0203fae <put_pgdir>
ffffffffc0204a22:	6a0a                	ld	s4,128(sp)
ffffffffc0204a24:	7ae6                	ld	s5,120(sp)
ffffffffc0204a26:	7b46                	ld	s6,112(sp)
ffffffffc0204a28:	7ba6                	ld	s7,104(sp)
ffffffffc0204a2a:	7c06                	ld	s8,96(sp)
    mm_destroy(mm);
ffffffffc0204a2c:	8526                	mv	a0,s1
ffffffffc0204a2e:	e79fe0ef          	jal	ffffffffc02038a6 <mm_destroy>
    do_exit(ret);
ffffffffc0204a32:	8522                	mv	a0,s0
ffffffffc0204a34:	e54e                	sd	s3,136(sp)
ffffffffc0204a36:	e152                	sd	s4,128(sp)
ffffffffc0204a38:	fcd6                	sd	s5,120(sp)
ffffffffc0204a3a:	f8da                	sd	s6,112(sp)
ffffffffc0204a3c:	f4de                	sd	s7,104(sp)
ffffffffc0204a3e:	f0e2                	sd	s8,96(sp)
ffffffffc0204a40:	ece6                	sd	s9,88(sp)
ffffffffc0204a42:	e4ee                	sd	s11,72(sp)
ffffffffc0204a44:	a8bff0ef          	jal	ffffffffc02044ce <do_exit>
    if (len > PROC_NAME_LEN)
ffffffffc0204a48:	863e                	mv	a2,a5
    memcpy(local_name, name, len);
ffffffffc0204a4a:	85ca                	mv	a1,s2
ffffffffc0204a4c:	1808                	addi	a0,sp,48
ffffffffc0204a4e:	5d1000ef          	jal	ffffffffc020581e <memcpy>
    if (mm != NULL)
ffffffffc0204a52:	f00497e3          	bnez	s1,ffffffffc0204960 <do_execve+0x4e>
    if (current->mm != NULL)
ffffffffc0204a56:	000d3783          	ld	a5,0(s10)
ffffffffc0204a5a:	779c                	ld	a5,40(a5)
ffffffffc0204a5c:	db9d                	beqz	a5,ffffffffc0204992 <do_execve+0x80>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204a5e:	00002617          	auipc	a2,0x2
ffffffffc0204a62:	78260613          	addi	a2,a2,1922 # ffffffffc02071e0 <etext+0x19aa>
ffffffffc0204a66:	25600593          	li	a1,598
ffffffffc0204a6a:	00002517          	auipc	a0,0x2
ffffffffc0204a6e:	58e50513          	addi	a0,a0,1422 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204a72:	e54e                	sd	s3,136(sp)
ffffffffc0204a74:	e152                	sd	s4,128(sp)
ffffffffc0204a76:	fcd6                	sd	s5,120(sp)
ffffffffc0204a78:	f8da                	sd	s6,112(sp)
ffffffffc0204a7a:	f4de                	sd	s7,104(sp)
ffffffffc0204a7c:	f0e2                	sd	s8,96(sp)
ffffffffc0204a7e:	ece6                	sd	s9,88(sp)
ffffffffc0204a80:	e4ee                	sd	s11,72(sp)
ffffffffc0204a82:	9c5fb0ef          	jal	ffffffffc0200446 <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204a86:	0386d703          	lhu	a4,56(a3)
ffffffffc0204a8a:	e54e                	sd	s3,136(sp)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204a8c:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204a90:	00371793          	slli	a5,a4,0x3
ffffffffc0204a94:	8f99                	sub	a5,a5,a4
ffffffffc0204a96:	078e                	slli	a5,a5,0x3
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204a98:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204a9a:	97ce                	add	a5,a5,s3
ffffffffc0204a9c:	ece6                	sd	s9,88(sp)
ffffffffc0204a9e:	f43e                	sd	a5,40(sp)
    struct Page *page = NULL;
ffffffffc0204aa0:	4c81                	li	s9,0
    for (; ph < ph_end; ph++)
ffffffffc0204aa2:	00f9fe63          	bgeu	s3,a5,ffffffffc0204abe <do_execve+0x1ac>
ffffffffc0204aa6:	e4ee                	sd	s11,72(sp)
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204aa8:	0009a783          	lw	a5,0(s3)
ffffffffc0204aac:	4705                	li	a4,1
ffffffffc0204aae:	0ee78f63          	beq	a5,a4,ffffffffc0204bac <do_execve+0x29a>
    for (; ph < ph_end; ph++)
ffffffffc0204ab2:	77a2                	ld	a5,40(sp)
ffffffffc0204ab4:	03898993          	addi	s3,s3,56
ffffffffc0204ab8:	fef9e8e3          	bltu	s3,a5,ffffffffc0204aa8 <do_execve+0x196>
ffffffffc0204abc:	6da6                	ld	s11,72(sp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204abe:	4701                	li	a4,0
ffffffffc0204ac0:	46ad                	li	a3,11
ffffffffc0204ac2:	00100637          	lui	a2,0x100
ffffffffc0204ac6:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204aca:	8526                	mv	a0,s1
ffffffffc0204acc:	e2dfe0ef          	jal	ffffffffc02038f8 <mm_map>
ffffffffc0204ad0:	842a                	mv	s0,a0
ffffffffc0204ad2:	1a051063          	bnez	a0,ffffffffc0204c72 <do_execve+0x360>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204ad6:	6c88                	ld	a0,24(s1)
ffffffffc0204ad8:	467d                	li	a2,31
ffffffffc0204ada:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204ade:	ba9fe0ef          	jal	ffffffffc0203686 <pgdir_alloc_page>
ffffffffc0204ae2:	38050863          	beqz	a0,ffffffffc0204e72 <do_execve+0x560>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ae6:	6c88                	ld	a0,24(s1)
ffffffffc0204ae8:	467d                	li	a2,31
ffffffffc0204aea:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204aee:	b99fe0ef          	jal	ffffffffc0203686 <pgdir_alloc_page>
ffffffffc0204af2:	34050f63          	beqz	a0,ffffffffc0204e50 <do_execve+0x53e>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204af6:	6c88                	ld	a0,24(s1)
ffffffffc0204af8:	467d                	li	a2,31
ffffffffc0204afa:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204afe:	b89fe0ef          	jal	ffffffffc0203686 <pgdir_alloc_page>
ffffffffc0204b02:	32050663          	beqz	a0,ffffffffc0204e2e <do_execve+0x51c>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b06:	6c88                	ld	a0,24(s1)
ffffffffc0204b08:	467d                	li	a2,31
ffffffffc0204b0a:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204b0e:	b79fe0ef          	jal	ffffffffc0203686 <pgdir_alloc_page>
ffffffffc0204b12:	2e050d63          	beqz	a0,ffffffffc0204e0c <do_execve+0x4fa>
    mm->mm_count += 1;
ffffffffc0204b16:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204b18:	000d3603          	ld	a2,0(s10)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b1c:	6c94                	ld	a3,24(s1)
ffffffffc0204b1e:	2785                	addiw	a5,a5,1
ffffffffc0204b20:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204b22:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b24:	c02007b7          	lui	a5,0xc0200
ffffffffc0204b28:	2cf6e563          	bltu	a3,a5,ffffffffc0204df2 <do_execve+0x4e0>
ffffffffc0204b2c:	000a3783          	ld	a5,0(s4)
ffffffffc0204b30:	577d                	li	a4,-1
ffffffffc0204b32:	177e                	slli	a4,a4,0x3f
ffffffffc0204b34:	8e9d                	sub	a3,a3,a5
ffffffffc0204b36:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204b3a:	f654                	sd	a3,168(a2)
ffffffffc0204b3c:	8fd9                	or	a5,a5,a4
ffffffffc0204b3e:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204b42:	7244                	ld	s1,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204b44:	4581                	li	a1,0
ffffffffc0204b46:	12000613          	li	a2,288
ffffffffc0204b4a:	8526                	mv	a0,s1
    uintptr_t sstatus = tf->status;
ffffffffc0204b4c:	1004b903          	ld	s2,256(s1)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204b50:	4bd000ef          	jal	ffffffffc020580c <memset>
    tf->epc = elf->e_entry;
ffffffffc0204b54:	67e2                	ld	a5,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204b56:	000d3983          	ld	s3,0(s10)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204b5a:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry;
ffffffffc0204b5e:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204b60:	4785                	li	a5,1
ffffffffc0204b62:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204b64:	02096913          	ori	s2,s2,32
    tf->epc = elf->e_entry;
ffffffffc0204b68:	10e4b423          	sd	a4,264(s1)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204b6c:	e89c                	sd	a5,16(s1)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204b6e:	0b498513          	addi	a0,s3,180
ffffffffc0204b72:	4641                	li	a2,16
ffffffffc0204b74:	4581                	li	a1,0
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204b76:	1124b023          	sd	s2,256(s1)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204b7a:	493000ef          	jal	ffffffffc020580c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204b7e:	0b498513          	addi	a0,s3,180
ffffffffc0204b82:	180c                	addi	a1,sp,48
ffffffffc0204b84:	463d                	li	a2,15
ffffffffc0204b86:	499000ef          	jal	ffffffffc020581e <memcpy>
ffffffffc0204b8a:	69aa                	ld	s3,136(sp)
ffffffffc0204b8c:	6a0a                	ld	s4,128(sp)
ffffffffc0204b8e:	7ae6                	ld	s5,120(sp)
ffffffffc0204b90:	7b46                	ld	s6,112(sp)
ffffffffc0204b92:	7ba6                	ld	s7,104(sp)
ffffffffc0204b94:	7c06                	ld	s8,96(sp)
ffffffffc0204b96:	6ce6                	ld	s9,88(sp)
}
ffffffffc0204b98:	70aa                	ld	ra,168(sp)
ffffffffc0204b9a:	8522                	mv	a0,s0
ffffffffc0204b9c:	740a                	ld	s0,160(sp)
ffffffffc0204b9e:	64ea                	ld	s1,152(sp)
ffffffffc0204ba0:	694a                	ld	s2,144(sp)
ffffffffc0204ba2:	6d46                	ld	s10,80(sp)
ffffffffc0204ba4:	614d                	addi	sp,sp,176
ffffffffc0204ba6:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0204ba8:	5471                	li	s0,-4
ffffffffc0204baa:	b561                	j	ffffffffc0204a32 <do_execve+0x120>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204bac:	0289b603          	ld	a2,40(s3)
ffffffffc0204bb0:	0209b783          	ld	a5,32(s3)
ffffffffc0204bb4:	20f66163          	bltu	a2,a5,ffffffffc0204db6 <do_execve+0x4a4>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204bb8:	0049a783          	lw	a5,4(s3)
ffffffffc0204bbc:	0027971b          	slliw	a4,a5,0x2
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204bc0:	0027f693          	andi	a3,a5,2
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204bc4:	8b11                	andi	a4,a4,4
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204bc6:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204bc8:	c6e9                	beqz	a3,ffffffffc0204c92 <do_execve+0x380>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204bca:	1c079563          	bnez	a5,ffffffffc0204d94 <do_execve+0x482>
            perm |= (PTE_W | PTE_R);
ffffffffc0204bce:	47dd                	li	a5,23
            vm_flags |= VM_WRITE;
ffffffffc0204bd0:	00276693          	ori	a3,a4,2
            perm |= (PTE_W | PTE_R);
ffffffffc0204bd4:	e43e                	sd	a5,8(sp)
        if (vm_flags & VM_EXEC)
ffffffffc0204bd6:	c709                	beqz	a4,ffffffffc0204be0 <do_execve+0x2ce>
            perm |= PTE_X;
ffffffffc0204bd8:	67a2                	ld	a5,8(sp)
ffffffffc0204bda:	0087e793          	ori	a5,a5,8
ffffffffc0204bde:	e43e                	sd	a5,8(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204be0:	0109b583          	ld	a1,16(s3)
ffffffffc0204be4:	4701                	li	a4,0
ffffffffc0204be6:	8526                	mv	a0,s1
ffffffffc0204be8:	d11fe0ef          	jal	ffffffffc02038f8 <mm_map>
ffffffffc0204bec:	842a                	mv	s0,a0
ffffffffc0204bee:	1c051263          	bnez	a0,ffffffffc0204db2 <do_execve+0x4a0>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204bf2:	0109ba83          	ld	s5,16(s3)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204bf6:	0209b403          	ld	s0,32(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204bfa:	77fd                	lui	a5,0xfffff
ffffffffc0204bfc:	00faf5b3          	and	a1,s5,a5
        end = ph->p_va + ph->p_filesz;
ffffffffc0204c00:	9456                	add	s0,s0,s5
        while (start < end)
ffffffffc0204c02:	1a8af363          	bgeu	s5,s0,ffffffffc0204da8 <do_execve+0x496>
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204c06:	0089b903          	ld	s2,8(s3)
ffffffffc0204c0a:	67e2                	ld	a5,24(sp)
ffffffffc0204c0c:	993e                	add	s2,s2,a5
ffffffffc0204c0e:	a881                	j	ffffffffc0204c5e <do_execve+0x34c>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c10:	6785                	lui	a5,0x1
ffffffffc0204c12:	00f58db3          	add	s11,a1,a5
                size -= la - end;
ffffffffc0204c16:	41540633          	sub	a2,s0,s5
            if (end < la)
ffffffffc0204c1a:	01b46463          	bltu	s0,s11,ffffffffc0204c22 <do_execve+0x310>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c1e:	415d8633          	sub	a2,s11,s5
    return page - pages + nbase;
ffffffffc0204c22:	000bb683          	ld	a3,0(s7)
    return KADDR(page2pa(page));
ffffffffc0204c26:	67c2                	ld	a5,16(sp)
ffffffffc0204c28:	000c3503          	ld	a0,0(s8)
    return page - pages + nbase;
ffffffffc0204c2c:	40dc86b3          	sub	a3,s9,a3
ffffffffc0204c30:	8699                	srai	a3,a3,0x6
ffffffffc0204c32:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204c34:	00f6f8b3          	and	a7,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c38:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c3a:	18a8f163          	bgeu	a7,a0,ffffffffc0204dbc <do_execve+0x4aa>
ffffffffc0204c3e:	000a3503          	ld	a0,0(s4)
ffffffffc0204c42:	40ba85b3          	sub	a1,s5,a1
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204c46:	e032                	sd	a2,0(sp)
ffffffffc0204c48:	9536                	add	a0,a0,a3
ffffffffc0204c4a:	952e                	add	a0,a0,a1
ffffffffc0204c4c:	85ca                	mv	a1,s2
ffffffffc0204c4e:	3d1000ef          	jal	ffffffffc020581e <memcpy>
            start += size, from += size;
ffffffffc0204c52:	6602                	ld	a2,0(sp)
ffffffffc0204c54:	9ab2                	add	s5,s5,a2
ffffffffc0204c56:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204c58:	048af463          	bgeu	s5,s0,ffffffffc0204ca0 <do_execve+0x38e>
ffffffffc0204c5c:	85ee                	mv	a1,s11
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204c5e:	6c88                	ld	a0,24(s1)
ffffffffc0204c60:	6622                	ld	a2,8(sp)
ffffffffc0204c62:	e02e                	sd	a1,0(sp)
ffffffffc0204c64:	a23fe0ef          	jal	ffffffffc0203686 <pgdir_alloc_page>
ffffffffc0204c68:	6582                	ld	a1,0(sp)
ffffffffc0204c6a:	8caa                	mv	s9,a0
ffffffffc0204c6c:	f155                	bnez	a0,ffffffffc0204c10 <do_execve+0x2fe>
ffffffffc0204c6e:	6da6                	ld	s11,72(sp)
        ret = -E_NO_MEM;
ffffffffc0204c70:	5471                	li	s0,-4
    exit_mmap(mm);
ffffffffc0204c72:	8526                	mv	a0,s1
ffffffffc0204c74:	de9fe0ef          	jal	ffffffffc0203a5c <exit_mmap>
ffffffffc0204c78:	69aa                	ld	s3,136(sp)
ffffffffc0204c7a:	6ce6                	ld	s9,88(sp)
ffffffffc0204c7c:	b345                	j	ffffffffc0204a1c <do_execve+0x10a>
            exit_mmap(mm);
ffffffffc0204c7e:	8526                	mv	a0,s1
ffffffffc0204c80:	dddfe0ef          	jal	ffffffffc0203a5c <exit_mmap>
            put_pgdir(mm);
ffffffffc0204c84:	8526                	mv	a0,s1
ffffffffc0204c86:	b28ff0ef          	jal	ffffffffc0203fae <put_pgdir>
            mm_destroy(mm);
ffffffffc0204c8a:	8526                	mv	a0,s1
ffffffffc0204c8c:	c1bfe0ef          	jal	ffffffffc02038a6 <mm_destroy>
ffffffffc0204c90:	b9ed                	j	ffffffffc020498a <do_execve+0x78>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204c92:	0e078d63          	beqz	a5,ffffffffc0204d8c <do_execve+0x47a>
            perm |= PTE_R;
ffffffffc0204c96:	47cd                	li	a5,19
            vm_flags |= VM_READ;
ffffffffc0204c98:	00176693          	ori	a3,a4,1
            perm |= PTE_R;
ffffffffc0204c9c:	e43e                	sd	a5,8(sp)
ffffffffc0204c9e:	bf25                	j	ffffffffc0204bd6 <do_execve+0x2c4>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204ca0:	0109b403          	ld	s0,16(s3)
ffffffffc0204ca4:	0289b683          	ld	a3,40(s3)
ffffffffc0204ca8:	9436                	add	s0,s0,a3
        if (start < la)
ffffffffc0204caa:	07bafc63          	bgeu	s5,s11,ffffffffc0204d22 <do_execve+0x410>
            if (start == end)
ffffffffc0204cae:	e15402e3          	beq	s0,s5,ffffffffc0204ab2 <do_execve+0x1a0>
                size -= la - end;
ffffffffc0204cb2:	41540933          	sub	s2,s0,s5
            if (end < la)
ffffffffc0204cb6:	0fb47463          	bgeu	s0,s11,ffffffffc0204d9e <do_execve+0x48c>
    return page - pages + nbase;
ffffffffc0204cba:	000bb683          	ld	a3,0(s7)
    return KADDR(page2pa(page));
ffffffffc0204cbe:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204cc2:	40dc86b3          	sub	a3,s9,a3
ffffffffc0204cc6:	8699                	srai	a3,a3,0x6
ffffffffc0204cc8:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204cca:	00c69613          	slli	a2,a3,0xc
ffffffffc0204cce:	8231                	srli	a2,a2,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204cd0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204cd2:	0eb67563          	bgeu	a2,a1,ffffffffc0204dbc <do_execve+0x4aa>
ffffffffc0204cd6:	000a3603          	ld	a2,0(s4)
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204cda:	6505                	lui	a0,0x1
ffffffffc0204cdc:	9556                	add	a0,a0,s5
ffffffffc0204cde:	96b2                	add	a3,a3,a2
ffffffffc0204ce0:	41b50533          	sub	a0,a0,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204ce4:	9536                	add	a0,a0,a3
ffffffffc0204ce6:	864a                	mv	a2,s2
ffffffffc0204ce8:	4581                	li	a1,0
ffffffffc0204cea:	323000ef          	jal	ffffffffc020580c <memset>
            start += size;
ffffffffc0204cee:	9aca                	add	s5,s5,s2
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204cf0:	01b436b3          	sltu	a3,s0,s11
ffffffffc0204cf4:	01b47463          	bgeu	s0,s11,ffffffffc0204cfc <do_execve+0x3ea>
ffffffffc0204cf8:	db540de3          	beq	s0,s5,ffffffffc0204ab2 <do_execve+0x1a0>
ffffffffc0204cfc:	e299                	bnez	a3,ffffffffc0204d02 <do_execve+0x3f0>
ffffffffc0204cfe:	03ba8263          	beq	s5,s11,ffffffffc0204d22 <do_execve+0x410>
ffffffffc0204d02:	00002697          	auipc	a3,0x2
ffffffffc0204d06:	50668693          	addi	a3,a3,1286 # ffffffffc0207208 <etext+0x19d2>
ffffffffc0204d0a:	00001617          	auipc	a2,0x1
ffffffffc0204d0e:	50e60613          	addi	a2,a2,1294 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0204d12:	2bf00593          	li	a1,703
ffffffffc0204d16:	00002517          	auipc	a0,0x2
ffffffffc0204d1a:	2e250513          	addi	a0,a0,738 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204d1e:	f28fb0ef          	jal	ffffffffc0200446 <__panic>
        while (start < end)
ffffffffc0204d22:	d88af8e3          	bgeu	s5,s0,ffffffffc0204ab2 <do_execve+0x1a0>
ffffffffc0204d26:	56fd                	li	a3,-1
ffffffffc0204d28:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204d2c:	f03e                	sd	a5,32(sp)
ffffffffc0204d2e:	a0b9                	j	ffffffffc0204d7c <do_execve+0x46a>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204d30:	6785                	lui	a5,0x1
ffffffffc0204d32:	00fd88b3          	add	a7,s11,a5
                size -= la - end;
ffffffffc0204d36:	41540933          	sub	s2,s0,s5
            if (end < la)
ffffffffc0204d3a:	01146463          	bltu	s0,a7,ffffffffc0204d42 <do_execve+0x430>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204d3e:	41588933          	sub	s2,a7,s5
    return page - pages + nbase;
ffffffffc0204d42:	000bb683          	ld	a3,0(s7)
    return KADDR(page2pa(page));
ffffffffc0204d46:	7782                	ld	a5,32(sp)
ffffffffc0204d48:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204d4c:	40dc86b3          	sub	a3,s9,a3
ffffffffc0204d50:	8699                	srai	a3,a3,0x6
ffffffffc0204d52:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204d54:	00f6f533          	and	a0,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204d58:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204d5a:	06b57163          	bgeu	a0,a1,ffffffffc0204dbc <do_execve+0x4aa>
ffffffffc0204d5e:	000a3583          	ld	a1,0(s4)
ffffffffc0204d62:	41ba8533          	sub	a0,s5,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204d66:	864a                	mv	a2,s2
ffffffffc0204d68:	96ae                	add	a3,a3,a1
ffffffffc0204d6a:	9536                	add	a0,a0,a3
ffffffffc0204d6c:	4581                	li	a1,0
            start += size;
ffffffffc0204d6e:	9aca                	add	s5,s5,s2
ffffffffc0204d70:	e046                	sd	a7,0(sp)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204d72:	29b000ef          	jal	ffffffffc020580c <memset>
        while (start < end)
ffffffffc0204d76:	d28afee3          	bgeu	s5,s0,ffffffffc0204ab2 <do_execve+0x1a0>
ffffffffc0204d7a:	6d82                	ld	s11,0(sp)
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204d7c:	6c88                	ld	a0,24(s1)
ffffffffc0204d7e:	6622                	ld	a2,8(sp)
ffffffffc0204d80:	85ee                	mv	a1,s11
ffffffffc0204d82:	905fe0ef          	jal	ffffffffc0203686 <pgdir_alloc_page>
ffffffffc0204d86:	8caa                	mv	s9,a0
ffffffffc0204d88:	f545                	bnez	a0,ffffffffc0204d30 <do_execve+0x41e>
ffffffffc0204d8a:	b5d5                	j	ffffffffc0204c6e <do_execve+0x35c>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204d8c:	47c5                	li	a5,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204d8e:	86ba                	mv	a3,a4
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204d90:	e43e                	sd	a5,8(sp)
ffffffffc0204d92:	b591                	j	ffffffffc0204bd6 <do_execve+0x2c4>
            perm |= (PTE_W | PTE_R);
ffffffffc0204d94:	47dd                	li	a5,23
            vm_flags |= VM_READ;
ffffffffc0204d96:	00376693          	ori	a3,a4,3
            perm |= (PTE_W | PTE_R);
ffffffffc0204d9a:	e43e                	sd	a5,8(sp)
ffffffffc0204d9c:	bd2d                	j	ffffffffc0204bd6 <do_execve+0x2c4>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204d9e:	415d8933          	sub	s2,s11,s5
ffffffffc0204da2:	bf21                	j	ffffffffc0204cba <do_execve+0x3a8>
        return -E_INVAL;
ffffffffc0204da4:	5475                	li	s0,-3
ffffffffc0204da6:	bbcd                	j	ffffffffc0204b98 <do_execve+0x286>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204da8:	8dae                	mv	s11,a1
        while (start < end)
ffffffffc0204daa:	8456                	mv	s0,s5
ffffffffc0204dac:	bde5                	j	ffffffffc0204ca4 <do_execve+0x392>
    int ret = -E_NO_MEM;
ffffffffc0204dae:	5471                	li	s0,-4
ffffffffc0204db0:	b9b5                	j	ffffffffc0204a2c <do_execve+0x11a>
ffffffffc0204db2:	6da6                	ld	s11,72(sp)
ffffffffc0204db4:	bd7d                	j	ffffffffc0204c72 <do_execve+0x360>
            ret = -E_INVAL_ELF;
ffffffffc0204db6:	6da6                	ld	s11,72(sp)
ffffffffc0204db8:	5461                	li	s0,-8
ffffffffc0204dba:	bd65                	j	ffffffffc0204c72 <do_execve+0x360>
ffffffffc0204dbc:	00002617          	auipc	a2,0x2
ffffffffc0204dc0:	80c60613          	addi	a2,a2,-2036 # ffffffffc02065c8 <etext+0xd92>
ffffffffc0204dc4:	07100593          	li	a1,113
ffffffffc0204dc8:	00002517          	auipc	a0,0x2
ffffffffc0204dcc:	82850513          	addi	a0,a0,-2008 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0204dd0:	e76fb0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0204dd4:	00001617          	auipc	a2,0x1
ffffffffc0204dd8:	7f460613          	addi	a2,a2,2036 # ffffffffc02065c8 <etext+0xd92>
ffffffffc0204ddc:	07100593          	li	a1,113
ffffffffc0204de0:	00002517          	auipc	a0,0x2
ffffffffc0204de4:	81050513          	addi	a0,a0,-2032 # ffffffffc02065f0 <etext+0xdba>
ffffffffc0204de8:	e54e                	sd	s3,136(sp)
ffffffffc0204dea:	ece6                	sd	s9,88(sp)
ffffffffc0204dec:	e4ee                	sd	s11,72(sp)
ffffffffc0204dee:	e58fb0ef          	jal	ffffffffc0200446 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204df2:	00002617          	auipc	a2,0x2
ffffffffc0204df6:	87e60613          	addi	a2,a2,-1922 # ffffffffc0206670 <etext+0xe3a>
ffffffffc0204dfa:	2de00593          	li	a1,734
ffffffffc0204dfe:	00002517          	auipc	a0,0x2
ffffffffc0204e02:	1fa50513          	addi	a0,a0,506 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204e06:	e4ee                	sd	s11,72(sp)
ffffffffc0204e08:	e3efb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204e0c:	00002697          	auipc	a3,0x2
ffffffffc0204e10:	51468693          	addi	a3,a3,1300 # ffffffffc0207320 <etext+0x1aea>
ffffffffc0204e14:	00001617          	auipc	a2,0x1
ffffffffc0204e18:	40460613          	addi	a2,a2,1028 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0204e1c:	2d900593          	li	a1,729
ffffffffc0204e20:	00002517          	auipc	a0,0x2
ffffffffc0204e24:	1d850513          	addi	a0,a0,472 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204e28:	e4ee                	sd	s11,72(sp)
ffffffffc0204e2a:	e1cfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204e2e:	00002697          	auipc	a3,0x2
ffffffffc0204e32:	4aa68693          	addi	a3,a3,1194 # ffffffffc02072d8 <etext+0x1aa2>
ffffffffc0204e36:	00001617          	auipc	a2,0x1
ffffffffc0204e3a:	3e260613          	addi	a2,a2,994 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0204e3e:	2d800593          	li	a1,728
ffffffffc0204e42:	00002517          	auipc	a0,0x2
ffffffffc0204e46:	1b650513          	addi	a0,a0,438 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204e4a:	e4ee                	sd	s11,72(sp)
ffffffffc0204e4c:	dfafb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204e50:	00002697          	auipc	a3,0x2
ffffffffc0204e54:	44068693          	addi	a3,a3,1088 # ffffffffc0207290 <etext+0x1a5a>
ffffffffc0204e58:	00001617          	auipc	a2,0x1
ffffffffc0204e5c:	3c060613          	addi	a2,a2,960 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0204e60:	2d700593          	li	a1,727
ffffffffc0204e64:	00002517          	auipc	a0,0x2
ffffffffc0204e68:	19450513          	addi	a0,a0,404 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204e6c:	e4ee                	sd	s11,72(sp)
ffffffffc0204e6e:	dd8fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204e72:	00002697          	auipc	a3,0x2
ffffffffc0204e76:	3d668693          	addi	a3,a3,982 # ffffffffc0207248 <etext+0x1a12>
ffffffffc0204e7a:	00001617          	auipc	a2,0x1
ffffffffc0204e7e:	39e60613          	addi	a2,a2,926 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0204e82:	2d600593          	li	a1,726
ffffffffc0204e86:	00002517          	auipc	a0,0x2
ffffffffc0204e8a:	17250513          	addi	a0,a0,370 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc0204e8e:	e4ee                	sd	s11,72(sp)
ffffffffc0204e90:	db6fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204e94 <do_yield>:
    current->need_resched = 1;
ffffffffc0204e94:	00096797          	auipc	a5,0x96
ffffffffc0204e98:	7cc7b783          	ld	a5,1996(a5) # ffffffffc029b660 <current>
ffffffffc0204e9c:	4705                	li	a4,1
}
ffffffffc0204e9e:	4501                	li	a0,0
    current->need_resched = 1;
ffffffffc0204ea0:	ef98                	sd	a4,24(a5)
}
ffffffffc0204ea2:	8082                	ret

ffffffffc0204ea4 <do_wait>:
    if (code_store != NULL)
ffffffffc0204ea4:	c59d                	beqz	a1,ffffffffc0204ed2 <do_wait+0x2e>
{
ffffffffc0204ea6:	1101                	addi	sp,sp,-32
ffffffffc0204ea8:	e02a                	sd	a0,0(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204eaa:	00096517          	auipc	a0,0x96
ffffffffc0204eae:	7b653503          	ld	a0,1974(a0) # ffffffffc029b660 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204eb2:	4685                	li	a3,1
ffffffffc0204eb4:	4611                	li	a2,4
ffffffffc0204eb6:	7508                	ld	a0,40(a0)
{
ffffffffc0204eb8:	ec06                	sd	ra,24(sp)
ffffffffc0204eba:	e42e                	sd	a1,8(sp)
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204ebc:	f39fe0ef          	jal	ffffffffc0203df4 <user_mem_check>
ffffffffc0204ec0:	6702                	ld	a4,0(sp)
ffffffffc0204ec2:	67a2                	ld	a5,8(sp)
ffffffffc0204ec4:	c909                	beqz	a0,ffffffffc0204ed6 <do_wait+0x32>
}
ffffffffc0204ec6:	60e2                	ld	ra,24(sp)
ffffffffc0204ec8:	85be                	mv	a1,a5
ffffffffc0204eca:	853a                	mv	a0,a4
ffffffffc0204ecc:	6105                	addi	sp,sp,32
ffffffffc0204ece:	f44ff06f          	j	ffffffffc0204612 <do_wait.part.0>
ffffffffc0204ed2:	f40ff06f          	j	ffffffffc0204612 <do_wait.part.0>
ffffffffc0204ed6:	60e2                	ld	ra,24(sp)
ffffffffc0204ed8:	5575                	li	a0,-3
ffffffffc0204eda:	6105                	addi	sp,sp,32
ffffffffc0204edc:	8082                	ret

ffffffffc0204ede <do_kill>:
    if (0 < pid && pid < MAX_PID)
ffffffffc0204ede:	6789                	lui	a5,0x2
ffffffffc0204ee0:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204ee4:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bca>
ffffffffc0204ee6:	06e7e463          	bltu	a5,a4,ffffffffc0204f4e <do_kill+0x70>
{
ffffffffc0204eea:	1101                	addi	sp,sp,-32
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204eec:	45a9                	li	a1,10
{
ffffffffc0204eee:	ec06                	sd	ra,24(sp)
ffffffffc0204ef0:	e42a                	sd	a0,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204ef2:	484000ef          	jal	ffffffffc0205376 <hash32>
ffffffffc0204ef6:	02051793          	slli	a5,a0,0x20
ffffffffc0204efa:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204efe:	00092797          	auipc	a5,0x92
ffffffffc0204f02:	6e278793          	addi	a5,a5,1762 # ffffffffc02975e0 <hash_list>
ffffffffc0204f06:	96be                	add	a3,a3,a5
        while ((le = list_next(le)) != list)
ffffffffc0204f08:	6622                	ld	a2,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f0a:	8536                	mv	a0,a3
        while ((le = list_next(le)) != list)
ffffffffc0204f0c:	a029                	j	ffffffffc0204f16 <do_kill+0x38>
            if (proc->pid == pid)
ffffffffc0204f0e:	f2c52703          	lw	a4,-212(a0)
ffffffffc0204f12:	00c70963          	beq	a4,a2,ffffffffc0204f24 <do_kill+0x46>
ffffffffc0204f16:	6508                	ld	a0,8(a0)
        while ((le = list_next(le)) != list)
ffffffffc0204f18:	fea69be3          	bne	a3,a0,ffffffffc0204f0e <do_kill+0x30>
}
ffffffffc0204f1c:	60e2                	ld	ra,24(sp)
    return -E_INVAL;
ffffffffc0204f1e:	5575                	li	a0,-3
}
ffffffffc0204f20:	6105                	addi	sp,sp,32
ffffffffc0204f22:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204f24:	fd852703          	lw	a4,-40(a0)
ffffffffc0204f28:	00177693          	andi	a3,a4,1
ffffffffc0204f2c:	e29d                	bnez	a3,ffffffffc0204f52 <do_kill+0x74>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204f2e:	4954                	lw	a3,20(a0)
            proc->flags |= PF_EXITING;
ffffffffc0204f30:	00176713          	ori	a4,a4,1
ffffffffc0204f34:	fce52c23          	sw	a4,-40(a0)
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204f38:	0006c663          	bltz	a3,ffffffffc0204f44 <do_kill+0x66>
            return 0;
ffffffffc0204f3c:	4501                	li	a0,0
}
ffffffffc0204f3e:	60e2                	ld	ra,24(sp)
ffffffffc0204f40:	6105                	addi	sp,sp,32
ffffffffc0204f42:	8082                	ret
                wakeup_proc(proc);
ffffffffc0204f44:	f2850513          	addi	a0,a0,-216
ffffffffc0204f48:	232000ef          	jal	ffffffffc020517a <wakeup_proc>
ffffffffc0204f4c:	bfc5                	j	ffffffffc0204f3c <do_kill+0x5e>
    return -E_INVAL;
ffffffffc0204f4e:	5575                	li	a0,-3
}
ffffffffc0204f50:	8082                	ret
        return -E_KILLED;
ffffffffc0204f52:	555d                	li	a0,-9
ffffffffc0204f54:	b7ed                	j	ffffffffc0204f3e <do_kill+0x60>

ffffffffc0204f56 <proc_init>:
}

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204f56:	1101                	addi	sp,sp,-32
ffffffffc0204f58:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204f5a:	00096797          	auipc	a5,0x96
ffffffffc0204f5e:	68678793          	addi	a5,a5,1670 # ffffffffc029b5e0 <proc_list>
ffffffffc0204f62:	ec06                	sd	ra,24(sp)
ffffffffc0204f64:	e822                	sd	s0,16(sp)
ffffffffc0204f66:	e04a                	sd	s2,0(sp)
ffffffffc0204f68:	00092497          	auipc	s1,0x92
ffffffffc0204f6c:	67848493          	addi	s1,s1,1656 # ffffffffc02975e0 <hash_list>
ffffffffc0204f70:	e79c                	sd	a5,8(a5)
ffffffffc0204f72:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204f74:	00096717          	auipc	a4,0x96
ffffffffc0204f78:	66c70713          	addi	a4,a4,1644 # ffffffffc029b5e0 <proc_list>
ffffffffc0204f7c:	87a6                	mv	a5,s1
ffffffffc0204f7e:	e79c                	sd	a5,8(a5)
ffffffffc0204f80:	e39c                	sd	a5,0(a5)
ffffffffc0204f82:	07c1                	addi	a5,a5,16
ffffffffc0204f84:	fee79de3          	bne	a5,a4,ffffffffc0204f7e <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204f88:	f19fe0ef          	jal	ffffffffc0203ea0 <alloc_proc>
ffffffffc0204f8c:	00096917          	auipc	s2,0x96
ffffffffc0204f90:	6e490913          	addi	s2,s2,1764 # ffffffffc029b670 <idleproc>
ffffffffc0204f94:	00a93023          	sd	a0,0(s2)
ffffffffc0204f98:	10050363          	beqz	a0,ffffffffc020509e <proc_init+0x148>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204f9c:	4789                	li	a5,2
ffffffffc0204f9e:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204fa0:	00003797          	auipc	a5,0x3
ffffffffc0204fa4:	06078793          	addi	a5,a5,96 # ffffffffc0208000 <bootstack>
ffffffffc0204fa8:	e91c                	sd	a5,16(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204faa:	0b450413          	addi	s0,a0,180
    idleproc->need_resched = 1;
ffffffffc0204fae:	4785                	li	a5,1
ffffffffc0204fb0:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fb2:	4641                	li	a2,16
ffffffffc0204fb4:	8522                	mv	a0,s0
ffffffffc0204fb6:	4581                	li	a1,0
ffffffffc0204fb8:	055000ef          	jal	ffffffffc020580c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204fbc:	8522                	mv	a0,s0
ffffffffc0204fbe:	463d                	li	a2,15
ffffffffc0204fc0:	00002597          	auipc	a1,0x2
ffffffffc0204fc4:	3c058593          	addi	a1,a1,960 # ffffffffc0207380 <etext+0x1b4a>
ffffffffc0204fc8:	057000ef          	jal	ffffffffc020581e <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204fcc:	00096797          	auipc	a5,0x96
ffffffffc0204fd0:	68c7a783          	lw	a5,1676(a5) # ffffffffc029b658 <nr_process>

    current = idleproc;
ffffffffc0204fd4:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204fd8:	4601                	li	a2,0
    nr_process++;
ffffffffc0204fda:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204fdc:	4581                	li	a1,0
ffffffffc0204fde:	00000517          	auipc	a0,0x0
ffffffffc0204fe2:	81650513          	addi	a0,a0,-2026 # ffffffffc02047f4 <init_main>
    current = idleproc;
ffffffffc0204fe6:	00096697          	auipc	a3,0x96
ffffffffc0204fea:	66e6bd23          	sd	a4,1658(a3) # ffffffffc029b660 <current>
    nr_process++;
ffffffffc0204fee:	00096717          	auipc	a4,0x96
ffffffffc0204ff2:	66f72523          	sw	a5,1642(a4) # ffffffffc029b658 <nr_process>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204ff6:	c88ff0ef          	jal	ffffffffc020447e <kernel_thread>
ffffffffc0204ffa:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204ffc:	08a05563          	blez	a0,ffffffffc0205086 <proc_init+0x130>
    if (0 < pid && pid < MAX_PID)
ffffffffc0205000:	6789                	lui	a5,0x2
ffffffffc0205002:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bca>
ffffffffc0205004:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205008:	02e7e463          	bltu	a5,a4,ffffffffc0205030 <proc_init+0xda>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020500c:	45a9                	li	a1,10
ffffffffc020500e:	368000ef          	jal	ffffffffc0205376 <hash32>
ffffffffc0205012:	02051713          	slli	a4,a0,0x20
ffffffffc0205016:	01c75793          	srli	a5,a4,0x1c
ffffffffc020501a:	00f486b3          	add	a3,s1,a5
ffffffffc020501e:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0205020:	a029                	j	ffffffffc020502a <proc_init+0xd4>
            if (proc->pid == pid)
ffffffffc0205022:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0205026:	04870d63          	beq	a4,s0,ffffffffc0205080 <proc_init+0x12a>
    return listelm->next;
ffffffffc020502a:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020502c:	fef69be3          	bne	a3,a5,ffffffffc0205022 <proc_init+0xcc>
    return NULL;
ffffffffc0205030:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205032:	0b478413          	addi	s0,a5,180
ffffffffc0205036:	4641                	li	a2,16
ffffffffc0205038:	4581                	li	a1,0
ffffffffc020503a:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020503c:	00096717          	auipc	a4,0x96
ffffffffc0205040:	62f73623          	sd	a5,1580(a4) # ffffffffc029b668 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205044:	7c8000ef          	jal	ffffffffc020580c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205048:	8522                	mv	a0,s0
ffffffffc020504a:	463d                	li	a2,15
ffffffffc020504c:	00002597          	auipc	a1,0x2
ffffffffc0205050:	35c58593          	addi	a1,a1,860 # ffffffffc02073a8 <etext+0x1b72>
ffffffffc0205054:	7ca000ef          	jal	ffffffffc020581e <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205058:	00093783          	ld	a5,0(s2)
ffffffffc020505c:	cfad                	beqz	a5,ffffffffc02050d6 <proc_init+0x180>
ffffffffc020505e:	43dc                	lw	a5,4(a5)
ffffffffc0205060:	ebbd                	bnez	a5,ffffffffc02050d6 <proc_init+0x180>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205062:	00096797          	auipc	a5,0x96
ffffffffc0205066:	6067b783          	ld	a5,1542(a5) # ffffffffc029b668 <initproc>
ffffffffc020506a:	c7b1                	beqz	a5,ffffffffc02050b6 <proc_init+0x160>
ffffffffc020506c:	43d8                	lw	a4,4(a5)
ffffffffc020506e:	4785                	li	a5,1
ffffffffc0205070:	04f71363          	bne	a4,a5,ffffffffc02050b6 <proc_init+0x160>
}
ffffffffc0205074:	60e2                	ld	ra,24(sp)
ffffffffc0205076:	6442                	ld	s0,16(sp)
ffffffffc0205078:	64a2                	ld	s1,8(sp)
ffffffffc020507a:	6902                	ld	s2,0(sp)
ffffffffc020507c:	6105                	addi	sp,sp,32
ffffffffc020507e:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205080:	f2878793          	addi	a5,a5,-216
ffffffffc0205084:	b77d                	j	ffffffffc0205032 <proc_init+0xdc>
        panic("create init_main failed.\n");
ffffffffc0205086:	00002617          	auipc	a2,0x2
ffffffffc020508a:	30260613          	addi	a2,a2,770 # ffffffffc0207388 <etext+0x1b52>
ffffffffc020508e:	42f00593          	li	a1,1071
ffffffffc0205092:	00002517          	auipc	a0,0x2
ffffffffc0205096:	f6650513          	addi	a0,a0,-154 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc020509a:	bacfb0ef          	jal	ffffffffc0200446 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc020509e:	00002617          	auipc	a2,0x2
ffffffffc02050a2:	2ca60613          	addi	a2,a2,714 # ffffffffc0207368 <etext+0x1b32>
ffffffffc02050a6:	42000593          	li	a1,1056
ffffffffc02050aa:	00002517          	auipc	a0,0x2
ffffffffc02050ae:	f4e50513          	addi	a0,a0,-178 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc02050b2:	b94fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02050b6:	00002697          	auipc	a3,0x2
ffffffffc02050ba:	32268693          	addi	a3,a3,802 # ffffffffc02073d8 <etext+0x1ba2>
ffffffffc02050be:	00001617          	auipc	a2,0x1
ffffffffc02050c2:	15a60613          	addi	a2,a2,346 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02050c6:	43600593          	li	a1,1078
ffffffffc02050ca:	00002517          	auipc	a0,0x2
ffffffffc02050ce:	f2e50513          	addi	a0,a0,-210 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc02050d2:	b74fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02050d6:	00002697          	auipc	a3,0x2
ffffffffc02050da:	2da68693          	addi	a3,a3,730 # ffffffffc02073b0 <etext+0x1b7a>
ffffffffc02050de:	00001617          	auipc	a2,0x1
ffffffffc02050e2:	13a60613          	addi	a2,a2,314 # ffffffffc0206218 <etext+0x9e2>
ffffffffc02050e6:	43500593          	li	a1,1077
ffffffffc02050ea:	00002517          	auipc	a0,0x2
ffffffffc02050ee:	f0e50513          	addi	a0,a0,-242 # ffffffffc0206ff8 <etext+0x17c2>
ffffffffc02050f2:	b54fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02050f6 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02050f6:	1141                	addi	sp,sp,-16
ffffffffc02050f8:	e022                	sd	s0,0(sp)
ffffffffc02050fa:	e406                	sd	ra,8(sp)
ffffffffc02050fc:	00096417          	auipc	s0,0x96
ffffffffc0205100:	56440413          	addi	s0,s0,1380 # ffffffffc029b660 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0205104:	6018                	ld	a4,0(s0)
ffffffffc0205106:	6f1c                	ld	a5,24(a4)
ffffffffc0205108:	dffd                	beqz	a5,ffffffffc0205106 <cpu_idle+0x10>
        {
            schedule();
ffffffffc020510a:	104000ef          	jal	ffffffffc020520e <schedule>
ffffffffc020510e:	bfdd                	j	ffffffffc0205104 <cpu_idle+0xe>

ffffffffc0205110 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0205110:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0205114:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0205118:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc020511a:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc020511c:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0205120:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0205124:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0205128:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020512c:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0205130:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205134:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205138:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020513c:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205140:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205144:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205148:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020514c:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020514e:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205150:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205154:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205158:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020515c:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205160:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205164:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205168:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc020516c:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205170:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205174:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205178:	8082                	ret

ffffffffc020517a <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020517a:	4118                	lw	a4,0(a0)
{
ffffffffc020517c:	1101                	addi	sp,sp,-32
ffffffffc020517e:	ec06                	sd	ra,24(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205180:	478d                	li	a5,3
ffffffffc0205182:	06f70763          	beq	a4,a5,ffffffffc02051f0 <wakeup_proc+0x76>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205186:	100027f3          	csrr	a5,sstatus
ffffffffc020518a:	8b89                	andi	a5,a5,2
ffffffffc020518c:	eb91                	bnez	a5,ffffffffc02051a0 <wakeup_proc+0x26>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc020518e:	4789                	li	a5,2
ffffffffc0205190:	02f70763          	beq	a4,a5,ffffffffc02051be <wakeup_proc+0x44>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205194:	60e2                	ld	ra,24(sp)
            proc->state = PROC_RUNNABLE;
ffffffffc0205196:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc0205198:	0e052623          	sw	zero,236(a0)
}
ffffffffc020519c:	6105                	addi	sp,sp,32
ffffffffc020519e:	8082                	ret
        intr_disable();
ffffffffc02051a0:	e42a                	sd	a0,8(sp)
ffffffffc02051a2:	f62fb0ef          	jal	ffffffffc0200904 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc02051a6:	6522                	ld	a0,8(sp)
ffffffffc02051a8:	4789                	li	a5,2
ffffffffc02051aa:	4118                	lw	a4,0(a0)
ffffffffc02051ac:	02f70663          	beq	a4,a5,ffffffffc02051d8 <wakeup_proc+0x5e>
            proc->state = PROC_RUNNABLE;
ffffffffc02051b0:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc02051b2:	0e052623          	sw	zero,236(a0)
}
ffffffffc02051b6:	60e2                	ld	ra,24(sp)
ffffffffc02051b8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02051ba:	f44fb06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc02051be:	60e2                	ld	ra,24(sp)
            warn("wakeup runnable process.\n");
ffffffffc02051c0:	00002617          	auipc	a2,0x2
ffffffffc02051c4:	27860613          	addi	a2,a2,632 # ffffffffc0207438 <etext+0x1c02>
ffffffffc02051c8:	45d1                	li	a1,20
ffffffffc02051ca:	00002517          	auipc	a0,0x2
ffffffffc02051ce:	25650513          	addi	a0,a0,598 # ffffffffc0207420 <etext+0x1bea>
}
ffffffffc02051d2:	6105                	addi	sp,sp,32
            warn("wakeup runnable process.\n");
ffffffffc02051d4:	adcfb06f          	j	ffffffffc02004b0 <__warn>
ffffffffc02051d8:	00002617          	auipc	a2,0x2
ffffffffc02051dc:	26060613          	addi	a2,a2,608 # ffffffffc0207438 <etext+0x1c02>
ffffffffc02051e0:	45d1                	li	a1,20
ffffffffc02051e2:	00002517          	auipc	a0,0x2
ffffffffc02051e6:	23e50513          	addi	a0,a0,574 # ffffffffc0207420 <etext+0x1bea>
ffffffffc02051ea:	ac6fb0ef          	jal	ffffffffc02004b0 <__warn>
    if (flag)
ffffffffc02051ee:	b7e1                	j	ffffffffc02051b6 <wakeup_proc+0x3c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02051f0:	00002697          	auipc	a3,0x2
ffffffffc02051f4:	21068693          	addi	a3,a3,528 # ffffffffc0207400 <etext+0x1bca>
ffffffffc02051f8:	00001617          	auipc	a2,0x1
ffffffffc02051fc:	02060613          	addi	a2,a2,32 # ffffffffc0206218 <etext+0x9e2>
ffffffffc0205200:	45a5                	li	a1,9
ffffffffc0205202:	00002517          	auipc	a0,0x2
ffffffffc0205206:	21e50513          	addi	a0,a0,542 # ffffffffc0207420 <etext+0x1bea>
ffffffffc020520a:	a3cfb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020520e <schedule>:

void schedule(void)
{
ffffffffc020520e:	1101                	addi	sp,sp,-32
ffffffffc0205210:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205212:	100027f3          	csrr	a5,sstatus
ffffffffc0205216:	8b89                	andi	a5,a5,2
ffffffffc0205218:	4301                	li	t1,0
ffffffffc020521a:	e3c1                	bnez	a5,ffffffffc020529a <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020521c:	00096897          	auipc	a7,0x96
ffffffffc0205220:	4448b883          	ld	a7,1092(a7) # ffffffffc029b660 <current>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205224:	00096517          	auipc	a0,0x96
ffffffffc0205228:	44c53503          	ld	a0,1100(a0) # ffffffffc029b670 <idleproc>
        current->need_resched = 0;
ffffffffc020522c:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205230:	04a88f63          	beq	a7,a0,ffffffffc020528e <schedule+0x80>
ffffffffc0205234:	0c888693          	addi	a3,a7,200
ffffffffc0205238:	00096617          	auipc	a2,0x96
ffffffffc020523c:	3a860613          	addi	a2,a2,936 # ffffffffc029b5e0 <proc_list>
        le = last;
ffffffffc0205240:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0205242:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205244:	4809                	li	a6,2
ffffffffc0205246:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc0205248:	00c78863          	beq	a5,a2,ffffffffc0205258 <schedule+0x4a>
                if (next->state == PROC_RUNNABLE)
ffffffffc020524c:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0205250:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205254:	03070363          	beq	a4,a6,ffffffffc020527a <schedule+0x6c>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc0205258:	fef697e3          	bne	a3,a5,ffffffffc0205246 <schedule+0x38>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020525c:	ed99                	bnez	a1,ffffffffc020527a <schedule+0x6c>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc020525e:	451c                	lw	a5,8(a0)
ffffffffc0205260:	2785                	addiw	a5,a5,1
ffffffffc0205262:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205264:	00a88663          	beq	a7,a0,ffffffffc0205270 <schedule+0x62>
ffffffffc0205268:	e41a                	sd	t1,8(sp)
        {
            proc_run(next);
ffffffffc020526a:	dbbfe0ef          	jal	ffffffffc0204024 <proc_run>
ffffffffc020526e:	6322                	ld	t1,8(sp)
    if (flag)
ffffffffc0205270:	00031b63          	bnez	t1,ffffffffc0205286 <schedule+0x78>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205274:	60e2                	ld	ra,24(sp)
ffffffffc0205276:	6105                	addi	sp,sp,32
ffffffffc0205278:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020527a:	4198                	lw	a4,0(a1)
ffffffffc020527c:	4789                	li	a5,2
ffffffffc020527e:	fef710e3          	bne	a4,a5,ffffffffc020525e <schedule+0x50>
ffffffffc0205282:	852e                	mv	a0,a1
ffffffffc0205284:	bfe9                	j	ffffffffc020525e <schedule+0x50>
}
ffffffffc0205286:	60e2                	ld	ra,24(sp)
ffffffffc0205288:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020528a:	e74fb06f          	j	ffffffffc02008fe <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020528e:	00096617          	auipc	a2,0x96
ffffffffc0205292:	35260613          	addi	a2,a2,850 # ffffffffc029b5e0 <proc_list>
ffffffffc0205296:	86b2                	mv	a3,a2
ffffffffc0205298:	b765                	j	ffffffffc0205240 <schedule+0x32>
        intr_disable();
ffffffffc020529a:	e6afb0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc020529e:	4305                	li	t1,1
ffffffffc02052a0:	bfb5                	j	ffffffffc020521c <schedule+0xe>

ffffffffc02052a2 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02052a2:	00096797          	auipc	a5,0x96
ffffffffc02052a6:	3be7b783          	ld	a5,958(a5) # ffffffffc029b660 <current>
}
ffffffffc02052aa:	43c8                	lw	a0,4(a5)
ffffffffc02052ac:	8082                	ret

ffffffffc02052ae <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc02052ae:	4501                	li	a0,0
ffffffffc02052b0:	8082                	ret

ffffffffc02052b2 <sys_putc>:
    cputchar(c);
ffffffffc02052b2:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc02052b4:	1141                	addi	sp,sp,-16
ffffffffc02052b6:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc02052b8:	f11fa0ef          	jal	ffffffffc02001c8 <cputchar>
}
ffffffffc02052bc:	60a2                	ld	ra,8(sp)
ffffffffc02052be:	4501                	li	a0,0
ffffffffc02052c0:	0141                	addi	sp,sp,16
ffffffffc02052c2:	8082                	ret

ffffffffc02052c4 <sys_kill>:
    return do_kill(pid);
ffffffffc02052c4:	4108                	lw	a0,0(a0)
ffffffffc02052c6:	c19ff06f          	j	ffffffffc0204ede <do_kill>

ffffffffc02052ca <sys_yield>:
    return do_yield();
ffffffffc02052ca:	bcbff06f          	j	ffffffffc0204e94 <do_yield>

ffffffffc02052ce <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc02052ce:	6d14                	ld	a3,24(a0)
ffffffffc02052d0:	6910                	ld	a2,16(a0)
ffffffffc02052d2:	650c                	ld	a1,8(a0)
ffffffffc02052d4:	6108                	ld	a0,0(a0)
ffffffffc02052d6:	e3cff06f          	j	ffffffffc0204912 <do_execve>

ffffffffc02052da <sys_wait>:
    return do_wait(pid, store);
ffffffffc02052da:	650c                	ld	a1,8(a0)
ffffffffc02052dc:	4108                	lw	a0,0(a0)
ffffffffc02052de:	bc7ff06f          	j	ffffffffc0204ea4 <do_wait>

ffffffffc02052e2 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc02052e2:	00096797          	auipc	a5,0x96
ffffffffc02052e6:	37e7b783          	ld	a5,894(a5) # ffffffffc029b660 <current>
    return do_fork(0, stack, tf);
ffffffffc02052ea:	4501                	li	a0,0
    struct trapframe *tf = current->tf;
ffffffffc02052ec:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc02052ee:	6a0c                	ld	a1,16(a2)
ffffffffc02052f0:	d97fe06f          	j	ffffffffc0204086 <do_fork>

ffffffffc02052f4 <sys_exit>:
    return do_exit(error_code);
ffffffffc02052f4:	4108                	lw	a0,0(a0)
ffffffffc02052f6:	9d8ff06f          	j	ffffffffc02044ce <do_exit>

ffffffffc02052fa <syscall>:

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
    struct trapframe *tf = current->tf;
ffffffffc02052fa:	00096697          	auipc	a3,0x96
ffffffffc02052fe:	3666b683          	ld	a3,870(a3) # ffffffffc029b660 <current>
syscall(void) {
ffffffffc0205302:	715d                	addi	sp,sp,-80
ffffffffc0205304:	e0a2                	sd	s0,64(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205306:	72c0                	ld	s0,160(a3)
syscall(void) {
ffffffffc0205308:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020530a:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc020530c:	4834                	lw	a3,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020530e:	02d7ec63          	bltu	a5,a3,ffffffffc0205346 <syscall+0x4c>
        if (syscalls[num] != NULL) {
ffffffffc0205312:	00002797          	auipc	a5,0x2
ffffffffc0205316:	36e78793          	addi	a5,a5,878 # ffffffffc0207680 <syscalls>
ffffffffc020531a:	00369613          	slli	a2,a3,0x3
ffffffffc020531e:	97b2                	add	a5,a5,a2
ffffffffc0205320:	639c                	ld	a5,0(a5)
ffffffffc0205322:	c395                	beqz	a5,ffffffffc0205346 <syscall+0x4c>
            arg[0] = tf->gpr.a1;
ffffffffc0205324:	7028                	ld	a0,96(s0)
ffffffffc0205326:	742c                	ld	a1,104(s0)
ffffffffc0205328:	7830                	ld	a2,112(s0)
ffffffffc020532a:	7c34                	ld	a3,120(s0)
ffffffffc020532c:	6c38                	ld	a4,88(s0)
ffffffffc020532e:	f02a                	sd	a0,32(sp)
ffffffffc0205330:	f42e                	sd	a1,40(sp)
ffffffffc0205332:	f832                	sd	a2,48(sp)
ffffffffc0205334:	fc36                	sd	a3,56(sp)
ffffffffc0205336:	ec3a                	sd	a4,24(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205338:	0828                	addi	a0,sp,24
ffffffffc020533a:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc020533c:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc020533e:	e828                	sd	a0,80(s0)
}
ffffffffc0205340:	6406                	ld	s0,64(sp)
ffffffffc0205342:	6161                	addi	sp,sp,80
ffffffffc0205344:	8082                	ret
    print_trapframe(tf);
ffffffffc0205346:	8522                	mv	a0,s0
ffffffffc0205348:	e436                	sd	a3,8(sp)
ffffffffc020534a:	faafb0ef          	jal	ffffffffc0200af4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc020534e:	00096797          	auipc	a5,0x96
ffffffffc0205352:	3127b783          	ld	a5,786(a5) # ffffffffc029b660 <current>
ffffffffc0205356:	66a2                	ld	a3,8(sp)
ffffffffc0205358:	00002617          	auipc	a2,0x2
ffffffffc020535c:	10060613          	addi	a2,a2,256 # ffffffffc0207458 <etext+0x1c22>
ffffffffc0205360:	43d8                	lw	a4,4(a5)
ffffffffc0205362:	06200593          	li	a1,98
ffffffffc0205366:	0b478793          	addi	a5,a5,180
ffffffffc020536a:	00002517          	auipc	a0,0x2
ffffffffc020536e:	11e50513          	addi	a0,a0,286 # ffffffffc0207488 <etext+0x1c52>
ffffffffc0205372:	8d4fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0205376 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205376:	9e3707b7          	lui	a5,0x9e370
ffffffffc020537a:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_exit_out_size+0xffffffff9e365e49>
ffffffffc020537c:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205380:	02000513          	li	a0,32
ffffffffc0205384:	9d0d                	subw	a0,a0,a1
}
ffffffffc0205386:	00a7d53b          	srlw	a0,a5,a0
ffffffffc020538a:	8082                	ret

ffffffffc020538c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020538c:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020538e:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205392:	f022                	sd	s0,32(sp)
ffffffffc0205394:	ec26                	sd	s1,24(sp)
ffffffffc0205396:	e84a                	sd	s2,16(sp)
ffffffffc0205398:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020539a:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020539e:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc02053a0:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02053a4:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02053a8:	84aa                	mv	s1,a0
ffffffffc02053aa:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc02053ac:	03067d63          	bgeu	a2,a6,ffffffffc02053e6 <printnum+0x5a>
ffffffffc02053b0:	e44e                	sd	s3,8(sp)
ffffffffc02053b2:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02053b4:	4785                	li	a5,1
ffffffffc02053b6:	00e7d763          	bge	a5,a4,ffffffffc02053c4 <printnum+0x38>
            putch(padc, putdat);
ffffffffc02053ba:	85ca                	mv	a1,s2
ffffffffc02053bc:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc02053be:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02053c0:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02053c2:	fc65                	bnez	s0,ffffffffc02053ba <printnum+0x2e>
ffffffffc02053c4:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02053c6:	00002797          	auipc	a5,0x2
ffffffffc02053ca:	0da78793          	addi	a5,a5,218 # ffffffffc02074a0 <etext+0x1c6a>
ffffffffc02053ce:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc02053d0:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02053d2:	0007c503          	lbu	a0,0(a5)
}
ffffffffc02053d6:	70a2                	ld	ra,40(sp)
ffffffffc02053d8:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02053da:	85ca                	mv	a1,s2
ffffffffc02053dc:	87a6                	mv	a5,s1
}
ffffffffc02053de:	6942                	ld	s2,16(sp)
ffffffffc02053e0:	64e2                	ld	s1,24(sp)
ffffffffc02053e2:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02053e4:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02053e6:	03065633          	divu	a2,a2,a6
ffffffffc02053ea:	8722                	mv	a4,s0
ffffffffc02053ec:	fa1ff0ef          	jal	ffffffffc020538c <printnum>
ffffffffc02053f0:	bfd9                	j	ffffffffc02053c6 <printnum+0x3a>

ffffffffc02053f2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02053f2:	7119                	addi	sp,sp,-128
ffffffffc02053f4:	f4a6                	sd	s1,104(sp)
ffffffffc02053f6:	f0ca                	sd	s2,96(sp)
ffffffffc02053f8:	ecce                	sd	s3,88(sp)
ffffffffc02053fa:	e8d2                	sd	s4,80(sp)
ffffffffc02053fc:	e4d6                	sd	s5,72(sp)
ffffffffc02053fe:	e0da                	sd	s6,64(sp)
ffffffffc0205400:	f862                	sd	s8,48(sp)
ffffffffc0205402:	fc86                	sd	ra,120(sp)
ffffffffc0205404:	f8a2                	sd	s0,112(sp)
ffffffffc0205406:	fc5e                	sd	s7,56(sp)
ffffffffc0205408:	f466                	sd	s9,40(sp)
ffffffffc020540a:	f06a                	sd	s10,32(sp)
ffffffffc020540c:	ec6e                	sd	s11,24(sp)
ffffffffc020540e:	84aa                	mv	s1,a0
ffffffffc0205410:	8c32                	mv	s8,a2
ffffffffc0205412:	8a36                	mv	s4,a3
ffffffffc0205414:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205416:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020541a:	05500b13          	li	s6,85
ffffffffc020541e:	00002a97          	auipc	s5,0x2
ffffffffc0205422:	362a8a93          	addi	s5,s5,866 # ffffffffc0207780 <syscalls+0x100>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205426:	000c4503          	lbu	a0,0(s8)
ffffffffc020542a:	001c0413          	addi	s0,s8,1
ffffffffc020542e:	01350a63          	beq	a0,s3,ffffffffc0205442 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0205432:	cd0d                	beqz	a0,ffffffffc020546c <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0205434:	85ca                	mv	a1,s2
ffffffffc0205436:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205438:	00044503          	lbu	a0,0(s0)
ffffffffc020543c:	0405                	addi	s0,s0,1
ffffffffc020543e:	ff351ae3          	bne	a0,s3,ffffffffc0205432 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0205442:	5cfd                	li	s9,-1
ffffffffc0205444:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0205446:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc020544a:	4b81                	li	s7,0
ffffffffc020544c:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020544e:	00044683          	lbu	a3,0(s0)
ffffffffc0205452:	00140c13          	addi	s8,s0,1
ffffffffc0205456:	fdd6859b          	addiw	a1,a3,-35
ffffffffc020545a:	0ff5f593          	zext.b	a1,a1
ffffffffc020545e:	02bb6663          	bltu	s6,a1,ffffffffc020548a <vprintfmt+0x98>
ffffffffc0205462:	058a                	slli	a1,a1,0x2
ffffffffc0205464:	95d6                	add	a1,a1,s5
ffffffffc0205466:	4198                	lw	a4,0(a1)
ffffffffc0205468:	9756                	add	a4,a4,s5
ffffffffc020546a:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020546c:	70e6                	ld	ra,120(sp)
ffffffffc020546e:	7446                	ld	s0,112(sp)
ffffffffc0205470:	74a6                	ld	s1,104(sp)
ffffffffc0205472:	7906                	ld	s2,96(sp)
ffffffffc0205474:	69e6                	ld	s3,88(sp)
ffffffffc0205476:	6a46                	ld	s4,80(sp)
ffffffffc0205478:	6aa6                	ld	s5,72(sp)
ffffffffc020547a:	6b06                	ld	s6,64(sp)
ffffffffc020547c:	7be2                	ld	s7,56(sp)
ffffffffc020547e:	7c42                	ld	s8,48(sp)
ffffffffc0205480:	7ca2                	ld	s9,40(sp)
ffffffffc0205482:	7d02                	ld	s10,32(sp)
ffffffffc0205484:	6de2                	ld	s11,24(sp)
ffffffffc0205486:	6109                	addi	sp,sp,128
ffffffffc0205488:	8082                	ret
            putch('%', putdat);
ffffffffc020548a:	85ca                	mv	a1,s2
ffffffffc020548c:	02500513          	li	a0,37
ffffffffc0205490:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205492:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205496:	02500713          	li	a4,37
ffffffffc020549a:	8c22                	mv	s8,s0
ffffffffc020549c:	f8e785e3          	beq	a5,a4,ffffffffc0205426 <vprintfmt+0x34>
ffffffffc02054a0:	ffec4783          	lbu	a5,-2(s8)
ffffffffc02054a4:	1c7d                	addi	s8,s8,-1
ffffffffc02054a6:	fee79de3          	bne	a5,a4,ffffffffc02054a0 <vprintfmt+0xae>
ffffffffc02054aa:	bfb5                	j	ffffffffc0205426 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc02054ac:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc02054b0:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc02054b2:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc02054b6:	fd06071b          	addiw	a4,a2,-48
ffffffffc02054ba:	24e56a63          	bltu	a0,a4,ffffffffc020570e <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc02054be:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054c0:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc02054c2:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc02054c6:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02054ca:	0197073b          	addw	a4,a4,s9
ffffffffc02054ce:	0017171b          	slliw	a4,a4,0x1
ffffffffc02054d2:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc02054d4:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02054d8:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02054da:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc02054de:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc02054e2:	feb570e3          	bgeu	a0,a1,ffffffffc02054c2 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc02054e6:	f60d54e3          	bgez	s10,ffffffffc020544e <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc02054ea:	8d66                	mv	s10,s9
ffffffffc02054ec:	5cfd                	li	s9,-1
ffffffffc02054ee:	b785                	j	ffffffffc020544e <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054f0:	8db6                	mv	s11,a3
ffffffffc02054f2:	8462                	mv	s0,s8
ffffffffc02054f4:	bfa9                	j	ffffffffc020544e <vprintfmt+0x5c>
ffffffffc02054f6:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc02054f8:	4b85                	li	s7,1
            goto reswitch;
ffffffffc02054fa:	bf91                	j	ffffffffc020544e <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc02054fc:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02054fe:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205502:	00f74463          	blt	a4,a5,ffffffffc020550a <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0205506:	1a078763          	beqz	a5,ffffffffc02056b4 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc020550a:	000a3603          	ld	a2,0(s4)
ffffffffc020550e:	46c1                	li	a3,16
ffffffffc0205510:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205512:	000d879b          	sext.w	a5,s11
ffffffffc0205516:	876a                	mv	a4,s10
ffffffffc0205518:	85ca                	mv	a1,s2
ffffffffc020551a:	8526                	mv	a0,s1
ffffffffc020551c:	e71ff0ef          	jal	ffffffffc020538c <printnum>
            break;
ffffffffc0205520:	b719                	j	ffffffffc0205426 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0205522:	000a2503          	lw	a0,0(s4)
ffffffffc0205526:	85ca                	mv	a1,s2
ffffffffc0205528:	0a21                	addi	s4,s4,8
ffffffffc020552a:	9482                	jalr	s1
            break;
ffffffffc020552c:	bded                	j	ffffffffc0205426 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc020552e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205530:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205534:	00f74463          	blt	a4,a5,ffffffffc020553c <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0205538:	16078963          	beqz	a5,ffffffffc02056aa <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc020553c:	000a3603          	ld	a2,0(s4)
ffffffffc0205540:	46a9                	li	a3,10
ffffffffc0205542:	8a2e                	mv	s4,a1
ffffffffc0205544:	b7f9                	j	ffffffffc0205512 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0205546:	85ca                	mv	a1,s2
ffffffffc0205548:	03000513          	li	a0,48
ffffffffc020554c:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc020554e:	85ca                	mv	a1,s2
ffffffffc0205550:	07800513          	li	a0,120
ffffffffc0205554:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205556:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc020555a:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020555c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020555e:	bf55                	j	ffffffffc0205512 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0205560:	85ca                	mv	a1,s2
ffffffffc0205562:	02500513          	li	a0,37
ffffffffc0205566:	9482                	jalr	s1
            break;
ffffffffc0205568:	bd7d                	j	ffffffffc0205426 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc020556a:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020556e:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0205570:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0205572:	bf95                	j	ffffffffc02054e6 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0205574:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205576:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020557a:	00f74463          	blt	a4,a5,ffffffffc0205582 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc020557e:	12078163          	beqz	a5,ffffffffc02056a0 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0205582:	000a3603          	ld	a2,0(s4)
ffffffffc0205586:	46a1                	li	a3,8
ffffffffc0205588:	8a2e                	mv	s4,a1
ffffffffc020558a:	b761                	j	ffffffffc0205512 <vprintfmt+0x120>
            if (width < 0)
ffffffffc020558c:	876a                	mv	a4,s10
ffffffffc020558e:	000d5363          	bgez	s10,ffffffffc0205594 <vprintfmt+0x1a2>
ffffffffc0205592:	4701                	li	a4,0
ffffffffc0205594:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205598:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc020559a:	bd55                	j	ffffffffc020544e <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc020559c:	000d841b          	sext.w	s0,s11
ffffffffc02055a0:	fd340793          	addi	a5,s0,-45
ffffffffc02055a4:	00f037b3          	snez	a5,a5
ffffffffc02055a8:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02055ac:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc02055b0:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02055b2:	008a0793          	addi	a5,s4,8
ffffffffc02055b6:	e43e                	sd	a5,8(sp)
ffffffffc02055b8:	100d8c63          	beqz	s11,ffffffffc02056d0 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc02055bc:	12071363          	bnez	a4,ffffffffc02056e2 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055c0:	000dc783          	lbu	a5,0(s11)
ffffffffc02055c4:	0007851b          	sext.w	a0,a5
ffffffffc02055c8:	c78d                	beqz	a5,ffffffffc02055f2 <vprintfmt+0x200>
ffffffffc02055ca:	0d85                	addi	s11,s11,1
ffffffffc02055cc:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02055ce:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055d2:	000cc563          	bltz	s9,ffffffffc02055dc <vprintfmt+0x1ea>
ffffffffc02055d6:	3cfd                	addiw	s9,s9,-1
ffffffffc02055d8:	008c8d63          	beq	s9,s0,ffffffffc02055f2 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02055dc:	020b9663          	bnez	s7,ffffffffc0205608 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc02055e0:	85ca                	mv	a1,s2
ffffffffc02055e2:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055e4:	000dc783          	lbu	a5,0(s11)
ffffffffc02055e8:	0d85                	addi	s11,s11,1
ffffffffc02055ea:	3d7d                	addiw	s10,s10,-1
ffffffffc02055ec:	0007851b          	sext.w	a0,a5
ffffffffc02055f0:	f3ed                	bnez	a5,ffffffffc02055d2 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc02055f2:	01a05963          	blez	s10,ffffffffc0205604 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc02055f6:	85ca                	mv	a1,s2
ffffffffc02055f8:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc02055fc:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc02055fe:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0205600:	fe0d1be3          	bnez	s10,ffffffffc02055f6 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205604:	6a22                	ld	s4,8(sp)
ffffffffc0205606:	b505                	j	ffffffffc0205426 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205608:	3781                	addiw	a5,a5,-32
ffffffffc020560a:	fcfa7be3          	bgeu	s4,a5,ffffffffc02055e0 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc020560e:	03f00513          	li	a0,63
ffffffffc0205612:	85ca                	mv	a1,s2
ffffffffc0205614:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205616:	000dc783          	lbu	a5,0(s11)
ffffffffc020561a:	0d85                	addi	s11,s11,1
ffffffffc020561c:	3d7d                	addiw	s10,s10,-1
ffffffffc020561e:	0007851b          	sext.w	a0,a5
ffffffffc0205622:	dbe1                	beqz	a5,ffffffffc02055f2 <vprintfmt+0x200>
ffffffffc0205624:	fa0cd9e3          	bgez	s9,ffffffffc02055d6 <vprintfmt+0x1e4>
ffffffffc0205628:	b7c5                	j	ffffffffc0205608 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc020562a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020562e:	4661                	li	a2,24
            err = va_arg(ap, int);
ffffffffc0205630:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205632:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0205636:	8fb9                	xor	a5,a5,a4
ffffffffc0205638:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020563c:	02d64563          	blt	a2,a3,ffffffffc0205666 <vprintfmt+0x274>
ffffffffc0205640:	00002797          	auipc	a5,0x2
ffffffffc0205644:	29878793          	addi	a5,a5,664 # ffffffffc02078d8 <error_string>
ffffffffc0205648:	00369713          	slli	a4,a3,0x3
ffffffffc020564c:	97ba                	add	a5,a5,a4
ffffffffc020564e:	639c                	ld	a5,0(a5)
ffffffffc0205650:	cb99                	beqz	a5,ffffffffc0205666 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205652:	86be                	mv	a3,a5
ffffffffc0205654:	00000617          	auipc	a2,0x0
ffffffffc0205658:	20c60613          	addi	a2,a2,524 # ffffffffc0205860 <etext+0x2a>
ffffffffc020565c:	85ca                	mv	a1,s2
ffffffffc020565e:	8526                	mv	a0,s1
ffffffffc0205660:	0d8000ef          	jal	ffffffffc0205738 <printfmt>
ffffffffc0205664:	b3c9                	j	ffffffffc0205426 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205666:	00002617          	auipc	a2,0x2
ffffffffc020566a:	e5a60613          	addi	a2,a2,-422 # ffffffffc02074c0 <etext+0x1c8a>
ffffffffc020566e:	85ca                	mv	a1,s2
ffffffffc0205670:	8526                	mv	a0,s1
ffffffffc0205672:	0c6000ef          	jal	ffffffffc0205738 <printfmt>
ffffffffc0205676:	bb45                	j	ffffffffc0205426 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0205678:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020567a:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc020567e:	00f74363          	blt	a4,a5,ffffffffc0205684 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0205682:	cf81                	beqz	a5,ffffffffc020569a <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0205684:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205688:	02044b63          	bltz	s0,ffffffffc02056be <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc020568c:	8622                	mv	a2,s0
ffffffffc020568e:	8a5e                	mv	s4,s7
ffffffffc0205690:	46a9                	li	a3,10
ffffffffc0205692:	b541                	j	ffffffffc0205512 <vprintfmt+0x120>
            lflag ++;
ffffffffc0205694:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205696:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0205698:	bb5d                	j	ffffffffc020544e <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc020569a:	000a2403          	lw	s0,0(s4)
ffffffffc020569e:	b7ed                	j	ffffffffc0205688 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc02056a0:	000a6603          	lwu	a2,0(s4)
ffffffffc02056a4:	46a1                	li	a3,8
ffffffffc02056a6:	8a2e                	mv	s4,a1
ffffffffc02056a8:	b5ad                	j	ffffffffc0205512 <vprintfmt+0x120>
ffffffffc02056aa:	000a6603          	lwu	a2,0(s4)
ffffffffc02056ae:	46a9                	li	a3,10
ffffffffc02056b0:	8a2e                	mv	s4,a1
ffffffffc02056b2:	b585                	j	ffffffffc0205512 <vprintfmt+0x120>
ffffffffc02056b4:	000a6603          	lwu	a2,0(s4)
ffffffffc02056b8:	46c1                	li	a3,16
ffffffffc02056ba:	8a2e                	mv	s4,a1
ffffffffc02056bc:	bd99                	j	ffffffffc0205512 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc02056be:	85ca                	mv	a1,s2
ffffffffc02056c0:	02d00513          	li	a0,45
ffffffffc02056c4:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc02056c6:	40800633          	neg	a2,s0
ffffffffc02056ca:	8a5e                	mv	s4,s7
ffffffffc02056cc:	46a9                	li	a3,10
ffffffffc02056ce:	b591                	j	ffffffffc0205512 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc02056d0:	e329                	bnez	a4,ffffffffc0205712 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056d2:	02800793          	li	a5,40
ffffffffc02056d6:	853e                	mv	a0,a5
ffffffffc02056d8:	00002d97          	auipc	s11,0x2
ffffffffc02056dc:	de1d8d93          	addi	s11,s11,-543 # ffffffffc02074b9 <etext+0x1c83>
ffffffffc02056e0:	b5f5                	j	ffffffffc02055cc <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02056e2:	85e6                	mv	a1,s9
ffffffffc02056e4:	856e                	mv	a0,s11
ffffffffc02056e6:	08a000ef          	jal	ffffffffc0205770 <strnlen>
ffffffffc02056ea:	40ad0d3b          	subw	s10,s10,a0
ffffffffc02056ee:	01a05863          	blez	s10,ffffffffc02056fe <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc02056f2:	85ca                	mv	a1,s2
ffffffffc02056f4:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02056f6:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc02056f8:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02056fa:	fe0d1ce3          	bnez	s10,ffffffffc02056f2 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056fe:	000dc783          	lbu	a5,0(s11)
ffffffffc0205702:	0007851b          	sext.w	a0,a5
ffffffffc0205706:	ec0792e3          	bnez	a5,ffffffffc02055ca <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020570a:	6a22                	ld	s4,8(sp)
ffffffffc020570c:	bb29                	j	ffffffffc0205426 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020570e:	8462                	mv	s0,s8
ffffffffc0205710:	bbd9                	j	ffffffffc02054e6 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205712:	85e6                	mv	a1,s9
ffffffffc0205714:	00002517          	auipc	a0,0x2
ffffffffc0205718:	da450513          	addi	a0,a0,-604 # ffffffffc02074b8 <etext+0x1c82>
ffffffffc020571c:	054000ef          	jal	ffffffffc0205770 <strnlen>
ffffffffc0205720:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205724:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0205728:	00002d97          	auipc	s11,0x2
ffffffffc020572c:	d90d8d93          	addi	s11,s11,-624 # ffffffffc02074b8 <etext+0x1c82>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205730:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205732:	fda040e3          	bgtz	s10,ffffffffc02056f2 <vprintfmt+0x300>
ffffffffc0205736:	bd51                	j	ffffffffc02055ca <vprintfmt+0x1d8>

ffffffffc0205738 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205738:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020573a:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020573e:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205740:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205742:	ec06                	sd	ra,24(sp)
ffffffffc0205744:	f83a                	sd	a4,48(sp)
ffffffffc0205746:	fc3e                	sd	a5,56(sp)
ffffffffc0205748:	e0c2                	sd	a6,64(sp)
ffffffffc020574a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020574c:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020574e:	ca5ff0ef          	jal	ffffffffc02053f2 <vprintfmt>
}
ffffffffc0205752:	60e2                	ld	ra,24(sp)
ffffffffc0205754:	6161                	addi	sp,sp,80
ffffffffc0205756:	8082                	ret

ffffffffc0205758 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205758:	00054783          	lbu	a5,0(a0)
ffffffffc020575c:	cb81                	beqz	a5,ffffffffc020576c <strlen+0x14>
    size_t cnt = 0;
ffffffffc020575e:	4781                	li	a5,0
        cnt ++;
ffffffffc0205760:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0205762:	00f50733          	add	a4,a0,a5
ffffffffc0205766:	00074703          	lbu	a4,0(a4)
ffffffffc020576a:	fb7d                	bnez	a4,ffffffffc0205760 <strlen+0x8>
    }
    return cnt;
}
ffffffffc020576c:	853e                	mv	a0,a5
ffffffffc020576e:	8082                	ret

ffffffffc0205770 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205770:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205772:	e589                	bnez	a1,ffffffffc020577c <strnlen+0xc>
ffffffffc0205774:	a811                	j	ffffffffc0205788 <strnlen+0x18>
        cnt ++;
ffffffffc0205776:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205778:	00f58863          	beq	a1,a5,ffffffffc0205788 <strnlen+0x18>
ffffffffc020577c:	00f50733          	add	a4,a0,a5
ffffffffc0205780:	00074703          	lbu	a4,0(a4)
ffffffffc0205784:	fb6d                	bnez	a4,ffffffffc0205776 <strnlen+0x6>
ffffffffc0205786:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205788:	852e                	mv	a0,a1
ffffffffc020578a:	8082                	ret

ffffffffc020578c <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc020578c:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc020578e:	0005c703          	lbu	a4,0(a1)
ffffffffc0205792:	0585                	addi	a1,a1,1
ffffffffc0205794:	0785                	addi	a5,a5,1
ffffffffc0205796:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020579a:	fb75                	bnez	a4,ffffffffc020578e <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020579c:	8082                	ret

ffffffffc020579e <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020579e:	00054783          	lbu	a5,0(a0)
ffffffffc02057a2:	e791                	bnez	a5,ffffffffc02057ae <strcmp+0x10>
ffffffffc02057a4:	a01d                	j	ffffffffc02057ca <strcmp+0x2c>
ffffffffc02057a6:	00054783          	lbu	a5,0(a0)
ffffffffc02057aa:	cb99                	beqz	a5,ffffffffc02057c0 <strcmp+0x22>
ffffffffc02057ac:	0585                	addi	a1,a1,1
ffffffffc02057ae:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc02057b2:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02057b4:	fef709e3          	beq	a4,a5,ffffffffc02057a6 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02057b8:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02057bc:	9d19                	subw	a0,a0,a4
ffffffffc02057be:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02057c0:	0015c703          	lbu	a4,1(a1)
ffffffffc02057c4:	4501                	li	a0,0
}
ffffffffc02057c6:	9d19                	subw	a0,a0,a4
ffffffffc02057c8:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02057ca:	0005c703          	lbu	a4,0(a1)
ffffffffc02057ce:	4501                	li	a0,0
ffffffffc02057d0:	b7f5                	j	ffffffffc02057bc <strcmp+0x1e>

ffffffffc02057d2 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02057d2:	ce01                	beqz	a2,ffffffffc02057ea <strncmp+0x18>
ffffffffc02057d4:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02057d8:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02057da:	cb91                	beqz	a5,ffffffffc02057ee <strncmp+0x1c>
ffffffffc02057dc:	0005c703          	lbu	a4,0(a1)
ffffffffc02057e0:	00f71763          	bne	a4,a5,ffffffffc02057ee <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc02057e4:	0505                	addi	a0,a0,1
ffffffffc02057e6:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02057e8:	f675                	bnez	a2,ffffffffc02057d4 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02057ea:	4501                	li	a0,0
ffffffffc02057ec:	8082                	ret
ffffffffc02057ee:	00054503          	lbu	a0,0(a0)
ffffffffc02057f2:	0005c783          	lbu	a5,0(a1)
ffffffffc02057f6:	9d1d                	subw	a0,a0,a5
}
ffffffffc02057f8:	8082                	ret

ffffffffc02057fa <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02057fa:	a021                	j	ffffffffc0205802 <strchr+0x8>
        if (*s == c) {
ffffffffc02057fc:	00f58763          	beq	a1,a5,ffffffffc020580a <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0205800:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205802:	00054783          	lbu	a5,0(a0)
ffffffffc0205806:	fbfd                	bnez	a5,ffffffffc02057fc <strchr+0x2>
    }
    return NULL;
ffffffffc0205808:	4501                	li	a0,0
}
ffffffffc020580a:	8082                	ret

ffffffffc020580c <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020580c:	ca01                	beqz	a2,ffffffffc020581c <memset+0x10>
ffffffffc020580e:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0205810:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0205812:	0785                	addi	a5,a5,1
ffffffffc0205814:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205818:	fef61de3          	bne	a2,a5,ffffffffc0205812 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020581c:	8082                	ret

ffffffffc020581e <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc020581e:	ca19                	beqz	a2,ffffffffc0205834 <memcpy+0x16>
ffffffffc0205820:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205822:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0205824:	0005c703          	lbu	a4,0(a1)
ffffffffc0205828:	0585                	addi	a1,a1,1
ffffffffc020582a:	0785                	addi	a5,a5,1
ffffffffc020582c:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0205830:	feb61ae3          	bne	a2,a1,ffffffffc0205824 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205834:	8082                	ret
