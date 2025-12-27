#include <list.h>
#include <sync.h>
#include <proc.h>
#include <stdio.h>
#include <assert.h>
#include <sched.h>

// SJF (Shortest Job First) scheduler
// In our environment, we estimate job length using time_slice as a proxy
// Processes with smaller time_slice (estimated shorter jobs) run first
// time_slice in proc_struct ranges from 1-MAX_TIME_SLICE
// We interpret smaller time_slice as shorter jobs

static void
sjf_init(struct run_queue *rq)
{
    list_init(&rq->run_list);
    rq->proc_num = 0;
}

static void
sjf_enqueue(struct run_queue *rq, struct proc_struct *proc)
{
    assert(list_empty(&proc->run_link));
    
    // Set default time slice that represents estimated job length
    // For SJF, we use the initial time_slice as estimated job size
    if (proc->time_slice == 0)
    {
        proc->time_slice = rq->max_time_slice;
    }
    
    // Insert in sorted order by time_slice (shorter jobs first)
    list_entry_t *le = list_next(&rq->run_list);
    while (le != &rq->run_list)
    {
        struct proc_struct *p = le2proc(le, run_link);
        if (proc->time_slice < p->time_slice)
        {
            // Found longer job, insert before it
            list_add_before(le, &proc->run_link);
            proc->rq = rq;
            rq->proc_num++;
            return;
        }
        le = list_next(le);
    }
    
    // Add to tail if it's longer or equal
    list_add_before(&rq->run_list, &proc->run_link);
    proc->rq = rq;
    rq->proc_num++;
}

static void
sjf_dequeue(struct run_queue *rq, struct proc_struct *proc)
{
    assert(!list_empty(&proc->run_link) && proc->rq == rq);
    list_del_init(&proc->run_link);
    rq->proc_num--;
}

static struct proc_struct *
sjf_pick_next(struct run_queue *rq)
{
    list_entry_t *le = list_next(&rq->run_list);
    if (le != &rq->run_list)
    {
        return le2proc(le, run_link);
    }
    return NULL;
}

static void
sjf_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    // SJF: No preemption by time - process runs to completion
    // The scheduler ensures shortest jobs run first at enqueue time
}

struct sched_class sjf_sched_class = {
    .name = "SJF",
    .init = sjf_init,
    .enqueue = sjf_enqueue,
    .dequeue = sjf_dequeue,
    .pick_next = sjf_pick_next,
    .proc_tick = sjf_proc_tick,
};
