## Chapter 5. Dealing with Files: Use the Concepts

- Create toupper program: [toupper.s](toupper.s)

- How to use stdin: [explore_stdin.s](explore_stdin.s)

- How to pass arg via command-line: [explore_passarg.s](explore_passarg.s)

- Change the size of the buffer. [toupper.s](toupper.s)

- Modify the toupper program so that it reads from STDIN and writes to STDOUT instead of using the files on the command-line. [toupper_std.s](toupper_std.s)

- Rewrite the program so that it uses storage in the .bss section rather than the stack to store the file descriptors. [towrite.s](towrite.s)

- Write a program that will create a file called heynow.txt and write the words "Hey diddle diddle!" into it. [towrite.s](towrite.s)

- Make the program able to either operate on command-line arguments or use STDIN or STDOUT based on the number of command-line arguments specified by ARGC. [toupper_either.s](toupper_either.s)

- Modify the program so that it checks the results of each system call, and prints out an error message to STDOUT when it occurs. [toupper.s](toupper.s)


## Todo:
- Fix bug in ch5/lib/prg.s

## Questions:
- How to read command line argument as integer?
- How high-level languages use .data və .bss sections?
- What is difference between %bh & %bl in ch5/explore_stdin.s ?
- Why I can't access commandline arguments with esp? Look:        
        # movl %esp, %ebp                           # without this gives error 
        pushl ST_ARGV_2(%esp)                       # output file name  - second argument
        pushl ST_ARGV_1(%esp)                       # input file name   - first argument