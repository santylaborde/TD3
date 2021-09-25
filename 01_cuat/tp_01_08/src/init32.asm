; *************************** RESET VECTOR ******************************************
; ********** CODIGO ********************** Comentarios ******************************

%include "inc/procesor-flags.h"

EXTERN  STACK_END_32 	  			        ; importo etiqueta
EXTERN  STACK_SIZE_32
EXTERN  CS_SEL_32
EXTERN  DS_SEL
EXTERN  KERNEL_32_INIT
EXTERN  KERNEL_32_LMA
EXTERN  KERNEL_32_VMA
EXTERN  KERNEL_32_SIZE
EXTERN  FUNCTIONS_LMA
EXTERN  FUNCTIONS_VMA
EXTERN  FUNCTIONS_SIZE
EXTERN  ISR_HANDLER_LMA
EXTERN  ISR_HANDLER_VMA
EXTERN  ISR_HANDLER_SIZE
EXTERN  PAGING_DPT_VMA
EXTERN  SYS_TABLES_VMA
EXTERN  VIDEO_VMA
EXTERN  DATA_VMA
EXTERN  DIGITS_TABLE
EXTERN  TASK01_TEXT_LMA
EXTERN  TASK01_TEXT_VMA
EXTERN  TASK01_TEXT_SIZE
EXTERN  TASK01_BSS_VMA
EXTERN  TASK01_DATA_VMA
EXTERN  TASK01_RODATA_VMA
EXTERN  STACK_START_32
EXTERN  STACK_TASK01_START
EXTERN  INIT_16_VMA
EXTERN  INIT_32_VMA
EXTERN  FUNCTIONS_ROM_VMA
EXTERN  RESET_VMA

EXTERN  td3_memcopy                         ; importo funciones
EXTERN  idtr
EXTERN  gdtr
EXTERN  init_pic
EXTERN  init_pit
EXTERN  set_CR3
EXTERN  set_PDE
EXTERN  set_PTE

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
    loop    init_stack                      ; se repite "ecx" veces 
    mov     esp, STACK_END_32               ; "sp" (stack pointer) apunta nuevamente al final

;   STACK FRAME (DESEMPAQUETA LA ROM)
;   COPIA LAS FUNCIONES EN RAM 
    push    ebp                             ; guarda el valor de "ebp" (base pointer) para no perder la referencia
    mov     ebp, esp                        ; hacemos que ambos apunten a la misma direccion
    push    FUNCTIONS_SIZE                   
    push    FUNCTIONS_VMA
    push    FUNCTIONS_LMA
    call    td3_memcopy                     ; llama a la funcion de copia
    leave                                   ; copia en "esp" el valor de "ebp" recuperando la referencia

    cmp eax, 0                              ; compara el retorno siendo 0 EXITO 
    jne .aqui                               ; si fallo hacemos "halt"

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

;   COPIA TASK01 TEXT EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK01_TEXT_SIZE
    push    TASK01_TEXT_VMA
    push    TASK01_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne .aqui
    
;   CARGA LA IDT
    lidt    [idtr] 

;   INICIALIZA EL PIC
    call    init_pic 

;   INICIALIZA EL PIT
    call    init_pit 

;   HABILITA INTERRUPCIONES
    sti    

;   PAGINACION
;---INICIALIZA CR3---------------------------------------------------------
    push ebp
    mov ebp, esp
    push 1                                  ; PWT: Page level write through
    push 1                                  ; PCD: Page level cache disable 
    push dword(PAGING_DPT_VMA)              ; DPT: Directory page tables
    call set_CR3    
    mov cr3, eax
    leave

;---CARGA LA DPT-----------------------------------------------------------
;   SYSTABLES, FUNCTIONS, PAGING, VIDEO, ISR, DATA, KERNEL & TASK01
;   (0x000XXXXX a 0x003XXXXX) 
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(PAGING_DPT_VMA+0x1000)       ; PT0: Page table 0 (DPT + 4KB)
    push 0x000                              ; Entry: 10 bits mas significativos de la VMA
    push dword(PAGING_DPT_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   STACK 32 & STACK TASK01 
;   (0x1FFXXXXX)
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 508KB)
    push 0x07F                              ; Entry: 10 bits mas significativos de la VMA
    push dword(PAGING_DPT_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   ROM: INIT16, INIT32, FUNCTIONS_ROM & RESET 
;   (0xFFFXXXXX)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; PS: Page Size (4KB)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4092KB)
    push 0x3FF                          ; Entry: 10 bits mas significativos de la VMA
    push dword(PAGING_DPT_VMA)          ; DPT: Directory page tables
    call set_PDE                        ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;---CARGA LAS PT------------------------------------------------------------
;   PT0:P0 SYSTABLE (0x00000000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(SYS_TABLES_VMA)          ; Direccion de mapeo
    push 0x00                           ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P5 FUNCTIONS (0x00005000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(FUNCTIONS_VMA)           ; Direccion de mapeo
    push 0x005                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P15 PAGING (0x00010000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(PAGING_DPT_VMA)          ; Direccion de mapeo
    push 0x010                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P183 VIDEO (0x000B8000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(VIDEO_VMA)               ; Direccion de mapeo
    push 0x0B8                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P255 ISR (0x00100000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(ISR_HANDLER_VMA)         ; Direccion de mapeo
    push 0x100                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P511 DATA (0x00200000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(DATA_VMA)                ; Direccion de mapeo
    push 0x200                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave        

;   PT0:P527 DIGITS_TABLE (0x00210000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(DIGITS_TABLE)            ; Direccion de mapeo
    push 0x210                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT0:P543 KERNEL (0x00220000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(KERNEL_32_VMA)           ; Direccion de mapeo
    push 0x220                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P783 TASK01_TEXT (0x00310000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(TASK01_TEXT_VMA)         ; Direccion de mapeo
    push 0x310                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P799 TASK01_BSS (0x00320000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(TASK01_BSS_VMA)          ; Direccion de mapeo
    push 0x320                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P815 TASK01_DATA (0x00330000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(TASK01_DATA_VMA)         ; Direccion de mapeo
    push 0x330                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P832 TASK01_RODATA (0x00340000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(TASK01_RODATA_VMA)       ; Direccion de mapeo
    push 0x340                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT127:P1015 STACK32 (0x1FFF8000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(STACK_START_32)          ; Direccion de mapeo
    push 0x3F8                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 508KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT127:P1022 STACK TASK01 (0x1FFFF000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(STACK_TASK01_START)      ; Direccion de mapeo
    push 0x3FF                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 508KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1023:P1015 ROM:INIT16 (0xFFFF8000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(INIT_16_VMA)             ; Direccion de mapeo
    push 0x3F8                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4092KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1023:P1017 ROM:INIT16 (0xFFFF9000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(INIT_16_VMA*0x1000)      ; Direccion de mapeo
    push 0x3F9                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4092KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT1023:P1017 ROM:INIT_32 (0xFFFFA000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(INIT_32_VMA)             ; Direccion de mapeo
    push 0x3FA                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4092KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1023:P1019 ROM:FUNCTIONS_ROM (0xFFFFFC00)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 1                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 1                              ; G: Global
    push dword(FUNCTIONS_ROM_VMA)       ; Direccion de mapeo
    push 0x3FC                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4092KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1023:P1022 ROM:SYS_TABLES (0xFFFFFD00) 
;   push ebp
;   mov ebp, esp
;   push 1                              ; P: Presence
;   push 0                              ; RW: Read and Write
;   push 0                              ; US: User or Supervisor
;   push 0                              ; PWT: Page level write through
;   push 0                              ; PCD: Page level cache disable 
;   push 0                              ; A: Accessed
;   push 0                              ; D: Dirty
;   push 0                              ; PAT: Page table attribute
;   push 0                              ; G: Global
;   push dword(SYS_TABLES_VMA)          ; Direccion de mapeo
;   push 0x3FD                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
;   push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4092KB)
;   call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
;   leave 


;   PT1023:P1023 ROM:RESET (0xFFFFFFF0) 
;   push ebp
;   mov ebp, esp
;   push 1                              ; P: Presence
;   push 0                              ; RW: Read and Write
;   push 0                              ; US: User or Supervisor
;   push 0                              ; PWT: Page level write through
;   push 0                              ; PCD: Page level cache disable 
;   push 0                              ; A: Accessed
;   push 0                              ; D: Dirty
;   push 0                              ; PAT: Page table attribute
;   push 0                              ; G: Global
;   push dword(RESET_VMA)               ; Direccion de mapeo
;   push 0x3FF                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
;   push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4092KB)
;   call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
;   leave 




;---HABILITA PAGINACION-----------------------------------------------------
    mov eax, cr0
    or eax, X86_CR0_PG
    mov cr0, eax
    xchg bx,bx

;   SALTAMOS A FUNCION PRINCIPAL
    jmp CS_SEL_32:KERNEL_32_INIT           

.aqui:
    hlt
    jmp .aqui
;____________________________________________________________________________________

