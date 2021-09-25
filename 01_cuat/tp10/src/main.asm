; *************************** RESET VECTOR ******************************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL KERNEL_32_INIT                       ;exporto etiqueta

EXTERN RING_BUFFER_LIN
EXTERN ring_buffer_init

EXTERN DIGITS_TABLE_LIN
EXTERN digits_table_init

EXTERN scheduler_C
EXTERN TIMER_LIN

EXTERN VIDEO_VMA
EXTERN screen_init

USE32
;____________________________________________________________________________________
section .kernel32

KERNEL_32_INIT:
init_keyboard:
    push ebp
    mov ebp, esp
	push RING_BUFFER_LIN
    call ring_buffer_init
	leave

init_digits_table:
    push ebp
    mov ebp, esp
    push DIGITS_TABLE_LIN
    call digits_table_init        
    leave

init_screen:
    push ebp
    mov ebp, esp
    push VIDEO_VMA
    call screen_init         
    leave

scheduler: 
    hlt
    push ebp
    mov ebp, esp
    push TIMER_LIN
    push DIGITS_TABLE_LIN
    call scheduler_C
    leave 
    jmp scheduler

idle:
    hlt
    jmp idle
;____________________________________________________________________________________