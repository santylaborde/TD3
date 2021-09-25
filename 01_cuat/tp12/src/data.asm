; *******************************    DATA    ****************************************
; ********** CODIGO ********************** Comentarios ******************************

GLOBAL TICKS01
GLOBAL TICKS02
GLOBAL TICKS03
GLOBAL CURRENT_TASK
GLOBAL NEXT_TASK
GLOBAL LAST_MMX
GLOBAL ADDED_TASK02
GLOBAL ADDED_TASK03

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
;********************************
;____________________________________________________________________________________