.section .data
    .equ SYS_EXIT, 1
    .equ SYS_READ, 3
    .equ SYS_WRITE, 4
    .equ SYS_OPEN, 5
    .equ SYS_CLOSE, 6
    .equ SYS_INT, 0x80

    .equ FD_STDIN, 0
    .equ FD_STDOUT, 1
    .equ FD_STDERR, 2

    .equ O_RDONLY, 0
    .equ O_WRONLY, 03101

    age:
        .long 789

    tmp_buffer:
        .ascii "\0\0\0\0\0\0\0\0\0\0\0"

    newline:
        .ascii "\n"

.section .text
    _start:
        movl %esp, %ebp

        # convert number to string        
        pushl $tmp_buffer                               # storage for the result
        pushl age                                      # number to convert
        call f_int_to_str                               # call f_int_to_str
        addl $8, %esp                                   # reset %esp

        # find count of string
        pushl $tmp_buffer                               # string buffer
        call f_count_chars                              # call f_count_chars 
        addl $4, %esp                                   # reset %esp
        movl %eax, %edi                                 # set return value to %edi

		# write to STDOUT
		movl $SYS_WRITE, %eax							# write syscall
		movl $FD_STDOUT, %ebx							# file descriptor
		movl $tmp_buffer, %ecx							# written text
		movl %edi, %edx							        # length of text
		int $SYS_INT									# call linux

		# write newline to STDOUT
		movl $SYS_WRITE, %eax							# write syscall
		movl $FD_STDOUT, %ebx							# file descriptor
		movl $newline, %ecx							    # written text
		movl $1, %edx							        # length of text
		int $SYS_INT									# call linux

    end:
        movl $0, %ebx
        movl $SYS_EXIT, %eax
        int $SYS_INT
        
        

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
    .type f_count_chars, @function
    .globl f_count_chars

    .equ ST_STRING_START_ADDRESS, 8                     # This is where our one parameter is on the stack
    f_count_chars:
        f_count_chars_start:
            pushl %ebp
            movl %esp, %ebp

        f_count_chars_body:
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

        f_count_chars_end:
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
    .globl f_int_to_str
    .type f_int_to_str, @function
    f_int_to_str:
        f_int_to_str_start:
            pushl %ebp
            movl %esp, %ebp

        f_int_to_str_body:
            
            movl $0, %ecx                   # current character count
            movl 8(%ebp), %eax              # move the value into position
            movl $10, %edi                  # when we divide by 10, the 10 must be in a register or memory location

            conversion_loop:
                # division is actually performed on the
                # combined %edx:%eax register, so first
                # clear out %edx
                movl $0, %edx

                # divide %edx:%eax (which are implied) by 10.
                # store the quotient in %eax and the remainder
                # in %edx (both of which are implied).
                divl %edi

                # Quotient is in the right place. %edx has
                # the remainder, which now needs to be converted
                # into a number. So, %edx has a number that is
                # 0 through 9. You could also interpret this as
                # an index on the ASCII table starting from the
                # character '0'. The ascii code for '0' plus zero
                # is still the ascii code for '0'. The ascii code
                # for '0' plus 1 is the ascii code for the
                # character '1'. Therefore, the following
                # instruction will give us the character for the
                # number stored in %edx
                addl $'0', %edx

                # Now we will take this value and push it on the
                # stack. This way, when we are done, we can just
                # popoff the characters one-by-one and they will
                # be in the right order. Note that we are pushing
                # the whole register, but we only need the byte
                # in %dl (the last byte of the %edx register) for
                # the character.
                pushl %edx

                # increment the digit count
                incl %ecx

                # Check to see if %eax is zero yet, go to next step if so.
                cmpl $0, %eax
                je end_conversion_loop

                # %eax already has its new value.
                jmp conversion_loop

            end_conversion_loop:
                # The string is now on the stack, if we pop it
                # off a character at a time we can copy it into
                # the buffer and be done.

                # Get the pointer to the buffer in %edx
                movl 12(%ebp), %edx

            copy_reversing_loop:
                # We pushed a whole register, but we only need
                # the last byte. So we are going to pop off to
                # the entire %eax register, but then only move the
                # small part (%al) into the character string.
                popl %eax
                movb %al, (%edx)
            
                # Decreasing %ecx so we know when we are finished
                decl %ecx
                
                # Increasing %edx so that it will be pointing to the next byte
                incl %edx

                # Check to see if we are finished
                cmpl $0, %ecx
                # If so, jump to the end of the function
                je end_copy_reversing_loop
                # Otherwise, repeat the loop
                jmp copy_reversing_loop

            end_copy_reversing_loop:
                # Done copying. Now write a null byte and return
                movb $0, (%edx)

        f_int_to_str_end:
            movl %ebp, %esp
            popl %ebp
            ret
