; *************************** RESET VECTOR ******************************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL KERNEL_32_INIT                       ;exporto etiqueta

EXTERN RING_BUFFER
EXTERN ring_buffer_init

;EXTERN DIGIT_TABLE_START
;EXTERN digits_table_init


USE32
;____________________________________________________________________________________
section .kernel32

KERNEL_32_INIT:
init_keyboard:
    push ebp
    mov ebp, esp
	push RING_BUFFER
    call ring_buffer_init
	leave


;init_digits_table:
;    push DIGIT_TABLE_START
;    call digits_table_init        
;    leave
 

while1:
	jmp while1

idle:
    hlt
    jmp idle
;____________________________________________________________________________________