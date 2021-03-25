# PURPOSE:  Write some text to STDOUT when calling
#
msg: .ascii "We're not exiting ahahahh!\n"
len =.-msg

.type exit, @function
.globl exit
    exit:
        exit_start:
            pushl %ebp
            movl %esp, %ebp

        exit_body:
            # write to STDOUT
            movl $4, %eax							        # write syscall
            movl $1, %ebx							        # file descriptor of standart output
            movl $msg, %ecx									# written text
            movl $len, %edx									# length of text
            int $0x80									    # call linux

            movl $1, %eax
            int $0x80

        exit_end:
            movl %ebp, %esp
            popl %ebp
            ret
