all:
	as --32 prg.s -o prg.o
	as --32 lib_file.s -o lib_file.o
	as --32 lib_convert.s -o lib_convert.o
	ld -m elf_i386 lib_convert.o lib_file.o prg.o -o prg

	clear

clean:
	find . -type f -name '*.o' -delete
	find . -type f -name '*.uppercase' -delete
	find . -type f -executable -delete
	clear

run: 
	./prg prg.s prg.uppercase
	clear