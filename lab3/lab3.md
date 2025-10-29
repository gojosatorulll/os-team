# 练习一：

## 一、实现过程

1. **修改目标函数**
    在 `trap.c` 中找到 `interrupt_handler()` 函数里的case IRQ_S_TIMER分支。

2. **补充中断处理逻辑**
    按要求添加如下代码（核心逻辑）：

   ```
   case IRQ_S_TIMER: {
       clock_set_next_event();   // 设定下次时钟中断
       static int ticks = 0;
       static int num = 0;
       ticks++;
   
       if (ticks % TICK_NUM == 0) {  // 每100次打印一次
           print_ticks();
           num++;
       }
   
       if (num == 10) {              // 打印10次后关机
           sbi_shutdown();
       }
       break;
   }
   ```

3. **重新编译并运行内核**

   - 运行后，大约每 1 秒会打印一次 100 ticks
   - 共打印 10 次后系统自动关机。

##  二、定时器中断的处理流程

### 1. 硬件触发

RISC-V 的 **定时器（timer）** 到达设定时间后，会向 **S 模式（Supervisor Mode）** 发出一个 **时钟中断信号**。

首先初始化trap.c：

```
void idt_init(void) {
    extern void __alltraps(void);
    //约定：若中断前处于S态，sscratch为0
    //若中断前处于U态，sscratch存储内核栈地址
    //那么之后就可以通过sscratch的数值判断是内核态产生的中断还是用户态产生的中断
    //我们现在是内核态所以给sscratch置零
    write_csr(sscratch, 0);
    //我们保证__alltraps的地址是四字节对齐的，将__alltraps这个符号的地址直接写到stvec寄存器
    write_csr(stvec, &__alltraps);
}
```

write_csr函数将sscratch置为0，表示当前是s态，然后初始化中断向量表基址，此处为唯一的中断异常处理程序__alltraps。

然后在intr.c中设置sstatus的s态中断使能位，防止中断过程中有其他中断进入。

### 2. 进入陷入处理

然后在intr.c中设置sstatus的s态中断使能位，防止中断过程中有其他中断进入。
CPU 收到中断后：

- 自动保存当前寄存器上下文；
- 跳转到 `stvec` 寄存器中保存的地址（即 `__alltraps`）；
- 由汇编入口代码（`trapentry.S`）构造一个 `trapframe`；
- 然后跳入 C 语言层面的 `trap(struct trapframe *tf)`。

------

### 🔹 3. C层 trap() 调用分发

```
static inline void trap_dispatch(struct trapframe *tf) {
    //scause的最高位是1，说明trap是由中断引起的
    if ((intptr_t)tf->cause < 0) {
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
    }
}
```

调用trap_dispatch函数，传入参数tf->cause的第一位确定是0的话就是中断，进入分支interrupt_handler（tf）。否则进入   exception_handler(tf);

根据 `tf->cause` 判断是 **异常** 还是 **中断**。
 如果是中断，就调用：

### 4. 进入中断分发函数

`interrupt_handler()` 根据中断号选择对应的 case：

```
case IRQ_S_TIMER:
 clock_set_next_event();   // 设定下次时钟中断
            static int ticks = 0;
            static int num = 0;
            ticks++;

            if (ticks % TICK_NUM == 0) {  // 每100次打印一次
            print_ticks();
            num++;
            }

            if (num == 10) {              // 打印10次后关机
            sbi_shutdown();
            }
```



### 5 . 恢复现场返回

中断处理完毕后：

- 程序回到 `trapentry.S`；
- 由汇编恢复寄存器现场；
- 使用 `sret` 指令返回到被中断的代码继续执行。

![image-20251028180215996](D:\notebook\image\image-20251028180215996.png)

#### 扩展练习 Challenge1：描述与理解中断流程

> 回答：描述ucore中处理中断异常的流程（从异常的产生开始），其中mov a0，sp的目的是什么？SAVE_ALL中寄寄存器保存在栈中的位置是什么确定的？对于任何中断，__alltraps 中都需要保存所有寄存器吗？请说明理由。

从异常产生，硬件会自动检测到事件异常，然后将当前指令地址或者发生错误缺页访问的地址等等存入sepc，并将识别出的异常原因写进scause供后续的stvec处理指向具体程序，如果是异常，会保存附带信息如出错的指令地址到stval。

设置当前特权级为s，跳转到stvec指定的入口即alltrap（）

```
__alltraps:
    SAVE_ALL

    move  a0, sp
    jal trap
    # sp should be the same as before "jal trap"

    .globl __trapret
```

alltrap内部首先保存上下文有32个通用寄存器以及4个中断相关的CSR：

```assembly
# RISCV不能直接从CSR写到内存, 需要csrr把CSR读取到通用寄存器，再从通用寄存器STORE到内存
    csrrw s0, sscratch, x0
    csrr s1, sstatus
    csrr s2, sepc
    csrr s3, sbadaddr
    csrr s4, scause

    STORE s0, 2*REGBYTES(sp)
    STORE s1, 32*REGBYTES(sp)
    STORE s2, 33*REGBYTES(sp)
    STORE s3, 34*REGBYTES(sp)
    STORE s4, 35*REGBYTES(sp)
    .endm #汇编宏定义结束
```

**其中mov a0，sp的目的是**：sp指向当前栈顶，也就是trapframe的结构体，struct trapframe *tf = (struct trapframe *)sp;把sp的存储地址给a0，a0作为参数传入下一个被调用的函数的参数，也就是jal到的trap函数的参数。

**SAVE_ALL中寄寄存器保存在栈中的位置是什么确定的？**

SAVE_ALL是一段汇编宏，把32个通用寄存器以及4个s模式的CSR一个个按顺序压入栈，对应着c中的trapframe的结构体定义顺序，一一对应：

```assembly
csrw sscratch, sp

    addi sp, sp, -36 * REGBYTES
    # save x registers
    STORE x0, 0*REGBYTES(sp)
    STORE x1, 1*REGBYTES(sp)
    STORE x3, 3*REGBYTES(sp)
    STORE x4, 4*REGBYTES(sp)
    STORE x5, 5*REGBYTES(sp)
    STORE x6, 6*REGBYTES(sp)
    STORE x7, 7*REGBYTES(sp)
    STORE x8, 8*REGBYTES(sp)
    STORE x9, 9*REGBYTES(sp)
    STORE x10, 10*REGBYTES(sp)
    STORE x11, 11*REGBYTES(sp)
    STORE x12, 12*REGBYTES(sp)
    STORE x13, 13*REGBYTES(sp)
    STORE x14, 14*REGBYTES(sp)
    STORE x15, 15*REGBYTES(sp)
    STORE x16, 16*REGBYTES(sp)
    STORE x17, 17*REGBYTES(sp)
    STORE x18, 18*REGBYTES(sp)
    STORE x19, 19*REGBYTES(sp)
    STORE x20, 20*REGBYTES(sp)
    STORE x21, 21*REGBYTES(sp)
    STORE x22, 22*REGBYTES(sp)
    STORE x23, 23*REGBYTES(sp)
    STORE x24, 24*REGBYTES(sp)
    STORE x25, 25*REGBYTES(sp)
    STORE x26, 26*REGBYTES(sp)
    STORE x27, 27*REGBYTES(sp)
    STORE x28, 28*REGBYTES(sp)
    STORE x29, 29*REGBYTES(sp)
    STORE x30, 30*REGBYTES(sp)
    STORE x31, 31*REGBYTES(sp)

    # get sr, epc, badvaddr, cause
    # Set sscratch register to 0, so that if a recursive exception
    # occurs, the exception vector knows it came from the kernel
    csrrw s0, sscratch, x0
    csrr s1, sstatus
    csrr s2, sepc
    csrr s3, sbadaddr
    csrr s4, scause

    STORE s0, 2*REGBYTES(sp)
    STORE s1, 32*REGBYTES(sp)
    STORE s2, 33*REGBYTES(sp)
    STORE s3, 34*REGBYTES(sp)
    STORE s4, 35*REGBYTES(sp)
    .endm
```

```c++
struct pushregs {
    uintptr_t zero;  // Hard-wired zero
    uintptr_t ra;    // Return address
    uintptr_t sp;    // Stack pointer
    uintptr_t gp;    // Global pointer
    uintptr_t tp;    // Thread pointer
    uintptr_t t0;    // Temporary
    uintptr_t t1;    // Temporary
    uintptr_t t2;    // Temporary
    uintptr_t s0;    // Saved register/frame pointer
    uintptr_t s1;    // Saved register
    uintptr_t a0;    // Function argument/return value
    uintptr_t a1;    // Function argument/return value
    uintptr_t a2;    // Function argument
    uintptr_t a3;    // Function argument
    uintptr_t a4;    // Function argument
    uintptr_t a5;    // Function argument
    uintptr_t a6;    // Function argument
    uintptr_t a7;    // Function argument
    uintptr_t s2;    // Saved register
    uintptr_t s3;    // Saved register
    uintptr_t s4;    // Saved register
    uintptr_t s5;    // Saved register
    uintptr_t s6;    // Saved register
    uintptr_t s7;    // Saved register
    uintptr_t s8;    // Saved register
    uintptr_t s9;    // Saved register
    uintptr_t s10;   // Saved register
    uintptr_t s11;   // Saved register
    uintptr_t t3;    // Temporary
    uintptr_t t4;    // Temporary
    uintptr_t t5;    // Temporary
    uintptr_t t6;    // Temporary
};

struct trapframe {
    struct pushregs gpr;
    uintptr_t status;
    uintptr_t epc;
    uintptr_t badvaddr;
    uintptr_t cause;
};
```

 **对于任何中断，`__alltraps` 都要保存所有寄存器吗？**

被中断具有随机性和不确定性，只有全部保存才能保证中断处理结束后，返回的上下文是与先前一致的，更保险。

#### 扩增练习 Challenge2：理解上下文切换机制

> 回答：在trapentry.S中汇编代码 csrw sscratch, sp；csrrw s0, sscratch, x0实现了什么操作，目的是什么？save all里面保存了stval scause这些csr，而在restore all里面却不还原它们？那这样store的意义何在呢？

`csrw sscratch, sp；`是将当前栈顶指针存入sscratch，在中断发生后，硬件只会自动保存sepc、scause、sstval、sstatus。但是软件的正在使用且保存着数据的通用寄存器还没保存，而又因为当前的栈是用户态的由sp管理，因此要安全的保存，应该使用s态的临时寄存器存放指针，来暂时维护栈，栈（`sp`）是**用户态的栈**，它可能不安全、甚至不能访问（比如访问页表被限制）

`csrrw s0, sscratch, x0`将sscratch读出来的值放到通用寄存器s0，并且清空sscratch。这时的s0寄存器可能后续用来保存上下文，或者恢复用户态的栈，或者切换任务的交接

##### save all里面保存了stval scause这些csr，而在restore all里面却不还原它们？那这样store的意义何在呢？

他们只用来保存中断时的异常原因状态等，一旦使用完就没有意义了，不需要对其维护，只需等下一次trap再次变化，store的意义在于通过这些CSR可以确定trap的属性是中断还是异常，如果异常，那错误指令在哪，中断处理完之后，程序该回到哪。

