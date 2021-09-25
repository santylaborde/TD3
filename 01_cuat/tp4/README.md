# _GUIA DE TP 1C TD3 2021_
### 4. MODO PROTEGIDO 32 BITS                                                                                
> En base al ejercicio anterior adecuarlo para que el mismo se ejecute en modo protegido 32bits.
a. Crear una estructura GDT mínima con modelo de segmentación FLAT [3][4][5]
b. En la zona denominada Kernel solo debe copiarse código.
c. Definir una pila dentro del segmento de datos e inicializar el par de registros SS:ESP [3][4] adecuadamente. Realice la definición de forma dinámica de modo que pueda modificarse su tamaño y ubicación de manera simple.

El mapa de memoria para las diferentes secciones debe ser el siguiente:
```
Sección                             Dirección inicial
Rutinas                             00010000h
Kernel                              00020200h
Pila                                2FFF8000h
Secuencia inicialización ROM        FFFFFFF0h
Vector de reset                     FFFFFFF0h
```

#### Objetivos conceptuales                                                                                              
> I. Comprender los requerimientos necesarios para que un programa pueda ejecutarse en modo protegido.
II. Identificar todos los registros y datos que utiliza el procesador para acceder a cada instrucción de código, dato y pila.
III. Analizar el esquema de direccionamiento entre modo protegido y real, identificando diferencias y similitudes.
IV. Comprender el significado y la implicancia de cada campo de las tablas de descriptores y los mecanismos de protección que activan.

#### Referencias
[3] Volumen 3, Capítulo 2, sección 2, Intel® 64 and IA-32 Architectures Software Developer Manuals
[4] Volumen 3, Capítulo 3, sección 2, Intel® 64 and IA-32 Architectures Software Developer Manuals,
[5] Volumen 3, Capítulo 3, sección 4, Intel® 64 and IA-32 Architectures Software Developer Manuals,


