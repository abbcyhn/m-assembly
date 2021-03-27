#include <stdio.h>
#include <stdlib.h>
int main() {
    int *p;                     // allocate the pointer
    
    p = malloc(sizeof(int));    // allocate heap memory to the pointer

    *p = 42;                    // allocate a value to the heap memory

    printf("%d\n", *p);         // print out the value 
    
    free(p);                    // free the allocated memory
   
    return 0;
}