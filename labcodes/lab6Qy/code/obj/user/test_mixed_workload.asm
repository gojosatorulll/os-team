
obj/__user_test_mixed_workload.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	0d4000ef          	jal	ra,8000f4 <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800026:	1141                	addi	sp,sp,-16
  800028:	e022                	sd	s0,0(sp)
  80002a:	e406                	sd	ra,8(sp)
  80002c:	842e                	mv	s0,a1
    sys_putc(c);
  80002e:	096000ef          	jal	ra,8000c4 <sys_putc>
    (*cnt) ++;
  800032:	401c                	lw	a5,0(s0)
}
  800034:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800036:	2785                	addiw	a5,a5,1
  800038:	c01c                	sw	a5,0(s0)
}
  80003a:	6402                	ld	s0,0(sp)
  80003c:	0141                	addi	sp,sp,16
  80003e:	8082                	ret

0000000000800040 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800040:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800042:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  800046:	8e2a                	mv	t3,a0
  800048:	f42e                	sd	a1,40(sp)
  80004a:	f832                	sd	a2,48(sp)
  80004c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80004e:	00000517          	auipc	a0,0x0
  800052:	fd850513          	addi	a0,a0,-40 # 800026 <cputch>
  800056:	004c                	addi	a1,sp,4
  800058:	869a                	mv	a3,t1
  80005a:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  80005c:	ec06                	sd	ra,24(sp)
  80005e:	e0ba                	sd	a4,64(sp)
  800060:	e4be                	sd	a5,72(sp)
  800062:	e8c2                	sd	a6,80(sp)
  800064:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  800066:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  800068:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80006a:	102000ef          	jal	ra,80016c <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80006e:	60e2                	ld	ra,24(sp)
  800070:	4512                	lw	a0,4(sp)
  800072:	6125                	addi	sp,sp,96
  800074:	8082                	ret

0000000000800076 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800076:	7175                	addi	sp,sp,-144
  800078:	f8ba                	sd	a4,112(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  80007a:	e0ba                	sd	a4,64(sp)
  80007c:	0118                	addi	a4,sp,128
syscall(int64_t num, ...) {
  80007e:	e42a                	sd	a0,8(sp)
  800080:	ecae                	sd	a1,88(sp)
  800082:	f0b2                	sd	a2,96(sp)
  800084:	f4b6                	sd	a3,104(sp)
  800086:	fcbe                	sd	a5,120(sp)
  800088:	e142                	sd	a6,128(sp)
  80008a:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  80008c:	f42e                	sd	a1,40(sp)
  80008e:	f832                	sd	a2,48(sp)
  800090:	fc36                	sd	a3,56(sp)
  800092:	f03a                	sd	a4,32(sp)
  800094:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);
    asm volatile (
  800096:	4522                	lw	a0,8(sp)
  800098:	55a2                	lw	a1,40(sp)
  80009a:	5642                	lw	a2,48(sp)
  80009c:	56e2                	lw	a3,56(sp)
  80009e:	4706                	lw	a4,64(sp)
  8000a0:	47a6                	lw	a5,72(sp)
  8000a2:	00000073          	ecall
  8000a6:	ce2a                	sw	a0,28(sp)
          "m" (a[3]),
          "m" (a[4])
        : "memory"
      );
    return ret;
}
  8000a8:	4572                	lw	a0,28(sp)
  8000aa:	6149                	addi	sp,sp,144
  8000ac:	8082                	ret

00000000008000ae <sys_exit>:

int
sys_exit(int64_t error_code) {
  8000ae:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  8000b0:	4505                	li	a0,1
  8000b2:	b7d1                	j	800076 <syscall>

00000000008000b4 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  8000b4:	4509                	li	a0,2
  8000b6:	b7c1                	j	800076 <syscall>

00000000008000b8 <sys_wait>:
}

int
sys_wait(int64_t pid, int *store) {
  8000b8:	862e                	mv	a2,a1
    return syscall(SYS_wait, pid, store);
  8000ba:	85aa                	mv	a1,a0
  8000bc:	450d                	li	a0,3
  8000be:	bf65                	j	800076 <syscall>

00000000008000c0 <sys_getpid>:
    return syscall(SYS_kill, pid);
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
  8000c0:	4549                	li	a0,18
  8000c2:	bf55                	j	800076 <syscall>

00000000008000c4 <sys_putc>:
}

int
sys_putc(int64_t c) {
  8000c4:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000c6:	4579                	li	a0,30
  8000c8:	b77d                	j	800076 <syscall>

00000000008000ca <sys_lab6_set_priority>:
    return syscall(SYS_gettime);
}

void
sys_lab6_set_priority(uint64_t priority)
{
  8000ca:	85aa                	mv	a1,a0
    syscall(SYS_lab6_set_priority, priority);
  8000cc:	0ff00513          	li	a0,255
  8000d0:	b75d                	j	800076 <syscall>

00000000008000d2 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000d2:	1141                	addi	sp,sp,-16
  8000d4:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000d6:	fd9ff0ef          	jal	ra,8000ae <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000da:	00000517          	auipc	a0,0x0
  8000de:	51650513          	addi	a0,a0,1302 # 8005f0 <main+0xe6>
  8000e2:	f5fff0ef          	jal	ra,800040 <cprintf>
    while (1);
  8000e6:	a001                	j	8000e6 <exit+0x14>

00000000008000e8 <fork>:
}

int
fork(void) {
    return sys_fork();
  8000e8:	b7f1                	j	8000b4 <sys_fork>

00000000008000ea <waitpid>:
    return sys_wait(0, NULL);
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
  8000ea:	b7f9                	j	8000b8 <sys_wait>

00000000008000ec <getpid>:
    return sys_kill(pid);
}

int
getpid(void) {
    return sys_getpid();
  8000ec:	bfd1                	j	8000c0 <sys_getpid>

00000000008000ee <lab6_setpriority>:
}

void
lab6_setpriority(uint32_t priority)
{
    sys_lab6_set_priority(priority);
  8000ee:	1502                	slli	a0,a0,0x20
  8000f0:	9101                	srli	a0,a0,0x20
  8000f2:	bfe1                	j	8000ca <sys_lab6_set_priority>

00000000008000f4 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000f4:	1141                	addi	sp,sp,-16
  8000f6:	e406                	sd	ra,8(sp)
    int ret = main();
  8000f8:	412000ef          	jal	ra,80050a <main>
    exit(ret);
  8000fc:	fd7ff0ef          	jal	ra,8000d2 <exit>

0000000000800100 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800100:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800104:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  800106:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80010a:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  80010c:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800110:	f022                	sd	s0,32(sp)
  800112:	ec26                	sd	s1,24(sp)
  800114:	e84a                	sd	s2,16(sp)
  800116:	f406                	sd	ra,40(sp)
  800118:	e44e                	sd	s3,8(sp)
  80011a:	84aa                	mv	s1,a0
  80011c:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80011e:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800122:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800124:	03067e63          	bgeu	a2,a6,800160 <printnum+0x60>
  800128:	89be                	mv	s3,a5
        while (-- width > 0)
  80012a:	00805763          	blez	s0,800138 <printnum+0x38>
  80012e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800130:	85ca                	mv	a1,s2
  800132:	854e                	mv	a0,s3
  800134:	9482                	jalr	s1
        while (-- width > 0)
  800136:	fc65                	bnez	s0,80012e <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800138:	1a02                	slli	s4,s4,0x20
  80013a:	00000797          	auipc	a5,0x0
  80013e:	4ce78793          	addi	a5,a5,1230 # 800608 <main+0xfe>
  800142:	020a5a13          	srli	s4,s4,0x20
  800146:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  800148:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  80014a:	000a4503          	lbu	a0,0(s4)
}
  80014e:	70a2                	ld	ra,40(sp)
  800150:	69a2                	ld	s3,8(sp)
  800152:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  800154:	85ca                	mv	a1,s2
  800156:	87a6                	mv	a5,s1
}
  800158:	6942                	ld	s2,16(sp)
  80015a:	64e2                	ld	s1,24(sp)
  80015c:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  80015e:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  800160:	03065633          	divu	a2,a2,a6
  800164:	8722                	mv	a4,s0
  800166:	f9bff0ef          	jal	ra,800100 <printnum>
  80016a:	b7f9                	j	800138 <printnum+0x38>

000000000080016c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  80016c:	7119                	addi	sp,sp,-128
  80016e:	f4a6                	sd	s1,104(sp)
  800170:	f0ca                	sd	s2,96(sp)
  800172:	ecce                	sd	s3,88(sp)
  800174:	e8d2                	sd	s4,80(sp)
  800176:	e4d6                	sd	s5,72(sp)
  800178:	e0da                	sd	s6,64(sp)
  80017a:	fc5e                	sd	s7,56(sp)
  80017c:	f06a                	sd	s10,32(sp)
  80017e:	fc86                	sd	ra,120(sp)
  800180:	f8a2                	sd	s0,112(sp)
  800182:	f862                	sd	s8,48(sp)
  800184:	f466                	sd	s9,40(sp)
  800186:	ec6e                	sd	s11,24(sp)
  800188:	892a                	mv	s2,a0
  80018a:	84ae                	mv	s1,a1
  80018c:	8d32                	mv	s10,a2
  80018e:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800190:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  800194:	5b7d                	li	s6,-1
  800196:	00000a97          	auipc	s5,0x0
  80019a:	4a6a8a93          	addi	s5,s5,1190 # 80063c <main+0x132>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80019e:	00000b97          	auipc	s7,0x0
  8001a2:	6bab8b93          	addi	s7,s7,1722 # 800858 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001a6:	000d4503          	lbu	a0,0(s10)
  8001aa:	001d0413          	addi	s0,s10,1
  8001ae:	01350a63          	beq	a0,s3,8001c2 <vprintfmt+0x56>
            if (ch == '\0') {
  8001b2:	c121                	beqz	a0,8001f2 <vprintfmt+0x86>
            putch(ch, putdat);
  8001b4:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001b6:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  8001b8:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001ba:	fff44503          	lbu	a0,-1(s0)
  8001be:	ff351ae3          	bne	a0,s3,8001b2 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  8001c2:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  8001c6:	02000793          	li	a5,32
        lflag = altflag = 0;
  8001ca:	4c81                	li	s9,0
  8001cc:	4881                	li	a7,0
        width = precision = -1;
  8001ce:	5c7d                	li	s8,-1
  8001d0:	5dfd                	li	s11,-1
  8001d2:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  8001d6:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  8001d8:	fdd6059b          	addiw	a1,a2,-35
  8001dc:	0ff5f593          	zext.b	a1,a1
  8001e0:	00140d13          	addi	s10,s0,1
  8001e4:	04b56263          	bltu	a0,a1,800228 <vprintfmt+0xbc>
  8001e8:	058a                	slli	a1,a1,0x2
  8001ea:	95d6                	add	a1,a1,s5
  8001ec:	4194                	lw	a3,0(a1)
  8001ee:	96d6                	add	a3,a3,s5
  8001f0:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8001f2:	70e6                	ld	ra,120(sp)
  8001f4:	7446                	ld	s0,112(sp)
  8001f6:	74a6                	ld	s1,104(sp)
  8001f8:	7906                	ld	s2,96(sp)
  8001fa:	69e6                	ld	s3,88(sp)
  8001fc:	6a46                	ld	s4,80(sp)
  8001fe:	6aa6                	ld	s5,72(sp)
  800200:	6b06                	ld	s6,64(sp)
  800202:	7be2                	ld	s7,56(sp)
  800204:	7c42                	ld	s8,48(sp)
  800206:	7ca2                	ld	s9,40(sp)
  800208:	7d02                	ld	s10,32(sp)
  80020a:	6de2                	ld	s11,24(sp)
  80020c:	6109                	addi	sp,sp,128
  80020e:	8082                	ret
            padc = '0';
  800210:	87b2                	mv	a5,a2
            goto reswitch;
  800212:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800216:	846a                	mv	s0,s10
  800218:	00140d13          	addi	s10,s0,1
  80021c:	fdd6059b          	addiw	a1,a2,-35
  800220:	0ff5f593          	zext.b	a1,a1
  800224:	fcb572e3          	bgeu	a0,a1,8001e8 <vprintfmt+0x7c>
            putch('%', putdat);
  800228:	85a6                	mv	a1,s1
  80022a:	02500513          	li	a0,37
  80022e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800230:	fff44783          	lbu	a5,-1(s0)
  800234:	8d22                	mv	s10,s0
  800236:	f73788e3          	beq	a5,s3,8001a6 <vprintfmt+0x3a>
  80023a:	ffed4783          	lbu	a5,-2(s10)
  80023e:	1d7d                	addi	s10,s10,-1
  800240:	ff379de3          	bne	a5,s3,80023a <vprintfmt+0xce>
  800244:	b78d                	j	8001a6 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800246:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  80024a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80024e:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  800250:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  800254:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  800258:	02d86463          	bltu	a6,a3,800280 <vprintfmt+0x114>
                ch = *fmt;
  80025c:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  800260:	002c169b          	slliw	a3,s8,0x2
  800264:	0186873b          	addw	a4,a3,s8
  800268:	0017171b          	slliw	a4,a4,0x1
  80026c:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  80026e:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  800272:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800274:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800278:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  80027c:	fed870e3          	bgeu	a6,a3,80025c <vprintfmt+0xf0>
            if (width < 0)
  800280:	f40ddce3          	bgez	s11,8001d8 <vprintfmt+0x6c>
                width = precision, precision = -1;
  800284:	8de2                	mv	s11,s8
  800286:	5c7d                	li	s8,-1
  800288:	bf81                	j	8001d8 <vprintfmt+0x6c>
            if (width < 0)
  80028a:	fffdc693          	not	a3,s11
  80028e:	96fd                	srai	a3,a3,0x3f
  800290:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  800294:	00144603          	lbu	a2,1(s0)
  800298:	2d81                	sext.w	s11,s11
  80029a:	846a                	mv	s0,s10
            goto reswitch;
  80029c:	bf35                	j	8001d8 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  80029e:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  8002a2:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  8002a6:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  8002a8:	846a                	mv	s0,s10
            goto process_precision;
  8002aa:	bfd9                	j	800280 <vprintfmt+0x114>
    if (lflag >= 2) {
  8002ac:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002ae:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002b2:	01174463          	blt	a4,a7,8002ba <vprintfmt+0x14e>
    else if (lflag) {
  8002b6:	1a088e63          	beqz	a7,800472 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  8002ba:	000a3603          	ld	a2,0(s4)
  8002be:	46c1                	li	a3,16
  8002c0:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  8002c2:	2781                	sext.w	a5,a5
  8002c4:	876e                	mv	a4,s11
  8002c6:	85a6                	mv	a1,s1
  8002c8:	854a                	mv	a0,s2
  8002ca:	e37ff0ef          	jal	ra,800100 <printnum>
            break;
  8002ce:	bde1                	j	8001a6 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8002d0:	000a2503          	lw	a0,0(s4)
  8002d4:	85a6                	mv	a1,s1
  8002d6:	0a21                	addi	s4,s4,8
  8002d8:	9902                	jalr	s2
            break;
  8002da:	b5f1                	j	8001a6 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8002dc:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002de:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002e2:	01174463          	blt	a4,a7,8002ea <vprintfmt+0x17e>
    else if (lflag) {
  8002e6:	18088163          	beqz	a7,800468 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  8002ea:	000a3603          	ld	a2,0(s4)
  8002ee:	46a9                	li	a3,10
  8002f0:	8a2e                	mv	s4,a1
  8002f2:	bfc1                	j	8002c2 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  8002f4:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  8002f8:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  8002fa:	846a                	mv	s0,s10
            goto reswitch;
  8002fc:	bdf1                	j	8001d8 <vprintfmt+0x6c>
            putch(ch, putdat);
  8002fe:	85a6                	mv	a1,s1
  800300:	02500513          	li	a0,37
  800304:	9902                	jalr	s2
            break;
  800306:	b545                	j	8001a6 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800308:	00144603          	lbu	a2,1(s0)
            lflag ++;
  80030c:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  80030e:	846a                	mv	s0,s10
            goto reswitch;
  800310:	b5e1                	j	8001d8 <vprintfmt+0x6c>
    if (lflag >= 2) {
  800312:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800314:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800318:	01174463          	blt	a4,a7,800320 <vprintfmt+0x1b4>
    else if (lflag) {
  80031c:	14088163          	beqz	a7,80045e <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  800320:	000a3603          	ld	a2,0(s4)
  800324:	46a1                	li	a3,8
  800326:	8a2e                	mv	s4,a1
  800328:	bf69                	j	8002c2 <vprintfmt+0x156>
            putch('0', putdat);
  80032a:	03000513          	li	a0,48
  80032e:	85a6                	mv	a1,s1
  800330:	e03e                	sd	a5,0(sp)
  800332:	9902                	jalr	s2
            putch('x', putdat);
  800334:	85a6                	mv	a1,s1
  800336:	07800513          	li	a0,120
  80033a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80033c:	0a21                	addi	s4,s4,8
            goto number;
  80033e:	6782                	ld	a5,0(sp)
  800340:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800342:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  800346:	bfb5                	j	8002c2 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  800348:	000a3403          	ld	s0,0(s4)
  80034c:	008a0713          	addi	a4,s4,8
  800350:	e03a                	sd	a4,0(sp)
  800352:	14040263          	beqz	s0,800496 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  800356:	0fb05763          	blez	s11,800444 <vprintfmt+0x2d8>
  80035a:	02d00693          	li	a3,45
  80035e:	0cd79163          	bne	a5,a3,800420 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800362:	00044783          	lbu	a5,0(s0)
  800366:	0007851b          	sext.w	a0,a5
  80036a:	cf85                	beqz	a5,8003a2 <vprintfmt+0x236>
  80036c:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  800370:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800374:	000c4563          	bltz	s8,80037e <vprintfmt+0x212>
  800378:	3c7d                	addiw	s8,s8,-1
  80037a:	036c0263          	beq	s8,s6,80039e <vprintfmt+0x232>
                    putch('?', putdat);
  80037e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800380:	0e0c8e63          	beqz	s9,80047c <vprintfmt+0x310>
  800384:	3781                	addiw	a5,a5,-32
  800386:	0ef47b63          	bgeu	s0,a5,80047c <vprintfmt+0x310>
                    putch('?', putdat);
  80038a:	03f00513          	li	a0,63
  80038e:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800390:	000a4783          	lbu	a5,0(s4)
  800394:	3dfd                	addiw	s11,s11,-1
  800396:	0a05                	addi	s4,s4,1
  800398:	0007851b          	sext.w	a0,a5
  80039c:	ffe1                	bnez	a5,800374 <vprintfmt+0x208>
            for (; width > 0; width --) {
  80039e:	01b05963          	blez	s11,8003b0 <vprintfmt+0x244>
  8003a2:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  8003a4:	85a6                	mv	a1,s1
  8003a6:	02000513          	li	a0,32
  8003aa:	9902                	jalr	s2
            for (; width > 0; width --) {
  8003ac:	fe0d9be3          	bnez	s11,8003a2 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003b0:	6a02                	ld	s4,0(sp)
  8003b2:	bbd5                	j	8001a6 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003b4:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8003b6:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  8003ba:	01174463          	blt	a4,a7,8003c2 <vprintfmt+0x256>
    else if (lflag) {
  8003be:	08088d63          	beqz	a7,800458 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  8003c2:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8003c6:	0a044d63          	bltz	s0,800480 <vprintfmt+0x314>
            num = getint(&ap, lflag);
  8003ca:	8622                	mv	a2,s0
  8003cc:	8a66                	mv	s4,s9
  8003ce:	46a9                	li	a3,10
  8003d0:	bdcd                	j	8002c2 <vprintfmt+0x156>
            err = va_arg(ap, int);
  8003d2:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003d6:	4761                	li	a4,24
            err = va_arg(ap, int);
  8003d8:	0a21                	addi	s4,s4,8
            if (err < 0) {
  8003da:	41f7d69b          	sraiw	a3,a5,0x1f
  8003de:	8fb5                	xor	a5,a5,a3
  8003e0:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003e4:	02d74163          	blt	a4,a3,800406 <vprintfmt+0x29a>
  8003e8:	00369793          	slli	a5,a3,0x3
  8003ec:	97de                	add	a5,a5,s7
  8003ee:	639c                	ld	a5,0(a5)
  8003f0:	cb99                	beqz	a5,800406 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  8003f2:	86be                	mv	a3,a5
  8003f4:	00000617          	auipc	a2,0x0
  8003f8:	24460613          	addi	a2,a2,580 # 800638 <main+0x12e>
  8003fc:	85a6                	mv	a1,s1
  8003fe:	854a                	mv	a0,s2
  800400:	0ce000ef          	jal	ra,8004ce <printfmt>
  800404:	b34d                	j	8001a6 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800406:	00000617          	auipc	a2,0x0
  80040a:	22260613          	addi	a2,a2,546 # 800628 <main+0x11e>
  80040e:	85a6                	mv	a1,s1
  800410:	854a                	mv	a0,s2
  800412:	0bc000ef          	jal	ra,8004ce <printfmt>
  800416:	bb41                	j	8001a6 <vprintfmt+0x3a>
                p = "(null)";
  800418:	00000417          	auipc	s0,0x0
  80041c:	20840413          	addi	s0,s0,520 # 800620 <main+0x116>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800420:	85e2                	mv	a1,s8
  800422:	8522                	mv	a0,s0
  800424:	e43e                	sd	a5,8(sp)
  800426:	0c8000ef          	jal	ra,8004ee <strnlen>
  80042a:	40ad8dbb          	subw	s11,s11,a0
  80042e:	01b05b63          	blez	s11,800444 <vprintfmt+0x2d8>
                    putch(padc, putdat);
  800432:	67a2                	ld	a5,8(sp)
  800434:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  800438:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  80043a:	85a6                	mv	a1,s1
  80043c:	8552                	mv	a0,s4
  80043e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800440:	fe0d9ce3          	bnez	s11,800438 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800444:	00044783          	lbu	a5,0(s0)
  800448:	00140a13          	addi	s4,s0,1
  80044c:	0007851b          	sext.w	a0,a5
  800450:	d3a5                	beqz	a5,8003b0 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  800452:	05e00413          	li	s0,94
  800456:	bf39                	j	800374 <vprintfmt+0x208>
        return va_arg(*ap, int);
  800458:	000a2403          	lw	s0,0(s4)
  80045c:	b7ad                	j	8003c6 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  80045e:	000a6603          	lwu	a2,0(s4)
  800462:	46a1                	li	a3,8
  800464:	8a2e                	mv	s4,a1
  800466:	bdb1                	j	8002c2 <vprintfmt+0x156>
  800468:	000a6603          	lwu	a2,0(s4)
  80046c:	46a9                	li	a3,10
  80046e:	8a2e                	mv	s4,a1
  800470:	bd89                	j	8002c2 <vprintfmt+0x156>
  800472:	000a6603          	lwu	a2,0(s4)
  800476:	46c1                	li	a3,16
  800478:	8a2e                	mv	s4,a1
  80047a:	b5a1                	j	8002c2 <vprintfmt+0x156>
                    putch(ch, putdat);
  80047c:	9902                	jalr	s2
  80047e:	bf09                	j	800390 <vprintfmt+0x224>
                putch('-', putdat);
  800480:	85a6                	mv	a1,s1
  800482:	02d00513          	li	a0,45
  800486:	e03e                	sd	a5,0(sp)
  800488:	9902                	jalr	s2
                num = -(long long)num;
  80048a:	6782                	ld	a5,0(sp)
  80048c:	8a66                	mv	s4,s9
  80048e:	40800633          	neg	a2,s0
  800492:	46a9                	li	a3,10
  800494:	b53d                	j	8002c2 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  800496:	03b05163          	blez	s11,8004b8 <vprintfmt+0x34c>
  80049a:	02d00693          	li	a3,45
  80049e:	f6d79de3          	bne	a5,a3,800418 <vprintfmt+0x2ac>
                p = "(null)";
  8004a2:	00000417          	auipc	s0,0x0
  8004a6:	17e40413          	addi	s0,s0,382 # 800620 <main+0x116>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004aa:	02800793          	li	a5,40
  8004ae:	02800513          	li	a0,40
  8004b2:	00140a13          	addi	s4,s0,1
  8004b6:	bd6d                	j	800370 <vprintfmt+0x204>
  8004b8:	00000a17          	auipc	s4,0x0
  8004bc:	169a0a13          	addi	s4,s4,361 # 800621 <main+0x117>
  8004c0:	02800513          	li	a0,40
  8004c4:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c8:	05e00413          	li	s0,94
  8004cc:	b565                	j	800374 <vprintfmt+0x208>

00000000008004ce <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004ce:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8004d0:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004d4:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004d6:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004d8:	ec06                	sd	ra,24(sp)
  8004da:	f83a                	sd	a4,48(sp)
  8004dc:	fc3e                	sd	a5,56(sp)
  8004de:	e0c2                	sd	a6,64(sp)
  8004e0:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8004e2:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004e4:	c89ff0ef          	jal	ra,80016c <vprintfmt>
}
  8004e8:	60e2                	ld	ra,24(sp)
  8004ea:	6161                	addi	sp,sp,80
  8004ec:	8082                	ret

00000000008004ee <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8004ee:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8004f0:	e589                	bnez	a1,8004fa <strnlen+0xc>
  8004f2:	a811                	j	800506 <strnlen+0x18>
        cnt ++;
  8004f4:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8004f6:	00f58863          	beq	a1,a5,800506 <strnlen+0x18>
  8004fa:	00f50733          	add	a4,a0,a5
  8004fe:	00074703          	lbu	a4,0(a4)
  800502:	fb6d                	bnez	a4,8004f4 <strnlen+0x6>
  800504:	85be                	mv	a1,a5
    }
    return cnt;
}
  800506:	852e                	mv	a0,a1
  800508:	8082                	ret

000000000080050a <main>:
 */
#include <ulib.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  80050a:	7175                	addi	sp,sp,-144
    cprintf("test_mixed_workload: mixed workload and priority test\n");
  80050c:	00000517          	auipc	a0,0x0
  800510:	46450513          	addi	a0,a0,1124 # 800970 <error_string+0x118>
int main(void) {
  800514:	fca6                	sd	s1,120(sp)
  800516:	f8ca                	sd	s2,112(sp)
  800518:	e506                	sd	ra,136(sp)
  80051a:	e122                	sd	s0,128(sp)
  80051c:	f4ce                	sd	s3,104(sp)
  80051e:	f0d2                	sd	s4,96(sp)
    cprintf("test_mixed_workload: mixed workload and priority test\n");
  800520:	b21ff0ef          	jal	ra,800040 <cprintf>
    // Processes with different priorities and workloads
    struct {
        int workload;
        int priority;
        char *name;
    } tasks[] = {
  800524:	00000797          	auipc	a5,0x0
  800528:	4ec78793          	addi	a5,a5,1260 # 800a10 <error_string+0x1b8>
  80052c:	0007be03          	ld	t3,0(a5)
  800530:	0087b303          	ld	t1,8(a5)
  800534:	0107b883          	ld	a7,16(a5)
  800538:	0187b803          	ld	a6,24(a5)
  80053c:	7388                	ld	a0,32(a5)
  80053e:	778c                	ld	a1,40(a5)
  800540:	7b90                	ld	a2,48(a5)
  800542:	7f94                	ld	a3,56(a5)
  800544:	63b8                	ld	a4,64(a5)
  800546:	67bc                	ld	a5,72(a5)
  800548:	e872                	sd	t3,16(sp)
  80054a:	ec1a                	sd	t1,24(sp)
  80054c:	f046                	sd	a7,32(sp)
  80054e:	f442                	sd	a6,40(sp)
  800550:	f82a                	sd	a0,48(sp)
  800552:	fc2e                	sd	a1,56(sp)
  800554:	e0b2                	sd	a2,64(sp)
  800556:	e4b6                	sd	a3,72(sp)
  800558:	e8ba                	sd	a4,80(sp)
  80055a:	ecbe                	sd	a5,88(sp)
    };
    
    int child_count = 5;
    int i, pid;
    
    for (i = 0; i < child_count; i++) {
  80055c:	4481                	li	s1,0
  80055e:	4915                	li	s2,5
        pid = fork();
  800560:	b89ff0ef          	jal	ra,8000e8 <fork>
  800564:	842a                	mv	s0,a0
        if (pid == 0) {
  800566:	c915                	beqz	a0,80059a <main+0x90>
    for (i = 0; i < child_count; i++) {
  800568:	2485                	addiw	s1,s1,1
  80056a:	ff249be3          	bne	s1,s2,800560 <main+0x56>
  80056e:	4415                	li	s0,5
            exit(0);
        }
    }
    
    // Parent waits for all children
    for (i = 0; i < child_count; i++) {
  800570:	347d                	addiw	s0,s0,-1
        waitpid(-1, NULL);
  800572:	4581                	li	a1,0
  800574:	557d                	li	a0,-1
  800576:	b75ff0ef          	jal	ra,8000ea <waitpid>
    for (i = 0; i < child_count; i++) {
  80057a:	f87d                	bnez	s0,800570 <main+0x66>
    }
    
    cprintf("test_mixed_workload: all children finished\n");
  80057c:	00000517          	auipc	a0,0x0
  800580:	46450513          	addi	a0,a0,1124 # 8009e0 <error_string+0x188>
  800584:	abdff0ef          	jal	ra,800040 <cprintf>
    return 0;
}
  800588:	60aa                	ld	ra,136(sp)
  80058a:	640a                	ld	s0,128(sp)
  80058c:	74e6                	ld	s1,120(sp)
  80058e:	7946                	ld	s2,112(sp)
  800590:	79a6                	ld	s3,104(sp)
  800592:	7a06                	ld	s4,96(sp)
  800594:	4501                	li	a0,0
  800596:	6149                	addi	sp,sp,144
  800598:	8082                	ret
            lab6_setpriority(tasks[i].priority);
  80059a:	109c                	addi	a5,sp,96
  80059c:	00449993          	slli	s3,s1,0x4
  8005a0:	01378933          	add	s2,a5,s3
  8005a4:	fb492a03          	lw	s4,-76(s2)
  8005a8:	8552                	mv	a0,s4
  8005aa:	b45ff0ef          	jal	ra,8000ee <lab6_setpriority>
            for (j = 0; j < tasks[i].workload; j++) {
  8005ae:	fb092903          	lw	s2,-80(s2)
            volatile int sum = 0;
  8005b2:	c602                	sw	zero,12(sp)
            for (j = 0; j < tasks[i].workload; j++) {
  8005b4:	01245763          	bge	s0,s2,8005c2 <main+0xb8>
                sum += j;
  8005b8:	46b2                	lw	a3,12(sp)
  8005ba:	9ea1                	addw	a3,a3,s0
  8005bc:	c636                	sw	a3,12(sp)
            for (j = 0; j < tasks[i].workload; j++) {
  8005be:	2405                	addiw	s0,s0,1
  8005c0:	bfd5                	j	8005b4 <main+0xaa>
            cprintf("child %d (%s, pid %d, prio %d, load %d) finished\n", 
  8005c2:	109c                	addi	a5,sp,96
  8005c4:	99be                	add	s3,s3,a5
  8005c6:	fb89b403          	ld	s0,-72(s3)
  8005ca:	b23ff0ef          	jal	ra,8000ec <getpid>
  8005ce:	86aa                	mv	a3,a0
  8005d0:	87ca                	mv	a5,s2
  8005d2:	8752                	mv	a4,s4
  8005d4:	8622                	mv	a2,s0
  8005d6:	85a6                	mv	a1,s1
  8005d8:	00000517          	auipc	a0,0x0
  8005dc:	3d050513          	addi	a0,a0,976 # 8009a8 <error_string+0x150>
  8005e0:	a61ff0ef          	jal	ra,800040 <cprintf>
            exit(0);
  8005e4:	4501                	li	a0,0
  8005e6:	aedff0ef          	jal	ra,8000d2 <exit>
