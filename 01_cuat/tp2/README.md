# _GUIA DE TP 1C TD3 2021_
### 2. INICIALIZACIÓN BÁSICA UTILIZANDO SOLO ENSAMBLADOR CON ACCESO A 1MB                                                                                   
> Escribir un programa que se ejecute en una ROM de 64kB y permita copiarse a sí mismo en cualquier zona de memoria. A tal fin se deberá implementar la función:
```
void *td3_memcopy(void *destino, const void *origen unsigned int num_bytes);
```
> Para validar el correcto funcionamiento del programa, el mismo deberá copiarse en las direcciones indicadas a continuación y mediante Bochs verificar que la memoria se haya escrito correctamente.
i. 0x00000
ii. 0xF0000 

#### Objetivos conceptuales                                                                                                
>i. Familiarizarse con el lenguaje ASM y las herramientas asociadas (NASM).
ii. Familiarizarse con las herramientas de depuración provistas por el Bochs.
iii. Comprender el mapa de memoria del procesador.
iv. Identificar todos los registros y datos que utiliza el procesador para acceder a cada
instrucción de código y dato. [1][2]

#### Referencias  

> [1] Volumen 1, Capítulo 3, sección 3, Intel® 64 and IA-32 Architectures Software Developer Manuals,
[2] Volumen 1, Capítulo 3, sección 4, Intel® 64 and IA-32 Architectures Software Developer Manuals,
