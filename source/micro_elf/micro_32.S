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
        .byte      'M'                                  //1  - EI_PAD
        .byte      'E'                                  //2  - EI_PAD + 1
        .byte      'S'                                  //3  - EI_PAD + 2
        .byte      'S'                                  //4  - EI_PAD + 3
        .byte      'A'                                  //5  - EI_PAD + 4
        .byte      'G'                                  //6  - EI_PAD + 5
        .byte      'E'                                  //7  - EI_PAD + 6
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
        .word      0x0001                               //e_phnum

        .set       ELF_HEADER_SIZE,       . - ELF_HEADER
        .set       PROGRAM_HEADER_OFFSET, . - ELF_HEADER

PROGRAM_HEADER:

        .long      0x00000001                           //p_type
        .long      0x00000000                           //p_offset
        .long      BASE                                 //p_vaddr 
        .long      BASE                                 //p_paddr
        .long      FILE_SIZE                            //p_filesz 
        .long      MEMORY_SIZE                          //p_memsz 
        .long      0x00000007
        .long      0x00001000                           //p_align

        .set       PROGRAM_HEADER_SIZE, . - PROGRAM_HEADER 
      
        .set       START, . - ELF_HEADER + BASE


_start:
      
         mov     $MESSAGE_SIZE,%edx                         
         mov     $BASE + MESSAGE_OFFSET,%ecx                           
         mov     $1,%ebx                         
         mov     $4,%eax                           
         int     $0x80                           

         mov     $1,%eax            
         int     $0x80                




        .set        FILE_SIZE,   . - ELF_HEADER
        .set        MEMORY_SIZE, . - ELF_HEADER
 
