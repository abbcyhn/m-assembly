# PURPOSE: Find minimum value from the list

# VARIABLES: 
# edi - index of the current value
# eax - current value
# ebx - minimum value 
# ecx - count of the list

.section .data
    count:
        .long 7

    list:
        .long 80, 90, 10, 74, 1, 8, 0

.section .text
    .globl _start
        _start:                                     # start of the program

            movl $0, %edi                           # set index zero

            movl count(,%edi,4), %ecx               # set count of the list

            movl list(,%edi,4), %eax                # set current value as first value in the list
            decl %ecx                               # decrement count (because we read a value from the list)

            movl %eax, %ebx                         # set current value as minimum value

            _loop:
                cmpl $0, %ecx                       # jump end of the program, if count = 0 
                je end

                incl %edi                           # increment current index
                movl list(,%edi,4), %eax            # read next value from the list
                decl %ecx                           # decrement count (because we read a value from the list)

                cmpl %ebx, %eax                     # loop again, if current value (eax) >= minimum value (ebx)
                jge _loop

                movl %eax, %ebx                     # otherwise, set current value as minimum value
                jmp _loop                           # then loop again


        end:                                        # end of the program
            movl $1, %eax                           # system call number (sys_exit)
            int $0x80                               # call kernel
