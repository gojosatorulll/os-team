#### 练习0：填写已有实验

本实验依赖实验2/3。请把你做的实验2/3的代码填入本实验中代码中有“LAB2”,“LAB3”的注释相应部分。

#### 练习1：分配并初始化一个进程控制块（需要编码）

alloc_proc函数（位于kern/process/proc.c中）负责分配并返回一个新的struct proc_struct结构，用于存储新建立的内核线程的管理信息。ucore需要对这个结构进行最基本的初始化，你需要完成这个初始化过程。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 请说明proc_struct中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？（提示通过看代码和编程调试可以判断出来）

**struct context context**是用来保存cpu的上下文，当cpu进行了进程间的切换时，要保存旧进程的上下文也就是各种寄存器的状态比如：

```c++
struct context {
    uint32_t eip;   // 指令指针
    uint32_t esp;   // 栈指针
    uint32_t ebp;   // 基址指针
    uint32_t ebx;
    uint32_t esi;
    uint32_t edi;
    // 其他通用寄存器
};

```

**只保存内核模式需要的寄存器**（用户态寄存器通过 trapframe 保存）。当调度器决定切换进程时，调用函数switch_to(old,new),同时保存就进程的寄存器状态的context并把context恢复到new中（如果是第一次就初始化一个栈帧，使用proc->esp指向这个栈帧顶部）

**struct trapframe *tf**用来存中断、异常、系统调用等时的cpu状态，trapframe 保存了 **完整寄存器集合**，包括用户态寄存器，每次中断时，cpu自动把寄存器压入内核栈中，由trapframe表示，内核通过tf修改栈中寄存器值。新建内核线程时，`tf` 可以为空，因为没有用户态寄存器要保存。

综上，context可以看成是内核线程的快照，trapframe时用户态的快照。

##### 1.设计实现过程简要说明

在`alloc_proc`函数中，我为新分配的`proc_struct`结构体的各个成员进行了初始化，确保其状态为未初始化（`PROC_UNINIT`），pid为-1，运行次数为0，内核栈指针为0，调度标志为0，父进程和内存管理指针为NULL，trapframe指针为NULL，页表指针为`boot_pgdir_pa`，标志位为0，进程名清零，并初始化了链表节点。这样可以保证新进程结构体的各项属性处于安全、可控的初始状态，便于后续的进程管理和调度。

##### 2.context 和 trapframe 的含义及作用

- **struct context context**
  - **含义**：保存进程/线程在内核态切换时需要保存的寄存器（如ra、sp等），用于进程切换时的上下文保存和恢复。
  - **作用**：在进程切换（`switch_to`）时，当前进程的`context`会保存当前CPU的部分寄存器内容，切换到下一个进程时再恢复其`context`，实现多进程/线程的切换。
- **struct trapframe \*tf**
  - **含义**：指向一个trapframe结构体，trapframe保存了进程/线程在发生中断、异常或系统调用时的全部寄存器状态（包括用户态和内核态的通用寄存器、pc、状态寄存器等）。
  - **作用**：在内核处理中断、异常或系统调用时，`tf`用于保存和恢复进程的完整CPU状态。新进程创建时会设置`tf`，进程返回用户态时会根据`tf`恢复寄存器，实现用户态与内核态的切换。



#### 练习2：为新创建的内核线程分配资源（需要编码）

创建一个内核线程需要分配和设置好很多资源。kernel_thread函数通过调用**do_fork**函数完成具体内核线程的创建工作。do_kernel函数会调用alloc_proc函数来分配并初始化一个进程控制块，但alloc_proc只是找到了一小块内存用以记录进程的必要信息，并没有实际分配这些资源。ucore一般通过do_fork实际创建新的内核线程。do_fork的作用是，创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同。因此，我们**实际需要"fork"的东西就是stack和trapframe**。在这个过程中，需要给新内核线程分配资源，并且复制原进程的状态。你需要完成在kern/process/proc.c中的do_fork函数中的处理过程。它的大致执行步骤包括：

- 调用alloc_proc，首先获得一块用户信息块。
- 为进程分配一个内核栈。
- 复制原进程的内存管理信息到新进程（但内核线程不必做此事）
- 复制原进程上下文到新进程
- 将新进程添加到进程列表
- 唤醒新进程
- 返回新进程号

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。



##### 1.设计实现过程简要说明

本实验的进程/线程创建主要通过`do_fork`函数实现。其核心流程如下：

1. **分配进程控制块**：调用`alloc_proc`为新进程分配并初始化`proc_struct`结构体，设置初始状态和各成员变量。
2. **分配内核栈**：调用`setup_kstack`为新进程分配内核栈空间。
3. **复制内存管理信息**：调用`copy_mm`，对于内核线程本实验无需实际复制用户空间内存管理信息。
4. **复制上下文和trapframe**：调用`copy_thread`，将父进程的trapframe和上下文复制到新进程，保证新进程启动时的CPU状态正确。
5. **分配唯一pid**：调用`get_pid`为新进程分配唯一的进程ID。
6. **设置父子关系**：将新进程的`parent`指向当前进程。
7. **插入进程链表和哈希表**：调用`hash_proc`和`list_add`将新进程插入全局进程管理结构。
8. **唤醒新进程**：调用`wakeup_proc`将新进程状态设置为可调度。
9. **返回新进程pid**：返回新进程的唯一标识符。



##### 2.**答案：是的，ucore为每个新fork的线程分配了唯一的id。**

**分析理由如下：**

- 在`do_fork`函数中，分配pid的操作是通过`proc->pid = get_pid();`完成的。
- `get_pid`函数会遍历全局进程链表，查找未被占用的最小pid，并保证不会与现有进程重复。它会跳过已被占用的pid，并在必要时循环查找，确保分配的pid在所有活动进程中唯一。
- 只有当`get_pid`返回的pid未被其他进程占用时，才会分配给新进程。
- 进程创建后，pid会被插入到哈希表和链表中，后续分配时会再次检查，避免重复。

**结论**：
ucore通过`get_pid`机制，确保每个新fork的线程（进程）都能获得唯一的pid，不会与现有进程冲突，满足操作系统对进程唯一标识的要求。





#### 练习3：编写proc_run 函数（需要编码）

proc_run用于将指定的进程切换到CPU上运行。它的大致执行步骤包括：

- 检查要切换的进程是否与当前正在运行的进程相同，如果相同则不需要切换。
- 禁用中断。你可以使用`/kern/sync/sync.h`中定义好的宏`local_intr_save(x)`和`local_intr_restore(x)`来实现关、开中断。
- 切换当前进程为要运行的进程。
- 切换页表，以便使用新进程的地址空间。`/libs/riscv.h`中提供了`lsatp(unsigned int pgdir)`函数，可实现修改SATP寄存器值的功能。
- 实现上下文切换。`/kern/process`中已经预先编写好了`switch.S`，其中定义了`switch_to()`函数。可实现两个进程的context切换。
- 允许中断。

请回答如下问题：

- 在本实验的执行过程中，创建且运行了几个内核线程？



##### 1.完成代码编写后，编译并运行代码：make qemu

在本实验的执行过程中，创建并运行了2个内核线程：

1. idle 线程（idleproc）
2. init 线程（initproc）

idle 线程由 proc_init 首先创建并运行，init 线程通过 kernel_thread 创建并运行。







#### 扩展练习 Challenge：

> 说明语句`local_intr_save(intr_flag);....local_intr_restore(intr_flag);`是如何实现开关中断的？

**RISC-V CPU 的中断控制**

- RISC-V 用 `sstatus` 寄存器的 **SIE 位** 来控制 Supervisor（内核/特权级）下的中断允许：
  - `SIE` = 1 → 中断允许
  - `SIE` = 0 → 中断禁止
- 当中断发生时，硬件会：
  1. 清 `SIE`（自动禁止下一级中断）
  2. 保存当前 `sstatus` 的 `SIE` 到 `SPIE`
  3. 跳转到 trap handler

```c++
#define SSTATUS_SIE (1 << 1)

static inline void local_intr_save(unsigned long *flags)
{
    unsigned long sstatus_val = read_csr(sstatus); // 读 sstatus 寄存器
    *flags = sstatus_val & SSTATUS_SIE;           // 保存当前中断允许标志
    clear_csr(sstatus, SSTATUS_SIE);             // 禁止中断
}

```

`read_csr(sstatus)` : 读取 CPU 的状态寄存器

保存当前 SIE 到 `irq_flags`

`clear_csr(sstatus, SSTATUS_SIE)` : 禁止本 CPU 响应中断

此时，当前核可以安全执行临界区代码，不会被中断打断。

```c++
static inline void local_intr_restore(unsigned long flags)
{
    if (flags & SSTATUS_SIE) 
        set_csr(sstatus, SSTATUS_SIE);  // 恢复中断允许
}

```

根据之前保存的 `irq_flags` 决定是否开启中断

这样可以保证**临界区结束后恢复之前的中断状态**

```c++
local_intr_save(irq_flags);

struct proc_struct *prev = current;
current = proc;
lsatp(proc->pgdir);
switch_to(&prev->context, &proc->context);

local_intr_restore(irq_flags);

```

1. 先禁止中断，避免在切换上下文时被打断 → 防止栈、寄存器被破坏
2. 切换当前进程指针 `current`
3. 切换页表 `lsatp`
4. 上下文切换 `switch_to`
5. 恢复中断，使 CPU 可以响应外部中断

> 深入理解不同分页模式的工作原理（思考题）

get_pte()函数（位于`kern/mm/pmm.c`）用于在页表中查找或创建页表项，从而实现对指定线性地址对应的物理页的访问和映射操作。这在操作系统中的分页机制下，是实现虚拟内存与物理内存之间映射关系非常重要的内容。

> get_pte()函数中有两段形式类似的代码， 结合sv32，sv39，sv48的异同，解释这两段代码为什么如此相像?

**答：**虚拟地址从高到低，每一层取对应的索引去页表中找下一级页表或最终 PTE。

​	页表是 **两级结构**：

```
[一级页目录 PDE1] → [二级页目录 PDE0] → [页表项 PTE]
```

所以函数要：

1. 从顶级页目录 `pgdir` 找到第一级表项（pdep1）
2. 找到或创建第二级页表（pdep0）
3. 最后返回具体 PTE 的地址

它们都在做“查找当前层页表项 → 如果不存在就分配一页新的页表 → 写入 PTE → 进入下一层”的动作。

所以在 SV39 下，`get_pte()` 逻辑就是三层嵌套：

```c++
// level 2
if (!PTE_V) alloc();
// level 1
if (!PTE_V) alloc();
// level 0
if (!PTE_V) alloc();
return PTE;

```

不论多少级，**每一层的逻辑几乎完全相同**，只是：

- 层数不同
- 每层索引位数不同（SV32 是 10 位，SV39/SV48 是 9 位）

> 目前get_pte()函数将页表项的查找和页表项的分配合并在一个函数里，你认为这种写法好吗？有没有必要把两个功能拆开？

页表页只有在需要时才真正分配，节省内存空间，避免一次性建立所有页表。

如果只想检查页表是否存在，不希望修改页表结构，这个函数就显得“过重”。

若分配失败（`alloc_page()` 返回 NULL），函数返回 NULL，调用者要额外判断是哪一层出了问题。
如果拆开，上层可以自由选择是否允许分配，逻辑更灵活。