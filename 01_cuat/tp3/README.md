# _GUIA DE TP 1C TD3 2021_
### 3. INICIALIZACIÓN BÁSICA UTILIZANDO EL LINKER                                                                                 
> Modificar el código del ejercicio anterior para satisfacer los siguientes requerimientos:
a. El programa debe situarse al inicio de la ROM (0xFFFF0000)
i. Copiarse y ejecutarse a la dirección 0x00007C00 donde debe establecer estado de halted en forma permanente.

El mapa de memoria propuesto:
```
Sección                             Dirección inicial
Binario copiado                     00007C00h
Pila                                00068000h
Secuencia inicialización ROM        FFFF0000h
Vector de reset                     FFFFFFF0h
```

#### Objetivos conceptuales                                                                                                
>i. Familiarizarse con el lenguaje ASM y las herramientas asociadas (NASM).
ii. Familiarizarse con las herramientas de depuración provistas por el Bochs.
iii. Familiarizarse con el “linker”, su lenguaje de “script” y las herramientas asociadas (ld).
iv. Identificar todos los registros y datos que utiliza el procesador para acceder a cada instrucción de código y dato y pila [1][2]
