; *************************** KERNEL (MAIN) *****************************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL KERNEL_32_INIT                       ; exporta etiqueta
GLOBAL while1
        
EXTERN RING_BUFFER_VMA                      ; importa etiquetas
EXTERN ring_buffer_init

EXTERN DIGITS_TABLE_VMA
EXTERN digits_table_init

EXTERN VIDEO_VMA
EXTERN screen_init

EXTERN init_basic_TSS
EXTERN init_my_TSS_lvl00
EXTERN init_my_TSS_lvl03

EXTERN TASK01_TSS_VMA
EXTERN TASK02_TSS_VMA
EXTERN TASK03_TSS_VMA
EXTERN TASK04_TSS_VMA

EXTERN task_01_C            
EXTERN task_02_C
EXTERN task_03_C
EXTERN task_04_C

EXTERN DPT_TASK01_VMA
EXTERN DPT_TASK02_VMA
EXTERN DPT_TASK03_VMA
EXTERN DPT_TASK04_VMA

EXTERN STACK_TASK01_END_VMA
EXTERN STACK_TASK02_END_VMA
EXTERN STACK_TASK03_END_VMA
EXTERN STACK_TASK04_END_VMA

EXTERN STACK32_T1_END_VMA
EXTERN STACK32_T2_END_VMA
EXTERN STACK32_T3_END_VMA
EXTERN STACK32_T4_END_VMA


USE32
;____________________________________________________________________________________
section .kernel32

KERNEL_32_INIT:
init_keyboard:
    push ebp
    mov ebp, esp
	push RING_BUFFER_VMA
    call ring_buffer_init
	leave

init_digits_table:
    push ebp
    mov ebp, esp
    push DIGITS_TABLE_VMA
    call digits_table_init        
    leave

init_screen:
    push ebp
    mov ebp, esp
    push VIDEO_VMA
    call screen_init         
    leave

init_TSS:
;   TASK01
    push ebp
    mov ebp, esp
    push TASK01_TSS_VMA
    push task_01_C
    push STACK_TASK01_END_VMA-5*04
    push STACK32_T1_END_VMA-5*04
    push DPT_TASK01_VMA
    call init_my_TSS_lvl03         
    leave

;   TASK02
    push ebp
    mov ebp, esp
    push TASK02_TSS_VMA
    push task_02_C
    push STACK_TASK02_END_VMA-5*04
    push STACK32_T2_END_VMA-5*04
    push DPT_TASK02_VMA
    call init_my_TSS_lvl03         
    leave

;   TASK03
    push ebp
    mov ebp, esp
    push TASK03_TSS_VMA
    push task_03_C
    push STACK_TASK03_END_VMA-5*04
    push STACK32_T3_END_VMA-5*04
    push DPT_TASK03_VMA
    call init_my_TSS_lvl03         
    leave

;   TASK04
    push ebp
    mov ebp, esp
    push TASK04_TSS_VMA
    push task_04_C
    push STACK_TASK04_END_VMA-5*04
    push STACK32_T4_END_VMA-5*04
    push DPT_TASK04_VMA
    call init_my_TSS_lvl00              ; ENUNCIADO PIDE NIVEL 0
;   call init_my_TSS_lvl03         
    leave

;   KERNEL
    push ebp
    mov ebp, esp
    call init_basic_TSS  
;   call init_my_TSS_lvl00              ; PODRIA SIMPLIFICAR EN 1 SOLA FUNCION...
    leave

;   HABILITA INTERRUPCIONES
    sti    

while1: 
    hlt
    jmp while1

idle:
    hlt
    jmp idle
;____________________________________________________________________________________