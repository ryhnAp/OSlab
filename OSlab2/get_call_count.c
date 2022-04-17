#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"


int main(int argc, char* argv[]) 
{
    int par_pid;
    int fork_sol, write_sol;
    int child1, child2;

    if (argc<1)
        exit();

    // int syscall = atoi(argv[1]);

    par_pid = getpid();

    child1 = fork();

    if (child1 == 0)
    {
        write(1, "Child1 writes s.t. in command!\n", 31);
        fork_sol = get_call_count(SYS_fork);
        write_sol = get_call_count(SYS_write);
        printf(1, "Child1 Process fork status:%d , write status:%d \n", fork_sol, write_sol);
        kill(child1);
    }
    sleep(10);
    
    child2 = fork();

    fork_sol = get_call_count(SYS_fork);
    write_sol = get_call_count(SYS_write);
    
    wait();
    if (child2 == 0)
        printf(1, "Child2 Process fork status:%d , write status:%d \n", fork_sol, write_sol);

    else if((child1 != 0) && (child2 != 0))
    {
        wait();
        wait();
    	printf(1, "Main Process ID : %d\n", par_pid);
	    printf(1, "Main Process child ID : 1:%d, 2:%d\n", child1, child2);

        printf(1, "Main Process fork status:%d , write status:%d \n", fork_sol, write_sol);
    
        for(int i = 0; i < 200 ; i+= 1);
    }
    exit();

    return 0;
}
