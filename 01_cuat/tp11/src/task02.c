#include "../inc/functions.h"

// *****************************************************************************************
// ***************************** RUTINA DE TAREA2 EN C *************************************
// *****************************************************************************************
__attribute__(( section(".task02"))) void task_02_C(void)
{
    digits_table_struct *dt = (digits_table_struct*) &DIGITS_TABLE_VMA;
    while (1)
    {
        char clean[11]="          ";

        /* MUESTRA CANTIDAD DE NUMEROS */
        char quantity[23]="TASK02 ---> Cantidad: ";
        // Pasa de entero a ASCII para imprimir
        char str_quantity[20]; 
        itoa(dt->numbers,str_quantity,10);
        // Escribe en pantalla "Promedio"
        screen_print(1,1,(screen_buffer_struct*) &VIDEO_VMA,quantity);
        // Limpia el campo "Promedio" anterior
        screen_print(23,1,(screen_buffer_struct*) &VIDEO_VMA,clean);
        // Escribe el campo "Promedio" nuevo
        screen_print(23,1,(screen_buffer_struct*) &VIDEO_VMA,str_quantity);

        __asm__("hlt");
    }
}