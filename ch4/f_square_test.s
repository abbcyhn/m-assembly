# PURPOSE: This program calls and tests f_square function
#
# NOTE: Run the following commands in order to compile:
#       as --32 f_square.s -o f_square.o
#       as --32 f_square_test.s -o f_square_test.o
#       ld -m elf_i386 f_square.o f_square_test.o -o f_square_test

.data
    number:
        .long 4
.text
    .globl _start
    _start:
        pushl number
        call f_square

        movl %eax, %ebx
    
    end:
        movl $1, %eax
        int $0x80
