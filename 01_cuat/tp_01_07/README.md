# _GUIA DE TP 1C TD3 2021_
### 7. RUTINA TEMPORIZADA Y CONTROLADOR DE VIDEO                                                                           
> Modificar el programa desarrollado hasta el momento considerando las siguientes consignas:
a. Escribir un código listo para ser tratado a futuro como una tarea. Debe promediar todos los números de 64 bits almacenados en la Tabla de Dígitos, que fueron ingresados por teclado, y presentar el resultado en el extremo superior derecho de la pantalla, y almacenarlo en alguna variable situada en la sección Datos.
**La rutina debe cumplir los siguientes requerimientos:**
a. Ejecutarse cada 500ms. (se puede seguir ingresando datos mientras tanto)
b. Adecuar el código y el linker script para satisfacer el siguiente mapa de memoria (Tabla 5):
```
Sección                             Dirección inicial
Tablas de sistema                   00000000h
Rutina de teclado e ISR             00100000h
Tabla de Dígitos                    00200000h
Datos                               00210000h
Kernel                              00020200h
Tarea 1                             00300000h
Pila                                1FFF8000h
Secuencia inicialización ROM        FFFF0000h
Vector de reset                     FFFFFFF0h
```

#### Objetivos conceptuales                                                                                              
> I. Analizar la implementación del direccionamiento realizada por el compilador y el linker.
II. Asociar los esquemas de direccionamiento del procesador con los utilizados por el programador y las herramientas (compilador y linker).