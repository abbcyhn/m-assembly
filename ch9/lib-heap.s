# PURPOSE:  Program to manage memory usage - allocates
#           and deallocates memory as requested
#
# NOTES:    The programs using these routines will ask
#           for a certain size of memory. We actually
#           use more than that size, but we put it
#           at the beginning, before the pointer
#           we hand back. We add a size field and
#           an AVAILABLE/UNAVAILABLE marker. So, the
#           memory looks like this
#
# #########################################################
# #Available Marker#Size of memory#Actual memory locations#
# #########################################################
#                                 ^--Returned pointer points here
#
#           The pointer we return only points to the actual
#           locations requested to make it easier for the
#           calling program. It also allows us to change our
#           structure without the calling program having to
#           change at all.

.section .data
#   #######FOR TESTING########
    msg: .ascii "THIS IS FROM JEYHUN's OWN ALLOCATOR!\n"
    len =.-msg

#   #######GLOBAL VARIABLES########
    heap_begin:                     # this points to the beginning of the memory we are managing
        .long 0

    current_break:                  # this points to one location past the memory we are managing
        .long 0


#   ######STRUCTURE INFORMATION####
    .equ HEADER_SIZE, 8             # size of space for memory region header
    .equ HDR_AVAIL_OFFSET, 0        # location of the "available" flag in the header
    .equ HDR_SIZE_OFFSET, 4         # location of the size field in the header


#   ###########CONSTANTS###########
    .equ UNAVAILABLE, 0             # this is the number we will use to mark space that has been given out
    .equ AVAILABLE, 1               # this is the number we will use to mark space that has been returned, and is available for giving
    .equ SYS_BRK, 45                # break system call
    .equ SYS_INT, 0x80              # interrup system call


.section .text
#   ##########FUNCTIONS############
#
#           malloc_init
# PURPOSE:  call this function to initialize the
#           functions (specifically, this sets heap_begin and
#           current_break). This has no parameters and no
#           return value.
#
    .globl malloc_init
    .type malloc_init, @function
    malloc_init:
        malloc_init_start:
            pushl %ebp
            movl %esp, %ebp

        malloc_init_body:
            # If the brk system call is called with 0 in %ebx, it
            # returns the last valid usable address
            # Find out where the break is:
            movl $SYS_BRK, %eax
            movl $0, %ebx
            int $SYS_INT

            incl %eax                       # %eax now has the last valid address,
                                            # and we want the memory location after that

            movl %eax, current_break        # store the current break

            movl %eax, heap_begin           # store the current break as our
                                            # first address. This will cause
                                            # the allocate function to get
                                            # more memory from Linux the
                                            # first time it is run

        malloc_init_end:
            movl %ebp, %esp
            popl %ebp
            ret


#           malloc
# PURPOSE:      This function is used to grab a section of
#               memory. It checks to see if there are any
#               free blocks, and, if not, it asks Linux
#               for a new one.
#
# PARAMETERS:   This function has one parameter - the size
#               of the memory block we want to allocate
#
# RETURN VALUE:
#               This function returns the address of the
#               allocated memory in %eax. If there is no
#               memory available, it will return 0 in %eax
#
# VARIABLES:
#               %eax - current memory region being examined
#               %ebx - current break position
#               %ecx - hold the size of the requested memory (first/only parameter)
#               %edx - size of current memory region
#
# PROCESSING:
#               We scan through each memory region starting with
#               heap_begin. We look at the size of each one, and if
#               it has been allocated. If it’s big enough for the
#               requested size, and its available, it grabs that one.
#               If it does not find a region large enough, it asks
#               Linux for more memory. In that case, it moves current_break up.
#
    .globl malloc
    .type malloc, @function
    malloc:
        malloc_start:
            pushl %ebp
            movl %esp, %ebp

            # for TESTING: write to STDOUT
            movl $4, %eax							        # write syscall
            movl $1, %ebx							        # file descriptor of standart output
            movl $msg, %ecx									# written text
            movl $len, %edx									# length of text
            int $0x80									    # call linux

            # initialization logic
            cmpl $0, heap_begin                             # if heap not initialized 
            je malloc_init_call                             # initialize it
            jmp malloc_body                                 # else go to malloc_body

            malloc_init_call:                               # initialize heap
                call malloc_init

        malloc_body:
            movl 8(%ebp), %ecx                              # %ecx will hold the size we are looking for
            movl heap_begin, %eax                           # %eax will hold the current search location
            movl current_break, %ebx                        # %ebx will hold the current break

        malloc_loop_begin:                                  # here we iterate through each memory region
            cmpl %ebx, %eax                                 # need more memory if these are equal
            je malloc_move_break

            movl HDR_SIZE_OFFSET(%eax), %edx                # grab the size of this memory
            cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)       # if the space is unavailable, go to the
            je malloc_next_location                         # next one

            cmpl %edx, %ecx                                 # if the space is available, compare
            jle malloc_here                                 # the size to the needed size. If its big enough, go to malloc_here   

        malloc_next_location:
            addl $HEADER_SIZE, %eax                         # the total size of the memory
            addl %edx, %eax                                 # region is the sum of the size
                                                            # requested (currently stored
                                                            # in %edx), plus another 8 bytes
                                                            # for the header (4 for the
                                                            # AVAILABLE/UNAVAILABLE flag,
                                                            # and 4 for the size of the
                                                            # region). So, adding %edx and $8
                                                            # to %eax will get the address
                                                            # of the next memory region
            
            jmp malloc_loop_begin                           # go look at the next location

        malloc_here:                                        # if we’ve made it here,
                                                            # that means that the
                                                            # region header of the region
                                                            # to allocate is in %eax

            movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)       # mark space as unavailable
            addl $HEADER_SIZE, %eax                         # move %eax past the header to
                                                            # the usable memory (since
                                                            # that’s what we return)            
            jmp malloc_end

        malloc_move_break:                                  # if we’ve made it here, that
                                                            # means that we have exhausted
                                                            # all addressable memory, and
                                                            # we need to ask for more.
                                                            # %ebx holds the current
                                                            # endpoint of the data,
                                                            # and %ecx holds its size

                                                            # we need to increase %ebx to
                                                            # where we want memory
                                                            # to end, so we
            addl $HEADER_SIZE, %ebx                         # add space for the headers structure
            addl %ecx, %ebx                                 # add space to the break for the data requested

                                                            # now its time to ask Linux for more memory
            pushl %eax                                      # save needed registers
            pushl %ebx 
            pushl %ecx

            movl $SYS_BRK, %eax                             # reset the break (%ebx has the requested break point)
            int $SYS_INT

                                                            # under normal conditions, this should
                                                            # return the new break in %eax, which
                                                            # will be either 0 if it fails, or
                                                            # it will be equal to or larger than
                                                            # we asked for. We don’t care
                                                            # in this program where it actually
                                                            # sets the break, so as long as %eax
                                                            # isn’t 0, we don’t care what it is
            cmpl $0, %eax 
            je malloc_error                                 # check for error conditions

            popl %ecx                                       # restore saved registers
            popl %ebx
            popl %eax

            movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)       # set this memory as unavailable, since we’re about to give it away
            movl %ecx, HDR_SIZE_OFFSET(%eax)                # set the size of the memory
            addl $HEADER_SIZE, %eax                         # move %eax to the actual start of usable memory. %eax now holds the return value
            
            movl %ebx, current_break                        # save the new break
            jmp malloc_end

        malloc_error:                                       # on error, we return zero
            movl $0, %eax

        malloc_end:
            movl %ebp, %esp
            popl %ebp
            ret


#           free
# PURPOSE:  The purpose of this function is to give back
#           a region of memory to the pool after we’re done using it.
#
# PARAMETERS:
#           The only parameter is the address of the memory
#           we want to return to the memory pool.
#
# RETURN VALUE:
#           There is no return value
#
# PROCESSING:
#           If you remember, we actually hand the program the
#           start of the memory that they can use, which is
#           8 storage locations after the actual start of the
#           memory region. All we have to do is go back
#           8 locations and mark that memory as available,
#           so that the allocate function knows it can use it.
#
    .globl free
    .type free, @function
    free:
        # since the function is so simple, we
        # don’t need any of the fancy function stuff

        # for TESTING: write to STDOUT
        movl $4, %eax							        # write syscall
        movl $1, %ebx							        # file descriptor of standart output
        movl $msg, %ecx									# written text
        movl $len, %edx									# length of text
        int $0x80									    # call linux

        # get the address of the memory to free
        # (normally this is 8(%ebp), but since
        # we didn’t push %ebp or move %esp to
        # %ebp, we can just do 4(%esp)
        movl 4(%esp), %eax
        subl $HEADER_SIZE, %eax                         # get the pointer to the real beginning of the memory
        movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)         # mark it as available
        ret                                             # return

