# PURPOSE: Calculate sum of elements in the list using function
#
# NOTE: 0 means end of the list
#
.data
    list:
        .long 4, 6, 81, 7, 9, 11, 0

.text
    _start:
        pushl $list
        call f_sum
        movl %eax, %ebx

    end:
        movl $1, %eax
        int $0x80


# PURPOSE:  Calculate sum of elements in the list
# INPUT:
#           pointer of list - first argument
# OUTPUT:
#           sum of element
#
# VARIABLES:
#           eax - holds sum of elements
#           ebx - holds current element
#           ecx - holds pointer of list
#           edi - current index
#
    .type f_sum, @function
    f_sum:
        f_sum_start:
            pushl %ebp
            movl %esp, %ebp

        f_sum_body:
            movl 8(%ebp), %ecx              # ecx = pointer of list
            movl $0, %edi                   # set current index
            movl (%ecx, %edi, 4), %ebx      # set current value
            addl %ebx, %eax                 # set current value as sum of elements

            f_sum_loop:
                cmpl $0, %ebx               # jump end of the function, if current value = 0 (%ebx=0) 
                je f_sum_end

                incl %edi                   # increment index
                movl (%ecx, %edi, 4), %ebx  # read next value

                addl %ebx, %eax             # add current value to sum
                jmp f_sum_loop              # loop again

        f_sum_end:
            movl %ebp, %esp
            popl %ebp
            ret
