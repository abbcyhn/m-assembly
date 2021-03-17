.data
	.equ SYS_CLOSE, 6                               # close system call
    .equ SYS_OPEN,  5                               # open system call
    .equ SYS_WRITE, 4                               # write system call
    .equ SYS_READ,  3                               # read system call
    .equ SYS_INT, 0x80                              # interrupt system call

	.equ FD_STDIN, 0								# file descriptor of standart input 
	.equ FD_STDOUT, 1								# file descriptor of standart output

    msg: .ascii "Insert an input: "
    len =.-msg

.bss
	.equ BUFFER_SIZE, 500
	.lcomm BUFFER_DATA, BUFFER_SIZE

.text
	_start:

		# write to STDOUT
		movl $SYS_WRITE, %eax							# write syscall
		movl $FD_STDOUT, %ebx							# file descriptor
		movl $msg, %ecx									# written text
		movl $len, %edx									# length of text
		int $SYS_INT									# call linux


		# read from STDIN
		movl $SYS_READ, %eax 		    				# read syscall
		movl $FD_STDIN, %ebx		    				# file descriptor
		movl $BUFFER_DATA, %ecx 	    				# location to read into
		movl $BUFFER_SIZE, %edx							# size of location
		int $SYS_INT		        					# call Linux

        # find input length
        pushl $BUFFER_DATA								# input pointer - first argument
        call f_strlen									# call f_strlen
        movl %eax, %edi									# set result to edi

		# write to STDOUT
		movl $SYS_WRITE, %eax							# write syscall
		movl $FD_STDOUT, %ebx							# file descriptor
		movl $BUFFER_DATA, %ecx							# written text
		movl %edi, %edx									# length of text
		int $SYS_INT									# call linux
		

	end:
		movl $0, %ebx
		movl $1, %eax
		int $SYS_INT


# PURPOSE:  Find length of given string
#
# INPUT:
#           string pointer - first argument
#
# OUTPUT:
#           length of string
#
# VARIABLES:
#           %bl     - holds current character
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

		f_strlen_loop:
			movb (%eax,%edi, 1), %bl		# save current char in bl 
			incl %edi	 	    			# increment counter
			cmpb $0, %bl		    		# if we've not reached end of input
			jne f_strlen_loop		    	# continue

		movl %edi, %eax             		# set length to return value (eax = ecx)

    f_strlen_end:
        movl %ebp, %esp
        popl %ebp
        ret
