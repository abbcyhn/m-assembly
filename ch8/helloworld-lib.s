.section .data
    text:
        .ascii "Hello %s. When you write this program you are %d years old.\n\0"

    person_name:
        .ascii "Ceyhun\0"

    person_age:
        .long 25

.section .text
    .globl _start
    _start:
        pushl person_age
        pushl $person_name
        pushl $text
        call printf

        pushl $0
        call exit
