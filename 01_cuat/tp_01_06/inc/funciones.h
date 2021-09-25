// Typedef
typedef unsigned char   byte;   // Son 8 bits
typedef unsigned short  word;   // Son 16 bits
typedef unsigned int   dword;  // Son 32 bits
typedef unsigned long  qword;  // Son 64 bits

// Externs
//extern dword RING_BUFFER_V;
//extern dword RING_BUFFER_END;	
//extern dword RING_BUFFER_SIZE; 
extern dword RING_BUFFER;
//extern dword DIGIT_TABLE_VMA;
//extern dword DIGITS_TABLE_END;
//extern dword DIGITS_TABLE_SIZE;
extern dword DIGITS_TABLE;

// Defines: General
#define EXITO 0
#define ERROR 1
#define BREAKPOINT __asm__("xchg %bx, %bx")

// Defines: Keyboard  (https://stanislavs.org/helppc/make_codes.html)        
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

// Structs
typedef struct tiempos      
{
    byte base;             
    word counter;
}tiempos;                    

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
    byte buffer[SIZE_NUM_MAX];
    byte* start;        
    byte* end; 
    byte size;
    byte position;                         
}digits_table_struct; 

// Prototypes
__attribute__(( section(".functions_rom"))) byte td3_memcopy(const dword *src, dword *dst, dword length);

// Prototypes: Handlers in C
__attribute__(( section(".functions"))) void ISR32_handler_PIT_C(tiempos* tp);
__attribute__(( section(".functions"))) byte ISR33_handler_KEYBOARD_C(ring_buffer_struct* rb, byte key); 

// Prototypes: RingBuffer
__attribute__(( section(".functions"))) void ring_buffer_init(ring_buffer_struct* rb);
__attribute__(( section(".functions"))) void ring_buffer_clear(ring_buffer_struct* rb);
__attribute__(( section(".functions"))) void ring_buffer_push(ring_buffer_struct* rb, byte number);
__attribute__(( section(".functions"))) void ring_buffer_to_digits_table(ring_buffer_struct* rb, digits_table_struct* dt);

// Prototypes: Digits Table
__attribute__(( section(".functions"))) void digits_table_init(digits_table_struct* dt);
__attribute__(( section(".functions"))) void digits_table_clear(digits_table_struct* dt);
