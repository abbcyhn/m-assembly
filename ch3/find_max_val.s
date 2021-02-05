# PURPOSE:  Find maximum value from the list

# VARIABLES:
#   %edi    -   index of the current value
#   %eax    -   current value
#   %ebx    -   biggest value

# NOTES:    0 means end of the list 
#                   and must be replaced at the end of the list

.section .data
    list:
        .long 3, 1, 2, -5, 0


.section .text
    .globl _start
        _start:
            # first index must be zero
            movl $0, %edi

            # first value in the list is the current value
            movl list(, %edi, 4), %eax

            # also, first value in the list is the biggest value
            movl %eax, %ebx

            _loop:
                # when we reach at the end of the list, we must break loop
                cmpl $0, %eax
                je end

                # increment current index
                incl %edi

                # read next value from the list
                movl list(, %edi, 4), %eax

                # well, if current value (eax) <= minimum value (ebx), then repeat loop
                cmpl %ebx, %eax
                jle _loop

                # otherwise, set current value as minimum value, then repeat loop
                movl %eax, %ebx
                jmp _loop


        # end of the program
        end:
            movl $1, %eax
            int $0x80
