# PURPOSE:  This program calls maximum with 3 different lists, 
#           and returns the result of the last one as the program’s exit status code
#
# NOTE: 0 means end of the list
#
.data
    list1:
        .long 4, 6, 81, 7, 9, 11, 0

    list2:
        .long 74, 96, 1, 27, 3, 83, 0

    list3:
        .long 91, 64, 103, 88, 65, 56, 0

.text
    _start:
        pushl $list1
        call f_maximum

        pushl $list2
        call f_maximum

        pushl $list3
        call f_maximum

        movl %eax, %ebx

    end:
        movl $1, %eax
        int $0x80


# PURPOSE:  Find maximum value from the list
# INPUT:
#           pointer of list - first argument
# OUTPUT:
#           maximum value
#
# VARIABLES:
#           eax - holds maximum value
#           ebx - holds current value
#           ecx - holds pointer of list
#           edi - current index
#
    .type f_maximum, @function
    f_maximum:
        f_maximum_start:
            pushl %ebp
            movl %esp, %ebp

        f_maximum_body:
            movl 8(%ebp), %ecx              # ecx = pointer of list
            movl $0, %edi                   # set current index
            movl (%ecx, %edi, 4), %ebx      # set current value
            movl %ebx, %eax                 # set current value as max value

            f_maximum_loop:
                cmpl $0, %ebx               # jump end of the function, if current value = 0 (%ebx=0) 
                je f_maximum_end

                incl %edi                   # increment index
                movl (%ecx, %edi, 4), %ebx  # read next value

                cmpl %eax, %ebx             # loop again, if current value(ebx) <= maximum value(eax)
                jle f_maximum_loop

                movl %ebx, %eax             # otherwise, set maximum value(eax) = current value(ebx)
                jmp f_maximum_loop          # loop again

        f_maximum_end:
            movl %ebp, %esp
            popl %ebp
            ret
