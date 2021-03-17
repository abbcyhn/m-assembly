SRC := ch5/explore_stdin

all:
	as --32 $(SRC).s -o $(SRC).o

	ld -m elf_i386 $(SRC).o -o $(SRC)

	clear

	#gdb $(SRC)

	#./$(SRC) 

	#echo usd?

clean:
	find . -type f -name '*.o' -delete
	find . -type f -executable -delete
	find . -type f -name '*.txt*' -delete
	find . -type f -name '*.uppercase' -delete
	clear

run:
	./$(SRC)
