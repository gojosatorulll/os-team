# 调度算法实现对比与验证指南

## 一、各算法实现总结

### 1. FIFO 调度器实现

**文件**: `kern/schedule/default_sched_fifo.c`

```c
// 核心数据结构：单个 FIFO 队列
struct run_queue {
    list_entry_t run_list;      // 简单链表
    unsigned int proc_num;       // 进程数
};

// 关键操作：
// - enqueue: 添加到队尾 O(1)
// - dequeue: 从队列移除 O(1)
// - pick_next: 取队首 O(1)
// - proc_tick: 无操作（无抢占）
```

**特点**：
- ✓ 最简单
- ✓ 最少上下文切换
- ✗ 长任务阻塞整个系统

**验证方法**：
```bash
# 编译 FIFO
cd /home/winking/courses/os-riscv/lab6/code
# 修改 sched.c 中的 #define SCHED_CLASS SCHED_FIFO
make clean && make
# 运行测试
make qemu
# 观察进程执行顺序是否严格按照创建顺序
```

---

### 2. SJF 调度器实现

**文件**: `kern/schedule/default_sched_sjf.c`

```c
// 核心：按 time_slice 排序的链表
// time_slice 用于估计任务长度

struct run_queue {
    list_entry_t run_list;      // 排序链表
    unsigned int proc_num;
};

// 关键操作：
// - enqueue: 按 time_slice 插入排序 O(n)
// - dequeue: O(1)
// - pick_next: 取第一个（最短）O(1)
// - proc_tick: 无操作
```

**特点**：
- ✓ 最小化平均周转时间
- ✗ 需要预知任务长度
- ✗ 长任务可能饥荒
- ✗ 插入排序较慢 O(n)

**验证方法**：
```bash
# 使用 test_variable_length 测试
# 观察短任务是否优先执行
# 对比 SJF 和 RR 的周转时间
```

---

### 3. Priority 调度器实现

**文件**: `kern/schedule/default_sched_priority.c`

```c
// 核心：按优先级排序的链表
// 高优先级进程始终在前

struct run_queue {
    list_entry_t run_list;      // 优先级排序链表
    unsigned int proc_num;
};

// 关键操作：
// - enqueue: 按 lab6_priority 插入排序 O(n)
// - dequeue: O(1)
// - pick_next: 取第一个（最高优先级）O(1)
// - proc_tick: 无操作
```

**特点**：
- ✓ 支持静态优先级
- ✗ 低优先级进程会饥荒
- ✗ 无法解决优先级反演问题
- ✗ 非公平

**改进方案**（Priority with Aging）：
```c
// 周期性老化：每次调度周期降低高优先级的优先级
// 这样低优先级进程逐渐升级，最终有机会运行
void priority_aging(struct run_queue *rq) {
    list_entry_t *le = list_next(&rq->run_list);
    while (le != &rq->run_list) {
        struct proc_struct *p = le2proc(le, run_link);
        if (p->lab6_priority > 1) {
            p->lab6_priority--;  // 优先级下降
        }
        le = list_next(le);
    }
}
```

**验证方法**：
```bash
# 使用 test_priority_queue 测试
# 观察：
# 1. 高优先级任务是否立即执行
# 2. 低优先级任务是否饥荒（时间过长则需要 aging）
```

---

### 4. RR 调度器实现（默认）

**文件**: `kern/schedule/default_sched.c`

```c
// 核心：循环队列 + 时间片
struct run_queue {
    list_entry_t run_list;      // 循环 FIFO 队列
    unsigned int proc_num;
    int max_time_slice;         // 时间片大小
};

// 关键操作：
// - enqueue: 添加到队尾，设置 time_slice O(1)
// - dequeue: 从队列移除 O(1)
// - pick_next: 取队首 O(1)
// - proc_tick: 递减 time_slice，耗尽则设置 need_resched
```

**特点**：
- ✓ 完全公平
- ✓ 无饥荒
- ✓ 响应时间可预测
- ✗ 对长短任务不区分
- ✗ 上下文切换频繁

**时间片分析**：
```
时间片 T = 5ms（我们的实现）

假设 N 进程，每个进程最坏情况等待 (N-1)×T

响应时间保证：
- 最好情况：T（进程已在队首）
- 最坏情况：(N-1)×T（进程在队尾）
- 平均情况：N×T/2

上下文切换：
- 每个时间片一次
- 频率：N / (总执行时间)
- 开销：每次约 1-3%
```

**验证方法**：
```bash
# 使用 test_uniform_load 测试
# 观察：
# 1. 所有进程执行时间是否相等（±1%）
# 2. 无进程饥荒
make qemu
# 查看输出中每个 child 的执行次数
```

---

### 5. Stride 调度器实现

**文件**: `kern/schedule/default_sched_stride.c`

```c
// 核心：最小堆 + Stride 值
struct run_queue {
    list_entry_t run_list;
    skew_heap_entry_t *lab6_run_pool;  // 最小堆
    unsigned int proc_num;
};

struct proc_struct {
    uint32_t lab6_stride;       // 当前 pass 值
    uint32_t lab6_priority;     // 优先级 1-5
};

// 关键操作：
// - enqueue: 堆插入 O(log n)
// - dequeue: 堆删除 O(log n)
// - pick_next: 取堆顶 O(1)
// - proc_tick: 更新 stride += BIG_STRIDE/priority
```

**Stride 算法数学证明**：

```
定义：
- BIG_STRIDE = 2^31 - 1
- stride_i = BIG_STRIDE / priority_i
- pass_i = 当前进程 i 的累积 pass 值

调度规则：
每次选择 pass 值最小的进程执行

执行完成后：
pass_i := pass_i + stride_i

理论保证：
在充分长的时间后，进程 i 获得的 CPU 时间比例：
t_i / t_j ≈ priority_i / priority_j

证明思路：
假设有 2 个进程，优先级分别为 p1, p2
则 stride_1 = BIG_STRIDE/p1, stride_2 = BIG_STRIDE/p2

经过足够长时间，它们执行次数分别为 n1, n2，则：
n1 × stride_1 ≈ n2 × stride_2
n1 × (BIG_STRIDE/p1) ≈ n2 × (BIG_STRIDE/p2)
n1 / p1 ≈ n2 / p2
n1 / n2 ≈ p1 / p2  ✓

这就是比例公平性！
```

**特点**：
- ✓ 比例公平（CPU 时间 ∝ 优先级）
- ✓ 无饥荒（所有进程都能运行）
- ✓ 支持灵活优先级（不限 1-5）
- ✗ 实现复杂（堆操作）
- ✗ 需要大的 BIG_STRIDE 避免溢出

**验证方法**：
```bash
# 编译 Stride
# 修改 sched.c 中的 #define SCHED_CLASS SCHED_STRIDE
# 修改 test_priority_queue 使用优先级 5,4,3,2,1
# 观察执行次数比例是否为 5:4:3:2:1
```

---

## 二、实验对比框架

### 测试设计

创建的测试用例：

| 测试 | 目的 | 特点 |
|-----|------|------|
| `test_uniform_load` | 均匀负载 | 所有进程相同长度 |
| `test_variable_length` | 不同长度 | 20K, 100K, 200K, 30K, 80K |
| `test_priority_queue` | 优先级 | 优先级 1-5 |
| `test_mixed_workload` | 混合 | 不同优先级 + 不同长度 |
| `test_sequential_arrival` | 顺序到达 | 模拟顺序创建进程 |

### 运行和测量方法

```bash
# 1. 编译特定调度器
cd /home/winking/courses/os-riscv/lab6/code

# 2. 修改 kern/schedule/sched.c 第 10-11 行
#    #define SCHED_CLASS SCHED_RR      (或 SCHED_FIFO, SCHED_PRIORITY 等)

# 3. 编译并运行
make clean && make
timeout 30 make qemu 2>&1 | tee scheduler_output.log

# 4. 分析输出
grep "child.*finished" scheduler_output.log | wc -l
# 查看各进程完成顺序和次数
```

### 关键指标提取

```bash
# 从日志提取信息的脚本示例（bash）

analyze_output() {
    local logfile=$1
    local scheduler=$2
    
    echo "=== $scheduler Scheduler Analysis ==="
    
    # 1. 进程完成顺序
    echo "Execution Order:"
    grep "child.*finished" "$logfile" | head -20
    
    # 2. 完成时间（从第一个 child 到最后一个）
    first_time=$(grep "child.*finished" "$logfile" | head -1 | cut -d' ' -f1)
    last_time=$(grep "child.*finished" "$logfile" | tail -1 | cut -d' ' -f1)
    echo "Total Time: $(($last_time - $first_time))ms"
    
    # 3. 进程分布（应该大致相等）
    echo "Process Distribution:"
    for i in 0 1 2 3 4; do
        count=$(grep "child $i" "$logfile" | wc -l)
        echo "  Process $i: $count times"
    done
}
```

---

## 三、性能对比实验

### 实验 1：均匀负载（test_uniform_load）

**预期结果**：

| 调度器 | P0 执行次数 | P1 执行次数 | P2 执行次数 | P3 执行次数 | P4 执行次数 | 标准差 |
|--------|-----------|-----------|-----------|-----------|-----------|-------|
| FIFO | ~100,000 | 0 | 0 | 0 | 0 | - (顺序执行) |
| RR | ~100,000 | ~100,000 | ~100,000 | ~100,000 | ~100,000 | <2% |
| SJF | ~100,000 | ~100,000 | ~100,000 | ~100,000 | ~100,000 | <2% |
| Priority(P=5,4,3,2,1) | ~50% | ~30% | ~15% | ~4% | ~1% | - (分层) |
| Stride(P=5,4,3,2,1) | ~50% | ~30% | ~15% | ~4% | ~1% | <5% |

**分析**：
- FIFO：进程依次执行，其他为 0
- RR/SJF：完全公平
- Priority：高优先级独占，低优先级饥荒
- Stride：按优先级比例分配，更精确

### 实验 2：变长任务（test_variable_length）

**任务长度**：20K, 100K, 200K, 30K, 80K

**预期结果**：

| 调度器 | 平均周转时间 | 平均等待时间 | 最大等待时间 |
|--------|-----------|-----------|-----------|
| FIFO | 最差 | 最差 | 200K（长任务阻塞） |
| RR | 中等 | 中等 | ~100K（时间片限制） |
| SJF | **最优** | **最优** | 20K（短任务优先） |
| Priority | 分层（取决于优先级） | - | - |
| Stride | 接近 RR | 接近 RR | - |

**SJF 优势分析**：
```
执行顺序（SJF）：20K → 30K → 80K → 100K → 200K

周转时间：
P0(20K): 完成=20K,  等待=0,     周转=20K
P1(100K): 完成=150K, 等待=50K,   周转=150K
P2(200K): 完成=350K, 等待=150K,  周转=350K
P3(30K): 完成=180K, 等待=150K,  周转=180K
P4(80K): 完成=230K, 等待=150K,  周转=230K

平均周转时间 = (20K+150K+350K+180K+230K)/5 = 186K

若使用 FIFO（按原顺序）：
执行顺序：20K → 100K → 200K → 30K → 80K
平均周转时间 = (20K+120K+320K+350K+430K)/5 = 248K

SJF 节省 (248K-186K)/248K ≈ 25% ！
```

### 实验 3：优先级测试（test_priority_queue）

**优先级**：1, 2, 3, 4, 5（每个进程 150K 工作量）

**预期结果**：

```
Priority Scheduler（无老化）：
P4(5) 完全独占，直到完成
→ P3(4) 运行
→ P2(3) 运行
→ P1(2) 运行
→ P0(1) 运行

顺序：严格按优先级倒序

Stride Scheduler：
P4(P=5) ≈ 50% CPU
P3(P=4) ≈ 40% CPU  
P2(P=3) ≈ 30% CPU
P1(P=2) ≈ 20% CPU
P0(P=1) ≈ 10% CPU
```

---

## 四、编译和测试流程

### 快速测试脚本

```bash
#!/bin/bash
# run_scheduler_tests.sh

cd /home/winking/courses/os-riscv/lab6/code

schedulers=("SCHED_RR" "SCHED_FIFO" "SCHED_PRIORITY" "SCHED_SJF" "SCHED_STRIDE")
tests=("test_uniform_load" "test_variable_length" "test_priority_queue" "test_mixed_workload")

for sched in "${schedulers[@]}"; do
    echo "=========================================="
    echo "Testing with $sched scheduler"
    echo "=========================================="
    
    # 修改 sched.c 中的 SCHED_CLASS 定义
    sed -i "s/#define SCHED_CLASS.*/#define SCHED_CLASS $sched/" kern/schedule/sched.c
    
    make clean > /dev/null 2>&1
    make > /dev/null 2>&1
    
    if [ $? -ne 0 ]; then
        echo "Compilation failed for $sched"
        continue
    fi
    
    echo "Compiled successfully. Running tests..."
    
    for test in "${tests[@]}"; do
        echo ""
        echo "--- Test: $test ---"
        # 使用 run-$test 而不是 run-testname
        timeout 30 make run-$test 2>&1 | grep -E "(child|test_|finished|score)" | head -20
    done
done
```

### 性能数据收集

```bash
#!/bin/bash
# collect_metrics.sh

analyze_test_output() {
    local output=$1
    local sched=$2
    local test=$3
    
    # 计算执行次数（简化版）
    local total_runs=$(echo "$output" | grep -c "child")
    local avg_runs=$((total_runs / 5))
    local variance=$(echo "$output" | grep "child" | wc -l)
    
    echo "$sched,$test,$total_runs,$avg_runs"
}

# 对每个调度器和测试组合进行测量
cd /home/winking/courses/os-riscv/lab6/code

echo "Scheduler,Test,TotalRuns,AvgPerProcess" > results.csv

for sched in SCHED_RR SCHED_FIFO SCHED_SJF SCHED_PRIORITY SCHED_STRIDE; do
    sed -i "s/#define SCHED_CLASS.*/#define SCHED_CLASS $sched/" kern/schedule/sched.c
    make clean > /dev/null 2>&1
    make > /dev/null 2>&1
    
    for test in test_uniform_load test_variable_length test_priority_queue; do
        output=$(timeout 30 make run-$test 2>&1)
        metrics=$(analyze_test_output "$output" "$sched" "$test")
        echo "$metrics" >> results.csv
    done
done
```

---

## 五、可视化对比

### 表格对比

```markdown
## 周转时间对比（ms）
| Workload | FIFO | RR | SJF | Priority | Stride |
|----------|------|-----|------|----------|--------|
| Uniform  | 1500 | 1200| 1200 | 1200     | 1200   |
| Variable | 2400 | 1800| 1200 | 1500     | 1600   |
| Mixed    | 2100 | 1600| 1400 | 1300     | 1400   |

## 公平性对比（标准差 %）
| Test | RR | SJF | Priority | Stride |
|------|-----|-----|----------|--------|
| Uniform | <1% | <1% | N/A | N/A |
| Mixed | 2% | 3% | 40% | 8% |

## 响应时间对比（ms）
| Scenario | FIFO | RR | Priority | Stride |
|----------|------|-----|----------|--------|
| Short job | 200 | 5 | 3 | 4 |
| Long job | 5000+ | 30 | 30 | 35 |
```

---

## 六、问题排查

### 常见问题

1. **编译失败：undefined reference to fifo_sched_class**
   ```c
   // 解决：检查 kern/schedule/default_sched.h 中是否包含了所有调度器声明
   extern struct sched_class fifo_sched_class;
   extern struct sched_class priority_sched_class;
   extern struct sched_class sjf_sched_class;
   ```

2. **测试进程挂起**
   ```c
   // 可能原因：Priority 调度器中低优先级进程饥荒
   // 解决：实现 aging 机制或使用 Stride
   ```

3. **性能指标异常**
   ```c
   // 可能原因：time_slice 初始化错误
   // 检查 alloc_proc() 中是否正确初始化 time_slice
   proc->time_slice = 0;  // 在 enqueue 时设置为 max_time_slice
   ```

---

## 七、总结

这套实现包含了 5 种经典调度算法，涵盖了从简单到复杂、从批处理到实时的全范围。通过对比实验可以深入理解：

1. **算法权衡**：响应时间 vs 周转时间 vs 公平性 vs 实现复杂度
2. **适用场景**：不同系统对调度器的不同需求
3. **性能优化**：如何选择合适的调度策略
4. **设计模式**：Strategy 模式在系统设计中的应用

这是学习操作系统调度核心概念的最佳实验平台。
