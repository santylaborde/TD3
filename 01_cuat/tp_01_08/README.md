# _GUIA DE TP 1C TD3 2021_
### 8. PAGINACIÓN BÁSICA                                                                         
> Tomando como base al ejercicio anterior implementar un sistema de paginación [11] en modo identity mapping y adecuarlo a los siguientes lineamientos:
a. Estructurar el programa de forma tal que disponga de las siguientes secciones (la denominación se realiza acorde al estándar ELF) con sus respectivas propiedades:
I. **Sección de código (TEXT):** no debe contener ningún tipo de dato/variable.
II. **Sección de datos (DATA):** contiene los datos inicializados de lectura/escritura.
III. **Sección de datos (RODATA):** contiene los datos inicializados de solo lectura.
IV. **Sección de datos no inicializados (BSS):**
b. Implementar un controlador básico de #PF que indique el motivo de la excepción.
c. Implementar un controlador básico de #PF que indique el motivo de la excepción.
d. El mapa de memoria luego de la expansión del binario debe cumplir con el siguiente esquema:
```
Sección                             Dirección inicial
Tablas de sistema                   00000000h
Tablas de paginacion                00010000h
Video                               000B8000h
ISRs                                00100000h
Tabla de Dígitos                    00210000h
Kernel                              00220000h
TEXT Tarea 1                        00310000h
BSS Tarea 1                         00320000h
Data Tarea 1                        00330000h
RODATA Tarea 1                      00340000h
Pila Kernel                         1FFF8000h
Pila Tarea 1                        1FFFF000h
Secuencia inicialización ROM        FFFF0000h
Vector de reset                     FFFFFFF0h
```

Utilizar alguna herramienta interpretación de formato de archivos binarios para analizar los datos de posicionamiento en memoria.

#### Objetivos conceptuales                                                                                              
> I. Identificar los esquemas de direccionamiento del procesador.
II. Analizar la implementación del direccionamiento realizada por el compilador y el linker.
III. Asociar los esquemas de direccionamiento del procesador con los utilizados por el
programador y las herramientas (compilador y linker).
IV. Asociar los esquemas de direccionamiento del procesador con los utilizados por el
programador y las herramientas (compilador y linker).
V. Entender el funcionamiento del “linker script”.

#### Referencias

[11] Volumen 3, Capítulo 4, sección 1, Intel® 64 and IA-32 Architectures Software Developer Manuals.
