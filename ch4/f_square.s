# PURPOSE:  Find square of number: number*number
#
# INPUT:
#           number - first argument
# OUTPUT:
#           number * number
.text
    .globl f_square
    .type f_square, @function
    f_square:
        f_square_start:
            pushl %ebp
            movl %esp, %ebp

        f_square_body:
            movl 8(%ebp), %eax
            imull %eax, %eax
        
        f_square_end:
            movl %ebp, %esp
            popl %ebp
            ret
