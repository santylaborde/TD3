# _GUIA DE TP 1C TD3 2021_
### 13. NIVELES DE PRIVILEGIO
En base a lo elaborado anteriormente implementar un sistema que permita manejar niveles de privilegio. A tal fin modificar/agregar los siguientes ítems:

a) La GDT debe contemplar los descriptores de nivel 3 (PL=11 usuario) [17], tanto para código como para datos.

b) Adecuar las diferentes entradas de la tabla de paginación según corresponda a usuario o supervisor, verificando además que los permisos de lectura y escritura sean consistentes con la sección asociada.

c) Las tareas 1 a 3 deben ejecutarse en nivel 3. Analizar si es necesario disponer de una pila por cada tarea y realizar las modificaciones pertinentes acorde a su respuesta.

d) Diseñar un mecanismo apropiado de acceso para las siguientes funciones de sistema (system calls). Utilice el vector 80h para los servicios, o bien un CALL FAR.

i. void td3_halt(void);
ii. unsigned int td3_read(void *buffer, unsigned int num_bytes);
iii. unsigned int td3_print(void *buffer, unsigned int num_bytes);

e) Modificar el mapa de memoria al siguiente esquema
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
Pila Kernel Tarea 1                     1FFF4000h               1FFF4000h
Pila Kernel Tarea 2                     1FFF5000h               1FFF5000h
Pila Kernel Tarea 3                     1FFF6000h               1FFF6000h
Pila Kernel Tarea 4                     1FFF7000h               1FFF7000h
Pila Tarea 1                            1FFFF000h               0078F000h
Pila Tarea 2                            30000000h               00790000h
Pila Tarea 3                            30001000h               00791000h
Pila Tarea 4                            30002000h               00792000h
Secuencia inicialización ROM            FFFF0000h               FFFF0000h
Vector de reset                         FFFFFFF0h               FFFFFFF0h                                
```
#### Objetivos conceptuales                                                                                              
I. Identificar todos los registros y datos que utiliza el procesador para verificar si es posible efectuar una conmutación de privilegio.
II. Analizar en qué momento actúa cada unidad de direccionamiento para validar el acceso a una región de memoria determinada
III. Identificar todos los registros y datos que utiliza el procesador para verificar si es posible acceder a un dato desde un código de cierto nivel de privilegio.
IV. Analizar la gestión de la pila realizada para una interrupción al conmutar de nivel de privilegio.
V. Reconocer los campos necesarios para identificar el privilegio de una sección en las tablas de paginación.
VI. Analizar la gestión de la pila realizada para una interrupción.
VII. Comprender qué información se almacena en el espacio de contexto de cada tarea.

#### Referencias  

- [18] Volumen 3, Capítulo 5, Intel® 64 and IA-32 Architectures Software Developer Manuals.