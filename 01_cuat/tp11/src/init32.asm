; ******************************* MODO PROTEGIDO  ***********************************
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
EXTERN  TASK02_TEXT_LMA
EXTERN  TASK03_TEXT_LMA
EXTERN  TASK04_TEXT_LMA

EXTERN  ISR_HANDLER_SIZE                    ; importo etiquetas SIZE
EXTERN  STACK_SIZE_32
EXTERN  KERNEL_32_SIZE
EXTERN  FUNCTIONS_SIZE
EXTERN  ISR_HANDLER_SIZE
EXTERN  TASK01_TEXT_SIZE
EXTERN  TASK02_TEXT_SIZE
EXTERN  TASK03_TEXT_SIZE
EXTERN  TASK04_TEXT_SIZE

EXTERN  STACK_END_32_PHY			        ; importo etiquetas PHYSICAL
EXTERN  KERNEL_32_PHY
EXTERN  FUNCTIONS_PHY
EXTERN  ISR_HANDLER_PHY
EXTERN  DPT_KERNEL_PHY
EXTERN  SYS_TABLES_PHY
EXTERN  VIDEO_PHY
EXTERN  DATA_PHY
EXTERN  DIGITS_TABLE_PHY
EXTERN  STACK_START_16_PHY
EXTERN  STACK_START_32_PHY
EXTERN  STACK_TASK01_START_PHY
EXTERN  STACK_TASK02_START_PHY
EXTERN  STACK_TASK03_START_PHY
EXTERN  STACK_TASK04_START_PHY
EXTERN  INIT_16_PHY
EXTERN  INIT_32_PHY
EXTERN  FUNCTIONS_ROM_PHY
EXTERN  RESET_PHY
EXTERN  TASK01_TEXT_PHY
EXTERN  TASK01_BSS_PHY
EXTERN  TASK01_DATA_PHY
EXTERN  TASK01_RODATA_PHY
EXTERN  TASK01_TSS_PHY
EXTERN  TASK02_TEXT_PHY
EXTERN  TASK02_BSS_PHY
EXTERN  TASK02_DATA_PHY
EXTERN  TASK02_RODATA_PHY
EXTERN  TASK02_TSS_PHY
EXTERN  TASK03_TEXT_PHY
EXTERN  TASK03_BSS_PHY
EXTERN  TASK03_DATA_PHY
EXTERN  TASK03_RODATA_PHY
EXTERN  TASK03_TSS_PHY
EXTERN  TASK04_TEXT_PHY
EXTERN  TASK04_BSS_PHY
EXTERN  TASK04_DATA_PHY
EXTERN  TASK04_RODATA_PHY
EXTERN  TASK04_TSS_PHY
EXTERN  DPT_TASK01_PHY
EXTERN  DPT_TASK02_PHY
EXTERN  DPT_TASK03_PHY
EXTERN  DPT_TASK04_PHY

EXTERN  STACK_END_32_VMA			        ; importo etiquetas LINEAR
EXTERN  KERNEL_32_VMA
EXTERN  FUNCTIONS_VMA
EXTERN  ISR_HANDLER_VMA
EXTERN  SYS_TABLES_VMA
EXTERN  VIDEO_VMA
EXTERN  DATA_VMA
EXTERN  DIGITS_TABLE_VMA
EXTERN  TASK01_TEXT_VMA
EXTERN  TASK01_BSS_VMA
EXTERN  TASK01_DATA_VMA
EXTERN  TASK01_RODATA_VMA
EXTERN  STACK_START_32_VMA
EXTERN  STACK_TASK01_START_VMA
EXTERN  INIT_16_VMA
EXTERN  INIT_32_VMA
EXTERN  FUNCTIONS_ROM_VMA
EXTERN  RESET_VMA
EXTERN  DPT_KERNEL_VMA
EXTERN  DPT_TASK01_VMA
EXTERN  DPT_TASK02_VMA
EXTERN  DPT_TASK03_VMA
EXTERN  DPT_TASK04_VMA

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
    jne aqui                               ; si fallo hacemos "halt"

;   COPIA LAS ISR HANDLERS EN RAM 
    push    ebp
    mov     ebp, esp
    push    ISR_HANDLER_SIZE
    push    ISR_HANDLER_PHY
    push    ISR_HANDLER_LMA  
    call    td3_memcopy
    leave

    cmp eax, 0
    jne aqui

;   COPIA EL KERNEL EN RAM 
    push    ebp
    mov     ebp, esp
    push    KERNEL_32_SIZE
    push    KERNEL_32_PHY
    push    KERNEL_32_LMA  
    call    td3_memcopy
    leave

    cmp eax, 0
    jne aqui

;******** TASK01 ********
;   COPIA TASK01 TEXT EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK01_TEXT_SIZE
    push    TASK01_TEXT_PHY
    push    TASK01_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK01 BSS EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK01_TEXT_SIZE
    push    TASK01_TEXT_PHY
    push    TASK01_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK01 DATA EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK01_TEXT_SIZE
    push    TASK01_TEXT_PHY
    push    TASK01_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK01 RODATA EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK01_TEXT_SIZE
    push    TASK01_TEXT_PHY
    push    TASK01_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;******** TASK02 ********
;   COPIA TASK02 TEXT EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK02_TEXT_SIZE
    push    TASK02_TEXT_PHY
    push    TASK02_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK02 BSS EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK02_TEXT_SIZE
    push    TASK02_TEXT_PHY
    push    TASK02_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK02 DATA EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK02_TEXT_SIZE
    push    TASK02_TEXT_PHY
    push    TASK02_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK02 RODATA EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK02_TEXT_SIZE
    push    TASK02_TEXT_PHY
    push    TASK02_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;******** TASK03 ********
;   COPIA TASK03 TEXT EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK03_TEXT_SIZE
    push    TASK03_TEXT_PHY
    push    TASK03_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK03 BSS EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK03_TEXT_SIZE
    push    TASK03_TEXT_PHY
    push    TASK03_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK03 DATA EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK03_TEXT_SIZE
    push    TASK03_TEXT_PHY
    push    TASK03_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK03 RODATA EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK03_TEXT_SIZE
    push    TASK03_TEXT_PHY
    push    TASK03_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;******** TASK04 ********
;   COPIA TASK04 TEXT EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK04_TEXT_SIZE
    push    TASK04_TEXT_PHY
    push    TASK04_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK04 BSS EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK04_TEXT_SIZE
    push    TASK04_TEXT_PHY
    push    TASK04_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK04 DATA EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK04_TEXT_SIZE
    push    TASK04_TEXT_PHY
    push    TASK04_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

;   COPIA TASK04 RODATA EN RAM
    push    ebp
    mov     ebp, esp
    push    TASK04_TEXT_SIZE
    push    TASK04_TEXT_PHY
    push    TASK04_TEXT_LMA  
    call    td3_memcopy
    leave
    
    cmp eax, 0
    jne aqui

interruptions:
;   CARGA LA IDT
    lidt    [idtr] 

;   INICIALIZA EL PIC
    call    init_pic 

;   INICIALIZA EL PIT
    call    init_pit 

paging_kernel:                              ;   PAGINACION DEL KERNEL
;   INICIALIZA CR3 DEL KERNEL
    push ebp
    mov ebp, esp
    push 1                                  ; PWT: Page level write through
    push 1                                  ; PCD: Page level cache disable 
    push dword(DPT_KERNEL_VMA)              ; DPT: Directory page tables
    call set_CR3    
    mov cr3, eax
    leave

;---CARGA LA DPT DEL KERNEL------------------------------------------------------
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
    push dword(DPT_KERNEL_VMA+0x1000)       ; PT0: Page table 0 (DPT + 4KB)
    push 0x00                               ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_KERNEL_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   STACK TASK01/02/03/04 
;   (0x004XXXXX a 0x007XXXXX)
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 4KB + 4KB)
    push 0x001                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_KERNEL_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 3 (DPT + 4KB + 12KB)
    push 0x003                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_KERNEL_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 4 (DPT + 4KB + 16KB)
    push 0x004                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_KERNEL_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   TASK02, TASK03, TASK04
;   (0x014XXXXX a 0x017XXXXX) 
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
    push 0x005                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_KERNEL_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 4KB + 508KB)
    push 0x07F                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_KERNEL_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4KB + 4088KB)
    push 0x3FF                          ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_KERNEL_VMA)          ; DPT: Directory page tables
    call set_PDE                        ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;---CARGA LAS PT DEL KERNEL-----------------------------------------------------
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
    push dword(DPT_KERNEL_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_KERNEL_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_KERNEL_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_KERNEL_PHY)          ; Direccion de mapeo
    push 0x010                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_KERNEL_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 8KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT3:P640 VIDEO (VMA=0x00E80000 <--> PHY=0x000B8000)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 0 (DPT + 16KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT4:P544 KERNEL (0x01220000)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT4:P848 TASK01_TSS (TASK01 STATE SEGMENT) (0x01350000)
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
    push dword(TASK01_TSS_PHY)          ; Direccion de mapeo
    push 0x350                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 4 (DPT + 4KB +16KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P16 TASK02_TEXT (0x01410000)
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
    push dword(TASK02_TEXT_PHY)         ; Direccion de mapeo
    push 0x010                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P32 TASK02_BSS (0x01420000)
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
    push dword(TASK02_BSS_PHY)          ; Direccion de mapeo
    push 0x020                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P48 TASK02_DATA (0x01430000)
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
    push dword(TASK02_DATA_PHY)         ; Direccion de mapeo
    push 0x030                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P64 TASK02_RODATA (0x01440000)
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
    push dword(TASK02_RODATA_PHY)       ; Direccion de mapeo
    push 0x040                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 4KB + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P80 TASK02_TSS (TASK01 STATE SEGMENT) (0x01450000)
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
    push dword(TASK02_TSS_PHY)          ; Direccion de mapeo
    push 0x050                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB +20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT5:P272 TASK03_TEXT (0x01510000)
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
    push dword(TASK03_TEXT_PHY)         ; Direccion de mapeo
    push 0x110                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P288 TASK03_BSS (0x01520000)
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
    push dword(TASK03_BSS_PHY)          ; Direccion de mapeo
    push 0x120                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P304 TASK03_DATA (0x01530000)
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
    push dword(TASK03_DATA_PHY)         ; Direccion de mapeo
    push 0x130                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P320 TASK03_RODATA (0x01540000)
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
    push dword(TASK03_RODATA_PHY)       ; Direccion de mapeo
    push 0x140                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P336 TASK03_TSS (TASK03 STATE SEGMENT) (0x01550000)
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
    push dword(TASK03_TSS_PHY)          ; Direccion de mapeo
    push 0x150                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT5:P528 TASK04_TEXT (0x01610000)
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
    push dword(TASK04_TEXT_PHY)         ; Direccion de mapeo
    push 0x210                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P544 TASK04_BSS (0x01620000)
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
    push dword(TASK04_BSS_PHY)          ; Direccion de mapeo
    push 0x220                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P560 TASK04_DATA (0x01630000)
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
    push dword(TASK04_DATA_PHY)         ; Direccion de mapeo
    push 0x230                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P576 TASK04_RODATA (0x01640000)
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
    push dword(TASK04_RODATA_PHY)       ; Direccion de mapeo
    push 0x240                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P592 TASK04_TSS (TASK04 STATE SEGMENT) (0x01650000)
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
    push dword(TASK04_TSS_PHY)          ; Direccion de mapeo
    push 0x250                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 512KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1022:P1019 ROM:INIT_32 (0xFFFFB000)
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
    push dword(INIT_32_PHY+0x1000)      ; Direccion de mapeo
    push 0x3FB                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
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
    push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT1023:P1021 ROM:SYS_TABLES (0xFFFFFD00) 
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
;   push dword(SYS_TABLES_PHY)          ; Direccion de mapeo
;   push 0x3FD                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
;   push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
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
;   push dword(RESET_PHY)               ; Direccion de mapeo
;   push 0x3FF                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
;   push dword(DPT_KERNEL_VMA+0x1000+0x1000*0x3FF)  ; PT1022: Page table 0 (DPT + 4096KB)
;   call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
;   leave

paging_task01:
;---CARGA LA DPT DE TASK01-------------------------------------------------------
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
    push dword(DPT_TASK01_VMA+0x1000)       ; PT0: Page table 0 (DPT + 4KB)
    push 0x00                               ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK01_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 20KB + 4KB)
    push 0x001                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK01_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 3 (DPT + 20KB + 12KB)
    push 0x003                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK01_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 4 (DPT + 20KB + 16KB)
    push 0x004                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK01_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 4KB + 508KB)
    push 0x07F                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK01_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;---CARGA LAS PT DE TASK01-----------------------------------------------------
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
    push dword(DPT_TASK01_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_TASK01_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_TASK01_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT3:P640 VIDEO (VMA=0x00E80000 <--> PHY=0x000B8000)
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 0 (DPT + 16KB)
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 8KB)
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT4:P848 TASK01_TSS (TASK01 STATE SEGMENT) (0x01350000)
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
    push dword(TASK01_TSS_PHY)          ; Direccion de mapeo
    push 0x350                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 4 (DPT + 4KB +16KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT4:P864 DPT_TASK01_VMA (TASK01 DIRECTORY PAGE TABLE) (0x01360000)
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
    push dword(DPT_TASK01_PHY)          ; Direccion de mapeo
    push 0x360                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x04)    ; PT4: Page table 4 (DPT + 4KB +16KB)
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
    push dword(DPT_TASK01_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 512KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

paging_task02:
;---CARGA LA DPT DE TASK02-----------------------------------------------------
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
    push dword(DPT_TASK02_VMA+0x1000)       ; PT0: Page table 0 (DPT + 20KB)
    push 0x00                               ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK02_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   STACK TASK02
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
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 20KB + 4KB)
    push 0x001                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK02_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 3 (DPT + 20KB + 12KB)
    push 0x003                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK02_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave
    
;   DATA, KERNEL
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
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 4 (DPT + 20KB + 16KB)
    push 0x004                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK02_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   TASK02
;   (0x014FXXXX) 
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 20KB + 16KB)
    push 0x005                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK02_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 4KB + 508KB)
    push 0x07F                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK02_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;---CARGA LAS PT DE TASK02-----------------------------------------------------
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
    push dword(DPT_TASK02_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_TASK02_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_TASK02_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT3:P640 VIDEO (VMA=0x00E80000 <--> PHY=0x000B8000)
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
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 0 (DPT + 16KB)
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
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT1:P912 STACK TASK02 (0x00790000)
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
    push dword(STACK_TASK02_START_PHY)  ; Direccion de mapeo
    push 0x390                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 8KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P16 TASK02_TEXT (0x01410000)
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
    push dword(TASK02_TEXT_PHY)         ; Direccion de mapeo
    push 0x010                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P32 TASK02_BSS (0x01420000)
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
    push dword(TASK02_BSS_PHY)          ; Direccion de mapeo
    push 0x020                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P48 TASK02_DATA (0x01430000)
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
    push dword(TASK02_DATA_PHY)         ; Direccion de mapeo
    push 0x030                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P64 TASK02_RODATA (0x01440000)
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
    push dword(TASK02_RODATA_PHY)       ; Direccion de mapeo
    push 0x040                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P80 TASK02_TSS (TASK01 STATE SEGMENT) (0x01450000)
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
    push dword(TASK02_TSS_PHY)          ; Direccion de mapeo
    push 0x050                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB +20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT5:P96 DPT_TASK02_VMA (TASK02 DIRECTORY PAGE TABLE) (0x01460000)
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
    push dword(DPT_TASK02_PHY)          ; Direccion de mapeo
    push 0x060                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB +20KB)
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
    push dword(DPT_TASK02_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 512KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

paging_task03:
;---CARGA LA DPT DE TASK03-----------------------------------------------------
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
    push dword(DPT_TASK03_VMA+0x1000)       ; PT0: Page table 0 (DPT + 20KB)
    push 0x00                               ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK03_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   STACK TASK03
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
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 20KB + 4KB)
    push 0x001                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK03_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 3 (DPT + 20KB + 12KB)
    push 0x003                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK03_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave
    
;   DATA, KERNEL
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
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 4 (DPT + 20KB + 16KB)
    push 0x004                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK03_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   TASK03
;   (0x015FXXXX) 
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 20KB + 16KB)
    push 0x005                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK03_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 4KB + 508KB)
    push 0x07F                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK03_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;---CARGA LAS PT DE TASK03-----------------------------------------------------
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
    push dword(DPT_TASK03_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_TASK03_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_TASK03_VMA+0x1000)   ; Inicio de la tabla de paginas
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT3:P640 VIDEO (VMA=0x00E80000 <--> PHY=0x000B8000)
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
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 0 (DPT + 16KB)
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
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT1:P913 STACK TASK03 (0x00791000)
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
    push dword(STACK_TASK03_START_PHY)  ; Direccion de mapeo
    push 0x391                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 8KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P272 TASK03_TEXT (0x01510000)
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
    push dword(TASK03_TEXT_PHY)         ; Direccion de mapeo
    push 0x110                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P288 TASK03_BSS (0x01520000)
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
    push dword(TASK03_BSS_PHY)          ; Direccion de mapeo
    push 0x120                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P304 TASK03_DATA (0x01530000)
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
    push dword(TASK03_DATA_PHY)         ; Direccion de mapeo
    push 0x130                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P320 TASK03_RODATA (0x01540000)
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
    push dword(TASK03_RODATA_PHY)       ; Direccion de mapeo
    push 0x140                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 0 (DPT + 24KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P336 TASK03_TSS (TASK03 STATE SEGMENT) (0x01550000)
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
    push dword(TASK03_TSS_PHY)          ; Direccion de mapeo
    push 0x150                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P352 DPT_TASK03_VMA (TASK03 DIRECTORY PAGE TABLE) (0x01560000)
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
    push dword(DPT_TASK03_PHY)          ; Direccion de mapeo
    push 0x160                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
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
    push dword(DPT_TASK03_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 512KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

paging_task04:
;---CARGA LA DPT DE TASK04-----------------------------------------------------
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
    push dword(DPT_TASK04_VMA+0x1000)       ; PT0: Page table 0 (DPT + 20KB)
    push 0x00                               ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK04_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   STACK TASK04
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
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 20KB + 4KB)
    push 0x001                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK04_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x03)   ; PT3: Page table 3 (DPT + 20KB + 12KB)
    push 0x003                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK04_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave
    
;   DATA, KERNEL
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
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 4 (DPT + 20KB + 16KB)
    push 0x004                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK04_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;   TASK04
;   (0x016FXXXX) 
    push ebp
    mov ebp, esp
    push 1                                  ; P: Presence
    push 1                                  ; RW: Read and Write
    push 0                                  ; US: User or Supervisor
    push 0                                  ; PWT: Page level write through
    push 0                                  ; PCD: Page level cache disable 
    push 0                                  ; A: Accessed
    push 0                                  ; PS: Page Size (4KB)
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 20KB + 16KB)
    push 0x005                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK04_VMA)              ; DPT: Directory page tables
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
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 4KB + 508KB)
    push 0x07F                              ; Entry: 10 bits mas significativos de la VMA
    push dword(DPT_TASK04_VMA)              ; DPT: Directory page tables
    call set_PDE                            ; Llama a Page Directory Entry para crear un Descriptor en la DPT.
    leave

;---CARGA LAS PT DE TASK04-----------------------------------------------------
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
    push dword(DPT_TASK04_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_TASK04_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_TASK04_VMA+0x1000)   ; Inicio de la tabla de paginas
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
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
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
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x04)   ; PT4: Page table 0 (DPT + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT1:P914 STACK TASK04 (0x00792000)
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
    push dword(STACK_TASK04_START_PHY)  ; Direccion de mapeo
    push 0x392                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x01)   ; PT1: Page table 1 (DPT + 4KB + 4KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P528 TASK04_TEXT (0x01610000)
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
    push dword(TASK04_TEXT_PHY)         ; Direccion de mapeo
    push 0x210                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P544 TASK04_BSS (0x01620000)
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
    push dword(TASK04_BSS_PHY)          ; Direccion de mapeo
    push 0x220                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P560 TASK04_DATA (0x01630000)
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
    push dword(TASK04_DATA_PHY)         ; Direccion de mapeo
    push 0x230                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P576 TASK04_RODATA (0x01640000)
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
    push dword(TASK04_RODATA_PHY)       ; Direccion de mapeo
    push 0x240                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 

;   PT5:P592 TASK04_TSS (TASK04 STATE SEGMENT) (0x01650000)
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
    push dword(TASK04_TSS_PHY)          ; Direccion de mapeo
    push 0x250                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave

;   PT5:P608 DPT_TASK04_VMA (TASK04 DIRECTORY PAGE TABLE) (0x01660000)
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
    push dword(DPT_TASK04_PHY)          ; Direccion de mapeo
    push 0x260                          ; Entry: Offset de la tabla de paginas  (10 bits mas significativos de la VMA)
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x05)   ; PT5: Page table 5 (DPT + 4KB + 20KB)
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
    push dword(DPT_TASK04_VMA+0x1000+0x1000*0x7F)   ; PT126: Page table 0 (DPT + 512KB)
    call set_PTE                        ; Llama a Page Table Entry para crear un Descriptor en la PT.
    leave 
    
;---HABILITA PAGINACION-----------------------------------------------------
    mov eax, cr0
    or eax, X86_CR0_PG
    mov cr0, eax

;   SALTAMOS A FUNCION PRINCIPAL
    xchg bx,bx    
    jmp CS_SEL_32:KERNEL_32_INIT        ; El salto a la direccion VMA Lineal 0x01220000           

aqui:
    hlt
    jmp aqui
;____________________________________________________________________________________

