#include "../inc/funciones.h"

__attribute__(( section(".functions_rom"))) byte td3_memcopy(const dword *src, dword *dst, dword length)
{
    byte status = ERROR;

    if(length > 0)
    {
        while (length)
        {
            length--;
            *dst = *src;
            dst ++;
            src++; 
        }
        status = EXITO; 
    }
    return status;
}