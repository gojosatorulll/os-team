# 练习一

回答将以物理内存的分配过程为主线，解析过程中遇到的各类函数的作用。

## **default_init**

`static void`
`default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}`
该函数是将链表freelist初始化为空，即前缀后缀都指向自己，并记录空闲页数为0。

## default_init_memmap 

```
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link));
    } else {
        list_entry_t* le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }
        }
    }
}
```

该函数扫描了从base到base+n的地址内的空闲页，将其合为一个空闲块。具体实现：

1. 检查约束：不允许把长度为 0 的区间注册为空闲块。这是基本前置条件。
2. 指针指向base，然后循环遍历这n个page，标记为reserved，清楚标志位和property为0，base位置的property为n表示块大小，每个页的引用计数清零。
3. 全局空闲页加n，将当前的块插入空闲列表中，base比较每个节点的地址，找到第一个大于base的（之前都小于）节点，使用add_before函数插入。

## default_alloc_pages

```
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }

    base->property = n;
    SetPageProperty(base);

    struct Page *p = list_next(&free_list);
    while (p != &free_list) {
        if (base + n <= p) break;
        p = list_next(p);
    }
    list_add_before(p, &(base->page_link));
    nr_free += n;

    p = list_prev(&(base->page_link));
    if (p != &free_list) {
        if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            list_del(&(base->page_link));
            base = p;
        }
    }

    p = list_next(&(base->page_link));
    if (p != &free_list) {
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
    }
}

```

first-fit算法的核心函数，分配空闲块/页，函数原型中的n是期望分配页数，然后函数主体就是遍历空闲页表，寻找第一个符合条件的块（块大小>=n），如果刚好够就直接分配，如果大于，则把分配完剩余的空闲页数分出来作为新的空闲块放回应该在的位置。

## default_free_pages

```
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }

    base->property = n;
    SetPageProperty(base);

    struct Page *p = list_next(&free_list);
    while (p != &free_list) {
        if (base + n <= p) break;
        p = list_next(p);
    }
    list_add_before(p, &(base->page_link));
    nr_free += n;

    p = list_prev(&(base->page_link));
    if (p != &free_list) {
        if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            list_del(&(base->page_link));
            base = p;
        }
    }

    p = list_next(&(base->page_link));
    if (p != &free_list) {
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
    }
}
```

- 循环处理 `base` 开始的每一页。
- 保证每一页不是“保留页”（例如内核自身使用的页）；
- 保证每一页不是“属性页”（说明这段页之前没被标记为空闲块）；
- 然后清除标志位，重置引用计数为 0。
- 在空闲链表中找到合适的插入点（按照地址顺序）。
- 把当前空闲块插入进去。
- `nr_free` 是空闲页总数，更新它。
- 查看空闲链表中 `base` 前一个空闲块；
- 如果前一块的结束地址刚好接上 `base`（说明连续），就合并它们：
- 把前一块长度加上当前块；
- 删除当前块的节点；
- 清除当前块的“空闲头”标记。

操作系统回收一段刚用完的内存，把它重新拼接进空闲内存表中，尽量和前后的空闲块合并成更大的连续空闲区。

## first-fit改进

1. **记录上次分配位置：**当前算法是每次要分配空间都从头开始遍历，改进就可以记录下上次遍历到的位置，下次从这里开始，避免频繁从头扫描，提高平均查找效率，代价是多了一个记录上次扫描位置的指针

2. **按块大小分为多组空闲链表：**

   ```
   list_head free_list_small;
   list_head free_list_medium;
   list_head free_list_large;
   ```

   分级first-fit也可以减少遍历次数。

3. **延迟合并**：不是每次都立即合并，而是将合并延后到下一次分配前，减少频繁操作链表的开销。

4. **维护空闲区间:**用区间树（如红黑树）记录空闲内存区间，插入/删除/合并更高效。