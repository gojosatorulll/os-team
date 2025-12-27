#!/usr/bin/env python3
"""
Scheduler Performance Analysis Script
自动编译和测试各种调度算法在不同工作负载下的性能
"""

import subprocess
import os
import re
import sys
import time
from pathlib import Path

# 调度算法配置
SCHEDULERS = {
    'RR': 0,
    'STRIDE': 1,
    'FIFO': 2,
    'PRIORITY': 3,
    'SJF': 4,
}

# 测试用例
TEST_CASES = [
    'test_uniform_load',
    'test_variable_length',
    'test_priority_queue',
    'test_mixed_workload',
    'test_sequential_arrival',
]

# 工作目录
WORK_DIR = '/home/winking/courses/os-riscv/lab6/code'

def run_command(cmd, cwd=WORK_DIR, timeout=30):
    """运行命令并返回输出"""
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            cwd=cwd, 
            capture_output=True, 
            text=True, 
            timeout=timeout
        )
        return result.stdout + result.stderr
    except subprocess.TimeoutExpired:
        return "TIMEOUT"
    except Exception as e:
        return f"ERROR: {str(e)}"

def compile_kernel(scheduler_id):
    """为指定的调度器编译内核"""
    scheduler_name = list(SCHEDULERS.keys())[list(SCHEDULERS.values()).index(scheduler_id)]
    print(f"\n[*] Compiling for {scheduler_name} scheduler (ID={scheduler_id})...")
    
    cmd = f'make clean && make DEFS="-DSCHED_CLASS={scheduler_id}" 2>&1 | tail -5'
    output = run_command(cmd)
    
    if 'Error' in output or 'error' in output:
        print(f"[!] Compilation failed for {scheduler_name}")
        print(output)
        return False
    
    print(f"[+] {scheduler_name} scheduler compiled successfully")
    return True

def run_test(test_case, timeout=30):
    """运行指定的测试用例"""
    print(f"    Running {test_case}...", end='', flush=True)
    
    # 使用 -run 参数运行测试
    cmd = f"timeout {timeout} make run-{test_case} 2>&1"
    output = run_command(cmd, timeout=timeout+5)
    
    print(" [OK]")
    return output

def extract_metrics(output, test_case):
    """从 QEMU 输出中提取性能指标"""
    metrics = {
        'test': test_case,
        'finished': 'finished' in output.lower(),
        'child_count': len(re.findall(r'child \d+', output)),
    }
    
    # 尝试提取运行时间
    time_matches = re.findall(r'(\d+)ms', output)
    if time_matches:
        metrics['elapsed_ms'] = time_matches[-1]
    
    return metrics

def run_benchmark():
    """运行完整的基准测试"""
    results = {}
    
    print("="*70)
    print("Scheduler Performance Benchmark")
    print("="*70)
    
    for scheduler_name, scheduler_id in SCHEDULERS.items():
        print(f"\n{'='*70}")
        print(f"Testing {scheduler_name} Scheduler")
        print(f"{'='*70}")
        
        # 编译
        if not compile_kernel(scheduler_id):
            print(f"[!] Skipping {scheduler_name} due to compilation error")
            continue
        
        results[scheduler_name] = {}
        
        # 运行测试用例
        for test_case in TEST_CASES:
            output = run_test(test_case)
            metrics = extract_metrics(output, test_case)
            results[scheduler_name][test_case] = metrics
            
            # 存储完整输出以供后续分析
            with open(f'/tmp/sched_{scheduler_name}_{test_case}.log', 'w') as f:
                f.write(output)
    
    # 生成报告
    print("\n" + "="*70)
    print("Test Summary")
    print("="*70)
    
    for scheduler_name in SCHEDULERS.keys():
        if scheduler_name not in results:
            print(f"\n{scheduler_name}: SKIPPED")
            continue
        
        print(f"\n{scheduler_name}:")
        for test_case in TEST_CASES:
            if test_case in results[scheduler_name]:
                metrics = results[scheduler_name][test_case]
                status = "PASS" if metrics['finished'] else "FAIL"
                print(f"  {test_case}: {status}")

if __name__ == '__main__':
    run_benchmark()
