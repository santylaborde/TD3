; *************************** RESET VECTOR ******************************************
; ********** CODIGO ********************** Comentarios ******************************

EXTERN  STACK_END_32 	  			        ; importo etiqueta
EXTERN  STACK_SIZE_32
EXTERN  CS_SEL_32
EXTERN  DS_SEL
EXTERN  KERNEL_32_INIT
EXTERN  KERNEL_32_LMA
EXTERN  KERNEL_32_VMA
EXTERN  KERNEL_32_SIZE
EXTERN  FUNCTION_LMA
EXTERN  FUNCTION_VMA
EXTERN  FUNCTION_SIZE
EXTERN  SYS_TABLES_LMA
EXTERN  SYS_TABLES_VMA
EXTERN  SYS_TABLES_SIZE
EXTERN  ISR_HANDLER_LMA
EXTERN  ISR_HANDLER_VMA
EXTERN  ISR_HANDLER_SIZE
EXTERN  td3_memcopy
EXTERN  idtr
EXTERN  init_pic

GLOBAL init_32                              ; exporto etiqueta

USE32

;____________________________________________________________________________________
section .init32

init_32:
;   INICIALIZA LOS DATA SEGMENTS
    mov     ax, DS_SEL                      ; copia a "ax" el DS (describe toda la memoria)
    mov     ds, ax                          
    mov     es, ax                         
    mov     gs, ax                          
    mov     fs, ax                          

; 	MAPEO DE LA PILA 32 BITS
    mov     ss,ax                           ; inicializa el "ss" (stack pointer)
    mov     esp, STACK_END_32               ; se copia en "esp" el fondo de la pila (expand down)
    xor     eax, eax

;   LIMPIA LA PILA
    mov     ecx, STACK_SIZE_32              ; carga el contador con el tamaño de la pila

init_stack:                                 ; INICIALIZA LA PILA
    push    eax                             ; escribe ceros en la pila
    loop    init_stack                     ; se repite "ecx" veces 
    mov     esp, STACK_END_32               ; "sp" (stack pointer) apunta nuevamente al final

;   STACK FRAME (DESEMPAQUETA LA ROM)
;   COPIA LAS FUNCIONES EN RAM 
    push    ebp                             ; guarda el valor de "ebp" (base pointer) para no perder la referencia
    mov     ebp, esp                        ; hacemos que ambos apunten a la misma direccion
    push    FUNCTION_SIZE                   
    push    FUNCTION_VMA
    push    FUNCTION_LMA
    call    td3_memcopy                     ; llama a la funcion de copia
    leave                                   ; copia en "esp" el valor de "ebp" recuperando la referencia

    cmp eax, 0                              ; compara el retorno siendo 0 EXITO 
    jne .aqui                               ; si fallo hacemos "halt"

;   COPIA LAS SYSTABLES EN RAM
    push    ebp
    mov     ebp, esp
    push    SYS_TABLES_SIZE
    push    SYS_TABLES_VMA
    push    SYS_TABLES_LMA
    call    td3_memcopy
    leave

    cmp eax, 0
    jne .aqui

;   COPIA LAS ISR HANDLERS EN RAM 
    push    ebp
    mov     ebp, esp
    push    ISR_HANDLER_SIZE
    push    ISR_HANDLER_VMA
    push    ISR_HANDLER_LMA  
    call td3_memcopy
    leave

    cmp eax, 0
    jne .aqui

;   COPIA EL KERNEL EN RAM 
    push    ebp
    mov     ebp, esp
    push    KERNEL_32_SIZE
    push    KERNEL_32_VMA
    push    KERNEL_32_LMA  
    call td3_memcopy
    leave

    cmp eax, 0
    jne .aqui
    
;   CARGA LA IDT
    lidt    [idtr] 

;   INICIALIZA EL PIC
    call    init_pic 

;   HABILITA INTERRUPCIONES
    sti    

;   SALTAMOS A FUNCION PRINCIPAL
    jmp CS_SEL_32:KERNEL_32_INIT           

.aqui:
    hlt
    jmp .aqui
;____________________________________________________________________________________

