#include "../inc/functions.h"

// *****************************************************************************************
// ***************************** RUTINA DE TAREA2 EN C *************************************
// *****************************************************************************************
/*
    Tarea 2 debe realizar la suma aritmetica saturada en tamaño word, es decir,
    considerar que los numeros ingresador por teclado con 16 digitos hexadecimales 
    que equivalen a 64 bits deben considerarse como si en cada ingreso fueran 
    4 valores de 16 bits

*/
__attribute__(( section(".task02"))) void task_02_C(void)
{
    digits_table_struct *dt = (digits_table_struct*) &DIGITS_TABLE_VMA;
    qword accumulator;

    while (1)
    {
        accumulator = dt->sum;

        if(dt->numbers > ADDED_TASK02)
        {
            
            if((dt->position)==0)   // le dimos la vuelta a la tabla de digitos
            {
                // Parametro 1: Numero a sumar (dt->position)+(SIZE_TABLE-1): posicion en la tabla de digitos donde se guardó el último número)
                // Parametro 2: Numero acumulado
                accumulator= dword_addition(dt->buffer[(dt->position)+(SIZE_TABLE-1)], accumulator); 
            }                                                                             
            else
            {
                // Parametro 1: Numero a sumar (dt->position-1: posicion en la tabla de digitos donde se guardó el último número)
                // Parametro 2: Numero acumulado
                accumulator= dword_addition(dt->buffer[(dt->position)-1], accumulator);  
            }                                                                

            ADDED_TASK02++;
        }

        dt->sum= accumulator;

        char clean[11]="          ";

        /* MUESTRA CANTIDAD DE NUMEROS */
        char quantity[27]="TASK02 ---> Suma Saturada: ";
        // Pasa de entero a ASCII para imprimir
        char str_quantity[20]; 
        itoa(dt->sum,str_quantity,10);
        // Escribe en pantalla "Promedio"
        screen_print(1,2,(screen_buffer_struct*) &VIDEO_VMA,quantity);
        // Limpia el campo "Promedio" anterior
        screen_print(28,2,(screen_buffer_struct*) &VIDEO_VMA,clean);
        // Escribe el campo "Promedio" nuevo
        screen_print(28,2,(screen_buffer_struct*) &VIDEO_VMA,str_quantity);

        __asm__("hlt");
    }
}