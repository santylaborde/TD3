# _GUIA DE TP 1C TD3 2021_
### 10. PAGINACIÓN REAL                                                                         
> En base al código anterior modificar las siguientes funcionalidades:
a) La rutina de promedio (Tarea 1) debe intentar leer en la dirección que se obtenga como resultado de promedio. En caso de que dicho número supere la RAM del sistema (512MB) se omitirá la lectura.
b) El controlador de #PF al detectar que el error se debe a una página no presente, deberá asignar a la dirección que produjo el error una nueva página a partir de la dirección física 0x0A000000h.
**Tenga en cuenta que las estructuras de paginación deberán completarse en forma dinámica.**

#### Objetivos conceptuales                                                                                              
> I. Comprender en profundidad el controlador la excepción de Page Fault.

#### Referencias  

> Se recomienda leer nuevamente:
Volumen 3, Capítulo 6, sección 15, Intel® 64 and IA-32 Architectures Software Developer Manuals, la descripción de la excepción de Page Fault (14).
