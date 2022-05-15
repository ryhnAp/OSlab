#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"


int main(int argc, char* argv[]) 
{
    int par_pid;
    int child1, child2=-1;

    if (argc<1)
        exit();

    // int syscall = atoi(argv[1]);

    par_pid = getpid();

    child1 = fork();

    if(child1 != 0)
        wait_for_process(child1);
    for(int i = 0; i < 10000 ; i+= 1);

    if(child1 != 0)
        child2 = fork();
    
    // if(child2 != 0)
    //     wait_for_process(child2);

    if (child1 == 0)
    {
    	printf(1, "Child1:\n");
    	printf(1, "Child2 and Main Process needs to wait for child one fork and feedback done.\n");

    }
    if (child2 == 0)
    {
    	printf(1, "Child2:\n");
    	printf(1, "Child2 and Main Process both successfully wait for child one.\n");

    }

    else if((child1 != 0) && (child2 != 0))
    {
        wait();
    	printf(1, "Main Process ID : %d\n", par_pid);
	    printf(1, "Main Process child ID : 1:%d, 2:%d\n", child1, child2);
        printf(1, "Main Process successfully waited for the processes!\n");
    
    }
    exit();

    return 0;
}
