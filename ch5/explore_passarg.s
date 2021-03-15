# PURPOSE:  This program adds two numbers which are passed with terminal
#
#
# NOTE: 
#           Use the following command to run program: 
#               ./explore_passarg arg1 arg2 ...
#

.section .text
    .equ ST_ARGC, 0                                 # number of arguments
    .equ ST_ARGV_0, 4                               # name of program
    .equ ST_ARGV_1, 8                               # first argument
    .equ ST_ARGV_2, 12                              # second argument


    _start:
        movl %esp, %ebp                             # save the stack pointer

        # movl ST_ARGV_1(%ebp), %eax                  # get first number into %eax

        # movl ST_ARGV_2(%ebp), %ebx                  # get second number into %ebx

        # addl %eax, %ebx                             # add numbers

        movl ST_ARGV_1(%ebp), %eax
        movl $0, %edi
        movl (%eax, %edi, 4), %ebx

    end:
        movl $1, %eax
        int $0x80
