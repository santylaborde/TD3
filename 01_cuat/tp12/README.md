# _GUIA DE TP 1C TD3 2021_
### 12. SIMD                                                          
Modificar la Tarea 2 para que realice la suma aritmética saturada en tamaño word y la Tarea 3 para que lo realice en tamaño quadruple word.
Implementar el soporte necesario para el resguardo de los registros MMX/SSE mediante la excepción 7 (#NM) [15][16], así como también realizar las modificaciones correspondientes en
la función de cambio de contexto.

#### Objetivos conceptuales                                                                                              
I. Identificar todos los registros y datos que utiliza el procesador para verificar si se ha utilizado una instrucción SIMD.

II. Comprender los diferentes tipos de aritmética utilizados por el procesador.

#### Referencias  

- [16] Volumen 3, Capítulo 6, sección 15, Intel® 64 and IA-32 Architectures Software Developer Manuals,
- [17] Volumen 3, Capítulo 12, Intel® 64 and IA-32 Architectures Software Developer Manuals,