ASM     = as
LD      = ld
CC      = gcc

OBJCOPY = objcopy 
CHMOD   = chmod
RM      = rm

all:     micro_32.out micro_64.out

micro_32.out: micro_32.o
	$(OBJCOPY)  -O binary micro_32.o micro_32.out
	$(CHMOD)    +x micro_32.out

micro_32.o: micro_32.asm
	$(ASM) -a --32 -o micro_32.o micro_32.asm

micro_32.asm: 
	$(CC) -E micro_32.S -o micro_32.asm

micro_64.out: micro_64.o
	$(OBJCOPY)  -O binary micro_64.o micro_64.out
	$(CHMOD)    +x micro_64.out

micro_64.o: micro_64.asm
	$(ASM) -a --64 -o micro_64.o micro_64.asm

micro_64.asm: 
	$(CC) -E micro_64.S -o micro_64.asm


clean:
	$(RM) -rf *.asm *.o *.out  
