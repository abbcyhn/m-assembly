.section .data
    helloworld:
        .ascii "hello world\n\0"

.section .text
    .globl _start
    _start:
        push $helloworld
        call printf

        push $0
        call exit
