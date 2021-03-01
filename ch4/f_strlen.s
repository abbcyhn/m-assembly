# PURPOSE:  This program will compute length of string
#
# NOTE:
#           Last character of string is 0
#
.data
    mystring:
        .ascii "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..."

.text
    _start:
        movl $mystring, %ebx

        movl $0, %ecx
        movb (%ebx,%ecx,1), %bh

        loop:
            cmpb $0, %bh
            je loop_end

            incl %eax
            incl %ecx
            movb (%ebx,%ecx,1), %bh
            jmp loop

        loop_end:
            movl %eax, %ebx

    end:
        movl $1, %eax
        int $0x80
