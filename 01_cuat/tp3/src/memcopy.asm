; *************************** INICIALIZACION ****************************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL td3_memcopy							;exporto etiqueta

USE16
;____________________________________________________________________________________
section .FUNCTION
td3_memcopy:	
	cld										; Clear Direction Flag
											; CLD auto incrementa el DI
											; SLD auto decrementa el DI
next:
	mov	al,byte[cs:si]	                    ; entra por secuencialidad
	stosb			                        ; guarda AL en ES:DI , DI++
	inc 	si		                        ; apunta al siguiente byte en la ROM
	loop	next		                    ; cx--, if(FLAGS.ZF==0) goto next
	ret 
;____________________________________________________________________________________
