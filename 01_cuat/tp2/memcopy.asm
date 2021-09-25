global td3_memcopy

; *************************************** MAPEO DE ROM *******************************************************
; ********** CODIGO *********************************************** Comentarios ******************************
											
											; En Bytes:     1MB - 64KB
											; En Decimal:   2^20  - 2^16
											; En Hexa:      0x100000 - 0x10000
ORG 0xF0000									; Resultado:    0xF0000 (Origen de nuestra ROM)

USE16										; Directiva para el nasm: Segmentacion de 16 bits (modo real)
code_size EQU (end - idle)				    ; Tamaño del código generado 


times (65536-code_size) db 0x90				; Rellenamos la ROM con 0x90 (NOP)		
											; Otra opción: times 4096 resb 1

; ****************************************** MEMCOPY *********************************************************
; ********** CODIGO *********************************************** Comentarios ******************************
; Subrutina: memcopy
; Recibe:
; es:di la dirección lógica de destino (a donde quiero copiar)
; ds:si la dirección lógica de origen (lo que quiero copiar)
; cx la cantidad de bytes a copiar
; Retorna:
; NULL si hubo error
; puntero a la dirección de inicio de la nueva copia

idle:										; Bloque para esperar luego de hacer la copia 
	hlt										; estado de alta impedancia
	jmp	idle								; Loop infinito

init:										; inicializa los registros 
	xor	bx,bx		                        ; se pone "bx" en 0 
	mov	es,bx		                        ; se pone "es" en 0 (inicializacion indirecta para los de segmento)
	mov	di,0x00000	                        ; Offset dentro del segmento destino (item A)
;   mov	di,0xF0000	                        ; Offset dentro del segmento destino (item B)
	mov	si,idle                             ; Offset dentro del segmento origen
	mov	cx,code_size	                    ; Cantidad de bytes a copiar (parte útil de la ROM)
; Se pueden obviar las siguientes 2 lineas y usamos secuencialidad
;	mov	bx,td3_memcopy	                    ; Como no se ha inicializado la RAM aun....
;	jmp	bx		                            ; saltamos en vez de usar call (no hay stack) 

td3_memcopy:	
	cld										; Clear Direction Flag
											; CLD auto incrementa el DI
											; SLD auto decrementa el DI

next:
	mov	al,byte[cs:si]	                    ; entramos por secuencialidad
	stosb			                        ; guarda AL en ES:DI , DI++
	inc 	si		                        ; apuntamos al siguiente byte en la ROM
	loop	next		                    ; cx--, if(FLAGS.ZF==0) goto next 
; Se pueden obviar las siguientes 2 lineas y usamos secuencialidad
;	mov	bx,ret0
;	jmp 	bx

ret0:
	jmp	0x0:0x00000	                        ; saltamos a la copia
;	jmp	0x0:0xF0000	                        ; saltamos a la copia
; salto FAR. Se modifica el "CS" y dejamos de tener la ventaja que nos da intel en el arranque. 
; La ventaja era que nos dejaba acceder mucho más del 1MB.

align 16									; Completa hasta la siguiente dirección múltiplo de 16 

init16:				
	cli										; Deshabilita interrupciones
	jmp	init								; Vamos al bloque de inicializacion
					
aqui:										; Proteccion por si algo sale mal
	hlt										; estado de alta impedancia
	jmp	aqui								; Loop infinito

align 16									; Completa hasta la siguiente dirección múltiplo de 16 

end:										; hasta aca vamos a copiar

; Notas:

; Item A: cuando copiamos codigo de lineal address 0xFFFFFFC0 (ROM) a 0x00000000 (RAM), 
; 		  al llegar al final de los 512MB de RAM seteados comienza el inicio de la memoria de vuelta. Es un ciclo.

; Item B: no se puede realizar ya que hay una proteccion que no nos deja copiar sobre la ROM.