# PURPOSE:  This program finds difference between two numbers using function
.data
    num1:
        .long 8
    
    num2:
        .long 5

.text
    _start:
        pushl num2
        pushl num1
        call f_subtract

        movl %eax, %ebx

    end:
        movl $1, %eax
        int $0x80

# PURPOSE:  Find difference between two numbers
#
# INPUT:    
#           num1 - first argument
#           num2 - second argument
# OUTPUT:
#           num2 - num1
#
# VARIABLES:
#           %ebx - holds num1
#           %ecx - holds num2
#
    .type f_subtract, @function
    f_subtract:
        f_subtract_start:
            pushl %ebp
            movl %esp, %ebp

        f_subtract_body:
            movl 8(%ebp), %ebx          # ebx = num1
            movl 12(%ebp), %ecx         # ecx = num2
            subl %ebx, %ecx             # ecx = ecx - ebx (num2 - num1)

            movl %ecx, %eax             # eax = ecx (eax is return value)

        f_subtract_end:
            movl %ebp, %esp
            popl %ebp
            ret
