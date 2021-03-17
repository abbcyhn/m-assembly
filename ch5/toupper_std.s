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

        # convert input to uppercase
        pushl $BUFFER_DATA                              # location of buffer    - second argument
        pushl $BUFFER_SIZE                              # size of buffer        - first argument
        call f_toupper                                  # call f_toupper

        # find input length
        pushl $BUFFER_DATA								# input pointer         - first argument
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
