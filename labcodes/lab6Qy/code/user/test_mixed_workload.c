/*
 * Test Case 4: Mixed Workload (混合工作负载)
 * Purpose: 模拟现实场景：不同长度的任务和不同的优先级
 */
#include <ulib.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    cprintf("test_mixed_workload: mixed workload and priority test\n");
    
    // Processes with different priorities and workloads
    struct {
        int workload;
        int priority;
        char *name;
    } tasks[] = {
        {50000, 1, "low_short"},
        {200000, 2, "medium_long"},
        {100000, 3, "high_medium"},
        {30000, 4, "vhigh_short"},
        {150000, 5, "uhigh_medium"},
    };
    
    int child_count = 5;
    int i, pid;
    
    for (i = 0; i < child_count; i++) {
        pid = fork();
        if (pid == 0) {
            // Child process
            int myid = i;
            lab6_setpriority(tasks[i].priority);
            
            int j;
            volatile int sum = 0;
            for (j = 0; j < tasks[i].workload; j++) {
                sum += j;
            }
            cprintf("child %d (%s, pid %d, prio %d, load %d) finished\n", 
                    myid, tasks[i].name, getpid(), tasks[i].priority, tasks[i].workload);
            exit(0);
        }
    }
    
    // Parent waits for all children
    for (i = 0; i < child_count; i++) {
        waitpid(-1, NULL);
    }
    
    cprintf("test_mixed_workload: all children finished\n");
    return 0;
}
