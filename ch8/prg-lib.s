.section .data
    .type f_returnfive, @function
    .globl f_returnfive
    f_returnfive:
        f_returnfive_start:
            pushl %ebp
            movl %esp, %ebp

        f_returnfive_body:
            movl $5, %eax

        f_returnfive_end:
            movl %ebp, %esp
            popl %ebp
            ret 
