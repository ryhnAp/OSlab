#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[]) 
{

    int num = atoi(argv[1]);
    register int edi asm("edi"); // Get first value of register
    int first_value = edi;
    asm ("movl %0, %%edi;" : /*output operand*/ :"r"(num) :"%edi"); // Save number in the register
    printf(1, "next prime number is:%d\n", find_next_prime_number(num)); // Call systemcall
    asm ("movl %0, %%edi;" : /*output operand*/ :"r"(first_value) :"%edi"); // Save the first value in register
    exit();
}
