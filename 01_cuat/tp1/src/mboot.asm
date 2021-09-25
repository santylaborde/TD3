; *************************************** MAPEO DE ROM *******************************************************
; ********** CODIGO *********************************************** Comentarios ******************************
											
											; En Bytes:     1MB - 64KB
											; En Decimal:   2^20  - 2^16
											; En Hexa:      0x100000 - 0x10000
ORG 0xF0000									; Resultado:    0xF0000 (Origen de nuestra ROM)

USE16										; Directiva para el nasm: Segmentacion de 16 bits (modo real)
code_size EQU (end - init16)				; Tamaño del código generado 


times (65536-code_size) db 0x90				; Rellenamos la ROM con 0x90 (NOP)		
											; Otra opción: times 4096 resb 1

init16:
		cli									; Deshabilita interrupciones
		jmp	init16							; Loop infinito

aqui:
		hlt									; Si por algún motivo sale del loop: HALT
		jmp	aqui							; Solo sale por reset o por interrupción
align 16									; Completa hasta la siguiente dirección múltiplo de 16 

end:

											; Para configurar RAM= 512MB:
											; bochs > 3 > 7 > 1 > 1 > 512 > 512 > esc > 0 > 0 > 4 > enter