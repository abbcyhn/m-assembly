# PURPOSE:  This program converts an input file
#           to an output file with all letters
#           converted to uppercase.
#
# PROCESSING:
#           1) Open input file
#           2) Open output file
#           3) While we're not at end of input file
#               a) read part of file into our memory buffer
#               b) go through each byte of memory if byte is a lower-case letter, convert it to uppercase
#               c) write memory buffer to output file
#

.section .data
    .equ SYS_CLOSE, 6
    .equ SYS_OPEN,  5                               # system call numbers
    .equ SYS_WRITE, 4
    .equ SYS_READ,  3
    .equ SYS_EXIT,  1
    .equ SYS_INT, 0x80                              # system call interrupt

    .equ NUMBER_ARGUMENTS, 2
    .equ END_OF_FILE, 0                             # return value of read which means we've hit end of file


.section .bss
    .equ BUFFER_SIZE, 500
    .lcomm BUFFER_DATA, BUFFER_SIZE


.section .text
    .equ ST_FD_IN, -4
    .equ ST_FD_OUT, -8

    .equ ST_ARGC, 0                                 # Number of arguments
    .equ ST_ARGV_0, 4                               # Name of program
    .equ ST_ARGV_1, 8                               # Input file name
    .equ ST_ARGV_2, 12                              # Output file name


.globl _start
    _start:
        movl %esp, %ebp                             # save stack pointer


        # open input file
        pushl $0                                    # read only mode        - second argument
        pushl ST_ARGV_1(%ebp)                       # address of filename   - first argument
        call f_openfile                             # call f_openfile

        # save input file descriptor
        subl $4, %esp                               # allocate space for input file descriptor on stack
        movl %eax, ST_FD_IN(%ebp)                   # save input file descriptor


        # create/open output file
        pushl $1                                    # write only mode       - second argument
        pushl ST_ARGV_2(%ebp)                       # address of filename   - first argument
        call f_openfile                             # call f_openfile
        
        # save output file descriptor        
        subl $4, %esp                               # allocate space for output file descriptors on stack
        movl %eax, ST_FD_OUT(%ebp)                  # save output file descriptor


        loop_start:                                 # begin main read loop
            pushl $BUFFER_SIZE                      # size of buffer        - third argument
            pushl $BUFFER_DATA                      # location of buffer    - second argument
            pushl ST_FD_IN(%ebp)                    # input file descriptor - first argument
            call f_readfile                         # call f_readfile

            cmpl $0, %eax                           # if we've reached end of file or found error
            jle loop_end                            # go to end


            # convert block to uppercase
            pushl $BUFFER_DATA                      # location of buffer    - second argument
            pushl %eax                              # size of buffer        - first argument
            call f_toupper                          # call f_toupper
            popl %eax                               # get size of buffer
            addl $4, %esp                           # restore %esp


            # write block to output file
            pushl %eax                              # size of buffer        - third argument
            pushl $BUFFER_DATA                      # location of buffer    - second argument
            pushl ST_FD_OUT(%ebp)                   # output file descriptor- first argument
            call f_writefile                        # call f_writefile
            jmp loop_start                          # continue loop


        loop_end:                                   # close files
            pushl ST_FD_OUT(%ebp)                   # output file descriptor- first argument
            call f_closefile                        # call f_closefile
            pushl ST_FD_IN(%ebp)                    # input file descriptor - first argument
            call f_closefile                        # call f_closefile


    end:
        movl $0, %ebx
        movl $SYS_EXIT, %eax
        int $SYS_INT
