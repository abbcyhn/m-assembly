SRC := ch6/explore_number

all:
	as --32 $(SRC).s -o $(SRC).o

	ld -m elf_i386 $(SRC).o -o $(SRC)

	# ld  -dynamic-linker /lib/ld-linux.so.2 -o $(SRC) $(SRC).o -lc

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
