#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_find_next_prime_number(void)
{
  register int edi asm("edi");
  int num = edi;

  return find_next_prime_number(num);
}

int sys_get_call_count(void)
{
  int syscallID;

  if(argint(0, &syscallID) < 0)
    return -1;
  
  return get_call_count(syscallID);
}

int sys_get_most_caller(void)
{
  int syscallID;

  if(argint(0, &syscallID) < 0)
    return -1;
  
  return get_most_caller(syscallID);
}

int sys_wait_for_process(void)
{
  int pid;
  if (argint(0, &pid) < 0)
    return -1;

  return wait_for_process(pid);
}

int sys_change_queue(void) 
{
  int pid, queue;
  if (argint(0, &pid) < 0) 
    return -1;
  if (argint(1, &queue) < 0) 
    return -1;
  return change_queue(pid, queue);
}

int sys_print_process(void) 
{
  return print_process();
}

void sys_BJF_proc_level(void)
{
  int pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio;
  argint(0, &pid);
  argint(1, &priority_ratio);
  argint(2, &arrival_time_ratio);
  argint(3, &executed_cycle_ratio);
  BJF_proc_level(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio);
}

void sys_BJF_sys_level(void)
{
  int priority_ratio, arrival_time_ratio, executed_cycle_ratio;
  argint(0, &priority_ratio);
  argint(1, &arrival_time_ratio);
  argint(2, &executed_cycle_ratio);
  BJF_sys_level(priority_ratio, arrival_time_ratio, executed_cycle_ratio);
}

int sys_sem_init(void)
{
  int i, v, init;
  if (argint(0, &i) < 0) 
    return -1;
  if (argint(1, &v) < 0) 
    return -1;
  if (argint(2, &init) < 0) 
    return -1;
  return sem_init(i, v, init);
}

int sys_sem_acquire(void)
{
  int i;
  if (argint(0, &i) < 0) 
    return -1;

  return sem_acquire(i);
}

int sys_sem_release(void)
{
  int i;
  if (argint(0, &i) < 0) 
    return -1;
  return sem_release(i);
}

void sys_reentrant(void)
{
  int count;
  argint(0, &count);
  reentrant(count);
}