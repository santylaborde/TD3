#include "../inc/functions.h"

// *****************************************************************************************
// ***************************** RUTINA DE TASK03 EN C *************************************
// *****************************************************************************************
/*
    La tarea 3 debe realizar la suma saturada en quadruple word. 
    Respecto a la tarea 2, la ventaja del SIMD es que cada par de valores sumados
    se realiza empaquetando valores de 128 bits.
*/
__attribute__(( section(".task03"))) void task_03_C(void)
{
    digits_table_struct *dt = (digits_table_struct*) &DIGITS_TABLE_VMA;
    qword accumulator;

    while (1)
    {
        accumulator = dt->sum;

        if(dt->numbers > ADDED_TASK03)
        {
            
            if((dt->position)==0)   // le dimos la vuelta a la tabla de digitos
            {
                // Parametro 1: Numero a sumar (dt->position)+(SIZE_TABLE-1): posicion en la tabla de digitos donde se guardó el último número)
                // Parametro 2: Numero acumulado
                accumulator= qword_addition(dt->buffer[(dt->position)+(SIZE_TABLE-1)], accumulator); 
            }                                                                             
            else
            {
                // Parametro 1: Numero a sumar (dt->position-1: posicion en la tabla de digitos donde se guardó el último número)
                // Parametro 2: Numero acumulado
                accumulator= qword_addition(dt->buffer[(dt->position)-1], accumulator);  
            }                                                                

            ADDED_TASK03++;
        }

        // dt->sum= accumulator; Se encarga la TASK02 de guardar en memoria la suma

        char clean[11]="          ";

        /* MUESTRA CANTIDAD DE NUMEROS */
        char quantity[27]="TASK03 ---> Suma Saturada: ";
        // Pasa de entero a ASCII para imprimir
        char str_quantity[20]; 
        itoa(accumulator,str_quantity,10);
        // Escribe en pantalla "Promedio"
        screen_print(1,3,(screen_buffer_struct*) &VIDEO_VMA,quantity);
        // Limpia el campo "Promedio" anterior
        screen_print(28,3,(screen_buffer_struct*) &VIDEO_VMA,clean);
        // Escribe el campo "Promedio" nuevo
        screen_print(28,3,(screen_buffer_struct*) &VIDEO_VMA,str_quantity);

        __asm__("hlt");
    }   
}