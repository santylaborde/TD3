#include "../inc/funciones.h"

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
__attribute__(( section(".functions"))) void task_01_C(digits_table_struct *dt)
{
    char str_average[20]; 

    // Calcula el promedio
    dt->average = division(dt->sum,dt->numbers);
    // Pasa de entero a ASCII para imprimir
    itoa(dt->average,str_average,10);
    // Escribe en pantalla "Promedio"
    screen_print(1,1,(screen_buffer_struct*) &VIDEO_VGA,"Promedio:  ");
    // Limpia el campo "Promedio" anterior
    screen_print(11,1,(screen_buffer_struct*) &VIDEO_VGA,"         ");
    // Escribe el campo "Promedio" nuevo
    screen_print(11,1,(screen_buffer_struct*) &VIDEO_VGA,str_average);
}
