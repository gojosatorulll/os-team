#include <list.h>
#include <sync.h>
#include <proc.h>
#include <stdio.h>
#include <assert.h>
#include <sched.h>

// Priority scheduler: processes are sorted by priority level
// Higher lab6_priority value = higher priority (runs first)
// Uses simple list with priority-based insertion

static void
priority_init(struct run_queue *rq)
{
    list_init(&rq->run_list);
    rq->proc_num = 0;
}

static void
priority_enqueue(struct run_queue *rq, struct proc_struct *proc)
{
    assert(list_empty(&proc->run_link));
    
    // Insert in priority order (higher priority at front)
    list_entry_t *le = list_next(&rq->run_list);
    while (le != &rq->run_list)
    {
        struct proc_struct *p = le2proc(le, run_link);
        if (proc->lab6_priority > p->lab6_priority)
        {
            // Found lower priority process, insert before it
            list_add_before(le, &proc->run_link);
            proc->rq = rq;
            rq->proc_num++;
            return;
        }
        le = list_next(le);
    }
    
    // Add to tail if it's lower priority than all
    list_add_before(&rq->run_list, &proc->run_link);
    proc->rq = rq;
    rq->proc_num++;
}

static void
priority_dequeue(struct run_queue *rq, struct proc_struct *proc)
{
    assert(!list_empty(&proc->run_link) && proc->rq == rq);
    list_del_init(&proc->run_link);
    rq->proc_num--;
}

static struct proc_struct *
priority_pick_next(struct run_queue *rq)
{
    list_entry_t *le = list_next(&rq->run_list);
    if (le != &rq->run_list)
    {
        return le2proc(le, run_link);
    }
    return NULL;
}

static void
priority_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    // Priority scheduler: no time slice limitation
    // Process runs to completion unless higher priority process wakes up
}

struct sched_class priority_sched_class = {
    .name = "PRIORITY",
    .init = priority_init,
    .enqueue = priority_enqueue,
    .dequeue = priority_dequeue,
    .pick_next = priority_pick_next,
    .proc_tick = priority_proc_tick,
};
