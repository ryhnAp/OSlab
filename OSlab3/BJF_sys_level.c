#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"



int main(int argc, char *argv[])
{ 
    int arg1, arg2, arg3;

    if(argc > 3) {
        arg1 = atoi(argv[1]);
        arg2 = atoi(argv[2]);
        arg3 = atoi(argv[3]);
    }
    else {
        printf(1, "Insufficient inputs\n", sizeof("Insufficient inputs\n"));
        exit();
    } 
    
    BJF_sys_level(arg1, arg2, arg3);

    exit();
}
