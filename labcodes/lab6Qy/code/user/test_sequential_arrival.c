/*
 * Test Case 5: Sequential Arrival (顺序到达)
 * Purpose: 测试进程顺序到达时的调度行为（FIFO 特别有利）
 */
#include <ulib.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    cprintf("test_sequential_arrival: sequential arrival test\n");
    
    int child_count = 5;
    int i, pid;
    
    for (i = 0; i < child_count; i++) {
        // Sequential creation - each child does work before next is created
        pid = fork();
        if (pid == 0) {
            // Child process: do variable work
            int myid = i;
            int workload = 50000 + i * 30000;  // Increasing workload
            
            int j;
            volatile int sum = 0;
            for (j = 0; j < workload; j++) {
                sum += j;
            }
            cprintf("child %d (pid %d, work %d) finished\n", myid, getpid(), workload);
            exit(0);
        } else {
            // Parent waits for this child to be created
            // In real world, parent might create all at once
            // This sequential approach tests different scenarios
        }
    }
    
    // Parent waits for all children
    for (i = 0; i < child_count; i++) {
        waitpid(-1, NULL);
    }
    
    cprintf("test_sequential_arrival: all children finished\n");
    return 0;
}
