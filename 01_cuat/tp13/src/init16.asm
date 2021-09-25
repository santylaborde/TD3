; ******************************* MODO REAL  ****************************************
; ********** CODIGO ********************** Comentarios ******************************

%include "inc/procesor-flags.h"

EXTERN STACK16_START_PHY                   ; importa las etiquetas
EXTERN STACK16_END_PHY
EXTERN CS_SEL
EXTERN gdtr
EXTERN init_32
EXTERN init_screen
EXTERN  SYS_TABLES_LMA
EXTERN  SYS_TABLES_PHY
EXTERN  SYS_TABLES_SIZE

GLOBAL init16                               ; exporta las etiquetas
GLOBAL init_screen_back

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
    mov     ax, STACK16_START_PHY
    mov     ss, ax
    mov     sp, STACK16_END_PHY

;   DESHABILTA CACHE
    mov     eax, cr0                        ; copia los 32 bits de "CRO" en eax                           
    or      eax, (X86_CR0_NW | X86_CR0_CD)  ; hace una "or" entre NW y CD y lo guardamos en "eax"
    mov     cr0, eax
    wbinvd                                  ; limpia cache con WBINWD (Write Back and Invalidate Cache)
                                            ; Devuelve todas las líneas modificadas de la memoria caché interna del procesador a la memoria principal e invalida las cachés internas.
;   COPIA SYSTABLES:
    mov bx, cs
    mov ds, bx
    mov si, SYS_TABLES_LMA
    xor ax, ax
    mov es, ax
    mov di, SYS_TABLES_PHY
    mov cx, SYS_TABLES_SIZE

next:
    movsb
    loop next

    mov eax,0
    mov ds,eax
    
;   CARGA LA GDT
    o32 lgdt [gdtr] 

;   INICIALIZA LA PANTALLA
    jmp init_screen
    init_screen_back:

;   MODO PROTEGIDO (32 BITS)
    smsw    ax                              ; store machine status word, copia en ax los primeros 16 bits CR0.
    or      ax, X86_CR0_PE 
    lmsw    ax                              ; load machine status word, carga los 16 primeros bits del CR0.  
    jmp     dword CS_SEL:init_32            ; salta al modo protegido  
                                            ; "jump dword" salta a la direccion apuntado por el valor de la DWORD

aqui:										; Proteccion por si algo sale mal
    hlt										; estado de alta impedancia
    jmp	aqui                                ; Loop infinito
;_____________________________________________________________________________________________________________