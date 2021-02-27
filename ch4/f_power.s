# PURPOSE:  This program will compute the value of basenumber^power

.section .data
    basenumber:
        .long 2
    
    power:
        .long 3

.section .text
    .globl _start
        _start:
            pushl power                             # push second argument - the power
            pushl basenumber                        # push first argument - the base number
            call f_power                            # call the function

            addl $8, %esp                           # move the stack pointer back

            movl %eax, %ebx                         # save the result is in %ebx

        end:                                        # end of the program
            movl $1, %eax                           # system call number (sys_exit)
            int $0x80                               # call kernel


# PURPOSE:  This function is used to compute
#           the value of a number raised to a power.
#
# INPUT:
#           First argument - the base number
#           Second argument - the power
#
# OUTPUT:   Will give the result as a return value
#
# NOTES:    The power must be 1 or greater
#
# VARIABLES:
#           %eax        - is used for temporary storage
#           %ebx        - holds the base number
#           %ecx        - holds the power
#           -4(%ebp)    - holds the current result

.type power, @function
    f_power:
        pushl %ebp                                  # save old base pointer
        movl %esp, %ebp                             # make stack pointer the base pointer
        subl $4, %esp                               # get room for our local storage

        movl 8(%ebp), %ebx                          # put base number in %ebx
        movl 12(%ebp), %ecx                         # put power in %ecx

        movl %ebx, -4(%ebp)                         # store current result

    f_power_loop:
        cmpl $1, %ecx                               # if the power is 1, we are done
        je f_power_end
        
        movl -4(%ebp), %eax                         # move the current result into %eax
        imull %ebx, %eax                            # multiply the current result by the base number
        movl %eax, -4(%ebp)                         # store the current result

        decl %ecx                                   # decrease the power
        jmp f_power_loop                            # run for the next power

    f_power_end:
        movl -4(%ebp), %eax                         # return value goes in %eax
        movl %ebp, %esp                             # restore the stack pointer
        popl %ebp                                   # restore the base pointer
        ret                                         # return
