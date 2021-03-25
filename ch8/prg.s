.section .data
    person_info:
        .ascii "Hello %s. When you write this program you are %d years old.\n\0"

    person_name:
        .ascii "Ceyhun\0"

    person_age:
        .long 25

    func_arg:
        .long 4

    func_msg:
        .ascii "This result (%d) is returned from function which is located my own lib\n\0"

.section .text
    .globl _start
    _start:
        pushl person_age
        pushl $person_name
        pushl $person_info
        call printf

        pushl func_arg
        call f_factorial

        pushl %eax
        pushl $func_msg
        call printf

        pushl $0
        call exit
