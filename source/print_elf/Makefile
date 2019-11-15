ASM     = as
LD      = ld
CC      = gcc

OBJCOPY = objcopy 
CHMOD   = chmod
RM      = rm

all:    print_32.out print_64.out


print_32.out: print_32.o
	$(OBJCOPY)  -O binary print_32.o print_32.out
	$(CHMOD)    +x print_32.out

print_32.o: print_32.asm
	$(ASM) -a --32 -o print_32.o print_32.asm

print_32.asm: 
	$(CC) -E print_32.S -o print_32.asm

print_64.out: print_64.o
	$(OBJCOPY)  -O binary print_64.o print_64.out
	$(CHMOD)    +x print_64.out

print_64.o: print_64.asm
	$(ASM) -a -o print_64.o print_64.asm

print_64.asm: 
	$(CC) -E print_64.S -o print_64.asm

clean:
	$(RM) -rf *.asm *.o *.out  
