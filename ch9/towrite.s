# PURPOSE:  This program creates new file
#

.section .data
    .equ SYS_CLOSE, 6                               # close system call
    .equ SYS_OPEN,  5                               # open system call
    .equ SYS_WRITE, 4                               # write system call
    .equ SYS_READ,  3                               # read system call
    .equ SYS_INT, 0x80                              # interrupt system call

    .equ O_RDONLY,  0                               # read/write intensions
    .equ O_CREAT_WRONLY_TRUNC, 03101

    filename:
        .ascii "heynow.txt\0"

    text:
        .ascii "Hey diddle diddle!"

    text_length = .-text

    file_desc_ptr:
        .long 0

.section .text
    .globl _start
        _start:

            # allocate heap
            pushl $1                                    # heap size is 1
            call f_allocate                             # call f_allocate
            movl %eax, file_desc_ptr                    # save pointer in file_desc_ptr

            # create/open file
            movl $SYS_OPEN, %eax                        # open syscall
            movl $filename, %ebx                        # filename into %ebx
            movl $O_CREAT_WRONLY_TRUNC, %ecx            # write mode
            movl $0666, %edx                            # mode for new file (if it's created)
            int $SYS_INT                                # call linux

            # save file descriptor
            movl %eax, (file_desc_ptr)                  # save file descriptor into file_desc_ptr buffer

            # write text to file            
            movl $SYS_WRITE, %eax                       # write syscall
            movl file_desc_ptr, %ebx                    # file descriptor
            movl $text, %ecx                            # text
            movl $text_length, %edx                     # length of text
            int $SYS_INT                                # call linux

            # close file
            movl $SYS_WRITE, %eax                      # close syscall
            movl $file_desc_ptr, %ebx                  # file descriptor
            int $SYS_INT                               # call linux

            # deallocate heap
            pushl $file_desc_ptr
            call f_deallocate

        end:
            movl $0, %ebx
            movl $1, %eax
            int $SYS_INT
