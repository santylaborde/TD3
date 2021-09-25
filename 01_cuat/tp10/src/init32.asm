; *************************** RESET VECTOR ******************************************
; ********** CODIGO ********************** Comentarios ******************************

%include "inc/procesor-flags.h"

EXTERN  CS_SEL_32
EXTERN  DS_SEL
EXTERN  KERNEL_32_INIT

EXTERN  ISR_HANDLER_LMA                     ; importo etiquetas LMA
EXTERN  KERNEL_32_LMA
EXTERN  FUNCTIONS_LMA
EXTERN  ISR_HANDLER_LMA
EXTERN  TASK01_TEXT_LMA

EXTERN  ISR_HANDLER_SIZE                    ; importo etiquetas SIZE
EXTERN  STACK_SIZE_32
EXTERN  KERNEL_32_SIZE
EXTERN  FUNCTIONS_SIZE
EXTERN  ISR_HANDLER_SIZE
EXTERN  TASK01_TEXT_SIZE

EXTERN  STACK_END_32_PHY			        ; importo etiquetas PHYSICAL VMA
EXTERN  KERNEL_32_PHY
EXTERN  FUNCTIONS_PHY
EXTERN  ISR_HANDLER_PHY
EXTERN  PAGING_DPT_PHY
EXTERN  SYS_TABLES_PHY
EXTERN  VIDEO_PHY
EXTERN  DATA_PHY
EXTERN  DIGITS_TABLE_PHY
EXTERN  TASK01_TEXT_PHY
EXTERN  TASK01_BSS_PHY
EXTERN  TASK01_DATA_PHY
EXTERN  TASK01_RODATA_PHY
EXTERN  STACK_START_16_PHY
EXTERN  STACK_START_32_PHY
EXTERN  STACK_TASK01_START_PHY
EXTERN  INIT_16_PHY
EXTERN  INIT_32_PHY
EXTERN  FUNCTIONS_ROM_PHY
EXTERN  RESET_PHY

EXTERN  STACK_END_32_LIN			        ; importo etiquetas LINEAR VMA
EXTERN  KERNEL_32_VMA
EXTERN  FUNCTIONS_VMA
EXTERN  ISR_HANDLER_VMA
EXTERN  PAGING_DPT_VMA
EXTERN  SYS_TABLES_VMA
EXTERN  VIDEO_VMA
EXTERN  DATA_VMA
EXTERN  DIGITS_TABLE_LIN
EXTERN  TASK01_TEXT_VMA
EXTERN  TASK01_BSS_VMA
EXTERN  TASK01_DATA_VMA
EXTERN  TASK01_RODATA_VMA
EXTERN  STACK_START_32_LIN
EXTERN  STACK_TASK01_START_LIN
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
    mov     esp, STACK_END_32_PHY           ; se copia en "esp" el fondo de la pila (expand down)
    xor     eax, eax

;   LIMPIA LA PILA
    mov     ecx, STACK_SIZE_32              ; carga el contador con el tamaño de la pila

init_stack:                                 ; INICIALIZA LA PILA
    push    eax                             ; escribe ceros en la pila
    loop    init_stack                      ; se repite "ecx" veces 
    mov     esp, STACK_END_32_PHY           ; "sp" (stack pointer) apunta nuevamente al final

;   STACK FRAME (DESEMPAQUETA LA ROM)
;   COPIA LAS FUNCIONES EN RAM 
    push    ebp                             ; guarda el valor de "ebp" (base pointer) para no perder la referencia
    mov     ebp, esp                        ; hacemos que ambos apunten a la misma direccion
    push    FUNCTIONS_SIZE                   
    push    FUNCTIONS_PHY
    push    FUNCTIONS_LMA
    call    td3_memcopy                     ; llama a la funcion de copia
    leave                                   ; copia en "esp" el valor de "ebp" recuperando la referencia

    cmp eax, 0                              ; compara el retorno siendo 0 EXITO 
    jne .aqui                               ; si fallo hacemos "halt"

;   COPIA LAS ISR HANDLERS EN RAM 
    push    ebp
    mov     ebp, esp
    push    ISR_HANDLER_SIZE
    push    ISR_HANDLER_PHY
    push    ISR_HANDLER_LMA  
    call    td3_memcopy
    leave

    cmp eax, 0
    jne .aqui

;   COPIA EL KERNEL EN RAM 
    push    ebp
    mov     ebp, esp
    push    KERNEL_32_SIZE
    push    KERNEL_32_PHY
    push    KERNEL_32_LMA  
    call    td3_memcopy
    leave

    cmp eax, 0
    jne .aqui
    
;   COPIA TASK01 TEXT EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK01_TEXT_SIZE
    push    TASK01_TEXT_PHY
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
    push dword(PAGING_DPT_VMA)          ; DPT: Directory page tables
    call set_CR3    
    mov cr3, eax
    leave

;---CARGA LA DPT-----------------------------------------------------------
;   SYSTABLES, FUNCTIONS, PAGING, ISR, STACK16
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
    push 0x00                               ; Entry: 10 bits mas significativos de la VMA
    push dword(PAGING_DPT_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   STACK TASK01 
;   (0x007XXXXX)
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 8KB)
    push 0x001                              ; Entry: 10 bits mas significativos de la VMA
    push dword(PAGING_DPT_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   VIDEO 
;   (0x00E8XXXX)
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 0 (DPT + 16KB)
    push 0x003                              ; Entry: 10 bits mas significativos de la VMA
    push dword(PAGING_DPT_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   DATA, KERNEL, TASK01 
;   (0x010XXXXX a 0x013FXXXX) 
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    push 0x004                              ; Entry: 10 bits mas significativos de la VMA
    push dword(PAGING_DPT_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   STACK 32 
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
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 512KB)
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
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(SYS_TABLES_PHY)          ; Direccion de mapeo
    push 0x00                           ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P5 FUNCTIONS (0x00005000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(FUNCTIONS_PHY)           ; Direccion de mapeo
    push 0x005                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P6 STACK16 (0x00006000)
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
    push 0                              ; G: Global
    push dword(STACK_START_16_PHY)      ; Direccion de mapeo
    push 0x006                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P15 PAGING (0x00010000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(PAGING_DPT_PHY)          ; Direccion de mapeo
    push 0x010                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT0:P255 ISR (0x00100000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(ISR_HANDLER_PHY)         ; Direccion de mapeo
    push 0x100                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1:P911 STACK TASK01 (0x0078F000)
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
    push 0                              ; G: Global
    push dword(STACK_TASK01_START_PHY)  ; Direccion de mapeo
    push 0x38F                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 8KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT3:P640 VIDEO (0x00E80000)
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
    push 0                              ; G: Global
    push dword(VIDEO_PHY)               ; Direccion de mapeo
    push 0x280                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 0 (DPT + 16KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT4:P256 DATA (0x01200000)
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
    push 0                              ; G: Global
    push dword(DATA_PHY)                ; Direccion de mapeo
    push 0x200                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave        

;   PT4:P272 DIGITS_TABLE (0x01210000)
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
    push 0                              ; G: Global
    push dword(DIGITS_TABLE_PHY)        ; Direccion de mapeo
    push 0x210                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT4:P288 KERNEL (0x01220000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(KERNEL_32_PHY)           ; Direccion de mapeo
    push 0x220                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT4:P784 TASK01_TEXT (0x01310000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(TASK01_TEXT_PHY)         ; Direccion de mapeo
    push 0x310                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT4:P799 TASK01_BSS (0x01320000)
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
    push 0                              ; G: Global
    push dword(TASK01_BSS_PHY)          ; Direccion de mapeo
    push 0x320                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT4:P815 TASK01_DATA (0x01330000)
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
    push 0                              ; G: Global
    push dword(TASK01_DATA_PHY)         ; Direccion de mapeo
    push 0x330                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT4:P832 TASK01_RODATA (0x01340000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(TASK01_RODATA_PHY)       ; Direccion de mapeo
    push 0x340                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT126:P1016 STACK32 (0x1FFF8000)
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
    push 0                              ; G: Global
    push dword(STACK_START_32_PHY)      ; Direccion de mapeo
    push 0x3F8                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 512KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1022:P1016 ROM:INIT16 (0xFFFF8000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(INIT_16_PHY)             ; Direccion de mapeo
    push 0x3F8                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1022:P1017 ROM:INIT16 (0xFFFF9000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(INIT_16_PHY+0x1000)      ; Direccion de mapeo
    push 0x3F9                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT1022:P1018 ROM:INIT_32 (0xFFFFA000)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(INIT_32_PHY)             ; Direccion de mapeo
    push 0x3FA                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1023:P1020 ROM:FUNCTIONS_ROM (0xFFFFFC00)
    push ebp
    mov ebp, esp
    push 1                              ; P: Presence
    push 0                              ; RW: Read and Write
    push 0                              ; US: User or Supervisor
    push 0                              ; PWT: Page level write through
    push 0                              ; PCD: Page level cache disable 
    push 0                              ; A: Accessed
    push 0                              ; D: Dirty
    push 0                              ; PAT: Page table attribute
    push 0                              ; G: Global
    push dword(FUNCTIONS_ROM_PHY)       ; Direccion de mapeo
    push 0x3FC                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1023:P1021 ROM:SYS_TABLES (0xFFFFFD00) 
;    push ebp
;    mov ebp, esp
;    push 1                              ; P: Presence
;    push 0                              ; RW: Read and Write
;    push 0                              ; US: User or Supervisor
;    push 0                              ; PWT: Page level write through
;    push 0                              ; PCD: Page level cache disable 
;    push 0                              ; A: Accessed
;    push 0                              ; D: Dirty
;    push 0                              ; PAT: Page table attribute
;    push 0                              ; G: Global
;    push dword(SYS_TABLES_PHY)          ; Direccion de mapeo
;    push 0x3FD                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
;    push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
;    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
;    leave 
 
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
;   push dword(RESET_PHY)               ; Direccion de mapeo
;   push 0x3FF                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
;   push dword(PAGING_DPT_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
;   call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
;   leave

;---HABILITA PAGINACION-----------------------------------------------------
    mov eax, cr0
    or eax, X86_CR0_PG
    mov cr0, eax

;   SALTAMOS A FUNCION PRINCIPAL
    jmp CS_SEL_32:KERNEL_32_INIT        ; El salto a la direccion VMA Lineal 0x01220000           

.aqui:
    hlt
    jmp .aqui
;____________________________________________________________________________________

