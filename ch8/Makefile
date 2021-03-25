SRC := preload
LIB := preload-lib

all:
	as --32 $(SRC).s -o $(SRC).o
	ld -m elf_i386 $(SRC).o -o $(SRC)
	clear

# change LD_PRELOAD
# note: exec the following command manual
preload:
	LD_PRELOAD=$PWD/lib$(LIB).so ./$(SRC)

# link with C library
link:
	as --32 $(SRC).s -o $(SRC).o
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -o $(SRC) -lc $(SRC).o
	clear

# share your own library
share-lib:
	as --32 $(LIB).s -o $(LIB).o
	ld -m elf_i386 -shared $(LIB).o -o lib$(LIB).so
	clear

# link with your own library
link-lib:
	as --32 $(SRC).s -o $(SRC).o
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
	ld -m elf_i386 -L . -dynamic-linker /lib/ld-linux.so.2 -o $(SRC) -l$(LIB) $(SRC).o
	clear

# link with both C library and your own library
link-both:
	as --32 $(SRC).s -o $(SRC).o
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
	ld -m elf_i386 -L . -dynamic-linker /lib/ld-linux.so.2 -o $(SRC) -lc -l$(LIB) $(SRC).o
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
