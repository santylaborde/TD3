#include "../inc/functions.h"

// *****************************************************************************************
// ***************************** RUTINA DE TAREA1 EN C *************************************
// *****************************************************************************************
__attribute__(( section(".task01"))) void task_01_C(void)
{

    digits_table_struct *dt = (digits_table_struct*) &DIGITS_TABLE_VMA;
    while (1)
    {
        char clean[11]="          ";

        /* CALCULA PROMEDIO */
        dt->average = division_64(dt->sum,dt->numbers);
        
        /* MUESTRA PROMEDIO EN PANTALLA */
        char average[23]="TASK01 ---> Promedio: ";
        // Pasa de entero a ASCII para imprimir
        char str_average[20]; 
        itoa(dt->average,str_average,10);
        // Escribe en pantalla "Promedio"
        screen_print(1,3,(screen_buffer_struct*) &VIDEO_VMA,average);
        // Limpia el campo "Promedio" anterior
        screen_print(23,3,(screen_buffer_struct*) &VIDEO_VMA,clean);
        // Escribe el campo "Promedio" nuevo
        screen_print(23,3,(screen_buffer_struct*) &VIDEO_VMA,str_average);

        /* MUESTRA EL PROMEDIO COMO DIRECCION DE MEMORIA EN PANTALLA */
        qword direction= 0x00000000;

        if(dt->average < 0x1FFFFFFF)    // RAM = 512MB
        {
            direction= (dt->average);  
        }

        /* MUESTRA LA DIRECCION EN PANTALLA */
        char str_measurement[20]; 
        char measurement[13]="Direccion: 0x";
        // Pasa de entero a ASCII para imprimir
        itoa(direction,str_measurement,16);
        // Escribe en pantalla "Lectura en direccion "
        screen_print(1,5,(screen_buffer_struct*) &VIDEO_VMA,measurement);
        // Limpia el campo "Promedio" anterior
        screen_print(14,5,(screen_buffer_struct*) &VIDEO_VMA,clean);
        // Escribe la direccion apuntada por el "Promedio"
        screen_print(14,5,(screen_buffer_struct*) &VIDEO_VMA,str_measurement);


        /* INTENTA LEER LA DIRECCION DE MEMORIA */
        // qword* pointer= (qword*) (direction);
        // qword value = *(pointer);

        __asm__("hlt");
    }
}