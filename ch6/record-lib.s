.include "record-def.s"

.section .data
    newline:
        .ascii "\n"


# PURPOSE:  This function reads a record from the file
#           descriptor
#
# INPUT:    The file descriptor and a buffer
#
# OUTPUT:   This function writes the data to the buffer
#           and returns a status code.
#
.section .text
    .globl read_record
    .type read_record, @function
    read_record:
        read_record_start:
            pushl %ebp
            movl %esp, %ebp

        read_record_body:
            pushl %ebx

            movl $SYS_READ, %eax
            movl 12(%ebp), %ebx
            movl 8(%ebp), %ecx
            movl $RECORD_SIZE, %edx
            int $LINUX_SYSCALL

            popl %ebx   # NOTE - %eax has the return value, which we will
                        # give back to our calling program

        read_record_end:
            movl %ebp, %esp
            popl %ebp
            ret


# PURPOSE:  This function writes a record to
#           the given file descriptor
#
# INPUT:    The file descriptor and a buffer
#
# OUTPUT:   This function produces a status code
#
    .globl write_record
    .type write_record, @function
    write_record:
        write_record_start:
            pushl %ebp
            movl %esp, %ebp

        write_record_body:
            pushl %ebx

            movl $SYS_WRITE, %eax
            movl ST_FILEDES(%ebp), %ebx
            movl 8(%ebp), %ecx
            movl $RECORD_SIZE, %edx
            int $LINUX_SYSCALL

            popl %ebx   # NOTE - %eax has the return value, which we will
                        # give back to our calling program
        

        write_record_end:
            movl %ebp, %esp
            popl %ebp
            ret



# PURPOSE:  Count the characters until a null byte is reached.
#
# INPUT:    The address of the character string
#
# OUTPUT:   Returns the count in %eax
#
# PROCESS:  Registers used:
#           %ecx - character count
#           %al - current character
#           %edx - current character address
#
    .type count_chars, @function
    .globl count_chars

    .equ ST_STRING_START_ADDRESS, 8                     # This is where our one parameter is on the stack
    count_chars:
        count_chars_start:
            pushl %ebp
            movl %esp, %ebp

        count_chars_body:
            movl $0, %ecx                               # Counter starts at zero
            movl ST_STRING_START_ADDRESS(%ebp), %edx    # Starting address of data

        count_loop_begin:
            movb (%edx), %al                            # Grab the current character
            cmpb $0, %al                                # Is it null?
            je count_loop_end                           # If yes, we’re done

            incl %ecx                                   # Otherwise, increment the counter
            incl %edx                                   # and increment the pointer
            jmp count_loop_begin                        # Go back to the beginning of the loop

        count_loop_end:                                 # We’re done. Move the count into %eax
            movl %ecx, %eax

        count_chars_end:
            movl %ebp, %esp
            popl %ebp
            ret


# PURPOSE:  Write out a newline to STDOUT
#
    .globl write_newline
    .type write_newline, @function

    .equ ST_FILEDES, 8
    write_newline:
        write_newline_start:
            pushl %ebp
            movl %esp, %ebp

        write_newline_body:
            movl $SYS_WRITE, %eax
            movl ST_FILEDES(%ebp), %ebx
            movl $newline, %ecx
            movl $1, %edx
            int $LINUX_SYSCALL

        write_newline_end:
            movl %ebp, %esp
            popl %ebp
            ret


# PURPOSE:  Convert an integer number to a decimal string for display
#
# INPUT:
#           A buffer large enough to hold the largest possible number   - first argument
#           An integer to convert                                       - second argument
#
# OUTPUT: 
#           The buffer will be overwritten with the decimal string
#
# Variables:
#           %ecx - will hold the count of characters processed
#           %eax - will hold the current value
#           %edi - will hold the base (10)
#

.globl integer2string
.type integer2string, @function
integer2string:
#Normal function beginning
pushl %ebp
movl %esp, %ebp