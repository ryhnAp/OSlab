#include "spinlock.h"
#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"

#define SEM_SIZE 5

typedef struct 
{
    int head;
    int tail;
    int size;
    void* processes[NPROC];
    struct spinlock locks;

}Semaphore;
