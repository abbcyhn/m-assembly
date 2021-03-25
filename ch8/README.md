## Chapter 8. haring Functions with Code Libraries: Use the Concepts

- Rewrite one or more of the programs from the previous chapters to print their results to the screen using printf rather than returning the result as the exit status code. Also, make the exit status code be 0. [prg.s](prg.s)

- Use the factorial function you developed in the Section called Recursive Functions in Chapter 4 to make a shared library. Then re-write the main program so that it links with the library dynamically. [prg.s](prg.s)

- Rewrite the program above so that it also links with the 'c' library. Use the 'c' library's printf function to display the result of the factorial call. [prg.s](prg.s)

- Rewrite the towrite program so that it uses the c library functions for files rather than system calls. [towrite.s](towrite.s)

- Research the use of LD_PRELOAD . What is it used for? Try building a shared library that contained the exit function, and have it write a message to STDERR before exitting. Use LD_PRELOAD and run various programs with it. What are the results? [preload.s](preload.s)