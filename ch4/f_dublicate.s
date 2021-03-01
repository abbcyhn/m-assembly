# PURPOSE: Find count of given number dublicates from the list
#
# NOTE: 0 means end of the list
#
.data
    number:
        .long 4
    list:
        .long 4, 6, 81, 7, 4, 6, 9, 11, 6, 6, 0

.text
    _start:
        push number
        pushl $list
        call f_dublicate
        movl %eax, %ebx

    end:
        movl $1, %eax
        int $0x80


# PURPOSE:  Find count of given number dublicates from the list
# INPUT:
#           pointer of list - first argument
#           number - second argument
#
# OUTPUT:
#           count of dublicates
#
# VARIABLES:
#           eax     - holds count of dublicates
#           ebx     - holds current element
#           ecx     - holds pointer of list
#           edx     - holds given number
#           edi     - current index
#
    .type f_dublicate, @function
    f_dublicate:
        f_dublicate_start:
            pushl %ebp
            movl %esp, %ebp

        f_dublicate_body:
            movl 8(%ebp), %ecx                  # ecx = pointer of list
            movl 12(%ebp), %edx                 # edx = given number
            movl $0, %edi                       # set current index            
            movl (%ecx, %edi, 4), %ebx          # set current value
            
            cmpl %ebx, %edx                     # jump "f_dublicate_found" label, if current value(ebx) = given number(edx)
            je f_dublicate_found

            f_dublicate_loop:
                cmpl $0, %ebx                   # jump end of the function, if current value(ebx) = 0 
                je f_dublicate_end

                incl %edi                       # increment index
                movl (%ecx, %edi, 4), %ebx      # read next value

                cmpl %ebx, %edx                 # jump "f_dublicate_found" label, if current value(ebx) = given number(edx)
                je f_dublicate_found

                jmp f_dublicate_loop            # loop again

            f_dublicate_found:
                incl %eax                       # increment count of dublicates
                jmp f_dublicate_loop            # loop again

        f_dublicate_end:
            movl %ebp, %esp
            popl %ebp
            ret
