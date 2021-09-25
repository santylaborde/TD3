#include "../inc/functions.h"

// *****************************************************************************************
// ***************************** RUTINA DE TASK04 EN C *************************************
// *****************************************************************************************
__attribute__(( section(".task04"))) void task_04_C(void)
{
    while(1)
    {
        // La tarea IDLE sirve para no sobrecargar al procesador
        __asm__("hlt"); // simplemente un HALT
    }
}