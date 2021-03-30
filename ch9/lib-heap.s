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
    msg_malloc_int: .ascii "[FUNCTION] malloc_init\n"
    msg_malloc_int_len =.-msg_malloc_int

    msg_malloc: .ascii "[FUNCTION] malloc\n"
    msg_malloc_len =.-msg_malloc

    msg_malloc_loop_begin: .ascii "[LABEL] malloc_loop_begin\n"
    msg_malloc_loop_begin_len =.-msg_malloc_loop_begin

    msg_malloc_next_location: .ascii "[LABEL] malloc_next_location\n"
    msg_malloc_next_location_len =.-msg_malloc_next_location

    msg_malloc_move_break: .ascii "[LABEL] malloc_move_break\n"
    msg_malloc_move_break_len =.-msg_malloc_move_break

    msg_malloc_split: .ascii "[FUNCTION] malloc_split\n"
    msg_malloc_split_len =.-msg_malloc_split

    msg_free: .ascii "[FUNCTION] free\n"
    msg_free_len =.-msg_free

    msg_less: .ascii "[LABEL] malloc_here_when_less\n"
    msg_less_len =.-msg_less

    msg_equal: .ascii "[LABEL] malloc_here_when_equal\n"
    msg_equal_len =.-msg_equal


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

# WRITE LOG
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_malloc_int_len
pushl $msg_malloc_int
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

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

# WRITE LOG
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_malloc_len
pushl $msg_malloc
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

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
# WRITE LOG
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_malloc_loop_begin_len
pushl $msg_malloc_loop_begin
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

            cmpl %ebx, %eax                                 # need more memory if these are equal
            je malloc_move_break

            movl HDR_SIZE_OFFSET(%eax), %edx                # grab the size of this memory
            cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)       # if the space is unavailable, go to the
            je malloc_next_location                         # next one

            cmpl %edx, %ecx                                 # if the space is available, compare
            jle malloc_here_when_equal                      # the size to the needed size. If its equal, go to malloc_here_when_equal   

#           CURRENTLY NOT WORKING ######################################################################################################
            # jl malloc_here_when_less                        # If its big enough, go to malloc_here_when_less   

        malloc_next_location:
# WRITE LOG
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_malloc_next_location_len
pushl $msg_malloc_next_location
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

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

        malloc_here_when_equal:                             # if we’ve made it here,
                                                            # that means that the
                                                            # region header of the region
                                                            # to allocate is in %eax
# WRITE LOG
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_equal_len
pushl $msg_equal
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

            movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)       # mark space as unavailable
            addl $HEADER_SIZE, %eax                         # move %eax past the header to
                                                            # the usable memory (since
                                                            # that’s what we return)            
            jmp malloc_end

        malloc_here_when_less:

# WRITE LOG
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_less_len
pushl $msg_less
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################


            pushl %ecx                                      # requested size            - second parameter
            pushl %eax                                      # current region address    - first parameter
            call malloc_split                               # call malloc_split

            popl %eax
            popl %ecx

            addl $HEADER_SIZE, %eax

            jmp malloc_end

        malloc_move_break:                                  # if we’ve made it here, that
                                                            # means that we have exhausted
                                                            # all addressable memory, and
                                                            # we need to ask for more.
                                                            # %ebx holds the current
                                                            # endpoint of the data,
                                                            # and %ecx holds its size

# WRITE LOG
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_malloc_move_break_len
pushl $msg_malloc_move_break
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

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



#           malloc_split
# PURPOSE:      
#               This function is used to split region into two parts: requested region and remaining region
#
# PARAMETERS:   
#               current region address  - first parameter
#               requested region size   - second parameter
#
# RETURN VALUE:
#               returns nothing
#
# VARIABLES:
#               %eax - current region address (= requested region address)
#               %ebx - requested region size
#               %ecx - current region size
#               %edx - remaining region address
#               %edi - remaining region size
#
# PROCESSING:
#       CURRENT REGION (BEFORE SPLIT):
#                                   CURRENT REGION
#           AVALILABLE    SIZE                      USED SECTION
#             0 _______4_________8__________________________________________________508
#               |      |         | //////////////////////////////////////////////// |
#               |   1  |   500   | //////////////////////////////////////////////// |
#               |      |         | //////////////////////////////////////////////// |
#               ---------------------------------------------------------------------
#
#       IF REQUESTED SIZE IS 200:
#       CURRENT REGION (AFTER SPLIT):
#
#                   REQUESTED REGION            |           REMAINING REGION
#                                               |
#           AVALILABLE    SIZE     USED SECTION | AVAILABLE   SIZE     USED SECTION
#             0 _______4_________8______________208_______4_________8______________508
#               |      |         | //////////// |         |         | //////////// |
#               |   0  |   200   | ////208///// |    1    |   292   | ////292///// |
#               |      |         | //////////// |         |         | //////////// |
#               --------------------------------------------------------------------
#
    .globl malloc_split
    .type malloc_split, @function
    malloc_split:
        malloc_split_start:
            pushl %ebp
            movl %esp, %ebp

# WRITE LOG
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_malloc_split_len
pushl $msg_malloc_split
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

        malloc_split_body:
            # get variables
            movl 8(%ebp), %eax                              # get current region address (current region address = requested region address)
            movl 12(%ebp), %ebx                             # get requested region size
            movl HDR_SIZE_OFFSET(%eax), %ecx                # get current region size

            # find remaining region address                 # edx = current region address + requested region size + header size
            movl %eax, %edx                                 # edx = current region address
            addl %ebx, %edx                                 # edx += requested region size
            addl $HEADER_SIZE, %edx                         # edx += header size

            # find remaining region size                    # edi = current region size - requested region size - header size
            movl %ecx, %edi                                 # edi = current region size
            subl %edx, %edi                                 # edi -= requested region size
            subl $HEADER_SIZE, %edi                         # edi -= header size

            # confirm split process
            movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)       # set current region as unavailable (current region address = requested region address)
            movl %ebx, HDR_SIZE_OFFSET(%eax)                # set current region size 
            movl $AVAILABLE, HDR_AVAIL_OFFSET(%edx)         # set remaining region as available
            movl %edi, HDR_SIZE_OFFSET(%edx)                # set remaining region size 

        malloc_split_end:
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

# WRITE LOG
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_free_len
pushl $msg_free
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

        # get the address of the memory to free
        # (normally this is 8(%ebp), but since
        # we didn’t push %ebp or move %esp to
        # %ebp, we can just do 4(%esp)
        movl 4(%esp), %eax
        subl $HEADER_SIZE, %eax                         # get the pointer to the real beginning of the memory
        movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)         # mark it as available
        ret                                             # return


# PURPOSE:  Writes buffer to given file
#
# INPUT:
#           address of buffer   - first argument
#           size of buffer      - second argument
#
# OUTPUT:
#           returns nothing but overwrites buffer
#
.globl f_write_log
.type f_write_log, @function
f_write_log:
    f_write_log_start:
        pushl %ebp
        movl %esp, %ebp

    f_write_log_body:
        movl $4, %eax                               # write syscall
        movl $1, %ebx                               # file descriptor: STDOUT
        movl 8(%ebp), %ecx                          # buffer
        movl 12(%ebp), %edx                         # size of buffer
        int $0x80                                   # call linux

    f_write_log_end:
        movl %ebp, %esp
        popl %ebp
        ret
