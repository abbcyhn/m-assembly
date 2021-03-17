.data
    msg: .ascii "Insert an input: "
    len =.-msg


.text


MAX_CHAR=30

_start:

	# Start message
	movl $4, %eax
	movl $1, %ebx
	movl $msg, %ecx
	movl $len, %edx
	int $0x80


	# READ
	movl $3, %eax 		    # sys_read (number 3)
	movl $0, %ebx		    # stdin (number 0)
	movl %esp, %ecx 	    # starting point
	movl $MAX_CHAR, %edx	# max input
	int $0x80		        # call


	# Need the cycle to count input length	
	movl $1, %ecx 		    # counter

end_input:
	xor %ebx, %ebx
	movb (%esp), %bl
	add $1, %esp		    # get next char to compare 
	add $1, %ecx	 	    # counter+=1
	cmp $0xa, %ebx		    # compare with "\n" 
	jne end_input		    # if not, continue 


	# WRITE
	sub %ecx, %esp		    # start from the first input char
	movl $4, %eax		    # sys_write (number 4)
	movl $1, %ebx		    # stdout (number 1)
	movl %ecx, %edx		    # start pointer
	movl %esp, %ecx		    # length
	int $0x80		        # call
	 

	# EXIT
	movl $1, %eax
	movl $0, %ebx
	int $0x80	
