#include "../inc/functions.h"

// *****************************************************************************************
// *********************** RUTINA DEL SCHEDULER EN C ***************************************
// *****************************************************************************************

__attribute__(( section(".functions"))) void scheduler_C(digits_table_struct* dt, time_struct* tp) 
{
    switch (tp->counter)
    {
    case 5: //500 ms
        task_01_C(dt);
        break;
    
    default:
        break;
    }
}


// *****************************************************************************************
// ***************************** RUTINA DE TAREAS EN C *************************************
// *****************************************************************************************
/* Función para inicializar buffer del display */
__attribute__(( section(".task01"))) void task_01_C(digits_table_struct *dt)
{
    char clean[11]="          ";

    /* MUESTRA CANTIDAD DE NUMEROS */
    char quantity[11]="Cantidad: ";
    // Pasa de entero a ASCII para imprimir
    char str_quantity[20]; 
    itoa(dt->numbers,str_quantity,10);
    // Escribe en pantalla "Promedio"
    screen_print(1,1,(screen_buffer_struct*) &VIDEO_VMA,quantity);
    // Limpia el campo "Promedio" anterior
    screen_print(11,1,(screen_buffer_struct*) &VIDEO_VMA,clean);
    // Escribe el campo "Promedio" nuevo
    screen_print(11,1,(screen_buffer_struct*) &VIDEO_VMA,str_quantity);

    /* MUESTRA PROMEDIO EN PANTALLA */
    char sum[11]="Suma: ";
    // Pasa de entero a ASCII para imprimir
    char str_sum[20]; 
    itoa(dt->sum,str_sum,10);
    // Escribe en pantalla "Promedio"
    screen_print(1,2,(screen_buffer_struct*) &VIDEO_VMA,sum);
    // Limpia el campo "Promedio" anterior
    screen_print(11,2,(screen_buffer_struct*) &VIDEO_VMA,clean);
    // Escribe el campo "Promedio" nuevo
    screen_print(11,2,(screen_buffer_struct*) &VIDEO_VMA,str_sum);

    /* CALCULA PROMEDIO */
    dt->average = division_64(dt->sum,dt->numbers);
    
    /* MUESTRA PROMEDIO EN PANTALLA */
    char average[11]="Promedio: ";
    // Pasa de entero a ASCII para imprimir
    char str_average[20]; 
    itoa(dt->average,str_average,10);
    // Escribe en pantalla "Promedio"
    screen_print(1,3,(screen_buffer_struct*) &VIDEO_VMA,average);
    // Limpia el campo "Promedio" anterior
    screen_print(11,3,(screen_buffer_struct*) &VIDEO_VMA,clean);
    // Escribe el campo "Promedio" nuevo
    screen_print(11,3,(screen_buffer_struct*) &VIDEO_VMA,str_average);

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
    qword* pointer= (qword*) (direction);
    qword value = *(pointer);

}

