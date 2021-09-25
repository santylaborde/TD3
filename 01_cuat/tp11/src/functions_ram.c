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
    // Guarda la suma de los numeros que se ingresan
    dt->sum += decimal; 
    // Aumentam el contador de numeros
    dt->numbers++;   
    // Aumenta el contador de posiciones
    dt->position++;      

    if(dt->position >= SIZE_TABLE)
    {
        digits_table_clear(dt);
    }   
}

 /*Funcion para inicializar la tabla de digitos*/
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

    for(byte i=0; i< dt->size; i++)
    {
        dt->buffer[i]=0;
    }
}

/*Funcion para inicializar la tabla de digitos*/
__attribute__(( section(".functions"))) void digits_table_init(digits_table_struct* dt)
{
    // Vincula la estructura con las direcciones de memoria
    dt->start = (byte*) DIGITS_TABLE_VMA;
    dt->size  = SIZE_TABLE;
    dt->average = 0;
    dt->sum = 0;
    dt->numbers = 0;
    dt->position = 0;

    // Limpiamos la tabla de digitos
    digits_table_clear(dt);
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
    static int i=0;     // Filas
    static int j=0;     // Columnas
    
    for(i=0;i<25;i++)
    {
        for(j=0;j<80;j++)
        {
            sb->matrix[i][j] = 0x1E00;  // Pantalla azul
            //sb->buffer[i][j] = 0x0700;  // Pantalla negra
        }
    }
}

/* Funcion para escribir en el buffer del display */
__attribute__(( section(".functions"))) void screen_print(byte X, byte Y, screen_buffer_struct* sb, char* str)
{
    for(int i=0; str[i] != NULL; i++)
    {
        sb->matrix[Y][X+i] &= 0xFF00;
        sb->matrix[Y][X+i] |= (str[i] & 0xFF);
    }
}

