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
    qword value;
    char str_quantity[20]; 

    // Escribe en pantalla "Suma Saturada:"
    td3_print(1,2,"TASK02 ---> Suma Saturada: ");

    while (1)
    {
        accumulator = td3_read(&DIGITS_TABLE_VMA,OFFSET_ADD);       //  dt->sum;

        value= td3_read(&DIGITS_TABLE_VMA,OFFSET_NUM);              //  dt->numbers;
        if(value > ADDED_TASK02)
        {
            value= td3_read(&DIGITS_TABLE_VMA,OFFSET_POSE);         //  dt->position;
            if(value==0)   // le dimos la vuelta a la tabla de digitos
            {

                value = td3_read(&DIGITS_TABLE_VMA,SIZE_TABLE-1);   //  dt->buffer[SIZE_TABLE-1]  ; último número ingresado
                accumulator= dword_addition(value, accumulator); 
            }                                                                             
            else
            {
                value= td3_read(&DIGITS_TABLE_VMA,OFFSET_POSE);     //  dt->position: Ubicación donde se guardará el siguiente número
                value= td3_read(&DIGITS_TABLE_VMA,value-1);         //  dt->buffer[dt->position-1]; último número ingresado
                accumulator= dword_addition(value, accumulator); 
            }                                                                

            ADDED_TASK02++;
        }


        td3_write(&DIGITS_TABLE_VMA,OFFSET_ADD,accumulator);        //  dt->sum= accumulator;

        /* MUESTRA CANTIDAD DE NUMEROS */
        // Pasa de entero a ASCII para imprimir
        itoa(dt->sum,str_quantity,10);

        // Limpia el campo "Suma" anterior
        td3_print(28,2,"          ");

        // Escribe el campo "Suma" nuevo
        td3_print(28,2,str_quantity);

        // Hace un HALT
        td3_halt();
    }
}

__attribute__(( section(".data")))int dummy_task02_data;
__attribute__(( section(".rodata")))int dummy_task02_rodata;
__attribute__(( section(".bss")))int dummy_task02_bss;