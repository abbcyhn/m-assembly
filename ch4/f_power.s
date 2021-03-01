# PURPOSE: This program will computer: number^power

.data
    number:
        .long 5
    
    power:
        .long 3

.text
    _start:
        pushl power
        pushl number
        call f_power

        movl %eax, %ebx

    end:
        movl $1, %eax
        int $0x80


# PURPOSE:  Find number^power
#
# INPUT:
#           number - first argument
#           power - second argument
#
# OUTPUT:
#           number^power
# VARIABLES:
#           eax     - temp storage
#           ebx     - holds number
#           ecx     - holds power
#           -4(ebp) - local variable. holds current result
#
    .type f_power, @function
    f_power:
        f_power_start:
            pushl %ebp
            movl %esp, %ebp

        f_power_body:
            movl 8(%ebp), %ebx          # ebx = number
            movl 12(%ebp), %ecx         # ecx = power

            subl $4, %esp               # get room for local storage
            movl %ebx, -4(%ebp)         # save current result in local storage

            f_power_loop:
                cmpl $1, %ecx           # if power = 1
                je f_power_end          # jump end of function

                movl -4(%ebp), %eax     # save current result in temp storage
                imull %ebx, %eax        # current result = current result * number
                movl %eax, -4(%ebp)     # save current result in local storage

                decl %ecx               # decrement power
                jmp f_power_loop        # loop again

            movl -4(%ebp), %eax         # set result in return value

        f_power_end:
            movl %ebp, %esp
            popl %ebp
            ret
