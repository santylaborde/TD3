; ************* RUTINAS DE ATENCION DE INTERRUPCIONES *******************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL ISR0_handler_DE                      ; exporta etiquetas
GLOBAL ISR2_handler_NMI
GLOBAL ISR3_handler_BP
GLOBAL ISR4_handler_OF
GLOBAL ISR5_handler_BR
GLOBAL ISR6_handler_UD
GLOBAL ISR7_handler_NM
GLOBAL ISR8_handler_DF
GLOBAL ISR10_handler_TS
GLOBAL ISR11_handler_NP
GLOBAL ISR12_handler_SS
GLOBAL ISR13_handler_GP
GLOBAL ISR14_handler_PF
GLOBAL ISR16_handler_MF
GLOBAL ISR17_handler_AC
GLOBAL ISR18_handler_MC
GLOBAL ISR19_handler_XF
GLOBAL ISR32_handler_PIT
GLOBAL ISR33_handler_KEYBOARD
GLOBAL scheduler_back

EXTERN ISR32_handler_PIT_C                  ; importa etiquetas de handlers en C
EXTERN ISR33_handler_KEYBOARD_C 
EXTERN ISR14_handler_PF_C

EXTERN RING_BUFFER_VMA                      ; importa etiquetas varias
EXTERN scheduler
EXTERN CURRENT_TASK
EXTERN TASK02_MMX_VMA
EXTERN TASK03_MMX_VMA
EXTERN LAST_MMX

TASK02 EQU 2                                ; defines
TASK03 EQU 3

PORT_A_8042 EQU 0x60
STORE_CR2 EQU 0x00000000

USE32

;____________________________________________________________________________________
section .isr_handler

;***********************
; 
default_isr:
    hlt
    jmp default_isr
    iret

;***********************
; Divide-by-zero Error
ISR0_handler_DE:
    xchg bx,bx
    mov dl, 0
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Debug
; ISR1_handler_DB:

;***********************
; Non-maskable Interrupt
ISR2_handler_NMI:
    xchg bx,bx
    mov dl, 2
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Breakpoint
ISR3_handler_BP:
    xchg bx,bx
    mov dl, 3
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Overflow
ISR4_handler_OF:
    xchg bx,bx
    mov dl, 4
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Bound Range Exceeded
ISR5_handler_BR:
    xchg bx,bx
    mov dl, 5
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Invalid Opcode
ISR6_handler_UD:
    xchg bx,bx
    mov dl, 6
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Device Not Available
; Se graba el contexto con el CR3 de la tarea saliente (scheduler)
; Se recupera con el CR3 de la tarea entrante en la exc#7
;  _________________________________
; | ACCION  |   LUGAR   | CR3 TAREA |
; |---------|-----------|-----------|
; | fxsave  | scheduler |  saliente |
; | fxrstor |   exc#7   |  entrante |
; |_________|___________|___________|
ISR7_handler_NM:  
    mov dl, 7
    pushad

    clts    ; Limpia el bit CR0.TS (TASK SWITCH)

    ; Comparo la tarea actual para hacer el restore MMX
    cmp byte [CURRENT_TASK],TASK02
    je restore_task02
    cmp byte [CURRENT_TASK],TASK03
    je restore_task03

    end_ISR7:
        popad
        iret

    restore_task02:
        fxrstor &TASK02_MMX_VMA       
        mov dword [LAST_MMX], TASK02    ; lo utiliza el scheduler para hacer el fxsave
    jmp end_ISR7

    restore_task03:
        fxrstor &TASK03_MMX_VMA       
        mov dword [LAST_MMX], TASK03    ; lo utiliza el scheduler para hacer el fxsave
    jmp end_ISR7  

ALIGN 8

;***********************
; Double Fault
ISR8_handler_DF:
    xchg bx,bx
    mov dl, 8
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Invalid TSS
ISR10_handler_TS:
    xchg bx,bx
    mov dl, 10
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Segment Not Present
ISR11_handler_NP:
    xchg bx,bx
    mov dl, 11
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Stack-Segment Fault
ISR12_handler_SS:
    xchg bx,bx
    mov dl, 12
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; General Protection Fault
ISR13_handler_GP:
    xchg bx,bx
    mov dl, 13
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Page Fault
ISR14_handler_PF:
    xchg bx,bx
    mov dl, 14
    pushad

    jmp end_ISR14
    cli                                 ; deshabilita interrupciones
    
    mov edx, esp                        ; ESP apunta, en el comienzo del handler, a la direccion del stack con el ERROR CODE

    mov eax,cr2                         ; CR2 contiene la dirección lineal que produjo el fallo.
    mov dword [STORE_CR2], eax          ; resguarda el CR2 por si aparece otra #PF

    push ebp                            ; resguarda el base pointer para retornar luego de la funcion en C
    mov ebp, esp                        
    push eax                            ; Argumento 2 de la funcion: CR2
    push edx                            ; Argumento 1 de la funcion: ERROR_CODE
    call ISR14_handler_PF_C             ; analiza el ERROR CODE de la #PF
    leave
    
    sti                                 ; habilita nuevamente las interrupciones
    end_ISR14:
        mov al, 0x20                    ; limpia la interrupcion del pic
        out 0x20, al
        popad
        iret

ALIGN 8

;***********************
; Reserved
; ISR15_handler:

;***********************
; x87 Floating-Point Exception
ISR16_handler_MF:
    xchg bx,bx
    mov dl, 16
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Alignment Check
ISR17_handler_AC:
    xchg bx,bx
    mov dl, 17
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Machine Check
ISR18_handler_MC:
    xchg bx,bx
    mov dl, 18
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; SIMD Floating-Point Exception
ISR19_handler_XF:
    xchg bx,bx
    mov dl, 19
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
; Programable interrupt timer
ISR32_handler_PIT:
    mov dl, 32
    pushad                              ; salva en la pila el valor de los registros de proposito general
                                        ; Push EAX, ECX, EDX, EBX, original ESP, EBP, ESI, and EDI

    mov al, 0x20                        ;limpia la interrupcion del pic 
    out 0x20, al

    jmp scheduler
    scheduler_back:

    popad
    iret
ALIGN 8
    
;***********************
; Keyboard
ISR33_handler_KEYBOARD:
    mov dl, 33
    push eax
    xor eax, eax
    in al, PORT_A_8042
    bt eax,7

    ; Llama al handler en C del teclado
    push ebp
    mov ebp, esp
    push eax                            ; Argumento 2 de la funcion (tecla presionada)
    push RING_BUFFER_VMA                ; Argumento 1 de la funcion (direccion del ringbuffer)
    call ISR33_handler_KEYBOARD_C
    leave                               ; Dejo a pila donde estaba
    
    ; Limpia las interrupciones
    mov al, 0x20                     ; Send EOI signal to master PIC
    out 0x20, al     
    pop eax 
    iret
    
ALIGN 8