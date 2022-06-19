#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   int parent_process_id = getpid();

   if (fork() == 0) 
   {
      uint * null_page = (uint*)0;
      printf(1, "Null pointer as unsigned int unit,\nwhich reference to Zero pointer(page number) have been created.\n");
      printf(1, "Null pointer dereference: \n");
      printf(1, "null_page: %x\nnull_page_pointer(*null_page):\n", null_page);
      printf(1, "%x\n", *null_page);
      
      // this process should be killed, cuz doesn't find the page so it cause an error
      // if we have next line announcement in command line it means there is no page fault
      // otherwise we successfully make error out of trap!
      printf(1, "Unsuccessfully pass!\n(pointer points to correct location/page exist/stuck in trap)\n");
      kill(parent_process_id);
      exit();
   } 
   else 
   {
      wait();
   }

   printf(1, "Successfully pass!\nProgram point to page number Zero, since we shift pages, then there is a page fault,\nand since page doesn't exist it cause an error.\n");
   exit();
}