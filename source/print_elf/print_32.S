#define BASE  0x40000

.code32

.section   ".header","a"

ELF_HEADER:
         
                                                        // e_ident - 16 bytes
        .byte      0x7F
        .byte      'E'
        .byte      'L'
        .byte      'F'
        .byte      0x01                                 //32-bit objects
        .byte      0x01                                 //Little endian
        .byte      0x01                                 //Version

        .set       MESSAGE_OFFSET, . - ELF_HEADER
        
MESSAGE:
        .byte      'P'                                  //1  - EI_PAD
        .byte      'R'                                  //2  - EI_PAD + 1
        .byte      'I'                                  //3  - EI_PAD + 2
        .byte      'N'                                  //4  - EI_PAD + 3
        .byte      'T'                                  //5  - EI_PAD + 4
        .byte      'E'                                  //6  - EI_PAD + 5
        .byte      'R'                                  //7  - EI_PAD + 6
        .byte      0x0a                                 //8  - EI_PAD + 7 
        .byte      0x00                                 //9  - EI_PAD + 8

        .set       MESSAGE_SIZE, . - MESSAGE

        .word      0x0002                               //e_type
        .word      0x0003                               //e_machine
        .long      0x00000001                           //e_version
        .long      START                                //e_entry
        .long      PROGRAM_HEADER_OFFSET                //e_phoff
        .long      0x00000000                           //e_shoff
        .long      0x00000000                           //e_flags
        .word      ELF_HEADER_SIZE                      //e_ehsize
        .word      PROGRAM_HEADER_SIZE                  //e_phentsize
        .word      0x0003                               //e_phnum

        .set       ELF_HEADER_SIZE,       . - ELF_HEADER
        .set       PROGRAM_HEADER_OFFSET, . - ELF_HEADER

PROGRAM_HEADER:

        .long      0x00000001                           //p_type
        .long      0x00000000                           //p_offset
        .long      BASE                                 //p_vaddr 
        .long      BASE                                 //p_paddr
        .long      FILE_SIZE                            //p_filesz 
        .long      MEMORY_SIZE                          //p_memsz 
        .long      0x00000007                           //p_flags
        .long      0x00001000                           //p_align

        .set       PROGRAM_HEADER_SIZE, . - PROGRAM_HEADER 
      
DYNAMIC_HEADER:

        .long      0x00000002                           //p_type
        .long      DYNAMIC_TABLE_OFFSET                 //p_offset
        .long      DYNAMIC_TABLE_OFFSET + BASE          //p_vaddr
        .long      DYNAMIC_TABLE_OFFSET + BASE          //p_paddr
        .long      DYNAMIC_TABLE_SIZE                   //p_filesz  
        .long      DYNAMIC_TABLE_SIZE                   //p_memsz 
        .long      0x00000006                           //p_flags
        .long      0x00000004                           //p_align

       
INTERPRETER_HEADER:

        .long      0x00000003                           //p_type
        .long      INTERPRETER_SECTION_OFFSET           //p_offset
        .long      INTERPRETER_SECTION_OFFSET + BASE    //p_vaddr
        .long      INTERPRETER_SECTION_OFFSET + BASE    //p_paddr
        .long      INTERPRETER_SECTION_SIZE             //p_filesz 
        .long      INTERPRETER_SECTION_SIZE             //p_memsz 
        .long      0x00000004                           //p_flags
        .long      0x00000001                           //p_align


        .set       DYNAMIC_TABLE_OFFSET, . - ELF_HEADER

DYNAMIC_TABLE:

        .long      1,  LIBC_NAME                        //d_tag = DT_NEEDED
        .long      4,  HASH_TABLE_OFFSET                //d_tag = DT_HASH
        .long      5,  STRING_TABLE_OFFSET              //d_tag = DT_STRTAB
        .long      6,  SYMBOL_TABLE_OFFSET              //d_tag = DT_SYMTAB
        .long      10, STRING_TABLE_SIZE                //d_tag = DT_STRSZ
        .long      11, SYMBOL_TABLE_SIZE                //d_tag = DT_SYMENT
        .long      17, RELOCATIONS_TABLE_OFFSET         //d_tag = DT_REL
        .long      18, RELOCATIONS_TABLE_SIZE           //d_tag = DT_RELSZ
        .long      19, 8                                //d_tag = DT_RELENT
        .long      0,  0                                //d_tag = DT_NULL

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

        .long      0x00000000                           //st_name
        .long      0x00000000                           //st_value
        .long      0x00000000                           //st_size
        .byte      0x00                                 //st_info
        .byte      0x00
        .word      0x0000

        .long      PRINTF_NAME                          //st_name
        .long      0x00000000                           //
        .long      0x00000000      
        .byte      0x12                                 //st_info - STB_GLOBAL and STT_FUNC
        .byte      0x00                                 //                  
        .word      0x0000                               //

        .set       SYMBOL_TABLE_SIZE, . - SYMBOL_TABLE 

        .set       RELOCATIONS_TABLE_OFFSET, . - ELF_HEADER + BASE

RELOCATIONS_TABLE:

        .long      PRINTF_RELOCATION 
        .long      0x00000101

        .set       RELOCATIONS_TABLE_SIZE, . - RELOCATIONS_TABLE   

        .set       STRING_TABLE_OFFSET, . - ELF_HEADER + BASE
        
STRING_TABLE:

        .set       LIBC_NAME,   . - STRING_TABLE 
        .string    "libc.so.6"
        .set       PRINTF_NAME, . - STRING_TABLE
        .string    "printf"

        .set       STRING_TABLE_SIZE, . - STRING_TABLE

        .set       INTERPRETER_SECTION_OFFSET, . - ELF_HEADER

INTERPRETER_SECTION:

        .string    "/lib/ld-linux.so.2"
        .set       INTERPRETER_SECTION_SIZE, . - INTERPRETER_SECTION
     
        .set       START, . - ELF_HEADER + BASE

_start:
      
         xor       %eax,%eax
         push      $BASE + MESSAGE_OFFSET
         mov       PRINTF_RELOCATION(%eax),%ebx
         call      *%ebx         

         mov       $1,%eax            
         int       $0x80                

        .set       FILE_SIZE,   . - ELF_HEADER
       
        .set       PRINTF_RELOCATION, . - ELF_HEADER + BASE

        .set       MEMORY_SIZE, . - ELF_HEADER + 8
 
