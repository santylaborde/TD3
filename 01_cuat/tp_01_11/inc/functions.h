// Typedef
typedef unsigned char       byte;   // Son 8 bits
typedef unsigned short      word;   // Son 16 bits
typedef unsigned long       dword;  // Son 32 bits
typedef unsigned long long  qword;  // Son 64 bits

// Externs
extern dword RING_BUFFER_VMA;
extern dword DIGITS_TABLE_VMA;
extern dword VIDEO_VMA;
extern dword DPT_KERNEL_VMA;
extern dword START_NEW_PAGES_PHY;

// Defines: General
#define EXITO 0
#define ERROR 1
#define BREAKPOINT __asm__("xchg %bx, %bx")
#define NULL '\0'

// Defines: x86_CR0
#define X86_CR0_PE      0x00000001 /* Protectede mode enable*/
#define X86_CR0_MP      0x00000002 /* Monitor coProcessor*/
#define X86_CR0_EM      0x00000004 /* Emulation*/
#define X86_CR0_TS      0x00000008 /* Task Switched*/
#define X86_CR0_ET      0x00000010 /* Extension Type*/
#define X86_CR0_NE      0x00000020 /* Numeric Error*/
#define X86_CR0_WP      0x00010000 /* Write Protect*/
#define X86_CR0_AM      0x00040000 /* Alignment Mask*/
#define X86_CR0_NW      0x20000000 /* Not Write-through*/
#define X86_CR0_CD      0x40000000 /* Cache Disable*/
#define X86_CR0_PG      0x80000000 /* PaGine*/

// Defines: Keyboard (https://stanislavs.org/helppc/make_codes.html)        
#define KEY_1     0x02
#define KEY_2     0x03
#define KEY_3     0x04
#define KEY_4     0x05
#define KEY_5     0x06
#define KEY_6     0x07
#define KEY_7     0x08
#define KEY_8     0x09
#define KEY_9     0x0A
#define KEY_0     0x0B
#define KEY_ENTER 0x1C
#define SIZE_NUM_MAX 16
#define KEY_F     0x16
#define SIZE_TABLE 4

// Defines: Screen

// Structs
typedef struct time_struct      
{
    byte base;    
    word counter;         
}time_struct;                    

typedef struct ring_buffer_struct  
{	
    byte* head;
	byte* tail;
    byte buffer[SIZE_NUM_MAX];  
    byte size; 
	byte* start;        
    byte* end;           
    byte progress;  
         
}ring_buffer_struct; 

typedef struct digits_table_struct    
{	
    qword buffer[SIZE_TABLE];
    byte* start;        
    byte* end; 
    byte size;
    byte position;
    byte numbers;
    qword sum; 
    qword average;                        
}digits_table_struct; 

typedef struct screen_buffer_struct
{
    word matrix[25][80];
}screen_buffer_struct;

// Prototypes
__attribute__(( section(".functions_rom"))) byte td3_memcopy(const dword *src, dword *dst, dword length);

// Prototypes: Handlers in C
__attribute__(( section(".isr_handler"))) void ISR32_handler_PIT_C(time_struct* tp);
__attribute__(( section(".isr_handler"))) byte ISR33_handler_KEYBOARD_C(ring_buffer_struct* rb, byte key); 
__attribute__(( section(".isr_handler"))) void ISR14_handler_PF_C(dword* ERROR_CODE, dword CR2);

// Prototypes: Operations
__attribute__(( section(".functions"))) dword input_to_decimal(ring_buffer_struct *rb);
__attribute__(( section(".functions"))) dword division_32(dword dividend,byte divisor);
__attribute__(( section(".functions"))) qword division_64(qword dividend,byte divisor);
__attribute__(( section(".functions"))) void itoa(int num, char* str, int base);

// Prototypes: RingBuffer
__attribute__(( section(".functions"))) void ring_buffer_init(ring_buffer_struct* rb);
__attribute__(( section(".functions"))) void ring_buffer_clear(ring_buffer_struct* rb);
__attribute__(( section(".functions"))) void ring_buffer_push(ring_buffer_struct* rb, byte number);
__attribute__(( section(".functions"))) void ring_buffer_align(ring_buffer_struct* rb);

// Prototypes: Digits Table
__attribute__(( section(".functions"))) void ring_buffer_to_digits_table(qword decimal, digits_table_struct* dt);
__attribute__(( section(".functions"))) void digits_table_init(digits_table_struct* dt);
__attribute__(( section(".functions"))) void digits_table_clear(digits_table_struct* dt);

// Prototypes: Screen
__attribute__(( section(".functions"))) void screen_init(screen_buffer_struct* sb);
__attribute__(( section(".functions"))) void screen_print(byte X, byte Y, screen_buffer_struct* sb, char* str);

// Prototypes: Tasks
__attribute__(( section(".functions"))) void scheduler_C(digits_table_struct* dt, time_struct* tp); 
__attribute__(( section(".task01"))) void task_01_C(void);
__attribute__(( section(".task02"))) void task_02_C(void);
__attribute__(( section(".task03"))) void task_03_C(void);
__attribute__(( section(".task04"))) void task_04_C(void);

// Prototypes: Paging
__attribute__((section(".functions"))) dword set_CR3(dword DPT, byte PCD, byte PWT);
__attribute__((section(".functions"))) void set_PDE(dword DPT, word ENTRY, dword PT, byte PS, byte A, byte PCD, byte PWT, byte US, byte RW, byte P);
__attribute__((section(".functions"))) void set_PTE(dword PT, word ENTRY, dword SRC, byte G, byte PAT, byte D, byte A, byte PCD, byte PWT, byte US, byte RW, byte P);
