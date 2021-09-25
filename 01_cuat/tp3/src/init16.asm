; *************************** INICIALIZACION ****************************************
; ********** CODIGO ********************** Comentarios ******************************

EXTERN STACK_START_16						; importo las etiquetas
EXTERN STACK_END_16
EXTERN td3_memcopy							
GLOBAL init16 								; exporto la etiqueta

SEG_DEST EQU 0x0							; seccion destino
OFFSET_DEST EQU 0x7C00						; offset destino
											; enunciado: 00007C00h

USE16
;____________________________________________________________________________________
section .ROM_init

idle:										; Bloque para esperar luego de hacer la copia 
	hlt										; estado de alta impedancia
	jmp	idle								; Loop infinito

init16:										; inicializa los registros 
; 	MAPEO DE LA PILA
	mov bx,STACK_START_16
	mov ss,bx								; setea el comienzo del stack
	mov sp,STACK_END_16						; setea el final del stack
; 	CARGO LO QUE QUIERO COPIAR
	mov bx,SEG_DEST
	mov	es,bx	                        	; carga la seccion destino dentro especial segment
	mov	di,OFFSET_DEST	                    ; carga el offset destino dentro destination index
	push cs									; escribe en la pila el code segment
    pop ds									; lee de la pila el data segment
	mov	si,idle                             ; carga el inicio del codigo en source index
	mov	cx,code_size	                    ; Cantidad de bytes a copiar 
	call td3_memcopy	                    ; "call" (ahora si hay stack) 
	jmp	SEG_DEST:OFFSET_DEST	            ; salta a la copia

code_size EQU $ - idle						; calcula el tamaño del codigo a copiar
;_____________________________________________________________________________________________________________
