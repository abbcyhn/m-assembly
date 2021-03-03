# PURPOSE: This program will computer Fibonacci of n-th term
#
# NOTE:
#       You can test result via https://www.omnicalculator.com/math/fibonacci
#
.data
    n:
        .long 11

.text
    _start:
        pushl n
        call f_fibonacci

        movl %eax, %ebx

    end:
        movl $1, %eax
        int $0x80

# PURPOSE:  Find fibonacci of n-th term
#
# INPUT:
#           n - first argument
#
# OUTPUT:
#           fibonacci of n-th term
#
# VARIABLES:
#           -4(ebp) - holds result of first call
#
# NOTE:
#           Fibonacci recursive function in highlevel language:
#
#           int fib(int n)
#           {           
#               if (n <= 2)           
#                   return 1;
#
#               return fib(n - 1) + fib(n - 2); 
#           }
#
.type f_fibonacci, @function
    f_fibonacci:
        f_fibonacci_start:
            pushl %ebp
            movl %esp, %ebp

        f_fibonacci_body:

            cmpl $2, 8(%ebp)            # if n <= 2 
            jle return_one              # jump to return_one


            # setup first recursive call:
            movl 8(%ebp), %eax          # set first argument(n) to eax

            subl $1, %eax               # set eax = eax - 1
            pushl %eax                  # push eax as argument
            call f_fibonacci            # call f_fibonacci

            subl $4, %esp               # create local storage: -4(ebp)
            movl %eax, -4(%ebp)         # save result of first call(eax) in local storage -4(ebp)


            # setup second recursive call:
            movl 8(%ebp), %eax          # set first argument(n) to eax

            subl $2, %eax               # set eax = eax - 2
            pushl %eax                  # push eax as argument
            call f_fibonacci            # call f_fibonacci

            addl -4(%ebp), %eax         # add result of first call( -4(ebp) ) to result of second call (eax)
            jmp f_fibonacci_end         # jump end of function


        return_one:                     # this label calls only when n <= 2
            movl $1, %eax               # set eax = 1

        f_fibonacci_end:
            movl %ebp, %esp
            popl %ebp
            ret
