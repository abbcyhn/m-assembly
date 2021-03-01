# PURPOSE:  Find maximum value from the list

# VARIABLES:
#   %edi    -   index of the current value
#   %eax    -   current value
#   %ebx    -   maximum value
#   %ecx    -   starting address of the list
#   %edx    -   ending address of the list


.section .data
    count:
        .long 6

    list:
        .long 3, 1, 2, 60, -5, 25, 8


.section .text
    .globl _start
        _start:                                     # start of the program

            movl $list, %ecx                        # set starting address of the list (for example, 0x000H)

                                                    # calculate ending address: 
            movl count, %edx                        # set count to edx register (for example, edx = 5)
            leal (%ecx, %edx, 4), %edx              # ending address = starting address + 4 * (count - 1)

            movl $0, %edi                           # set index zero
            movl list(, %edi, 4), %eax              # set current value as first value in the list

            movl %eax, %ebx                         # set current value as maximum value

            _loop:
                cmpl %ecx, %edx                     # jump end of the program, if startind address = ending address (ecx = edx) 
                je end

                incl %edi                           # increment current index
                movl list(, %edi, 4), %eax          # read next value from the list
                addl $4, %ecx                       # add 4 to starting address (because we read a value from the list)

                cmpl %ebx, %eax                     # loop again, if current value (eax) <= maximum value (ebx)
                jle _loop

                movl %eax, %ebx                     # otherwise, set current value as maximum value
                jmp _loop                           # loop again


        end:                                        # end of the program
            movl $1, %eax                           # system call number (sys_exit)
            int $0x80                               # call kernel
