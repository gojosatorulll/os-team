/*
 * Test Case 1: Uniform Load (所有进程时间相同)
 * Purpose: 测试调度器对相同工作负载的处理，衡量公平性
 */
#include <ulib.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    cprintf("test_uniform_load: uniform workload test\n");
    
    int cpuload = 100000;  // 标准 CPU 工作量
    int child_count = 5;
    int i, pid;
    
    for (i = 0; i < child_count; i++) {
        pid = fork();
        if (pid == 0) {
            // Child process: do uniform CPU work
            int j;
            volatile int sum = 0;
            for (j = 0; j < cpuload; j++) {
                sum += j;
            }
            cprintf("child %d (pid %d) finished with sum=%d\n", i, getpid(), sum);
            exit(0);
        }
    }
    
    // Parent waits for all children
    for (i = 0; i < child_count; i++) {
        waitpid(-1, NULL);
    }
    
    cprintf("test_uniform_load: all children finished\n");
    return 0;
}
