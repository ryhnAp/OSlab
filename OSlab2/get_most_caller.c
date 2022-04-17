#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"


int main(int argc, char* argv[]) 
{
    int par_pid;
    int most_wait_call, most_write_call, most_fork_call;
    int child1, child2;

    if (argc<1)
        exit();

    // int syscall = atoi(argv[1]);

    par_pid = getpid();

    child1 = fork();

    if (child1 == 0)
    {
        write(1, "Child1 writes s.t. in command!\n", 31);
        write(1, "Child1 again writes s.t. in command!\n", 37);
        kill(child1);
    }
    sleep(10);
    
    child2 = fork();

    
    wait();
    if (child2 == 0)
        write(1, "Child2 writes s.t. in command!\n", 31);

    else if((child1 != 0) && (child2 != 0))
    {
        wait();
        wait();
    	printf(1, "Main Process ID : %d\n", par_pid);
	    printf(1, "Main Process child ID : 1:%d, 2:%d\n", child1, child2);

        most_wait_call = get_most_caller(SYS_wait);
        most_fork_call = get_most_caller(SYS_fork);
        most_write_call = get_most_caller(SYS_write);
        
        printf(1, "Main Process most wait syscall process ID:%d \n", most_wait_call);
        printf(1, "Main Process most fork syscall process ID:%d \n", most_fork_call);
        printf(1, "Main Process most write syscall process ID:%d \n", most_write_call);
    
        for(int i = 0; i < 200 ; i+= 1);
    }
    exit();

    return 0;
}
