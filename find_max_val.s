# PURPOSE:  Find maximum value from the list

# VARIABLES:
#   %edi    -   index of the current value
#   %eax    -   current value
#   %ebx    -   biggest value

# NOTES:    0 means end of the list 
#                   and must be replaced at the end of the list

.section .data
    list:
        .long 3, 250, 5, 89, 0


.section .text
    .globl _start
        _start:
            # first index must be zero
            movl $0, %edi

            # first value in the list is the current value
            movl list(, %edi, 4), %eax

            # also, first value in the list is the biggest value
            movl %eax, %ebx

            _loop_start:
                # it means that if the current value is zero we reached at the of the list
                cmpl $0, %eax
                je _loop_end

                # in order to read next value from list, we must increment index
                incl %edi
                movl list(, %edi, 4), %eax

                # compare current value and the biggest value, if current value <= biggest value, then repeat loop
                cmpl %ebx, %eax
                jle _loop_start

                # so, if current value > biggest value, then biggest value = current value, then repeat loop
                movl %eax, %ebx
                jmp _loop_start

            _loop_end:
            # end of the program
            movl $1, %eax
            int $0x80
