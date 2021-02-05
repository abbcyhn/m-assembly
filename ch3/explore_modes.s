.section .data
    myvar:
        .long 88

.section .text
    .globl _start
        _start:

            dm:                                     # for debugging
            movl myvar, %eax                        # Directing mode. eax = 88

            im:                                     # for debugging
            movl $myvar, %eax                       # Immediate mode. eax = memory address of myvar


        end:                                        # end of the program
            movl $1, %eax                           # system call number (sys_exit)
            int $0x80                               # call kernel
                    