section .sys_tables

GLOBAL CS_SEL_32
GLOBAL DS_SEL
GLOBAL gdtr

D_GDT EQU 0xFFFFFD00

GDT:
NULL_SEL    EQU $ - GDT
    dq 0x0

CS_SEL_32   EQU $ - GDT     ; calcula dinamicamente el tama;o el selector de segmento
; define el descriptor apuntado por el selector de segmento
    dw 0xffff       ; Limite 15-0
    dw 0x0000       ; Base 15-0
    db 0x00         ; Base 23-16
    db 10011001b    ; Atributos
                    ; P = 1
                    ; DPL = 00
                    ; S = 1 con 1 no es de sistema
                    ; D/C = 1 = Bit 11 (segmento de codigo) si es 0 es de (dato o pila)
                    ; ED/C = 1 crece para direcciones mayores con 0 y con 1 es expand down
                    ; R/W = 0
                    ; A = 1
    db 11001111b    ; Limit 19-16 + atributos:
                    ; G = 1
                    ; D/B = 1
                    ; L = 0
                    ; AVL = 0
    db 0x00         ; Base 31-24
DS_SEL      EQU $ - GDT
    dw 0xffff       ; Limit 15-0
    dw 0x0000       ; Base 15-0
    db 0x00         ; Base 23-16
    db 10010010b    ; Atributos
                    ; P = 1
                    ; DPL = 00
                    ; S = 1
                    ; D/C = 0
                    ; ED/C = 0
                    ; R/W = 1
                    ; A = 0
    db 11001111b    ; Atributos + Limit 19-16:
                    ; G = 1
                    ; D/B = 1
                    ; L = 0
                    ; AVL = 0
    db 0x00         ; Base 31-24
GDT_LENGTH  EQU $ - GDT             ;calcula dinamicamente el tama;o de la GDT

gdtr:
    dw GDT_LENGTH-1         ; 2bytes para el limite
    dd D_GDT           ; 4bytes para la base (se ubica en el shadow no en la ROM)

