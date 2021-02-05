# PURPOSE: Reset eflags register and broke comparision


# NOTE: How cmpl effects to eflag?
# consider: cmpl edx, ecx
# 1) if ecx < edx, then 
#       eflags  0x297   [ CF PF AF SF IF ]
#
# 2) if ecx = edx, then
#       eflags  0x246   [ PF ZF IF ]
#
# 3) if eax > ebx, then
#       eflags  0x202   [ IF ]


# SOURCE: FLAGS REGISTER: https://en.wikipedia.org/wiki/FLAGS_register
#     Abbreviation            Description                 Category            =1                      =0            
# 1.  CF                      Carry flag                  Status flag         CY(Carry)               NC(No Carry)        
# 2.  PF                      Parity flag                 Status flag         PE(Parity Even)         PO(Parity Odd)
# 3.  AF                      Adjust flag                 Status flag         AC(Auxiliary Carry)     NA(No Auxiliary Carry)
# 4.  ZF                      Zero flag                   Status flag         ZR(Zero)                NZ(Not Zero)
# 5.  SF                      Sign flag                   Status flag         NG(Negative)            PL(Positive)
# 6.  IF                      Interrupt enable flag       Control flag        EI(Enable Interrupt)	  DI(Disable Interrupt)

# CF - when an arithmetic carry or borrow has been generated out of ALU.
# PF - if the numbers of set bits is odd or even in the binary representation of the result of the last operation.
# AF - when an arithmetic carry or borrow has been generated out of the four least significant bits, or lower nibble. 
#      if carry is generated at 5th position then auxilliary flag is SET to 1.
# ZF - it is set to 1, or true, if an arithmetic result is zero, and reset otherwise.
# SF - for example, in an 8-bit signed number system, -37 will be represented as 1101 1011 in binary (the most significant bit, or sign bit, is 1), 
#      while +37 will be represented as 0010 0101 (the most significant bit is 0).
# IF - determines whether or not the CPU will respond to maskable hardware interrupts.


.section .data

.section .text
    .globl _start
        _start:

            movl $5, %ecx                           # set ecx = 5
            movl $88, %edx                          # set edx = 88

            cmpl %edx, %ecx                         # compare edx and ecx (must be ecx < edx). Look at above "NOTE" section.                                                        


            # starting reset flags (SF ZF AF PF CF)
            lahf                                    # load flags into ah register
            movb $0, %ah                            # set ah = 0
            sahf                                    # store ah into flags
            # ending reset flags


            jl setzero                              # if ecx < edx, jump setzero
            jmp setone                              # else, jump setone


            setzero:                                # if ecx < edx, then
                movl $0, %ebx                       # set ebx = 0 and
                jmp end                             # jump end of the program


            setone:                                 # if ecx >= edx, then
                movl $1, %ebx                       # set ebx = 1, and
                jmp end                             # jump end of the program


        end:                                        # end of the program
            movl $1, %eax                           # system call number (sys_exit)
            int $0x80                               # call kernel
