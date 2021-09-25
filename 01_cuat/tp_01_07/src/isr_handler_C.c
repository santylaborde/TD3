#include "../inc/funciones.h"

// *****************************************************************************************
// ************* RUTINA DE ATENCION DE INTERRUPCION DEL PIT EN C ***************************
// *****************************************************************************************

/* Handler del PIT */
__attribute__(( section(".functions"))) void ISR32_handler_PIT_C(time_struct* tp) 
{
    tp->base++;
    if(tp->base>=10)    // 100ms
    {
        tp->base>=0;    // Reiniciamos el timer
        tp->counter++;  // Aumentamos el contador de 100ms
    }
}

// *****************************************************************************************
// ************* RUTINA DE ATENCION DE INTERRUPCION DEL PIT EN C ***************************
// *****************************************************************************************

__attribute__(( section(".functions"))) byte ISR33_handler_KEYBOARD_C(ring_buffer_struct* rb, byte key) 
{
    qword decimal= 0;

    // Valida el tamaño del número acumulado (64 bits = 16 teclas)
    if (rb->progress < rb->size)
    {
        // Valida tecla (dígitos numéricos y el retorno de carro)
        if(key == KEY_ENTER || (key >= KEY_1 && key <= KEY_0))
        {
            switch (key)
            {
                case KEY_0:
                    rb->buffer[rb->progress]= 0x0;
                    rb->progress++;
                    break;
                    
                case KEY_1:
                    rb->buffer[rb->progress]= 0x1;
                    rb->progress++;
                    break;
                    
                case KEY_2:
                    rb->buffer[rb->progress]= 0x2;
                    rb->progress++;
                    break;
                    
                case KEY_3:
                    rb->buffer[rb->progress]= 0x3;
                    rb->progress++;
                    break;
                    
                case KEY_4:
                    rb->buffer[rb->progress]= 0x4;
                    rb->progress++;
                    break;
                    
                case KEY_5:
                    rb->buffer[rb->progress]= 0x5;
                    rb->progress++;
                    break;
                    
                case KEY_6:
                    rb->buffer[rb->progress]= 0x6;
                    rb->progress++;
                    break;
                    
                case KEY_7:
                    rb->buffer[rb->progress]= 0x7;
                    rb->progress++;
                    break;
                    
                case KEY_8:
                    rb->buffer[rb->progress]= 0x8;
                    rb->progress++;
                    break;

                case KEY_9:
                    rb->buffer[rb->progress]= 0x9;
                    rb->progress++;
                    break;

                case KEY_F:
                    BREAKPOINT;
                    ring_buffer_clear(rb); 
                    digits_table_init((digits_table_struct*)&DIGITS_TABLE);
                    break;

                case KEY_ENTER:
                    ring_buffer_align(rb);
                    decimal= input_to_decimal(rb);
                    ring_buffer_to_digits_table(decimal, (digits_table_struct*)&DIGITS_TABLE);  
                    //td3_memcopy((dword*)rb->buffer,(dword*)&DIGITS_TABLE,(dword*)rb->size);
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
        ring_buffer_align(rb);
        decimal= input_to_decimal(rb);
        ring_buffer_to_digits_table(decimal, (digits_table_struct*)&DIGITS_TABLE);  
        //td3_memcopy((dword*)rb->buffer,(dword*)&DIGITS_TABLE,(dword)rb->size);  
        ring_buffer_clear(rb);
    }
}
