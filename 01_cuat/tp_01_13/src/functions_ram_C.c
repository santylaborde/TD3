#include "../inc/functions.h"

// *****************************************************************************************
// ************************ RUTINAS DEL TECLADO EN C ***************************************
// *****************************************************************************************
/* Funcion para inicializar el ring buffer de teclado */
__attribute__(( section(".functions"))) void ring_buffer_init(ring_buffer_struct* rb)
{
    // Vincula la estructura con las direcciones de memoria
    rb->start = (byte*) RING_BUFFER_VMA;
    rb->size  = SIZE_NUM_MAX;

    // Limpiamos el ring buffer
    ring_buffer_clear(rb);
}

/* Funcion para limpiar el ring buffer de teclado */
__attribute__(( section(".functions"))) void ring_buffer_clear(ring_buffer_struct* rb)
{
    rb->progress= 0;
    rb->head= rb->start;    // Esta bien esto?
    rb->tail= rb->end;      // Esta bien esto?

    for(int i=0; i< rb->size; i++)
    {
        rb->buffer[i] = 0;
    }
}

/* Funcion para pasar del ring buffer al tabla de digitos */
__attribute__(( section(".functions"))) void ring_buffer_to_digits_table(qword decimal, digits_table_struct* dt)
{  
    // Guarda el decimal en la tabla
    dt->buffer[dt->position] = decimal;
    // Aumentam el contador de numeros
    dt->numbers++;   
    // Aumenta el contador de posiciones
    dt->position++;      

    if(dt->position >= SIZE_TABLE)
    {
        dt->position = 0;
        //digits_table_clear(dt);
    }   
}

 /*Funcion para alinear el ringbuffer*/
__attribute__(( section(".functions"))) void ring_buffer_align(ring_buffer_struct* rb)
{
    // Para pasar de 12340000h a 00001234h
    byte zeros = rb->size - rb->progress;   // ceros que estan a la derecha del numero
    if(!zeros)
        return;

    for(int i=0; zeros < rb->size ; i++, zeros++)
    {
        rb->buffer[zeros]= rb->buffer[i];
        rb->buffer[i]= 0;
    }   
}

/*Funcion para inicializar la tabla de digitos*/
__attribute__(( section(".functions"))) void digits_table_clear(digits_table_struct* dt)
{
    dt->position = 0;

    for(byte i=0; i< SIZE_TABLE; i++)
    {
        dt->buffer[i]=0;
    }
}

/*Funcion para inicializar la tabla de digitos*/
__attribute__(( section(".functions"))) void digits_table_init(digits_table_struct* dt)
{
    // Limpiamos la tabla de digitos
    digits_table_clear(dt);

    dt->average = 0;
    dt->sum = 0;
    dt->numbers = 0;
    dt->position = 0;
}

// *****************************************************************************************
// ***************** RUTINAS PARA MANEJO DE DATOS EN C *************************************
// *****************************************************************************************

/* Función para pasar la entrada a valor decimal */
__attribute__(( section(".functions"))) dword input_to_decimal(ring_buffer_struct *rb)
{
    qword decimal = 0;
    int k = 1;

    for(int i= rb->size-1; i>= 0; i--)
    {
        decimal += rb->buffer[i]*k;
        k= k*10;
    }

    return decimal;
}

/* Función para dividir un numero decimal de 32 bits */
__attribute__(( section(".functions"))) dword division_32(dword dividend,byte divisor)
{
    qword quotient = 0;

    while(dividend> 0 &&  divisor> 0 && dividend >= divisor)
    {
        quotient++;
        dividend -= divisor;
    }

    return quotient;
}

/* Función para dividir un numero decimal de 64 bits */
__attribute__(( section(".functions"))) qword division_64(qword dividend,byte divisor)
{    
    qword quotient= 0x0000000000000000;
    qword aux= 0x0000000000000000; 

    for(byte i=0; i<64; i++)
    {
        aux= aux | ((dividend >> (64-1-i) ) & (0x01));
        if(aux >= divisor)
        {
            quotient= quotient|0x1;            
            aux-= divisor;
        }
        
        quotient= quotient<<1;
        aux= aux<<1;
    }

    quotient= quotient>>1;
    return quotient;
}

/* Función para pasar de entero a ASCII para imprimir*/
/* https://www.geeksforgeeks.org/implement-itoa/ */
__attribute__(( section(".functions"))) void itoa(int num, char* str, int base)
{
    int i = 0;
  
    // Process individual digits
    while (num != 0)
    {
        int rem = num % base;
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0';
        num = num/base;
    }
  
    // Append string terminator
    str[i] = '\0'; 
  
    // Reverse the string
    int start = 0;
    int end = i-1;
    while (start < end)
    {
        char *temp = *(str+start);
        *(str+start) = *(str+end);
        *(str+end) = temp;
        start++;
        end--;
    }
}

// *****************************************************************************************
// ************************ RUTINAS PARA MANEJO DEL DISPLAY EN C ***************************
// *****************************************************************************************
/* Función para inicializar buffer del display */
__attribute__(( section(".functions"))) void screen_init(screen_buffer_struct *sb)
{
    for(byte i=0;i<25;i++)  // Filas
    {
        for(byte j=0;j<80;j++)  // Columnas
        {
            sb->matrix[i][j] = 0x1E00;  // Pantalla azul
            //sb->buffer[i][j] = 0x0700;  // Pantalla negra
        }
    }
}

/* Funcion para escribir en el buffer del display */
__attribute__(( section(".functions"))) void screen_print(byte X, byte Y, char* str)
{
    screen_buffer_struct* sb = (screen_buffer_struct*) &VIDEO_VMA;
    
    for(byte i=0; str[i] != NULL; i++)
    {
        if(X >= 80)
        {
            X = 0;
            Y++;
            if (Y >= 25)    
                break;  
        }

        sb->matrix[Y][X] &= 0xFF00;
        sb->matrix[Y][X] |= (str[i] & 0xFF);
        X++;
    }
}

// *****************************************************************************************
// *************************** RUTINAS PARA PAGINACION EN C ********************************
// *****************************************************************************************
/* Función para setear el registro CR3 a partir del DPT */
__attribute__((section(".functions"))) dword set_CR3(dword DPT, byte PCD, byte PWT)
{
    dword CR3 = 0;

//  Se queda con todos los bits excepto los 3 menos significativos (OFFSET)
    CR3 |= (DPT & 0xFFFFF000);      // Direccion fisica del directorio de tablas de paginas
//  Setea los atributos de CR3
    CR3 |= (PCD << 4);              // BIT 4: Page Level Cache Disable
    CR3 |= (PWT << 3);              // BIT 3: Page Level Write Through

    return CR3;
}

/* Función para agregar una ENTRY al DPT */
__attribute__((section(".functions"))) void set_PDE(dword DPT, word ENTRY, dword PT, byte PS, byte A, byte PCD, byte PWT, byte US, byte RW, byte P)
{
    dword PDE = 0;                  // Page directory entry
    dword* dst = (dword*) DPT;

    //  Se queda con todos los bits excepto los 3 menos significativos (OFFSET)
    PDE |= (PT & 0xFFFFF000);      // Direccion fisica de la tabla de paginas
    //  Setea los atributos de la PDE
    PDE |= (PS << 7);               // BIT 7: Page size
    PDE |= (0 << 6);                // BIT 6: IGNORE
    PDE |= (A << 5);                // BIT 5: Accessed
    PDE |= (PCD << 4);              // BIT 4: Page Level Cache Disable
    PDE |= (PWT << 3);              // BIT 3: Page Level Write Through
    PDE |= (US << 2);               // BIT 2: User or Supervisor
    PDE |= (RW << 1);               // BIT 1: Read and Writeable
    PDE |= (P << 0);                // BIT 0: Presence

    *(dst+ENTRY)= PDE;              // Guardamos el descriptor del DPT
}

/* Función para agregar una ENTRY a la PT */
__attribute__((section(".functions"))) void set_PTE(dword PT, word ENTRY, dword SRC, byte G, byte PAT, byte D, byte A, byte PCD, byte PWT, byte US, byte RW, byte P)
{
    dword PTE = 0;                  // Page table entry
    dword* dst = (dword*) PT;

//  Se queda con todos los bits excepto los 3 menos significativos (OFFSET)
    PTE |= (SRC & 0xFFFFF000);      // Direccion fisica de la tabla de paginas
//  Setea los atributos de la PTE
    PTE |= (0 << 11);               // BIT 11: IGNORE
    PTE |= (0 << 10);               // BIT 10: IGNORE
    PTE |= (0 << 9);                // BIT 9:  IGNORE
    PTE |= (G << 8);                // BIT 8:  Global
    PTE |= (PAT << 7);              // BIT 7:  Page table attribute
    PTE |= (D << 6);                // BIT 6:  Dirty
    PTE |= (A << 5);                // BIT 5:  Accessed
    PTE |= (PCD << 4);              // BIT 4:  Page Level Cache Disable
    PTE |= (PWT << 3);              // BIT 3:  Page Level Write Through
    PTE |= (US << 2);               // BIT 2:  User or Supervisor
    PTE |= (RW << 1);               // BIT 1:  Read and Writeable
    PTE |= (P << 0);                // BIT 0:  Presence

    *(dst+ENTRY)= PTE;              // Guardamos el descriptor de la PT
}