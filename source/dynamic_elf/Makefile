ASM     = as
LD      = ld
CC      = gcc

OBJCOPY = objcopy 
CHMOD   = chmod
RM      = rm

all:    dynamic.out

dynamic.out: dynamic.o
	$(OBJCOPY)  -O binary dynamic.o dynamic.out
	$(CHMOD)    +x dynamic.out

dynamic.o: dynamic.asm
	$(ASM) -a --64 -o dynamic.o dynamic.asm

dynamic.asm: 
	$(CC) -E dynamic.S -o dynamic.asm

clean:
	$(RM) -rf *.asm *.o *.out  
