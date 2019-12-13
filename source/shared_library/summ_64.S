#define BASE   (0x200000)

.code64

.section   ".header","a"

ELF_HEADER:

        .byte      0x7F
        .byte      'E'
        .byte      'L'
        .byte      'F'
        .byte      0x02                                 //64-bit objects 
        .byte      0x01                                 //Little endian
        .byte      0x01                                 //Version

        .byte      0x00                                 //1  - UNIX System V ABI 
        .byte      0x00                                 //2  - ABI Version
        
        
        .set       MESSAGE_OFFSET, . - ELF_HEADER

MESSAGE:
        .byte      'S'                                  //3  - EI_PAD
        .byte      'H'                                  //4  - EI_PAD + 1
        .byte      'A'                                  //5  - EI_PAD + 2
        .byte      'R'                                  //6  - EI_PAD + 3
        .byte      'E'                                  //7  - EI_PAD + 4
        .byte      0x0a                                 //8  - EI_PAD + 5 
        .byte      0x00                                 //9  - EI_PAD + 6

        .set       MESSAGE_SIZE, . - MESSAGE

        .word      0x0003                               //e_type - ET_DYN
        .word      0x003e                               //e_machine
        .long      0x00000001                           //e_version
        .quad      SUMMA                                //e_entry
        .quad      PROGRAM_HEADER_OFFSET                //e_phoff
        .quad      0x0000000000000000                   //e_shoff
        .long      0x00000000                           //e_flags
        .word      ELF_HEADER_SIZE                      //e_ehsize
        .word      PROGRAM_HEADER_SIZE                  //e_phentsize
        .word      0x0003                               //e_phnum

        .set       ELF_HEADER_SIZE,       . - ELF_HEADER
        .set       PROGRAM_HEADER_OFFSET, . - ELF_HEADER


PROGRAM_HEADER_1:

        .long      0x00000001                           //p_type
        .long      0x00000005                           //p_flags
        .quad      0x0000000000000000                   //p_offset
        .quad      0x0000000000000000                   //p_vaddr 
        .quad      0x0000000000000000                   //p_paddr
        .quad      FILE_SIZE                            //p_filesz 
        .quad      MEMORY_SIZE                          //p_memsz 
        .quad      BASE                                 //p_align

        .set       PROGRAM_HEADER_SIZE, . - PROGRAM_HEADER_1 

PROGRAM_HEADER_2:

        .long      0x00000001                           //p_type
        .long      0x00000006                           //p_flags
        .quad      0x0000000000000000                   //p_offset
        .quad      BASE                                 //p_vaddr 
        .quad      BASE                                 //p_paddr
        .quad      FILE_SIZE                            //p_filesz 
        .quad      MEMORY_SIZE                          //p_memsz 
        .quad      BASE                                 //p_align

DYNAMIC_HEADER:

        .long      0x00000002                           //p_type
        .long      0x00000006                           //p_flags
        .quad      0x0000000000000000                   //p_offset
        .quad      BASE                                 //p_vaddr 
        .quad      BASE                                 //p_paddr
        .quad      FILE_SIZE                            //p_filesz 
        .quad      MEMORY_SIZE                          //p_memsz 
        .quad      0x8                                  //p_align

        .set       DYNAMIC_TABLE_OFFSET, . - ELF_HEADER

DYNAMIC_TABLE:

        .quad      5,  STRING_TABLE_OFFSET              //d_tag = DT_STRTAB
        .quad      6,  SYMBOL_TABLE_OFFSET              //d_tag = DT_SYMTAB
        .quad      10, STRING_TABLE_SIZE                //d_tag = DT_STRSZ
        .quad      11, SYMBOL_TABLE_SIZE                //d_tag = DT_SYMENT
        .quad      0,  0                                //d_tag = DT_NULL


        .set       SYMBOL_TABLE_OFFSET, . - ELF_HEADER

SYMBOL_TABLE:

        .long      0x00000000                           //
        .byte      0x00 
        .byte      0x00
        .word      0x0000
        .quad      0x0000000000000000
        .quad      0x0000000000000000

        .long      SUMMA_NAME                           //
        .byte      0x12                                 //STB_GLOBAL and STT_FUNC
        .byte      0x00                                 //
        .word      0x0000                               //
        .quad      0x0000000000000000                   //
        .quad      0x0000000000000000                   //

        .set       SYMBOL_TABLE_SIZE, . - SYMBOL_TABLE 

        .set       STRING_TABLE_OFFSET, . - ELF_HEADER

STRING_TABLE:

        .set       SUMMA_NAME, . - STRING_TABLE 

        .string    "summa"
    
        .set       STRING_TABLE_SIZE, . - STRING_TABLE
        

        .set       SUMMA, . - ELF_HEADER

summa:

        push       %rbp
        mov        %rsp,%rbp
        mov        %rdi,-0x8(%rbp)
        mov        %rsi,-0x10(%rbp)
        mov        -0x8(%rbp),%rdx
 	mov        -0x10(%rbp),%rax
 	add        %rdx,%rax
        pop        %rbp
        retq   


        .set       FILE_SIZE,   . - ELF_HEADER
        .set       MEMORY_SIZE, . - ELF_HEADER 