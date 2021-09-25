; *************************** INICIALIZACION ****************************************
; ********** CODIGO ********************** Comentarios ******************************

%include "inc/procesor-flags.h"

EXTERN STACK_START_16                       ; importo las etiquetas
EXTERN STACK_END_16
EXTERN CS_SEL_32
EXTERN gdtr
EXTERN init_32
EXTERN init_screen
EXTERN  SYS_TABLES_LMA
EXTERN  SYS_TABLES_VMA
EXTERN  SYS_TABLES_SIZE

GLOBAL init16                               ; exporto la etiqueta

USE16
;____________________________________________________________________________________
section .init16 

init16:
;   VERIFICA SI NO HAY FAULT
    test    eax, 0x0                        ; hace una "and" entre los dos operandos
    jne     aqui                            ; jump not equal

;   INVALIDA TLB (Translation lookaside buffer)
    xor     eax, eax
    mov     cr3, eax

;   CARGA EL DS 
    mov     ax, cs                      
    mov     ds, ax                          ; se hace para indicarle al "ldgt" ds:_gdtr                          

; 	MAPEO DE LA PILA
    mov     ax, STACK_START_16
    mov     ss, ax
    mov     sp, STACK_END_16

;   DESHABILTA CACHE
    mov     eax, cr0                        ; copiamos los 32 bits de "CRO" en eax                           
    or      eax, (X86_CR0_NW | X86_CR0_CD)  ; hacemos una "or" entre NW y CD y lo guardamos en "eax"
    mov     cr0, eax
    wbinvd                                  ; limpio cache con WBINWD (Write Back and Invalidate Cache)
                                            ; Devuelve todas las líneas modificadas de la memoria caché interna del procesador a la memoria principal e invalida las cachés internas.
;   tables_copy:
    mov bx, cs
    mov ds, bx
    mov si, SYS_TABLES_LMA
    xor ax, ax
    mov es, ax
    mov di, SYS_TABLES_VMA
    mov cx, SYS_TABLES_SIZE

next:
    movsb
    loop next

    mov eax,0
    mov ds,eax
    
;   CARGA LA GDT
    o32 lgdt    [gdtr] 

;   INICIALIZA LA PANTALLA
    call    init_screen

;   MODO PROTEGIDO (32 BITS)
    smsw    ax                              ; store machine status word, copia en ax los primeros 16 bits CR0.
    or      ax, X86_CR0_PE 
    lmsw    ax                              ; load machine status word, carga los 16 primeros bits del CR0.  
    jmp     dword CS_SEL_32:init_32         ; salta al modo protegido  
                                            ; "jump dword" salta a la direccion apuntado por el valor de la DWORD

aqui:										; Proteccion por si algo sale mal
    hlt										; estado de alta impedancia
    jmp	aqui                                ; Loop infinito
;_____________________________________________________________________________________________________________