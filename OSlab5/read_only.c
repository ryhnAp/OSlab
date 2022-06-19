#include "types.h"
#include "stat.h"
#include "user.h"
#include "mmu.h"

int main(int argc, char *argv[])
{
  printf(1, "Access to a location in code segment with *begin pointer.\n"); 
  char *begin = sbrk(0);
  sbrk(PGSIZE);
  printf(1, "Going to write value 'a' in parent process on that location.\n"); 
  *begin='a';
  printf(1, "Write value 'a' in parent process successfully.\n"); 

  printf(1, "Now file is going to be read only...\n"); 
  provide_protection(begin, 1); // just one char and in entry address we make changes
  printf(1, "Fork a child which make pointer and location unprotected(readable&writable).\n"); 
  int refuse_caller=fork();
  if (refuse_caller != 0)
    printf(1, "Fork a child which writes on read only.\n"); 
  int protect_writer=-1;
  if (refuse_caller != 0)
    protect_writer = fork();

  if (refuse_caller==0){
	  printf(1, "\nProtected written value by parent = %c\n",*begin); 
    refuse_protection(begin, 1);  
    printf(1, "Unprotected file(readable&writable) by first child.\n"); 
    *begin='b';
    printf(1, "After unprotecting the written value become = %c\n",*begin);
    exit();
  }
  else if (protect_writer == 0)
  {
    wait();
    sleep(20);
    printf(1, "\nSecond child is going to stuck in trap.\ncuz it doesn't Know first child make file unprotected and writes in read only!\n"); 
    *begin='c'; 
    printf(1, "\nTrap notice writing on read only, so you won't this announcement!\n");    
    exit();
  }
  else if((refuse_caller>0) & (protect_writer>0)){
    wait();
    wait();
  } 
  exit();
  return 0;
}
