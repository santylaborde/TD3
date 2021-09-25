; *************************** RESET VECTOR ******************************************
; ********** CODIGO ********************** Comentarios ******************************

EXTERN init16 	  							;importo etiqueta
GLOBAL Entry      							;exporto etiqueta

USE16

;____________________________________________________________________________________
section .reset
Entry:										; reset vector en direccion 0x...
	cli										; Deshabilita interrupciones
	jmp	init16								; Vamos al bloque de inicializacion
					
aqui:										; Proteccion por si algo sale mal
	hlt										; estado de alta impedancia
	jmp	aqui								; Loop infinito

align 16									; Completa hasta la siguiente dirección múltiplo de 16 
;____________________________________________________________________________________

