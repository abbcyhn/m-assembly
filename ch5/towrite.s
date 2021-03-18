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


.section .bss
    .lcomm FILE_DESC_DATA, 1


.section .text
    .globl _start
        _start:
            # create/open file
            movl $SYS_OPEN, %eax                        # open syscall
            movl $filename, %ebx                        # filename into %ebx
            movl $O_CREAT_WRONLY_TRUNC, %ecx            # write mode
            movl $0666, %edx                            # mode for new file (if it's created)
            int $SYS_INT                                # call linux

            # save file descriptor
            movl %eax, FILE_DESC_DATA                   # save file descriptor into FILE_DESC_DATA buffer

            # write text to file            
            movl $SYS_WRITE, %eax                       # write syscall
            movl $FILE_DESC_DATA, %ebx                  # file descriptor
            movl $text, %ecx                            # text
            movl $text_length, %edx                     # length of text
            int $SYS_INT                                # call linux

            # close file
            movl $SYS_WRITE, %eax                       # close syscall
            movl FILE_DESC_DATA, %ebx                   # file descriptor
            int $SYS_INT                                # call linux

        end:
            movl $0, %ebx
            movl $1, %eax
            int $SYS_INT
