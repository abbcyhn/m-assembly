# PURPOSE:  Find maximum value from the list

# VARIABLES:
#   %edi    -   index of the current value
#   %eax    -   current value
#   %ebx    -   maximum value

# NOTES:    0 means end of the list 
#                   and must be replaced at the end of the list

.section .data
    list:
        .long 3, 1, 2, -5, 255


.section .text
    .globl _start
        _start:                                     # start of the program

            movl $0, %edi                           # set index zero
            movl list(, %edi, 4), %eax              # set current value as first value in the list

            movl %eax, %ebx                         # set current value as maximum value

            _loop:
                cmpl $255, %eax                     # jump end of the program, if current value (%eax=255) 
                je end

                incl %edi                           # increment current index
                movl list(, %edi, 4), %eax          # read next value from the list

                cmpl %ebx, %eax                     # loop again, if current value (eax) <= maximum value (ebx)
                jle _loop

                movl %eax, %ebx                     # otherwise, set current value as maximum value
                jmp _loop                           # loop again


        end:                                        # end of the program
            movl $1, %eax                           # system call number (sys_exit)
            int $0x80                               # call kernel
