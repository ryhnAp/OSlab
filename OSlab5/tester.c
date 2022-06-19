#include "types.h"
#include "user.h"
#include "date.h"
#include "pstat.h"

int main(int argc, char* argv[]){
    struct pstat ps;

    for(int i=1 ; i < argc ; i++ ){
        int tickets_number =  atoi(argv[i]);
        settickets(tickets_number);
        printf(1,"#") ; 
        // while (1);
        printf(1,"@") ; 
        // printf(1, "%d", argv[i]);
    }
    getpinfo(&ps);
    printf(1, "%d running processes\n", NPROC);
    printf(1, "\nPID\tUSED?\tTICKETS\t\tTICKS\n");
    for (int i = 0; i < NPROC ; i++)
    {
        // selcet used processes and print their information from pstat struct
        if(ps.pid[i] && ps.tickets[i]>0)
            printf(1, "%d\t%d\t%d\t\t%d\n",ps.pid[i], ps.inuse[i], ps.tickets[i], ps.ticks[i]);
    }
    exit();
    return 0;
}
