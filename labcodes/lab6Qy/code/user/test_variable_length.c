/*
 * Test Case 2: Variable Length (不同长度的任务)
 * Purpose: 测试调度器对不同任务长度的处理，有利于 SJF 调度器
 */
#include <ulib.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    cprintf("test_variable_length: variable workload test\n");
    
    // 5 processes with different workloads: short, medium, long, short, medium
    int workloads[] = {20000, 100000, 200000, 30000, 80000};
    int child_count = 5;
    int i, pid;
    
    for (i = 0; i < child_count; i++) {
        pid = fork();
        if (pid == 0) {
            // Child process: do variable CPU work
            int j;
            volatile int sum = 0;
            for (j = 0; j < workloads[i]; j++) {
                sum += j;
            }
            cprintf("child %d (pid %d, load %d) finished\n", i, getpid(), workloads[i]);
            exit(0);
        }
    }
    
    // Parent waits for all children
    for (i = 0; i < child_count; i++) {
        waitpid(-1, NULL);
    }
    
    cprintf("test_variable_length: all children finished\n");
    return 0;
}
