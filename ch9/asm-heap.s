# PURPOSE:  This program creates new file
#
.section .data
 #   #######FOR TESTING########
    msg_newline: .ascii "\n"
    msg_newline_len =.-msg_newline

    msg_size_500: .ascii "[SIZE] 500\n"
    msg_size_500_len =.-msg_size_500

    msg_size_200: .ascii "[SIZE] 200\n"
    msg_size_200_len =.-msg_size_200

    msg_size_292: .ascii "[SIZE] 292\n"
    msg_size_292_len =.-msg_size_292

#   #######GLOBAL VARIABLES########
    filename:
        .ascii "heynow.txt\0"

    text:
        .ascii "Hey diddle diddle!"

    text_length = .-text

    file_desc_ptr:
        .long 0

.section .text
    .globl _start
        _start:
# WRITE LOG: SIZE 500
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_size_500_len
pushl $msg_size_500
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

            # allocate heap
            pushl $500                                  # heap size is 1
            call malloc                                 # call malloc
            movl %eax, file_desc_ptr                    # save pointer in file_desc_ptr

            # deallocate heap
            pushl file_desc_ptr
            call free

# WRITE LOG: newline
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_newline_len
pushl $msg_newline
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

# WRITE LOG: SIZE 200
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_size_200_len
pushl $msg_size_200
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

            # allocate heap
            pushl $200                                  # heap size is 1
            call malloc                                 # call malloc
            movl %eax, (file_desc_ptr)                  # save pointer in file_desc_ptr

            # deallocate heap
            pushl file_desc_ptr
            call free

# WRITE LOG: newline
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_newline_len
pushl $msg_newline
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

# WRITE LOG: SIZE 292
# ####################################################################################################################################
pushl %eax  # save %eax
pushl %ebx  # save %ebx
pushl %ecx  # save %ecx
pushl %edx  # save %edx

pushl $msg_size_292_len
pushl $msg_size_292
call f_write_log
addl $8, %esp

popl %edx   # restore %edx
popl %ecx   # restore %ecx
popl %ebx   # restore %ebx
popl %eax   # restore %eax
# ####################################################################################################################################

            # allocate heap
            pushl $292                                  # heap size is 1
            call malloc                                 # call malloc
            movl %eax, (file_desc_ptr)                  # save pointer in file_desc_ptr

            # deallocate heap
            pushl file_desc_ptr
            call free

        end:
            movl $0, %ebx
            movl $1, %eax
            int $0x80
