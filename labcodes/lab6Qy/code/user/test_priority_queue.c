/*
 * Test Case 3: Priority Queue (优先级队列)
 * Purpose: 测试调度器的优先级处理能力
 */
#include <ulib.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    cprintf("test_priority_queue: priority test\n");
    
    // 5 processes with different priorities
    int priorities[] = {1, 2, 3, 4, 5};  // 1=lowest, 5=highest
    int child_count = 5;
    int i, pid;
    
    for (i = 0; i < child_count; i++) {
        pid = fork();
        if (pid == 0) {
            // Child process: set priority and do work
            int myid = i;
            int myprio = priorities[i];
            lab6_setpriority(myprio);
            
            int j;
            volatile int sum = 0;
            int cpuload = 150000;
            for (j = 0; j < cpuload; j++) {
                sum += j;
            }
            cprintf("child %d (pid %d, priority %d) finished\n", myid, getpid(), myprio);
            exit(0);
        }
    }
    
    // Parent waits for all children
    for (i = 0; i < child_count; i++) {
        waitpid(-1, NULL);
    }
    
    cprintf("test_priority_queue: all children finished\n");
    return 0;
}
