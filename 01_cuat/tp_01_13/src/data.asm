; *******************************    DATA    ****************************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL TICKS01                              ; exporta etiquetas
GLOBAL TICKS02
GLOBAL TICKS03
GLOBAL CURRENT_TASK
GLOBAL NEXT_TASK
GLOBAL LAST_MMX
GLOBAL ADDED_TASK02
GLOBAL ADDED_TASK03
GLOBAL FIRST
GLOBAL TASK01
GLOBAL TASK02
GLOBAL TASK03
GLOBAL TASK04
GLOBAL ACTION
GLOBAL HALT
GLOBAL READ
GLOBAL PRINT
GLOBAL WRITE

FIRST  EQU 0                                ; defines
TASK01 EQU 1
TASK02 EQU 2
TASK03 EQU 3
TASK04 EQU 4
HALT   EQU 1
READ   EQU 2
PRINT  EQU 3
WRITE  EQU 4

;____________________________________________________________________________________
section .data

;********************************
TICKS01:                                    ; SCHEDULER
    dq 0
align 32  
TICKS02:
    dq 0 
align 32
TICKS03:
    dq 0
align 32
CURRENT_TASK:
    dq 0
align 32
NEXT_TASK:
    dq 0
align 32 
LAST_MMX:
    dq 0
align 32 
ADDED_TASK02:
    dq 1
align 32 
ADDED_TASK03:
    dq 1
align 32 
ACTION:
    dq 0
align 32 
;********************************
;____________________________________________________________________________________