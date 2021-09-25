# _GUIA DE TP 1C TD3 2021_
### 8. PAGINACIÓN AVANZADA                                                                         
> Modificar el esquema de paginación del ejercicio anterior para satisfacer el mapa de memoria
siguiente:
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
Pila Kernel                             1FFF8000h               2FFF8000h
Pila Tarea 1                            1FFFF000h               0078F000h
Secuencia inicialización ROM            FFFF0000h               FFFF0000h
Vector de reset                         FFFFFFF0h               FFFFFFF0h
                                                 
```

Utilizar alguna herramienta interpretación de formato de archivos binarios para analizar los datos de posicionamiento en memoria.

#### Objetivos conceptuales                                                                                              
> I. Comprender en profundidad el mecanismo de paginación.
II. Dominar la herramienta “linker script”.


