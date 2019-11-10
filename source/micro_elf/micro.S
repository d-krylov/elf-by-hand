#define BASE  0x40000

.code64

.section   ".header","a"

ELF_HEADER:

        .byte      0x7F
        .byte      'E'
        .byte      'L'
        .byte      'F'
        .byte      0x02                         //64-bit objects 
        .byte      0x01                         //Little endian
        .byte      0x01                         //Version

        .byte      0x00                         //1  - UNIX System V ABI 
        .byte      0x00                         //2  - ABI Version
        
        
        .set       MESSAGE_OFFSET, . - ELF_HEADER
        
MESSAGE:
        .byte      'H'                          //3  - EI_PAD
        .byte      'E'                          //4  - EI_PAD + 1
        .byte      'L'                          //5  - EI_PAD + 2
        .byte      'L'                          //6  - EI_PAD + 3
        .byte      'O'                          //7  - EI_PAD + 4
        .byte      0x0a                         //8  - EI_PAD + 5 
        .byte      0x00                         //9  - EI_PAD + 6

        .set       MESSAGE_SIZE, . - MESSAGE
        
        .word      0x0002                       //e_type
        .word      0x003e                       //e_machine
        .long      0x00000001                   //e_version
        .quad      START                        //e_entry
        .quad      PROGRAM_HEADER_OFFSET        //e_phoff
        .quad      0x0000000000000000           //e_shoff
        .long      0x00000000                   //e_flags
        .word      ELF_HEADER_SIZE              //e_ehsize
        .word      PROGRAM_HEADER_SIZE          //e_phentsize
        .word      0x0001                       //e_phnum
        .word      0x0000                       //e_shentsize
        .word      0x0000                       //e_shnum
        .word      0x0000                       //e_shstrndx

        .set       ELF_HEADER_SIZE,       . - ELF_HEADER
        .set       PROGRAM_HEADER_OFFSET, . - ELF_HEADER
        
PROGRAM_HEADER:

        .long      0x00000001                   //p_type
        .long      0x00000007                   //p_flags
        .quad      0x0000000000000000           //p_offset
        .quad      BASE                         //p_vaddr 
        .quad      BASE                         //p_paddr
        .quad      FILE_SIZE                    //p_filesz 
        .quad      MEMORY_SIZE                  //p_memsz 
        .quad      0x0000000000001000           //p_align

        .set       PROGRAM_HEADER_SIZE, . - PROGRAM_HEADER 
        
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
       .set        MEMORY_SIZE, . - ELF_HEADER
 
