#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#define MUTEX 0
#define EMPTY 1
#define FULL 2
#define SIZE 5

void producer(int act) {
    for (int j = 0; j < SIZE; j++)
    {
		sem_acquire(1);
        sem_acquire(0);

        printf(1, "Produce value\n");

        sem_release(0);
		sem_release(2);

		sem_acquire(0);

        printf(1, "Add to queue %d\n", j);

		sem_release(0);
    }

	sem_acquire(0);

    printf(1, "Full queue\n");

	sem_release(0);

    exit();
}

void consumer(int act) {
    for (int j = 0; j < 5; j++)
    {
		sem_acquire(2);
        sem_acquire(MUTEX);

        printf(1, "Pop from queue\n");

        sem_release(MUTEX);
		sem_release(1);

		sem_acquire(MUTEX);

		printf(1, "Consume value %d\n", j);

		sem_release(MUTEX);
        
    }

	sem_acquire(MUTEX);

	printf(1, "Empty queue\n");

	sem_release(MUTEX);

    exit();
}

int main()
{
    sem_init(MUTEX, 1);
    sem_init(EMPTY, 5);
    sem_init(FULL, 0);

    int pid = fork();
    if (pid == 0) {
        producer(pid);
    } else {
        int pid2 = fork();
        if (pid2 == 0) {
            consumer(pid2);
        } else {
			wait();
			wait();
		}
    }
    
    exit();

    return 0;
}