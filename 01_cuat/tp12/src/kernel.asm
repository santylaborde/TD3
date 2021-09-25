; *************************** KERNEL (MAIN) *****************************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL KERNEL_32_INIT                       ; exporta etiqueta
        
EXTERN RING_BUFFER_VMA                      ; importa etiquetas
EXTERN ring_buffer_init

EXTERN DIGITS_TABLE_VMA
EXTERN digits_table_init

EXTERN VIDEO_VMA
EXTERN screen_init

EXTERN task_01_C            
EXTERN task_02_C
EXTERN task_03_C
EXTERN task_04_C

EXTERN TASK01_TSS_VMA
EXTERN TASK02_TSS_VMA
EXTERN TASK03_TSS_VMA
EXTERN TASK04_TSS_VMA

EXTERN TASK01_TEXT_VMA
EXTERN TASK02_TEXT_VMA
EXTERN TASK03_TEXT_VMA
EXTERN TASK04_TEXT_VMA

EXTERN DS_SEL
EXTERN CS_SEL_32
EXTERN STACK_TASK01_END_VMA
EXTERN STACK_TASK02_END_VMA
EXTERN STACK_TASK03_END_VMA
EXTERN STACK_TASK04_END_VMA

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
    push TASK01_TEXT_VMA
    push STACK_TASK01_END_VMA
    call init_my_TSS         
    leave

;   TASK02
    push ebp
    mov ebp, esp
    push TASK02_TSS_VMA
    push TASK02_TEXT_VMA
    push STACK_TASK02_END_VMA
    call init_my_TSS         
    leave

;   TASK03
    push ebp
    mov ebp, esp
    push TASK03_TSS_VMA
    push TASK03_TEXT_VMA
    push STACK_TASK03_END_VMA
    call init_my_TSS         
    leave

;   TASK04
    push ebp
    mov ebp, esp
    push TASK04_TSS_VMA
    push TASK04_TEXT_VMA
    push STACK_TASK04_END_VMA
    call init_my_TSS         
    leave

;   HABILITA INTERRUPCIONES
    sti    

while1: 
    jmp while1

idle:
    hlt
    jmp idle

init_my_TSS:
;   RECIBO PARAMETROS
    mov eax, [esp+12]                           ; Push 1: TASK0X_TSS_VMA             
    mov ebx, [esp+08]                           ; Push 2: task0X_asm
    mov ecx, [esp+04]                           ; Push 3: STACK_TASK0X_END_VMA
;   REGISTROS PROPOSITO GENERAL                 ; Reserva memoria para:
    mov [eax + 4*00], dword(0)                  ; eax  
    mov [eax + 4*01], dword(0)                  ; ebx
    mov [eax + 4*02], dword(0)                  ; ecx
    mov [eax + 4*03], dword(0)                  ; edx
    mov [eax + 4*04], dword(0)                  ; esi
    mov [eax + 4*05], dword(0)                  ; edi
    mov [eax + 4*06], dword(0)                  ; ebp
    mov [eax + 4*07], ecx                       ; esp
;   INSTRUCTION POINTER
    mov [eax + 4*08], ebx                       ; eip
;   EFLAGS
    mov [eax + 4*09], dword(0x202)              ; eflags
;   REGISTROS DE SEGMENTO
    mov [eax + 4*10], dword(CS_SEL_32)          ; cs
    mov [eax + 4*11], dword(DS_SEL)             ; ds
    mov [eax + 4*12], dword(DS_SEL)             ; es
    mov [eax + 4*13], dword(DS_SEL)             ; ss
    mov [eax + 4*14], dword(DS_SEL)             ; fs
    mov [eax + 4*15], dword(DS_SEL)             ; gs
    ret
;____________________________________________________________________________________