; ********************** TABLAS DE SISTEMA ******************************************
; ********** CODIGO ********************** Comentarios ******************************


GLOBAL CS_SEL_32                            ; exportamos etiquetas de GDT
GLOBAL DS_SEL
GLOBAL gdtr

GLOBAL idtr                                 ; exportamos etiquetas de IDT

EXTERN ISR0_handler_DE_L                       ; importamos etiquetas para IDT
EXTERN ISR0_handler_DE_H
EXTERN ISR2_handler_NMI_L
EXTERN ISR2_handler_NMI_H
EXTERN ISR3_handler_BP_L
EXTERN ISR3_handler_BP_H
EXTERN ISR4_handler_OF_L
EXTERN ISR4_handler_OF_H
EXTERN ISR5_handler_BR_L
EXTERN ISR5_handler_BR_H
EXTERN ISR6_handler_UD_L
EXTERN ISR6_handler_UD_H
EXTERN ISR7_handler_NM_L
EXTERN ISR7_handler_NM_H
EXTERN ISR8_handler_DF_L
EXTERN ISR8_handler_DF_H
EXTERN ISR10_handler_TS_L
EXTERN ISR10_handler_TS_H
EXTERN ISR11_handler_NP_L
EXTERN ISR11_handler_NP_H
EXTERN ISR12_handler_SS_L
EXTERN ISR12_handler_SS_H
EXTERN ISR13_handler_GP_L
EXTERN ISR13_handler_GP_H
EXTERN ISR14_handler_PF_L
EXTERN ISR14_handler_PF_H
EXTERN ISR16_handler_MF_L
EXTERN ISR16_handler_MF_H
EXTERN ISR17_handler_AC_L
EXTERN ISR17_handler_AC_H
EXTERN ISR18_handler_MC_L
EXTERN ISR18_handler_MC_H
EXTERN ISR19_handler_XF_L
EXTERN ISR19_handler_XF_H
EXTERN ISR32_handler_PIT_L
EXTERN ISR32_handler_PIT_H
EXTERN ISR33_handler_KEYBOARD_L
EXTERN ISR33_handler_KEYBOARD_H

D_GDT EQU 0xFFFFFD00                

;____________________________________________________________________________________
section .sys_tables

; ******************************* GDT ***********************************************
GDT:
;***********************
NULL_SEL    EQU $ - GDT
    dq 0x0
;***********************
CS_SEL_32   EQU $ - GDT                     ; calcula dinamicamente el tama;o el selector de segmento ; code segment
                                            ; define el descriptor apuntado por el selector de segmento
    dw 0xffff                               ; Limite 15-0
    dw 0x0000                               ; Base 15-0
    db 0x00                                 ; Base 23-16
    db 10011001b                            ; Atributos: P = 1
                                            ; DPL = 00
                                            ; S = 1 con 1 no es de sistema
                                            ; D/C = 1 = Bit 11 (segmento de codigo) si es 0 es de (dato o pila)
                                            ; ED/C = 1 crece para direcciones mayores con 0 y con 1 es expand down
                                            ; R/W = 0
                                            ; A = 1
    db 11001111b                            ; Limit 19-16 + atributos:
                                            ; G = 1
                                            ; D/B = 1
                                            ; L = 0
                                            ; AVL = 0
    db 0x00                                 ; Base 31-24
;***********************
DS_SEL      EQU $ - GDT                     ; data segment
    dw 0xffff                               ; Limit 15-0
    dw 0x0000                               ; Base 15-0
    db 0x00                                 ; Base 23-16
    db 10010010b                            ; Atributos
    db 11001111b                            ; Atributos + Limit 19-16:
    db 0x00                                 ; Base 31-24
;***********************

GDT_LENGTH  EQU $ - GDT                     ;calcula dinamicamente el tama;o de la GDT

gdtr:
    dw GDT_LENGTH-1                         ; 2bytes para el limite
    dd D_GDT                                ; 4bytes para la base (se ubica en el shadow no en la ROM)

; ******************************* IDT ***********************************************
IDT:
;***********************
IRQ0_DE:                                    ; calcula dinamicamente el tama;o el selector de segmento
                                            ; define el descriptor apuntado por el selector de segmento
    dw ISR0_handler_DE_L                       ; Offset 15-0 (Parte baja de la direccion de la ISR)
    dw CS_SEL_32                            ; Segment Selector 15-0
    db 0x00                                 ; Reservado(5 bits) + 000
    db 10001110b                            ; Atributos
                                            ; P = 1
                                            ; DPL = 00
                                            ; 0
                                            ; D= 1 Gate 32bits
                                            ; Gate: 110 (Intterupt Gate)                                        
    dw ISR0_handler_DE_H                       ; Offset 31-16 (Parte alta de la direccion de la ISR)
;***********************
IRQ1:                         
    dq 0x0
;***********************
IRQ2_NMI:                     
	dw ISR2_handler_NMI_L 
    dw CS_SEL_32    
    db 0x00         
    db 10001110b                                           
    dw ISR2_handler_NMI_H       
;***********************
IRQ3_BP:
    dw ISR3_handler_BP_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR3_handler_BP_H
;***********************
IRQ4_OF:
    dw ISR4_handler_OF_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR4_handler_OF_H
;***********************
IRQ5_BR:
    dw ISR5_handler_BR_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR5_handler_BR_H
;***********************
IRQ6_UD:
    dw ISR6_handler_UD_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR6_handler_UD_H
;***********************
IRQ7_NM:
    dw ISR7_handler_NM_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR7_handler_NM_H
;***********************
IRQ8_DF:
    dw ISR8_handler_DF_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR8_handler_DF_H
;***********************
IRQ9:
    dq 0x0
;***********************
IRQ10_TS:
    dw ISR10_handler_TS_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR10_handler_TS_H
;***********************
IRQ11_NP:
    dw ISR11_handler_NP_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR11_handler_NP_H
;***********************
IRQ12_SS:
    dw ISR12_handler_SS_L
    dw CS_SEL_32 			
    db 0x00
    db 10001110b
    dw ISR12_handler_SS_H
;***********************
IRQ13_GP:
    dw ISR13_handler_GP_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR13_handler_GP_H
;***********************
IRQ14_PF:
    dw ISR14_handler_PF_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR14_handler_PF_H
;***********************
IRQ15:
    dq 0x0
;***********************
IRQ16_MF:
    dw ISR16_handler_MF_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR16_handler_MF_H
;***********************
IRQ17_AC:
    dw ISR17_handler_AC_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR17_handler_AC_H
;***********************
IRQ18_MC:
    dw ISR18_handler_MC_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR18_handler_MC_H
;***********************
IRQ19_XF:
    dw ISR19_handler_XF_L
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR19_handler_XF_H
;***********************
IRQ20_31:                                   ; Reservado
    times 12 dq 0x0
;***********************
IRQ32_PIT:                                  ; Programmable interval timer (PIT 8254)
    dw ISR32_handler_PIT_L                  ; IRQ0 del PIC 8259
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR32_handler_PIT_H
;***********************
IRQ33_KEYBOARD:                             ; Keyboard (8042)
    dw ISR33_handler_KEYBOARD_L             ; IRQ1 del PIC 8259
    dw CS_SEL_32
    db 0x00
    db 10001110b
    dw ISR33_handler_KEYBOARD_H
;***********************
IRQ32_47:                                   ; Disponibles para el usuario
    times 16 dq 0x0
;***********************

IDT_LENGHT EQU $ - IDT

idtr:
    dw IDT_LENGHT-1                         ; tamano de la tabla en reg 16 bits
    dd IDT                                  ; direccion relativa en reg 32 bits
;____________________________________________________________________________________