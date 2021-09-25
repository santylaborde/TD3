# _GUIA DE TP 1C TD3 2021_
### 5. CONFIGURACIÓN DEL SISTEMA DE INTERRUPCIONES                                                                               
> Tomando el ejercicio anterior, agregar una IDT [6][7] capaz de manejar todas las excepciones del procesador e interrupciones mapeadas por ambos PIC, es decir de la 0x00 hasta el tipo 0x2F y cumpla con los siguientes requerimientos.
a. Configurar el PIC maestro y esclavo de manera que utilicen el rango de tipos de interrupción **0x20-0x27** y **0x28-0x2F**, respectivamente.
b. Inicializar el registro de máscaras [8], de modo que estén deshabilitadas, todas las interrupciones de hardware en ambos PIC’s.
c. Implementar en todas las excepciones una rutina que permita identificar el número de excepción generada y finalice deteniendo la ejecución de instrucciones mediante la instrucción **“hlt”**. Se propone como método de identificación almacenar en _dl_ el número de excepción.
d) Generar de manera apropiada [9] (no emulándolas por interrupciones de software) para comprobar su funcionamiento las excepciones #UD, #DF, #SS y #AC. Se recomienda asociar la generación de cada una de las excepciones indicadas previamente a la pulsación de diferentes teclas. A tal fin se propone la siguiente
correspondencia: #UD=**U**, #DF=**I**, #SS=**S**, y #AC=**A**.
e) La IDT se debe ubicar en _Tablas de sistema_

El mapa de memoria para las diferentes secciones debe ser el siguiente:
```
Sección                             Dirección inicial
Tablas de sistema                   00000000h
Rutina de teclado ISR               00100000h
Datos                               00210000h
Kernel                              00020200h
Pila                                1FFF8000h
Secuencia inicialización ROM        FFFF0000h
Vector de reset                     FFFFFFF0h
```

#### Objetivos conceptuales                                                                                              
> I. Comprender el esquema de numeración de los vectores de interrupción y su asociación con la decodificación realizada por los PIC.
II. Entender la diferencia entre IRQ y tipo de interrupción.
III. Identificar los tipos de excepciones y las condiciones que las generan.
IV. Comprender el significado y la implicancia de cada campo de las tablas de descriptores y los mecanismos de protección que activan.
V. Analizar la gestión de la pila realizada por cada excepción.
VI. Identificar todos los registros y datos que utiliza el procesador para acceder al controlador de una excepción.
VII. Identificar las diferencias principales entre una excepción y una interrupción

#### Referencias
[6] Volumen 3, Capítulo 6, sección 10, Intel® 64 and IA-32 Architectures Software Developer Manuals,
[7] Volumen 3, Capítulo 6, sección 11, Intel® 64 and IA-32 Architectures Software Developer Manuals,
[8] Volumen 3, Capítulo 2, sección 3, Intel® 64 and IA-32 Architectures Software Developer Manuals,
[9] Volumen 3, Capítulo 6, sección 15, Intel® 64 and IA-32 Architectures Software Developer Manuals.





