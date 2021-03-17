# PURPOSE:  This file contains main functions for working with files:
#           1) f_openfile 
#           2) f_readfile
#           3) f_writefile
#           4) f_closefile
#

.section .data
    .equ SYS_CLOSE, 6                               # close system call
    .equ SYS_OPEN,  5                               # open system call
    .equ SYS_WRITE, 4                               # write system call
    .equ SYS_READ,  3                               # read system call
    .equ SYS_INT, 0x80                              # interrupt system call

    .equ O_RDONLY,  0                               # read/write intensions
    .equ O_CREAT_WRONLY_TRUNC, 03101                




.section .text
# PURPOSE:  Opens given file
#
# INPUT:
#           address of first character of file name - first argument
#           read(0)/write(1) mode                   - second argument
# OUTPUT:
#           file descriptor
#
.globl f_openfile
.type f_openfile, @function
f_openfile:
    f_openfile_start:
        pushl %ebp
        movl %esp, %ebp

    f_openfile_body:
        movl $SYS_OPEN, %eax                        # open syscall
        movl 8(%ebp), %ebx                          # filename into %ebx

        cmpl $0, 12(%ebp)                           # if read/write mode = 0
        je f_openfile_readonly                      # jump to open file as readonly
        jmp f_openfile_writeonly                    # else jump to open file as writeonly

        f_openfile_readonly:                        # open file as readonly
            movl $O_RDONLY, %ecx
            jmp f_openfile_body_end                    

        f_openfile_writeonly:                       # open file as writeonly
            movl $O_CREAT_WRONLY_TRUNC, %ecx

    f_openfile_body_end:
        movl $0666, %edx                            # this doesn't really matter for reading but mode for new file (if it's created)
        int $SYS_INT                                # call linux

    f_openfile_end:
        movl %ebp, %esp
        popl %ebp
        ret



# PURPOSE:  Reads from given file
#
# INPUT:
#           file descriptor     - first argument
#           address of buffer   - second argument
#           size of buffer      - third argument
#
# OUTPUT:
#           returns nothing but overwrites buffer
#
.globl f_readfile
.type f_readfile, @function
f_readfile:
    f_readfile_start:
        pushl %ebp
        movl %esp, %ebp

    f_readfile_body:
        movl $SYS_READ, %eax                        # read syscall
        movl 8(%ebp), %ebx                          # file descriptor
        movl 12(%ebp), %ecx                         # location to read into
        movl 16(%ebp), %edx                         # size of buffer
        int $SYS_INT                                # call linux

    f_readfile_end:
        movl %ebp, %esp
        popl %ebp
        ret


# PURPOSE:  Writes buffer to given file
#
# INPUT:
#           file descriptor     - first argument
#           address of buffer   - second argument
#           size of buffer      - third argument
#
# OUTPUT:
#           returns nothing but overwrites buffer
#
.globl f_writefile
.type f_writefile, @function
f_writefile:
    f_writefile_start:
        pushl %ebp
        movl %esp, %ebp

    f_writefile_body:
        movl $SYS_WRITE, %eax                       # write syscall
        movl 8(%ebp), %ebx                          # file descriptor
        movl 12(%ebp), %ecx                         # buffer
        movl 16(%ebp), %edx                         # size of buffer
        int $SYS_INT                                # call linux

    f_writefile_end:
        movl %ebp, %esp
        popl %ebp
        ret


# PURPOSE:  Closes given file
#
# INPUT:
#           file descriptor     - first argument
#
# OUTPUT:
#           returns nothing
#
.globl f_closefile
.type f_closefile, @function
f_closefile:
    f_closefile_start:
        pushl %ebp
        movl %esp, %ebp

    f_closefile_body:
        movl $SYS_WRITE, %eax                       # close syscall
        movl 8(%ebp), %ebx                          # file descriptor
        int $SYS_INT                                # call linux

    f_closefile_end:
        movl %ebp, %esp
        popl %ebp
        ret