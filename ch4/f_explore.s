# PURPOSE: This program will explore how change stack when calling function
#
# NOTE:
#       (gdb) b before                  - set breakpoint at "before" label
#       (gdb) b func                    - set breakpoint at "func" function
#       (gdp) r                         - run program
#
#       Note: gdb stops at "before" label
#
#       (gdb) i r esp                   - get address esp register 
#       (gdb) x /8xg address_of_esp     - show stack
#       (gdb) print after               - get address of "after" label
#       (gdb) c                         - continue program
#
#       Note: gdb stops at "func" label
#
#       (gdb) i r esp                   - get address esp register 
#       (gdb) x /8xg address_of_esp     - show stack
#
#       Note: address of "after" label must be in stack
#
.text
    _start:
        pushl $80
        pushl $96
        pushl $54

        before:

        call func

        after:

    end:
        movl $1, %eax
        int $0x80

.type func, @function
    func:
        # func_start:
        pushl %ebp
        movl %esp, %ebp

        # func_end:
        movl %ebp, %esp
        popl %ebp
        ret
