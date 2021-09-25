// ************* RUTINAS DE ATENCION DE INTERRUPCIONES EN C ***************************

#include "../inc/funciones.h"

/* Handler del PIT */
__attribute__(( section(".functions"))) void ISR32_handler_PIT_C(tiempos* tp) 
{
    tp->base++;
    if(tp->base>=10)    // 100ms
        BREAKPOINT;
}

//Head and Tail(Read)
//if(Head==Tail) reiniciaciamos los indices
/* Handler del Keyboard */
__attribute__(( section(".functions"))) byte ISR33_handler_KEYBOARD_C(ring_buffer_struct* rb, byte key) 
{
    // Valida el tamaño del número acumulado (64 bits = 16 teclas)
    if (rb->progress < rb->size)
    {
        // Valida tecla (dígitos numéricos y el retorno de carro)
        if(key == KEY_ENTER || (key >= KEY_1 && key <= KEY_0))
        {
            switch (key)
            {
                case KEY_0:
                    rb->buffer[rb->progress]= 0x00;
                    rb->progress++;
                    break;
                    
                case KEY_1:
                    rb->buffer[rb->progress]= 0x01;
                    rb->progress++;
                    break;
                    
                case KEY_2:
                    rb->buffer[rb->progress]= 0x02;
                    rb->progress++;
                    break;
                    
                case KEY_3:
                    rb->buffer[rb->progress]= 0x03;
                    rb->progress++;
                    break;
                    
                case KEY_4:
                    rb->buffer[rb->progress]= 0x04;
                    rb->progress++;
                    break;
                    
                case KEY_5:
                    rb->buffer[rb->progress]= 0x05;
                    rb->progress++;
                    break;
                    
                case KEY_6:
                    rb->buffer[rb->progress]= 0x06;
                    rb->progress++;
                    break;
                    
                case KEY_7:
                    rb->buffer[rb->progress]= 0x07;
                    rb->progress++;
                    break;
                    
                case KEY_8:
                    rb->buffer[rb->progress]= 0x08;
                    rb->progress++;
                    break;

                case KEY_9:
                    rb->buffer[rb->progress]= 0x09;
                    rb->progress++;
                    break;

                case KEY_ENTER:
                    //ring_buffer_to_digits_table(rb, dt);  // Aca lo cargamos agregando 0s a la izquierda
                    td3_memcopy((dword*)rb->buffer,(dword*)&DIGITS_TABLE,(dword*)rb->size);
                    ring_buffer_clear(rb);    
                    break;

                default:
                    break;
            }    
        }
        else
        {
            return ERROR;
        }
    }
    else
    {
        td3_memcopy((dword*)rb->buffer,(dword*)&DIGITS_TABLE,(dword)rb->size);  // Aca lo cargamos sin agregar 0s a la izquierda
        ring_buffer_clear(rb);
    }
}

__attribute__(( section(".functions"))) void ring_buffer_init(ring_buffer_struct* rb)
{
    // Vincula la estructura con las direcciones de memoria
    rb->start = (byte*) RING_BUFFER;
    rb->size  = SIZE_NUM_MAX;

    // inicializamos los campos
    rb->progress = 0;
    rb->head = (byte*) rb->buffer[0];
    rb->tail = (byte*) rb->buffer[SIZE_NUM_MAX];

    // Limpiamos el ring buffer
    ring_buffer_clear(rb);
}

/* Funcion para limpiar el ring buffer de teclado */
__attribute__(( section(".functions"))) void ring_buffer_clear(ring_buffer_struct* rb)
{
    static int i=0;         // Hace falta? i no tenria que ser un char?
    rb->progress= 0;
    rb->head= rb->start;    // Esta bien esto?
    rb->tail= rb->end;      // Esta bien esto?

    for(i=0; i< rb->size; i++)
    {
        rb->buffer[i] = 0;
    }
}

/* Funcion para pasar del ring buffer al tabla de digitos */
__attribute__(( section(".functions"))) void ring_buffer_to_digits_table(ring_buffer_struct* rb, digits_table_struct* dt)
{
    /*
    for(int i=0; i< rb->size; i++)
    {
        dt->buffer[i] = rb->buffer[i];    
    }    

    if(dt->position >= dt->size)
        dt->position = 0;
        */

}

/*Funcion para inicializar la tabla de digitos*/
__attribute__(( section(".functions"))) void digits_table_clear(digits_table_struct* dt)
{
    static int i=0;

    for(i=0; i< dt->size; i++)
    {
        dt->buffer[i]=0x00;
    }
}

/*Funcion para inicializar la tabla de digitos*/
__attribute__(( section(".functions"))) void digits_table_init(digits_table_struct* dt)
{
    /*
    // Vincula la estructura con las direcciones de memoria
    dt->start = (digits_table_struct*) &digits_table;
    
    // inicializamos los campos
    dt->position = 0;

    // Limpiamos el ring buffer
    digits_table_clear(dt);
    */
    
}


 