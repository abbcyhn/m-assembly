## Chapter 3. Your First Programs: Use the Concepts

- Create First Simple Program: [helloasm.s](helloasm.s)

- Create Finding a Maximum Value Program: [find_max_val.s](find_max_val.s)

- Modify the first program to return the value 3: [helloasm.s](helloasm.s)

- Modify the maximum program to find the minimum instead: [find_min_val.s](find_min_val.s)

- Modify the maximum program to use the number 255 to end the list rather than the number 0: [find_max_val.s](find_max_val.s)

- Modify the maximum program to use an ending address rather than the number 0 to know when to stop: [find_max_val_by_ending_address.s](find_max_val_by_ending_address.s)

- Modify the maximum program to use a length count rather than the number 0 to know when to stop: [find_min_val.s](find_min_val.s)

- What would the instruction movl _start, %eax do? Be specific, based on your knowledge of both addressing modes and the meaning of _start. How would this differ from the instruction movl $_start, %eax ? [explore_modes.s](explore_modes.s)
    - movl _start, %eax -> This is **Directing Addressing Mode**: Read 4 bytes from "_start" label and write to eax register.
    - movl $_start, %eax -> This is **Immediate Addressing Mode**: Read "_start" labe address and write to eax register.

- How to change %eflags value, manually? [explore_eflags.s](explore_eflags.s)