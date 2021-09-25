#include "../inc/functions.h"

// *****************************************************************************************
// ***************************** RUTINA DE TASK03 EN C *************************************
// *****************************************************************************************
__attribute__(( section(".task03"))) void task_03_C(void)
{

    digits_table_struct *dt = (digits_table_struct*) &DIGITS_TABLE_VMA;
    while (1)
    {
        char clean[11]="          ";
        
        /* MUESTRA PROMEDIO EN PANTALLA */
        char sum[23]="TASK03 ---> Suma:     ";
        // Pasa de entero a ASCII para imprimir
        char str_sum[20]; 
        itoa(dt->sum,str_sum,10);
        // Escribe en pantalla "Promedio"
        screen_print(1,2,(screen_buffer_struct*) &VIDEO_VMA,sum);
        // Limpia el campo "Promedio" anterior
        screen_print(23,2,(screen_buffer_struct*) &VIDEO_VMA,clean);
        // Escribe el campo "Promedio" nuevo
        screen_print(23,2,(screen_buffer_struct*) &VIDEO_VMA,str_sum);

        __asm__("hlt");
    }
}