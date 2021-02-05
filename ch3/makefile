SRC := find_max_val.s

all:
	as --32 $(SRC).s -o $(SRC).o

	ld -m elf_i386 $(SRC).o -o $(SRC)

	clear

	#gdb $(SRC)

	#./$(SRC) 

	# echo usd?

clean:
	rm -rf *.o
	find . -maxdepth 1 -type f -executable -delete
	clear