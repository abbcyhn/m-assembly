.section .data
    .equ SYS_EXIT, 1
    .equ SYS_READ, 3
    .equ SYS_WRITE, 4
    .equ SYS_OPEN, 5
    .equ SYS_CLOSE, 6
    .equ SYS_INT, 0x80

    .equ FD_STDIN, 0
    .equ FD_STDOUT, 1
    .equ FD_STDERR, 2

    .equ O_RDONLY, 0
    .equ O_WRONLY, 03101

    age:
        .long 45

    age_len =.-age

    age_str:
        .ascii "45"

    age_str_len =.-age_str

.section .text
    _start:
		# write to STDOUT
		movl $SYS_WRITE, %eax							# write syscall
		movl $FD_STDOUT, %ebx							# file descriptor
		movl $age, %ecx							        # written text
		movl $age_len, %edx							    # length of text
		int $SYS_INT									# call linux

    end:
        movl $0, %ebx
        movl $SYS_EXIT, %eax
        int $SYS_INT
        
        
