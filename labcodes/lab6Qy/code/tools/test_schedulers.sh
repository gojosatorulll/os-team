#!/bin/bash
# Scheduler Performance Testing Script

WORK_DIR="/home/winking/courses/os-riscv/lab6/code"
cd $WORK_DIR

# 定义调度算法
declare -A SCHEDULERS=(
    [RR]=0
    [STRIDE]=1
    [FIFO]=2
    [PRIORITY]=3
    [SJF]=4
)

# 测试用例
TEST_CASES=(
    "test_uniform_load"
    "test_variable_length"
    "test_priority_queue"
    "test_mixed_workload"
    "test_sequential_arrival"
)

# 创建结果目录
mkdir -p /tmp/sched_results

echo "======================================================================="
echo "Scheduler Performance Analysis"
echo "======================================================================="

# 对每个调度器进行测试
for SCHED_NAME in "${!SCHEDULERS[@]}"; do
    SCHED_ID=${SCHEDULERS[$SCHED_NAME]}
    
    echo ""
    echo "======================================================================="
    echo "Testing $SCHED_NAME Scheduler (ID=$SCHED_ID)"
    echo "======================================================================="
    
    # 编译
    echo "[*] Compiling kernel for $SCHED_NAME..."
    make clean > /dev/null 2>&1
    if ! make DEFS="-DSCHED_CLASS=$SCHED_ID" > /tmp/sched_compile_$SCHED_NAME.log 2>&1; then
        echo "[!] Compilation failed for $SCHED_NAME"
        cat /tmp/sched_compile_$SCHED_NAME.log
        continue
    fi
    echo "[+] Compilation successful"
    
    # 运行测试
    for TEST in "${TEST_CASES[@]}"; do
        echo -n "  [$TEST] "
        
        # 运行测试并收集输出
        QEMU_OUT=$(/usr/bin/timeout 8 make qemu 2>&1)
        QEMU_EXIT=$?
        
        # 检查完成状态
        if echo "$QEMU_OUT" | grep -q "all user-mode processes have quit"; then
            echo "PASS"
            # 提取性能信息
            CHILD_EXEC=$(echo "$QEMU_OUT" | grep -c "child.*finished")
            if [ $CHILD_EXEC -gt 0 ]; then
                echo "    - Child processes executed: $CHILD_EXEC"
            fi
        else
            echo "FAIL"
        fi
        
        # 保存完整输出
        echo "$QEMU_OUT" > /tmp/sched_results/${SCHED_NAME}_${TEST}.log
    done
done

echo ""
echo "======================================================================="
echo "Benchmark Complete - Results saved to /tmp/sched_results/"
echo "======================================================================="
