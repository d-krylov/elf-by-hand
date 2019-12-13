#define BASE  0x40000

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
        .byte      'T'                                  //4  - EI_PAD + 1
        .byte      'A'                                  //5  - EI_PAD + 2
        .byte      'R'                                  //6  - EI_PAD + 3
        .byte      'T'                                  //7  - EI_PAD + 4
        .byte      0x0a                                 //8  - EI_PAD + 5 
        .byte      0x00                                 //9  - EI_PAD + 6

        .set       MESSAGE_SIZE, . - MESSAGE
        
        .word      0x0002                               //e_type
        .word      0x003e                               //e_machine
        .long      0x00000001                           //e_version
        .quad      START                                //e_entry
        .quad      PROGRAM_HEADER_OFFSET                //e_phoff
        .quad      0x0000000000000000                   //e_shoff
        .long      0x00000000                           //e_flags
        .word      ELF_HEADER_SIZE                      //e_ehsize
        .word      PROGRAM_HEADER_SIZE                  //e_phentsize
        .word      0x0003                               //e_phnum
        .word      0x0000                               //e_shentsize
        .word      0x0000                               //e_shnum
        .word      0x0000                               //e_shstrndx

        .set       ELF_HEADER_SIZE,       . - ELF_HEADER
        .set       PROGRAM_HEADER_OFFSET, . - ELF_HEADER
        
PROGRAM_HEADER:

        .long      0x00000001                           //p_type
        .long      0x00000007                           //p_flags
        .quad      0x0000000000000000                   //p_offset
        .quad      BASE                                 //p_vaddr 
        .quad      BASE                                 //p_paddr
        .quad      FILE_SIZE                            //p_filesz 
        .quad      MEMORY_SIZE                          //p_memsz 
        .quad      0x0000000000001000                   //p_align

        .set       PROGRAM_HEADER_SIZE, . - PROGRAM_HEADER 
    
DYNAMIC_HEADER:

        .long      0x00000002                           //p_type
        .long      0x00000006                           //p_flags
        .quad      DYNAMIC_TABLE_OFFSET                 //p_offset
        .quad      DYNAMIC_TABLE_OFFSET + BASE          //p_vaddr
        .quad      DYNAMIC_TABLE_OFFSET + BASE          //p_paddr
        .quad      DYNAMIC_TABLE_SIZE                   //p_filesz  
        .quad      DYNAMIC_TABLE_SIZE                   //p_memsz 
        .quad      0x0000000000000004                   //p_align

        
        
INTERPRETER_HEADER:

        .long      0x00000003                           //p_type
        .long      0x00000004                           //p_flags
        .quad      INTERPRETER_SECTION_OFFSET           //p_offset
        .quad      INTERPRETER_SECTION_OFFSET + BASE    //p_vaddr
        .quad      INTERPRETER_SECTION_OFFSET + BASE    //p_paddr
        .quad      INTERPRETER_SECTION_SIZE             //p_filesz 
        .quad      INTERPRETER_SECTION_SIZE             //p_memsz 
        .quad      0x0000000000000001                   //p_align


        .set       DYNAMIC_TABLE_OFFSET, . - ELF_HEADER

DYNAMIC_TABLE:

        .quad      1,  LIBDL_NAME                       //d_tag = DT_NEEDED
        .quad      4,  HASH_TABLE_OFFSET                //d_tag = DT_HASH
        .quad      5,  STRING_TABLE_OFFSET              //d_tag = DT_STRTAB
        .quad      6,  SYMBOL_TABLE_OFFSET              //d_tag = DT_SYMTAB
        .quad      7,  RELOCATIONS_TABLE_OFFSET         //d_tag = DT_REL
        .quad      8,  RELOCATIONS_TABLE_SIZE           //d_tag = DT_RELSZ
        .quad      9,  24                               //d_tag = DT_RELENT
        .quad      10, STRING_TABLE_SIZE                //d_tag = DT_STRSZ
        .quad      11, SYMBOL_TABLE_SIZE                //d_tag = DT_SYMENT
   
        .quad      0,  0                                //d_tag = DT_NULL

        .set       DYNAMIC_TABLE_SIZE, . - DYNAMIC_TABLE

        .set       HASH_TABLE_OFFSET, . - ELF_HEADER + BASE

HASH_TABLE:

        .long      1                                    //nbucket
        .long      3                                    //nchain
        .long      0                                    //bucket[0]
        .long      0                                    //chain[0]
        .long      0                                    //chain[1]
        .long      0                                    //chain[2]
    
        .set       SYMBOL_TABLE_OFFSET, . - ELF_HEADER + BASE

SYMBOL_TABLE:

        .long      0x00000000                           //
        .byte      0x00 
        .byte      0x00
        .word      0x0000
        .quad      0x0000000000000000
        .quad      0x0000000000000000

        .long      DLOPEN_NAME                          //
        .byte      0x12                                 //STB_GLOBAL and STT_FUNC
        .byte      0x00                                 //
        .word      0x0000                               //
        .quad      0x0000000000000000                   //
        .quad      0x0000000000000000                   //
        
        .long      DLSYM_NAME                           //
        .byte      0x12                                 //STB_GLOBAL and STT_FUNC
        .byte      0x00                                 //
        .word      0x0000                               //
        .quad      0x0000000000000000                   //
        .quad      0x0000000000000000                   //

        .set       SYMBOL_TABLE_SIZE, . - SYMBOL_TABLE 


        .set       RELOCATIONS_TABLE_OFFSET, . - ELF_HEADER + BASE

RELOCATIONS_TABLE:

        .quad      DLOPEN_RELOCATION 
        .quad      0x0000000100000001
        .quad      0x0000000000000000
        
        .quad      DLSYM_RELOCATION 
        .quad      0x0000000200000001
        .quad      0x0000000000000000

        .set       RELOCATIONS_TABLE_SIZE, . - RELOCATIONS_TABLE     
     
        .set       STRING_TABLE_OFFSET, . - ELF_HEADER + BASE
        
STRING_TABLE:

        .set       LIBDL_NAME,   . - STRING_TABLE 
        .string    "libdl.so.2"
        .set       DLOPEN_NAME,  . - STRING_TABLE
        .string    "dlopen"
        .set       DLSYM_NAME,   . - STRING_TABLE
        .string    "dlsym" 

        .set       LIBC_NAME,    . - STRING_NAME     
        .string    "libc.so.6"
        .set       PRINTF_NAME,  . - STRING_TABLE
        .string    "printf"
        .set       STRING_TABLE_SIZE, . - STRING_TABLE
        
        .set       INTERPRETER_SECTION_OFFSET, . - ELF_HEADER

INTERPRETER_SECTION:

        .string    "/lib64/ld-linux-x86-64.so.2"
        .set       INTERPRETER_SECTION_SIZE, . - INTERPRETER_SECTION
     
        .set       START, . - ELF_HEADER + BASE
     
_start:

        movq       $1,%rax          
        movq       $1,%rdi            
        movq       $BASE + MESSAGE_OFFSET, %rsi    
        movq       $MESSAGE_SIZE         , %rdx 
 
        syscall            

        movq       $60, %rax   
        movq       $0,  %rdi   
        syscall
      
       .set        FILE_SIZE,   . - ELF_HEADER
      
       .set        DLOPEN_RELOCATION, . - ELF_HEADER + BASE
       .set        DLSYM_RELOCATION,  . - ELF_HEADER + BASE + 8

       .set        MEMORY_SIZE, . - ELF_HEADER + 64
