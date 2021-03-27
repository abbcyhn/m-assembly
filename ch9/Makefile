LIB := lib-heap
SRC := asm-heap
SRCC := c-heap

all:
	as --32 $(SRC).s -o $(SRC).o
	as --32 $(LIB).s -o $(LIB).o
	ld -m elf_i386 $(SRC).o $(LIB).o -o $(SRC)
	gcc -m32 $(SRCC).c -o $(SRCC)
	clear

# change LD_PRELOAD
# note: exec the following command manual
preload:
	LD_PRELOAD=$PWD/lib$(LIB).so ./$(SRC)

# share your own library
share-lib:
	as --32 $(LIB).s -o $(LIB).o
	ld -m elf_i386 -shared $(LIB).o -o lib$(LIB).so
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