; *************************** RESET VECTOR ******************************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL KERNEL_32_INIT                       ;exporto etiqueta

EXTERN CS_SEL_32
EXTERN DIGITS

KEY_Y	EQU	0x15
KEY_U	EQU	0x16
KEY_I	EQU	0x17
KEY_O 	EQU	0x18
KEY_F	EQU	0x21


USE32
;____________________________________________________________________________________
section .kernel32
KERNEL_32_INIT:
    jmp     keyboard

idle:
    hlt
    jmp     idle
;____________________________________________________________________________________

;____________________________________________________________________________________
section isr_keyboard

keyboard:
	mov 	esi,DIGITS	        	 		;Cargo el inicio de la tabla 
	xor 	edi,edi                			;Limpio el offset

Polling:
;	Consulta el estado del teclado
	in 		al,0x60							;Leo tecla del buffer de teclado
	bt 		eax,0x07               			;Si hay un 1 en el bit 7 significa que fue de soltar
	jc 		Polling 						;Salto a Chequeo_Tecla si hay carry 


TablaDigitos:
;	Guarda en la tabla
	mov 	[esi+edi],al 					; Mueve el valor al puntero correspondiente
	inc 	di  									

	U: 										; U = #UD (Interrupt 6—Invalid Opcode Exception)
		cmp al,KEY_U 			
		jne I 					
		dw  0xFFFF        					; Genera un opcode invalido
		hlt

	I: 										; I = #DF (Interrupt 8—Double Fault Exception)
		cmp al,KEY_I 			
		jne F 					
		mov ax,CS_SEL_32		
		mov ss,ax
		hlt

	F: 										; F = Fin del programa
		cmp al,KEY_F			
		jne Polling 			
		jmp idle 		    
