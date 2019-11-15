ASM     = as
LD      = ld
CC      = gcc

OBJCOPY = objcopy 
CHMOD   = chmod
RM      = rm

all:    dynamic_32.out dynamic_64.out

dynamic_64.out: dynamic_64.o
	$(OBJCOPY)  -O binary dynamic_64.o dynamic_64.out
	$(CHMOD)    +x dynamic_64.out

dynamic_64.o: dynamic_64.asm
	$(ASM) -a --64 -o dynamic_64.o dynamic_64.asm

dynamic_64.asm: 
	$(CC) -E dynamic_64.S -o dynamic_64.asm


dynamic_32.out: dynamic_32.o
	$(OBJCOPY)  -O binary dynamic_32.o dynamic_32.out
	$(CHMOD)    +x dynamic_32.out

dynamic_32.o: dynamic_32.asm
	$(ASM) -a --32 -o dynamic_32.o dynamic_32.asm

dynamic_32.asm: 
	$(CC) -E dynamic_32.S -o dynamic_32.asm

clean:
	$(RM) -rf *.asm *.o *.out  
