# PURPOSE:  This program will compute length of string
#
.data
    mystring:
        .ascii "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..."
.text
    _start:
        pushl $mystring
        call f_strlen

        movl %eax, %ebx

    end:
        movl $1, %eax
        int $0x80


# PURPOSE:  Find length of given string
#
# INPUT:
#           string pointer - first argument
#
# OUTPUT:
#           length of string
#
# VARIABLES:
#           %bh     - holds current character
#           %eax    - holds string pointer
#           %ecx    - holds length
#           %edi    - holds index of current character
#
# NOTE:
#           Last character of string is 0
#
.type f_strlen, @function
f_strlen:
    f_strlen_start:
        pushl %ebp
        movl %esp, %ebp

    f_strlen_body:
        movl 8(%ebp), %eax                  # eax = string pointer

        movl $0, %edi                       # set current index(edi) = 0
        movb (%eax,%ecx,1), %bh             # set current character(bh)

            f_strlen_loop:
                cmpb $0, %bh                # if current character(bh) is 0
                je f_strlen_loop_end        # jump end of loop

                incl %ecx                   # otherwise, increment length(ecx) 
                incl %edi                   # increment current index(edi)
                movb (%eax,%edi,1), %bh     # read next character(bh)
                jmp f_strlen_loop           # loop again

            f_strlen_loop_end:              # end of loop
                movl %ecx, %eax             # set length to return value (eax = ecx)

    f_strlen_end:
        movl %ebp, %esp
        popl %ebp
        ret
