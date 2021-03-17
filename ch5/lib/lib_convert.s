# PURPOSE:  Convert to uppercase a block
#
# INPUT:
#           size of buffer          - first argument
#           location of buffer      - second argument
#
# OUTPUT:
#           returns nothing but overwrites buffer with the upper-casified version
#
#
# VARIABLES:
#           %eax - beginning of buffer
#           %ebx - size of buffer
#           %edi - current buffer offset
#           %cl  - current byte being examined (first part of %ecx)
#
# CONSTANTS
.equ LOWERCASE_A, 'a'                               # The lower boundary of our search
.equ LOWERCASE_Z, 'z'                               # The upper boundary of our search
.equ UPPER_CONVERSION, 'A' - 'a'                    # Conversion between upper and lower case

.globl f_toupper
.type f_toupper, @function
f_toupper:
    f_toupper_start:
        pushl %ebp
        movl %esp, %ebp

    f_toupper_body:
        movl 8(%ebp), %ebx                          # size of buffer
        movl 12(%ebp), %eax                         # location of buffer
        movl $0, %edi

        cmpl $0, %ebx                               # if a buffer size = 0
        je f_toupper_end                            # just leave


        f_toupper_loop:
            movb (%eax,%edi,1), %cl                 # get the current byte
        
            cmpb $LOWERCASE_A, %cl                  # go to the next byte unless it is between 'a' and 'z'
            jl next_byte

            cmpb $LOWERCASE_Z, %cl                  # go to the next byte unless it is between 'a' and 'z'
            jg next_byte
            
            addb $UPPER_CONVERSION, %cl             # otherwise convert the byte to uppercase            
            movb %cl, (%eax,%edi,1)                 # and store it back
            

            next_byte:                              # get next byte
                incl %edi                           # increment index
                cmpl %edi, %ebx                     # if we've not reached the end
                jne f_toupper_loop                  # continue


    f_toupper_end:
        movl %ebp, %esp
        popl %ebp
        ret
