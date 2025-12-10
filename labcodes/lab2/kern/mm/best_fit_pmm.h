#ifndef __KERN_MM_BEST_FIT_PMM_H__
#define  __KERN_MM_BEST_FIT_PMM_H__

#include <pmm.h>

struct Page;
extern const struct pmm_manager best_fit_pmm_manager;
struct Page *best_fit_alloc_pages(size_t n);

#endif /* ! __KERN_MM_BEST_FIT_PMM_H__ */
