## Chapter 9. Intermediate Memory Topics: Use the Concepts

- Modify the memory manager so that it calls allocate_init automatically if it hasn’t been initialized.[lib-heap.s](lib-heap.s)

- Modify the memory manager so that if the requested size of memory is smaller than the region chosen, it will break up the region into multiple parts. Be sure to take into account the size of the new header record when you do this.

-  Modify one of your programs that uses buffers to use the memory manager to get buffer memory rather than using the .bss.[towrite.s](towrite.s)

- Change the name of the functions to malloc and free, and build them into a shared library. Use LD_PRELOAD to force them to be used as your memory manager instead of the default one. Add some write system calls to STDOUT to verify that your memory manager is being used instead of the default one.[c-heap.c](c-heap.c)