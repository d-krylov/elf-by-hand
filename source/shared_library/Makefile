ASM     = as
LD      = ld
CC      = gcc

OBJCOPY = objcopy 
CHMOD   = chmod
RM      = rm

all:    libsumm.so 


test.o: test.c
	$(CC) -c test.c

libsumm.so: summ_64.asm.o 
	$(OBJCOPY)  -O binary summ_64.asm.o libsumm.so

summ_64.asm.o: summ_64.asm
	$(ASM) -a -o summ_64.asm.o summ_64.asm

summ_64.asm: 
	$(CC) -E summ_64.S -o summ_64.asm

clean:
	$(RM) -rf *.asm *.o *.out *.so
