# PURPOSE: This source code contains a prototype of function

.text
    f_prototype:
        f_prototype_start:
            pushl %ebp
            movl %esp, %ebp
        
        f_prototype_body:
            # function body goes in here

        f_prototype_end:
            movl %ebp, %esp
            popl %ebp
            ret