; ************* RUTINAS DE ATENCION DE INTERRUPCIONES *******************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL ISR0_handler                         ; exportamos etiquetas de 32 bits
GLOBAL ISR2_handler
GLOBAL ISR3_handler
GLOBAL ISR4_handler
GLOBAL ISR5_handler
GLOBAL ISR6_handler
GLOBAL ISR7_handler
GLOBAL ISR8_handler
GLOBAL ISR10_handler
GLOBAL ISR11_handler
GLOBAL ISR12_handler
GLOBAL ISR13_handler
GLOBAL ISR14_handler
GLOBAL ISR16_handler
GLOBAL ISR17_handler
GLOBAL ISR18_handler
GLOBAL ISR19_handler

USE32

;____________________________________________________________________________________
section .isr_handler

;***********************
default_isr:
    hlt
    jmp default_isr

;***********************
ISR0_handler:
    mov dl, 0
    jmp default_isr
ALIGN 8

;***********************
ISR2_handler:
    mov dl, 2
    jmp default_isr
ALIGN 8

;***********************
ISR3_handler:
    mov dl, 3
    jmp default_isr
ALIGN 8

;***********************
ISR4_handler:
    mov dl, 4
    jmp default_isr
ALIGN 8

;***********************
ISR5_handler:
    mov dl, 5
    jmp default_isr
ALIGN 8

;***********************
ISR6_handler:
    mov dl, 6
    jmp default_isr
ALIGN 8

;***********************
ISR7_handler:
    mov dl, 7
    jmp default_isr
ALIGN 8

;***********************
ISR8_handler:
    mov dl, 8
    jmp default_isr
ALIGN 8

;***********************
ISR10_handler:
    mov dl, 10
    jmp default_isr
ALIGN 8

;***********************
ISR11_handler:
    mov dl, 11
    jmp default_isr
ALIGN 8

;***********************
ISR12_handler:
    mov dl, 12
    jmp default_isr
ALIGN 8

;***********************
ISR13_handler:
    mov dl, 13
    jmp default_isr
ALIGN 8

;***********************
ISR14_handler:
    mov dl, 14
    jmp default_isr
ALIGN 8

;***********************
ISR16_handler:
    mov dl, 16
    jmp default_isr
ALIGN 8

;***********************
ISR17_handler:
    mov dl, 17
    jmp default_isr
ALIGN 8

;***********************
ISR18_handler:
    mov dl, 18
    jmp default_isr
ALIGN 8

;***********************
ISR19_handler:
    mov dl, 19
    jmp default_isr
ALIGN 8
;____________________________________________________________________________________