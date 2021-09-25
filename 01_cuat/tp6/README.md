# _GUIA DE TP 1C TD3 2021_
### 6. INTERRUPCIONES DE HARDWARE                                                                              
> Utilizando lo realizado anteriormente, implementar las siguientes modificaciones:
a. Incluir una rutina de adquisición de teclas debe realizarse en el controlador de teclado (IRQ1 [10], dirección de E/S 0x60 datos y 0x64 estado/comando ). Se debe tener en cuenta que por cada presión de una tecla se producen dos interrupciones, una por el make code y otra por el break code.
b. Implementar la lectura de la IRQ1, mediante un buffer circular cuyas direcciones y funcionamiento s muestra en la Figura 1.
c. Solo se tomarán como válidos dígitos numéricos y el retorno de carro. Las teclas restantes se descartarán.
d) El handler de IRQ1 conformará con los sucesivos caracteres un número de hasta 64bits. En caso de ingresarse una cantidad menor de 16 teclas numéricas consecutivas, completará el número con ceros a la izquierda, es decir si se presionan las teclas 12345678, se debe almacenar en la tabla de dígitos como una entrada que contiene al número 0000000012345678h. Cada nuevo número se insertará en la Tabla de datos cuando se presione ENTER. Por razones de simplicidad el buffer circular de teclado dispondrá de una longitud de 17 bytes. En caso de no haber recibido ENTER hasta el caracter No 16, al ingresarse el caracter No. 17 el handler lo reemplaza por ENTER y almacena el número de 16 dígitos en la posición correspondiente de Tabla.
e) Escribir el controlador del temporizador (IRQ0 [10]) de modo que interrumpa cada 100ms. Verifique el correcto funcionamiento almacenando en alguna dirección de Datos el número de veces que se produce la interrupción. Tenga en cuenta que la implementación del timer tick en Bochs no garantiza ejecución del tipo tiempo real, es decir observará una falta de correspondencia temporal entre la unidad de tiempo calculada y la que Bochs ejecuta en la práctica.

El mapa de memoria es el que se muestra en la Tabla 4.
```
Sección                             Dirección inicial
Tablas de sistema                   00000000h
Rutina de teclado e ISR             00100000h
Tabla de Dígitos                    00200000h
Datos                               00210000h
Kernel                              00020200h
Pila                                1FFF8000h
Secuencia inicialización ROM        FFFF0000h
Vector de reset                     FFFFFFF0h
```

#### Objetivos conceptuales                                                                                              
> I. Identificar todos los registros y datos que utiliza el procesador para acceder al controlador de una interrupción.
II. Comprender la implicancia del término “enmascarable”
III. Analizar la gestión de la pila realizada por una interrupción y compararla con la de una excepción.

#### Referencias
[10] Volumen 3, Capítulo 6, sección 12, Intel® 64 and IA-32 Architectures Software Developer Manuals.

#### Esquema
> <img src="/sup/Imagen.jpeg" alt="Ring Buffer"/>





