# PURPOSE - This program computes factorial of given a number: !number

.section .data
    number:
        .long 2

.section .text
    _start:
        pushl number
        call f_factorial            # call 1

        movl %eax, %ebx

    end:
        movl $1, %eax
        int $0x80


.type factorial, @function
    f_factorial:
        f_factorial_start:
            pushl %ebp
            movl %esp, %ebp

        f_factorial_body:
            movl 8(%ebp), %eax      # eax = number

            cmpl $1, %eax           # if number == 1
            je f_factorial_end      # jump end of function

            decl %eax               # otherwise, decrease the value
            pushl %eax              # push it for our call to factorial
            call f_factorial        # call 2. call factorial

            movl 8(%ebp), %ebx      # %eax has the return value, so we
                                    # reload our parameter into %ebx

            imull %ebx, %eax        # multiply that by the result of the
                                    # last call to factorial (in %eax)
                                    # the answer is stored in %eax, which
                                    # is good since that’s where return
                                    # values go.

        f_factorial_end:
            movl %ebp, %esp
            popl %ebp
            ret
