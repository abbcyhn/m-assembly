SRC := ch9/towrite

all:
	as --32 $(SRC).s -o $(SRC).o
	ld -m elf_i386 $(SRC).o -o $(SRC)
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