# _GUIA DE TP 1C TD3 2021_
### 11. CONMUTACIÓN DE TAREAS                                                          
Incorpore al programa desarrollado hasta el momento una capacidad mínima de administración de tareas[11]. Para ello se requiere, agregar las siguientes prestaciones:

a) Implementar 3 tareas a saber:
- Promedio (1 tarea). Es la tarea presente al momento. Sigue ejecutando cada 500 ms.
- Suma (2 tareas). Estas tareas se ejecutarán cada 100 y 200 ms. respectivamente. En todos los casos utilizarán como sumandos los datos de Tabla de dígitos, presentando el resultado en pantalla y al finalizar debe establecer al procesador en estado halted. Deshabilitar (no borrar) el código de generación de PF.
- Idle (1 tarea). Su única función es establecer al procesador en estado halted y se debe ejecutar cuando ninguna otra tarea se encuentre en ejecución.

b) Modificar el valor del temporizador 0 del PIT, para que genere una interrupción cada 10 mseg aproximadamente.

c) Modificar el controlador de la interrupción 32 (IRQ0, timer tick), para que actué como conmutador de tareas (scheduler). Diseñe dicho mecanismo [12] para que despache las tareas en forma secuencial. El mecanismo de conmutación de contextos deberá implementarlo finalmente de forma manual (transitoriamente puede analizar el mecanismo automático provisto por el procesador) [13][14].

d) Modificar el mapa de memoria al esquema de la Tabla 8:
```
Sección                             Dirección inicial   Dirección lineal inicial
Tablas de sistema                       00000000h               00000000h
Tablas de paginacion                    00010000h               00010000h
Video                                   000B8000h               00010000h
ISRs                                    00100000h               00100000h
Datos                                   00200000h               01200000h
Tabla de Dígitos                        00210000h               01210000h
Kernel                                  00220000h               01220000h
TEXT Tarea 1                            00310000h               01310000h
BSS Tarea 1                             00320000h               01320000h
Data Tarea 1                            00330000h               01330000h
RODATA Tarea 1                          00340000h               01340000h
TEXT Tarea 2                            00410000h               01410000h
BSS Tarea 2                             00420000h               01420000h
Data Tarea 2                            00430000h               01430000h
RODATA Tarea 2                          00440000h               01440000h
TEXT Tarea 3                            00510000h               01510000h
BSS Tarea 3                             00520000h               01520000h
Data Tarea 3                            00530000h               01530000h
RODATA Tarea 3                          00540000h               01540000h
TEXT Tarea 4                            00610000h               01610000h
BSS Tarea 4                             00620000h               01620000h
Data Tarea 4                            00630000h               01630000h
RODATA Tarea 4                          00640000h               01640000h
Pila Kernel                             1FFF8000h               1FFF8000h
Pila Tarea 1                            1FFFF000h               0078F000h
Pila Tarea 2                            30000000h               00790000h
Pila Tarea 3                            30001000h               00791000h
Pila Tarea 4                            30002000h               00792000h
Secuencia inicialización ROM            FFFF0000h               FFFF0000h
Vector de reset                         FFFFFFF0h               FFFFFFF0h                                
```

#### Objetivos conceptuales                                                                                              
I. Identificar todos los registros y datos utilizados para realizar la conmutación de tarea.

II. Comprender que el espacio de direcciones observado por cada tarea es completamente
independiente de la dirección física y la traducción solo es conocida por el SO.

#### Referencias  

- [12] Volumen 3, Capítulo 7, sección 1, Intel® 64 and IA-32 Architectures Software Developer
Manuals,
- [13] Volumen 3, Capítulo 7, sección 3, Intel® 64 and IA-32 Architectures Software Developer
Manuals,
- [14] Volumen 3, Capítulo 7, sección 2, Intel® 64 and IA-32 Architectures Software Developer
Manuals,
- [15] Volumen 3, Capítulo 7, sección 7, Intel® 64 and IA-32 Architectures Software Developer
Manuals.
