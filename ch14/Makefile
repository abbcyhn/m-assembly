SRC := gnome

all:
	as --32 $(SRC).s -o $(SRC).o
	gcc -m32 $(SRC).o `pkg-config --libs --cflags gtk+-3.0` -o $(SRC) 
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