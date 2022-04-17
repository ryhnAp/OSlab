#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"


int main(int argc, char* argv[]) 
{
    int par_pid;
    int child1, child2;

    if (argc<1)
        exit();

    // int syscall = atoi(argv[1]);

    par_pid = getpid();

    printf(1, "##1\n");

    child1 = fork();
    printf(1, "##2\n");
    // if(child1 != 0)
    //     wait_for_process(child1);

    child2 = fork();
    
    

    if (child1 == 0)
    {
    // if(child2 != 0)
    	printf(1, "Child1 ID : %d\n", child1);
    	printf(1, "Child2 and Main Process needs to wait for child one fork and feedback done.\n");
        wait_for_process(child2);
        for(int i = 0; i < 10000 ; i+= 1);
    
    }
    if (child2 == 0)
    {
    	printf(1, "Child2 ID : %d\n", child2);
    	printf(1, "Child2 and Main Process both successfully wait for child one.\n");

    }

    else if((child1 != 0) && (child2 != 0))
    {
        // kill(child2);
        // kill(child1);
        wait();
    	printf(1, "Main Process ID : %d\n", par_pid);
	    printf(1, "Main Process child ID : 1:%d, 2:%d\n", child1, child2);
        
        printf(1, "Main Process successfully waited for the processes!\n");
    
        for(int i = 0; i < 10000 ; i+= 1);
    }
    exit();

    return 0;
}
