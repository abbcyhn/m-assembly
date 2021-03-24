all:
	as --32 record-lib.s -o record-lib.o
	as --32 records-write.s -o records-write.o
	ld -m elf_i386 records-write.o record-lib.o -o prg-write

	as --32 records-read.s -o records-read.o
	ld -m elf_i386 records-read.o record-lib.o -o prg-read

	as --32 records-modify.s -o records-modify.o
	ld -m elf_i386 records-modify.o record-lib.o -o prg-modify

	clear

clean:
	find . -type f -name '*.o' -delete
	find . -type f -name '*.dat' -delete
	find . -type f -executable -delete
	clear

read: 
	./prg-read

write: 
	./prg-write

modify:
	./prg-modify
