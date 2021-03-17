# PURPOSE:  This program converts an input file
#           to an output file with all letters
#           converted to uppercase.
#
# PROCESSING:
#           1) Open the input file
#           2) Open the output file
#           3) While we're not at the end of the input file
#               a) read part of file into our memory buffer
#               b) go through each byte of memory if the byte is a lower-case letter, convert it to uppercase
#               c) write the memory buffer to output file
#
# NOTE: 
#           Use the following command to run program: 
#               ./toupper toupper.s toupper.uppercase
#

.section .data
    .equ SYS_OPEN,  5                               # system call numbers
    .equ SYS_WRITE, 4
    .equ SYS_READ,  3
    .equ SYS_CLOSE, 6
    .equ SYS_EXIT,  1

    .equ O_RDONLY,  0                               # options for open (look at /usr/include/asm/fcntl.h for various values.
    .equ O_CREAT_WRONLY_TRUNC, 03101                # You can combine them by adding them or ORing them)

    .equ STDIN, 0                                   # standard file descriptors
    .equ STDOUT, 1
    .equ STDERR, 2

    .equ NUMBER_ARGUMENTS, 2
    .equ LINUX_SYSCALL, 0x80                        # system call interrupt
    .equ END_OF_FILE, 0                             # return value of read which means we've hit the end of the file


# BUFFER:   This is where the data is loaded into
#           from the data file and written from
#           into the output file. This should
#           never exceed 16,000 for various reasons.
.section .bss
    .equ BUFFER_SIZE, 1000
    .lcomm BUFFER_DATA, BUFFER_SIZE


.section .text
    .equ ST_SIZE_RESERVE, 8                         # STACK POSITIONS
    .equ ST_FD_IN, -4
    .equ ST_FD_OUT, -8

    .equ ST_ARGC, 0                                 # Number of arguments
    .equ ST_ARGV_0, 4                               # Name of program
    .equ ST_ARGV_1, 8                               # Input file name
    .equ ST_ARGV_2, 12                              # Output file name


.globl _start
    _start:
        movl %esp, %ebp                             # save the stack pointer
        subl $ST_SIZE_RESERVE, %esp                 # Allocate space for our file descriptors on the stack

        open_files:
            open_fd_in:                             # OPEN INPUT FILE
                movl $SYS_OPEN, %eax                # open syscall
                movl ST_ARGV_1(%ebp), %ebx          # input filename into %ebx
                movl $O_RDONLY, %ecx                # read-only flag
                movl $0666, %edx                    # this doesn't really matter for reading
                int $LINUX_SYSCALL                  # call Linux

            store_fd_in:                            # save the given file descriptor
                movl %eax, ST_FD_IN(%ebp)
            
            open_fd_out:                            # OPEN OUTPUT FILE
                movl $SYS_OPEN, %eax                # open the file
                movl ST_ARGV_2(%ebp), %ebx          # output filename into %ebx
                movl $O_CREAT_WRONLY_TRUNC, %ecx    # flags for writing to the file
                movl $0666, %edx                    # mode for new file (if it's created)
                int $LINUX_SYSCALL                  # call Linux
            
            store_fd_out:                           # store the file descriptor here
                movl %eax, ST_FD_OUT(%ebp)


        read_loop_begin:                            # BEGIN MAIN LOOP
            movl $SYS_READ, %eax                    # READ IN A BLOCK FROM THE INPUT FILE
            movl ST_FD_IN(%ebp), %ebx               # get the input file descriptor
            movl $BUFFER_DATA, %ecx                 # the location to read into
            movl $BUFFER_SIZE, %edx                 # the size of the buffer
            int $LINUX_SYSCALL                      # Size of buffer read is returned in %eax

            cmpl $END_OF_FILE, %eax                 # EXIT IF WE'VE REACHED THE END check for end of file marker
            jle read_loop_end                       # if found or on error, go to the end

        read_loop_continue:                         # CONVERT THE BLOCK TO UPPER CASE
            pushl $BUFFER_DATA                      # location of buffer
            pushl %eax                              # size of the buffer
            call f_toupper
            popl %eax                               # get the size back
            addl $4, %esp                           # restore %esp


                                                    # WRITE THE BLOCK OUT TO THE OUTPUT FILE
            movl %eax, %edx                         # size of the buffer
            movl $SYS_WRITE, %eax                   # file to use
            movl ST_FD_OUT(%ebp), %ebx              # location of the buffer
            movl $BUFFER_DATA, %ecx
            int $LINUX_SYSCALL
            jmp read_loop_begin                     # CONTINUE THE LOOP


        read_loop_end:                              # CLOSE THE FILES
            movl $SYS_CLOSE, %eax                   # NOTE - we don't need to do error checking
            movl ST_FD_OUT(%ebp), %ebx              # on these, because error conditions
            int $LINUX_SYSCALL                      # don't signify anything special here
            movl $SYS_CLOSE, %eax
            movl ST_FD_IN(%ebp), %ebx
            int $LINUX_SYSCALL

    end:
            movl $SYS_EXIT, %eax
            movl $0, %ebx
            int $LINUX_SYSCALL




# PURPOSE:  This function actually does the
#           conversion to upper case for a block
#
# INPUT:
#           I parameter  - is the location of the block of memory to convert
#           II parameter - is the length of that buffer
#
# OUTPUT:
#           This function overwrites the current
#           buffer with the upper-casified version.
#
# VARIABLES:
#           %eax - beginning of buffer
#           %ebx - length of buffer
#           %edi - current buffer offset
#           %cl - current byte being examined (first part of %ecx)
#
# CONSTANTS
.equ LOWERCASE_A, 'a'                               # The lower boundary of our search
.equ LOWERCASE_Z, 'z'                               # The upper boundary of our search
.equ UPPER_CONVERSION, 'A' - 'a'                    # Conversion between upper and lower case
#
# STACK STUFF
.equ ST_BUFFER_LEN, 8                               # Length of buffer
.equ ST_BUFFER, 12                                  # actual buffer

.type f_toupper, @function
f_toupper:
    f_toupper_start:
        pushl %ebp
        movl %esp, %ebp

    f_toupper_body:
        movl ST_BUFFER(%ebp), %eax                  # SET UP VARIABLES
        movl ST_BUFFER_LEN(%ebp), %ebx
        movl $0, %edi

        cmpl $0, %ebx
        je f_toupper_end                            # if a buffer with zero length was given to us, just leave


        f_toupper_loop:
            movb (%eax,%edi,1), %cl                 # get the current byte
        
            cmpb $LOWERCASE_A, %cl                  # go to the next byte unless it is between 'a' and 'z'
            jl next_byte

            cmpb $LOWERCASE_Z, %cl                  # go to the next byte unless it is between 'a' and 'z'
            jg next_byte
            
            addb $UPPER_CONVERSION, %cl             # otherwise convert the byte to uppercase            
            movb %cl, (%eax,%edi,1)                 # and store it back
            

            next_byte:                              # get next byte
                incl %edi 
                cmpl %edi, %ebx                     # continue unless we've reached the end
                jne f_toupper_loop


    f_toupper_end:                                  # no return value, just leave function
        movl %ebp, %esp
        popl %ebp
        ret
