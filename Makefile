# reguła linkowania
hello: hello.o
	ld -m elf_i386 -o hello hello.o

# reguła kompilacji
hello.o: hello.s
	as --32 -o hello.o hello.s

run: ./hello

