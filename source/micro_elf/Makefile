ASM     = as
LD      = ld
CC      = gcc

OBJCOPY = objcopy 
CHMOD   = chmod
RM      = rm

all:     micro.out

micro.out: micro.o
	$(OBJCOPY)  -O binary micro.o micro.out
	$(CHMOD)    +x micro.out

micro.o: micro.asm
	$(ASM) -a --64 -o micro.o micro.asm

micro.asm: 
	$(CC) -E micro.S -o micro.asm

clean:
	$(RM) -rf *.asm *.o *.out  
