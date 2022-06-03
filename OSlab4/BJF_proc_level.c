#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[])
{ 
    int arg1, arg2, arg3, arg4;

    if(argc > 4) {
        arg1 = atoi(argv[1]);
        arg2 = atoi(argv[2]);
        arg3 = atoi(argv[3]);
        arg4 = atoi(argv[4]);
    }
    else {
        printf(1, "Insufficient inputs\n", sizeof("Insufficient inputs\n"));
        exit();
    } 
    
    BJF_proc_level(arg1, arg2, arg3, arg4);

    exit();
}
