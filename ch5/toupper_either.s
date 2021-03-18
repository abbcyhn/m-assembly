# PURPOSE:  This program converts a input to output with all letters
#           converted to uppercase,
#           either operate on command-line arguments or use STDIN or STDOUT 
#           based on the number of command-line arguments specified by ARGC.
#
.data
	.equ SYS_CLOSE, 6                               # close system call
    .equ SYS_OPEN,  5                               # open system call
    .equ SYS_WRITE, 4                               # write system call
    .equ SYS_READ,  3                               # read system call
    .equ SYS_INT, 0x80                              # interrupt system call

    .equ O_RDONLY,  0                               # open read mode
    .equ O_CREAT_WRONLY_TRUNC, 03101                # open write mode

	.equ FD_STDIN, 0								# file descriptor of standart input 
	.equ FD_STDOUT, 1								# file descriptor of standart output

    .equ END_OF_FILE, 0                             # return value of read which means we've hit the end of the file

    msg: .ascii "Insert an input: "
    len =.-msg

.bss
	.equ BUFFER_SIZE, 500
	.lcomm BUFFER_DATA, BUFFER_SIZE


.text
    .equ ST_SIZE_RESERVE, 8                         # STACK POSITIONS
    .equ ST_FD_IN, -4
    .equ ST_FD_OUT, -8

    .equ ST_ARGC, 0                                 # Number of arguments
    .equ ST_ARGV_0, 4                               # Name of program
    .equ ST_ARGV_1, 8                               # Input file name
    .equ ST_ARGV_2, 12                              # Output file name

	_start:
        movl %esp, %ebp                             # save stack pointer

        cmpl $1, ST_ARGC(%ebp)                      # check count of arguments
        je jump_std                                 # if equals 1 go to jump_std
        jmp jump_cmd                                # else go to jump_cmd

        jump_std:
            call f_std                              # call f_std
            jmp end                                 # go to end

        jump_cmd:
            pushl ST_ARGV_2(%ebp)                   # output file name  - second argument
            pushl ST_ARGV_1(%ebp)                   # input file name   - first argument
            call f_cmd
		
	end:
		movl $0, %ebx
		movl $1, %eax
		int $SYS_INT



# PURPOSE:  Use STDIN and STDOUT
#
# INPUT:
#           no input
#
# OUTPUT:
#           no output
#
.type f_std, @function
f_std:
    f_std_start:
        pushl %ebp
        movl %esp, %ebp

    f_std_body:
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

    f_std_end:
        movl %ebp, %esp
        popl %ebp
        ret


# PURPOSE:  Use Command-line argument
#
# INPUT:
#           no input
#
# OUTPUT:
#           no output
#
.type f_cmd, @function
f_cmd:
    f_cmd_start:
        pushl %ebp
        movl %esp, %ebp

    f_cmd_body:
        subl $ST_SIZE_RESERVE, %esp                 # allocate space for our file descriptors on the stack

        open_files:
            open_fd_in:                             # open input file
                movl $SYS_OPEN, %eax                # open syscall
                movl 8(%ebp), %ebx                  # input filename into %ebx
                movl $O_RDONLY, %ecx                # read-only flag
                movl $0666, %edx                    # this doesn't really matter for reading
                int $SYS_INT                        # call Linux

            store_fd_in:                            # save the given file descriptor
                movl %eax, ST_FD_IN(%ebp)
            
            open_fd_out:                            # open output file
                movl $SYS_OPEN, %eax                # open the file
                movl 12(%ebp), %ebx                 # output filename into %ebx
                movl $O_CREAT_WRONLY_TRUNC, %ecx    # flags for writing to the file
                movl $0666, %edx                    # mode for new file (if it's created)
                int $SYS_INT                        # call Linux
            
            store_fd_out:                           # store the file descriptor here
                movl %eax, ST_FD_OUT(%ebp)


        read_loop_begin:                            # begin main loop
            movl $SYS_READ, %eax                    # READ IN A BLOCK FROM THE INPUT FILE
            movl ST_FD_IN(%ebp), %ebx               # get the input file descriptor
            movl $BUFFER_DATA, %ecx                 # the location to read into
            movl $BUFFER_SIZE, %edx                 # the size of the buffer
            int $SYS_INT                            # size of buffer read is returned in %eax

            cmpl $END_OF_FILE, %eax                 # EXIT IF WE'VE REACHED THE END check for end of file marker
            jle read_loop_end                       # if found or on error, go to the end

        read_loop_continue:                         # CONVERT THE BLOCK TO UPPER CASE
            pushl $BUFFER_DATA                      # location of buffer
            pushl %eax                              # size of the buffer
            call f_toupper
            popl %eax                               # get the size back
            addl $4, %esp                           # restore %esp

                                                    # WRITE THE BLOCK OUT TO THE OUTPUT FILE
            movl %eax, %edx                         # size of the buffer
            movl $SYS_WRITE, %eax                   # file to use
            movl ST_FD_OUT(%ebp), %ebx              # location of the buffer
            movl $BUFFER_DATA, %ecx
            int $SYS_INT        
            jmp read_loop_begin                     # CONTINUE THE LOOP


        read_loop_end:                              # CLOSE THE FILES
            movl $SYS_CLOSE, %eax                   # note - we don't need to do error checking
            movl ST_FD_OUT(%ebp), %ebx              # on these, because error conditions
            int $SYS_INT                            # don't signify anything special here
            movl $SYS_CLOSE, %eax
            movl ST_FD_IN(%ebp), %ebx
            int $SYS_INT        

    f_cmd_end:
        movl %ebp, %esp
        popl %ebp
        ret

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
