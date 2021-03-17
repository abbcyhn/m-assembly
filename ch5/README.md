## Chapter 5. Dealing with Files: Use the Concepts

- Create toupper program: [toupper.s](toupper.s)

- How to use stdin: [explore_stdin.s](explore_stdin.s)

- Modify the toupper program so that it reads from STDIN and writes to STDOUT instead of using the files on the command-line.

- Change the size of the buffer.

- Rewrite the program so that it uses storage in the .bss section rather than the stack to store the file descriptors. [towrite.s](towrite.s)

- Write a program that will create a file called heynow.txt and write the words "Hey diddle diddle!" into it. [towrite.s](towrite.s)

- Make the program able to either operate on command-line arguments or use STDIN or STDOUT based on the number of command-line arguments specified by ARGC .

- Modify the program so that it checks the results of each system call, and prints out an error message to STDOUT when it occurs.


## Questions:
- How to read command line argument as integer? [explore_passarg.s](explore_passarg.s)
- Where are storage locations declared using .long or .byte directives created? (stack/heap or somewhere else?)