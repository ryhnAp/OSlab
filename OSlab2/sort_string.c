#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

#define O_RDONLY  0x000
#define O_WRONLY  0x001
#define O_RDWR    0x002
#define O_CREATE  0x200

const int ENG_CHAR_COUNT = 26;
const char* OUTPUT_FILE = "sort_string.txt";

int sort_string(char* in, char buffer[])
{
    int char_count[ENG_CHAR_COUNT]; 
    int count = strlen(in);
    int size = 0;

    for (int i = 0; i < count; i++)
    {
        char_count[in[i]-'a']++;
    }
    
    for (int i = 0; i < ENG_CHAR_COUNT; i++)
    {
        for (int j = 0; j < char_count[i]; j++)
        {
            buffer[size++] = (char) ('a' + i);
        }
    }

    buffer[size++] = '\n';

    return size;
}

void sorting(char* in)
{
    char buffer[512];
    char temp_buff[2];

    int file_descriptor = open(OUTPUT_FILE, O_CREATE|O_RDWR);

    if (file_descriptor < 0)
    {
        printf(1, "Unable to open the file.\n");
    }
    
    if (read(file_descriptor, temp_buff,1))
    {
        unlink(OUTPUT_FILE);
        file_descriptor = open(OUTPUT_FILE, O_CREATE|O_RDWR);
    }

    int size = sort_string(in, buffer);

    if(write(file_descriptor, buffer, size) != size) 
    {
        printf(1, "Unable to write in file.\n");
        exit();
    }
    
    close(file_descriptor);

}

int main(int argc, char *argv[])
{
    char* input = argv[1];
    // char* output;

    if (argc<2)
    {
        exit();
    }
    
    sorting(input);

    exit();
    return 0;
}