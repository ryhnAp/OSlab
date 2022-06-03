#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#define MUTEX 0
#define EMPTY 5
#define FULL 5
#define SIZE 5

void procon(int activity)
{

    // double x = 0;
    for(int j = 0 ; j < 5 ; j++)
    {
        sem_acquire(j+1+SIZE);
        sem_acquire(MUTEX);

        printf(1, "Produce value\n");
        // for(int i = 0 ; i < 20000 ; i+= 1)
        //     x += 80.86;

        sem_release(MUTEX);
        sem_release(SIZE - j);
        sem_release(j+1);

        printf(1, "Add to queue.\n");
    }

    printf(1, "Full queue.\n");

    // for (int j = 0; j < 5; j++)
    // {
    //     sem_acquire(FULL);
    //     sem_acquire(MUTEX);

    //     printf(1, "Pop from queue.\n");

    //     sem_release(MUTEX);
    //     sem_release(EMPTY);
        
    //     printf(1, "Consume value %d\n", activity);
    //     for(int i = 0 ; i < 200000 ; i++)
    //         x += 80.86;
                

    // }
    // printf(1, "Empty queue.\n");

    // exit();
}

int main()
{
    // mutex , full, empty
    sem_init(MUTEX, 1);
    for (int i = 0; i <= SIZE+SIZE; i++)
    {
        sem_init(i, 1); // binary lock
    }
    for (int i = SIZE; i >= 1; i--)
    {
        sem_acquire(i); // get empty
    }
    
    for(int i = 0 ; i < SIZE ; i++)
    {        
        int id = fork();
        if(!id)
            procon(i+1);
    }

    exit();

    return 0;
}