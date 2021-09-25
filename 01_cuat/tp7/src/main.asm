; *************************** RESET VECTOR ******************************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL KERNEL_32_INIT                       ;exporto etiqueta

EXTERN RING_BUFFER
EXTERN ring_buffer_init

EXTERN DIGITS_TABLE
EXTERN digits_table_init

EXTERN scheduler_C
EXTERN TIMER

EXTERN VIDEO_VGA
EXTERN screen_init

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


init_digits_table:
    push ebp
    mov ebp, esp
    push DIGITS_TABLE
    call digits_table_init        
    leave

init_screen:
    push ebp
    mov ebp, esp
    push VIDEO_VGA
    call screen_init         
    leave

scheduler: 
    hlt
    push ebp
    mov ebp, esp
    push TIMER
    push DIGITS_TABLE
    call scheduler_C
    leave 
    jmp scheduler

idle:
    hlt
    jmp idle
;____________________________________________________________________________________