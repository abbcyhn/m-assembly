.section .data

.section .text
    .globl _start
        _start:
            movl $2, %eax
            movl $3, %ebx

            pushl %eax
            pushl %ebx

            popl %eax
            popl %ebx

        end:
            movl $1, %eax
            int $0x80


