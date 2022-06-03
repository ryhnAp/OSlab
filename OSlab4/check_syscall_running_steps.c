#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main(int argc, char *argv[])
{
    int pid_check;
    // char* input = argv[1];
    // char* output;

    if (argc<1)
    {
        exit();
    }

    pid_check = getpid();
    
    printf(1, "see pid:%d\n", pid_check);


    exit();
    return 0;
}