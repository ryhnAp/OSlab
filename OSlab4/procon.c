#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#define MUTEX 0
#define EMPTY 1
#define FULL 2
#define SIZE 1

void producer(int activity)
{
    // double x = 0;
    for(int j = 0 ; j < 1 ; j++)
    {
        sem_acquire(EMPTY);
        sem_acquire(MUTEX);

        printf(1, "Produce value\n");
        // for(int i = 0 ; i < 20000 ; i+= 1)
        //     x += 80.86;

        sem_release(MUTEX);
        sem_release(FULL);
        // sem_release(SIZE +j+1);

        printf(1, "Add to queue.\n");
    }

    printf(1, "Full queue.\n");

    // exit();
}

void consumer(int activity)
{
    for (int j = 0; j < 1; j++)
    {
        sem_acquire(FULL);
        sem_acquire(MUTEX);

        printf(1, "Pop from queue.\n");

        sem_release(MUTEX);
        sem_release(EMPTY);
        
        printf(1, "Consume value %d\n", activity);
        // for(int i = 0 ; i < 200000 ; i++)
        //     x += 80.86;
    }

    printf(1, "Empty queue.\n");


    // exit();
}

void procon(int activity)
{
    producer(activity);
    consumer(activity);

    exit();
}

int main(int argc, char *argv[])
{
    // mutex , full[1:5], empty[6:10]
    sem_init(MUTEX, 1, 0);
    sem_init(EMPTY, 5, 0);
    sem_init(FULL, 0, 0);
    // sem_acquire(FULL);

    // for (int i = 1; i <= SIZE+SIZE; i++)
    // {
    //     sem_init(i, 5); // binary lock
    // }

    // for (int i = 0; i < SIZE; i++)
    // {
    //     sem_acquire(FULL); // get empty
    // }

    int pid = getpid();

    // for(int i = 0 ; i < SIZE ; i++)
    // {        
    //     int id = fork();
    //     if(!id)
    //         producer(i+1);
    // }

    // for(int i = 0 ; i < SIZE ; i++)
    // {        
    //     int id = fork();
    //     if(!id)
    //         consumer(i+1);
    // }

    for(int i = 0 ; i < SIZE ; i++)
    {
        if(pid>0)        
            pid = fork();

        // procon(i+1);
    }
    printf(1, "success1\n");

    if(pid==0)
        // procon(pid);
        procon(getpid()%SIZE);
    else
    {
        for (int i = 0; i < SIZE; i++)
        {
            wait();
        }
        
    }

    exit();

    return 0;
}