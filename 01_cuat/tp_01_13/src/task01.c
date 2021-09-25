#include "../inc/functions.h"

// *****************************************************************************************
// ***************************** RUTINA DE TAREA1 EN C *************************************
// *****************************************************************************************
__attribute__(( section(".task01"))) void task_01_C(void)
{

    digits_table_struct *dt = (digits_table_struct*) &DIGITS_TABLE_VMA;
    qword dividend;
    qword divisor;
    qword quotient;

    // Escribe en pantalla "Promedio"
    td3_print(1,1,"TASK01 ---> Promedio: ");

    while (1)
    {
        /* CALCULA PROMEDIO */
        dividend = td3_read(&DIGITS_TABLE_VMA,OFFSET_ADD);              // dt->sum;
        divisor  = td3_read(&DIGITS_TABLE_VMA,OFFSET_NUM);              // dt->numbers;
        quotient = division_64(dividend,divisor);   
        td3_write(&DIGITS_TABLE_VMA,OFFSET_AVR,quotient);               // dt->average = quotient;
       
        /* MUESTRA PROMEDIO EN PANTALLA */
        // Pasa de entero a ASCII para imprimir
        char str_average[20]; 
        itoa(dt->average,str_average,10);
       
        // Limpia el campo "Promedio en DEC" anterior
        td3_print(28,1,"          ");

        // Escribe el campo "Promedio en DEC" nuevo
        td3_print(28,1,str_average);

        // Hace un HALT
        td3_halt();
    }
}

__attribute__(( section(".data")))int dummy_task01_data;
__attribute__(( section(".rodata")))int dummy_task01_rodata;
__attribute__(( section(".bss")))int dummy_task01_bss;
