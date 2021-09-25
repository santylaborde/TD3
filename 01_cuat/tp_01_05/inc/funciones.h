typedef unsigned char           byte;
typedef unsigned short          word;
typedef unsigned long           dword;

#define EXITO 0
#define ERROR 1

__attribute__(( section(".functions_rom"))) byte td3_memcopy(const dword *src, dword *dst, dword length);
__attribute__(( section(".functions"))) byte hola_mundo(void);
