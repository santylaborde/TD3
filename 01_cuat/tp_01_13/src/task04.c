#include "../inc/functions.h"

// *****************************************************************************************
// ***************************** RUTINA DE TASK04 EN C *************************************
// *****************************************************************************************
__attribute__(( section(".task04"))) void task_04_C(void)
{
    while(1)
    {
        // La tarea IDLE sirve para no sobrecargar al procesador
        __asm__("hlt");     // Si TASK04 es SUPERVISORA
        //td3_halt();       // Si TASK04 es USUARIA
    }
}

__attribute__(( section(".data")))int dummy_task04_data;
__attribute__(( section(".rodata")))int dummy_task04_rodata;
__attribute__(( section(".bss")))int dummy_task04_bss;