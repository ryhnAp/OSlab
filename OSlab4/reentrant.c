#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    int count = atoi(argv[1]);
  
    printf(1, "Running %d times acquire :\n", count);
    reentrant(count);

    exit();

    return 0;
}
