; ************* RUTINAS DE ATENCION DE INTERRUPCIONES *******************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL ISR0_handler_DE                      ; exportamos etiquetas de 32 bits
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

EXTERN ISR32_handler_PIT_C                  ; importamos etiquetas de handlers en C
EXTERN ISR33_handler_KEYBOARD_C 
EXTERN RING_BUFFER   
EXTERN TIMER   

PORT_A_8042 EQU 0x60
PIC_EOI EQU 0x20
PORT_CONTROL_M_PICE EQU 0x20

USE32

;____________________________________________________________________________________
section .isr_handler

;***********************
default_isr:
    hlt
    jmp default_isr
    iret

;***********************
ISR0_handler_DE:
    mov dl, 0
    jmp default_isr
ALIGN 8

;***********************
ISR2_handler_NMI:
    mov dl, 2
    jmp default_isr
ALIGN 8

;***********************
ISR3_handler_BP:
    mov dl, 3
    jmp default_isr
ALIGN 8

;***********************
ISR4_handler_OF:
    mov dl, 4
    jmp default_isr
ALIGN 8

;***********************
ISR5_handler_BR:
    mov dl, 5
    jmp default_isr
ALIGN 8

;***********************
ISR6_handler_UD:
    mov dl, 6
    jmp default_isr
ALIGN 8

;***********************
ISR7_handler_NM:
    mov dl, 7
    jmp default_isr
ALIGN 8

;***********************
ISR8_handler_DF:
    mov dl, 8
    jmp default_isr
ALIGN 8

;***********************
ISR10_handler_TS:
    mov dl, 10
    jmp default_isr
ALIGN 8

;***********************
ISR11_handler_NP:
    mov dl, 11
    jmp default_isr
ALIGN 8

;***********************
ISR12_handler_SS:
    mov dl, 12
    jmp default_isr
ALIGN 8

;***********************
ISR13_handler_GP:
    mov dl, 13
    ;xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR14_handler_PF:
    mov dl, 14
    jmp default_isr
ALIGN 8

;***********************
ISR16_handler_MF:
    mov dl, 16
    jmp default_isr
ALIGN 8

;***********************
ISR17_handler_AC:
    mov dl, 17
    jmp default_isr
ALIGN 8

;***********************
ISR18_handler_MC:
    mov dl, 18
    jmp default_isr
ALIGN 8

;***********************
ISR19_handler_XF:
    mov dl, 19
    jmp default_isr
ALIGN 8

;***********************
ISR32_handler_PIT:
    mov dl, 32
    push ebp
    mov ebp, esp
    push TIMER
    call ISR32_handler_PIT_C
    leave
    
    mov al, 0x20                        ;limpia la interrupcion del pic 
    out 0x20, al
    iret
ALIGN 8
    
;***********************
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
    push RING_BUFFER                    ; Argumento 1 de la funcion ()
    call ISR33_handler_KEYBOARD_C
    leave                               ; Dejo a pila donde estaba
    
    ; Limpia las interrupciones
    mov al, PIC_EOI                     ; Send EOI signal to master PIC
    out PORT_CONTROL_M_PICE, al     
    pop eax 
    iret
    
ALIGN 8
;____________________________________________________________________________________