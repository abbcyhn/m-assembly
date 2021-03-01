# PURPOSE: This program explores the stack
# NOTES:
#   1) Firstly, %esp has it's max value.
#   2) When we push value on stack, %esp (-)decreases 4 byte.
#   3) When we pop value off stack, %esp (+)increases 4 byte.

.section .data

.section .text
    .globl _start
        _start:             # Now, %esp has it's max value.             esp         0xffffcfc0          4294954944

            push1:
            pushl $10       # After push, %esp (-) decreases 4 byte.    esp         0xffffcfbc          4294954940

            push2:
            pushl $25       # After push, %esp (-) decreases 4 byte.    esp         0xffffcfb8          4294954936 

            push3:
            pushl $80       # After push, %esp (-) decreases 4 byte.    esp         0xffffcfb4          4294954932 

            push4:
            pushl $71       # After push, %esp (-) decreases 4 byte.    esp         0xffffcfb0          4294954928   

            pop1:
            popl %eax       # After pop,  %esp (+) increases 4 byte.    esp         0xffffcfb4          4294954932
                            # eax = 71 (last pushed value).

        end:
            movl $1, %eax
            int $0x80
