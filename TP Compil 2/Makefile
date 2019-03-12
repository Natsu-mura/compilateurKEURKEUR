NASM = nasm -f elf -g -F dwarf
LD = ld -m elf_i386


all: fp

fp.asm: io.asm
	$(NASM) $<




.PHONY : clean

clean:
	- rm -f $(OBJ)
	- rm -f *.o
