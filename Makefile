SRC := ch8/helloworld-lib

all:
	as --32 $(SRC).s -o $(SRC).o

	ld -m elf_i386 $(SRC).o -o $(SRC)

	clear

link:
	as --32 $(SRC).s -o $(SRC).o

	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -o $(SRC) -lc $(SRC).o

	clear

clean:
	find . -type f -name '*.o' -delete
	find . -type f -executable -delete
	find . -type f -name '*.txt*' -delete
	find . -type f -name '*.uppercase' -delete
	clear

run:
	./$(SRC)

dbg:	
	gdb $(SRC)

echo:
	echo $?