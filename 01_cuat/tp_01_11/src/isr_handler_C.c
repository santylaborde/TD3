#include "../inc/functions.h"

// *****************************************************************************************
// ************* RUTINA DE ATENCION DE INTERRUPCION DEL PIT EN C ***************************
// *****************************************************************************************

/* Handler del PIT */
__attribute__(( section(".isr_handler"))) void ISR32_handler_PIT_C(time_struct* tp) 
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

__attribute__(( section(".isr_handler"))) byte ISR33_handler_KEYBOARD_C(ring_buffer_struct* rb, byte key) 
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
                    ring_buffer_clear(rb); 
                    digits_table_init((digits_table_struct*)&DIGITS_TABLE_VMA);
                    break;

                case KEY_ENTER:
                    ring_buffer_align(rb);
                    decimal= input_to_decimal(rb);
                    ring_buffer_to_digits_table(decimal, (digits_table_struct*)&DIGITS_TABLE_VMA);  
                    //td3_memcopy((dword*)rb->buffer,(dword*)&DIGITS_TABLE_VMA,(dword*)rb->size);
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
        ring_buffer_to_digits_table(decimal, (digits_table_struct*)&DIGITS_TABLE_VMA);  
        //td3_memcopy((dword*)rb->buffer,(dword*)&DIGITS_TABLE_VMA,(dword)rb->size);  
        ring_buffer_clear(rb);
    }
}

// *****************************************************************************************
// *************** RUTINA DE ATENCION DE INTERRUPCION DE PF EN C ***************************
// *****************************************************************************************

__attribute__(( section(".isr_handler"))) void ISR14_handler_PF_C(dword* ERROR_CODE, dword CR2) 
{   
    if(ERROR_CODE[0]==0)       // Bit 0 = 1 No presente
    {     
        __asm__("nop");
        static TIMES= 0;  
        // DESHABILITA PAGINACION
        dword mask= ~(X86_CR0_PG);
        __asm__("movl %%cr0,%%edx;"                    // Ojo! La sintaxis es: mov "origen","destino" (Al revés de Intel)
                "andl %0,%%edx;"                       // Hace una "andl" (and en 32bits) de CR0 con not(X86_CR0_PG)
                "movl %%edx,%%cr0;" : "+r" (mask));    // Reemplaza %0 por "valor"
        
        // AGREGA LA PT NUEVA A LA DPT 
        dword DTP_ENTRY= (0xFFC00000 & CR2) >> 22;                         // CONVIERTE CR2 EN UNA PAGE DIRECTORY ENTRY
        dword PT= &DPT_KERNEL_VMA;                                         
        PT= PT+0x1000+0x1000*DTP_ENTRY;                                      // DIRECCION DE LA NUEVA PAGE TABLE 
        set_PDE(&(DPT_KERNEL_VMA), DTP_ENTRY, PT, 0, 0, 0, 0, 0, 1, 1);    // AGREGA LA NUEVA PAGE TABLE AL DIRECTORIO

        // AGREGA LA PAGE NUEVA A LA PT NUEVA
        dword PT_ENTRY= (0x002FF000 & CR2)>>12;                            // CONVIERTE CR2 EN UNA PAGE TABLE ENTRY
        dword DYNAMIC_PHY = &START_NEW_PAGES_PHY;
        DYNAMIC_PHY = DYNAMIC_PHY+0x1000*TIMES;
        set_PTE(PT, PT_ENTRY, DYNAMIC_PHY, 0, 0, 0, 0, 0, 0, 0, 1, 1);    // AGREGA LA NUEVA PAGE A LA TABLA
        TIMES++;
        
        // HABILITA PAGINACION
        mask= X86_CR0_PG;
        __asm__("movl %%cr0,%%edx;"                    // Ojo! La sintaxis es: mov "origen","destino" (Al revés de Intel)
                "orl %0,%%edx;"                        // Hace una "orl" (or en 32bits) de CR0 con not(X86_CR0_PG)
                "movl %%edx,%%cr0;" : "+r" (mask));    // Reemplaza %0 por "valor"
    }
    else if(ERROR_CODE[1]==1)  // Bit 1 = 1 Permisos de Lectura/Escritura
    {
        BREAKPOINT;
    }
    else if(ERROR_CODE[2]==1)  // Bit 2 = 1 Permiso de privilegio
    {
        BREAKPOINT;
    }
    else if(ERROR_CODE[3]==1)  // Bit 3 = 1 RSVD 
    {
        BREAKPOINT;
    }
    else if(ERROR_CODE[4]==1)  // Bit 4 = 1 I/D 
    {
        BREAKPOINT;
    }
    else
    {
        BREAKPOINT;
    }

}