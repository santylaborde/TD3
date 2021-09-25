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
    qword value;
    char str_quantity[20]; 

    // Escribe en pantalla "Suma Saturada:"
    td3_print(1,3,"TASK03 ---> Suma Saturada: ");

    while (1)
    {
        accumulator = td3_read(&DIGITS_TABLE_VMA,OFFSET_ADD);       // dt->sum;
        
        value= td3_read(&DIGITS_TABLE_VMA,OFFSET_NUM);              // dt->numbers;
        if(value > ADDED_TASK03)
        {
            value= td3_read(&DIGITS_TABLE_VMA,OFFSET_POSE);         // dt->position;
            if((dt->position)==0)   // le dimos la vuelta a la tabla de digitos
            {
                value = td3_read(&DIGITS_TABLE_VMA,SIZE_TABLE-1);   // dt->buffer[SIZE_TABLE-1]  ; último número ingresado
                accumulator= qword_addition(value, accumulator); 
            }                                                                             
            else
            {
                value= td3_read(&DIGITS_TABLE_VMA,OFFSET_POSE);     // dt->position:   Ubicación donde se guardará el siguiente número
                value= td3_read(&DIGITS_TABLE_VMA,value-1);         // dt->buffer[dt->position-1]; último número ingresado
                accumulator= qword_addition(value, accumulator); 
            }                                                                

            ADDED_TASK03++;
        }

        /* MUESTRA CANTIDAD DE NUMEROS */
        // Pasa de entero a ASCII para imprimir
        itoa(accumulator,str_quantity,10);

        // Limpia el campo "Suma" anterior
        td3_print(28,3,"          ");

        // Escribe el campo "Suma" nuevo
        td3_print(28,3,str_quantity);

        // Hace un HALT
        td3_halt();
    
    }   
}

__attribute__(( section(".data")))int dummy_task03_data;
__attribute__(( section(".rodata")))int dummy_task03_rodata;
__attribute__(( section(".bss")))int dummy_task03_bss;