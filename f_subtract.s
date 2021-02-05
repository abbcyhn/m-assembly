.section .data

.section .text
    .globl _start
        _start:

            movl $20, %eax
            movl $80, %ebx

            pushl %ebx
            pushl %eax

            call subtract

            movl %eax, %ebx


        end:
            movl $1, %eax
            int $0x80


    .type subtract, @function
        subtract:
            pushl %ebp
            movl %esp, %ebp

            movl 8(%ebp), %eax
            movl 12(%ebp), %ebx

            subl %eax, %ebx

            movl %ebx, %eax

            movl %ebp, %esp
            popl %ebp
            ret
