# PURPOSE:  This program creates new file
#

.section .data
    SYS_WRITE:
        .ascii "w"

    filename:
        .ascii "heynow.txt\0"

    text:
        .ascii "Hey diddle diddle!\n\0"


.section .bss
    .lcomm FILE_STRUCT, 1


.section .text
    .globl _start
        _start:
            movl %esp, %ebp
            subl $4, %esp                               # allocate space for file struct

            # create/open file
            pushl $SYS_WRITE                           # write mode
            pushl $filename                             # filename into
            call fopen                                  # call fopen
            addl $8, %esp

            # save file struct
            movl %eax, -4(%ebp)                         # save file struct

            # write text to file            
            pushl -4(%ebp)                              # file struct
            pushl $text                                 # text
            call fputs                                  # call fputs

            # close file
            pushl -4(%ebp)                              # file struct
            call fclose                                 # call fclose

            # exit program
            pushl $0
            call exit
