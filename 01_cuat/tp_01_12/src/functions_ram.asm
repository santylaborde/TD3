; *****************************************************************************************
; ***************************** RUTINAS EN ASM ********************************************
; *****************************************************************************************

USE32

GLOBAL dword_addition
GLOBAL qword_addition

;____________________________________________________________________________________
section .functions

dword_addition:
    mov     ebx , ebp        ; resguarda el base pointer
    pxor    mm0 , mm0        ; inicializa mmo en cero
    pxor    mm1 , mm1        ; inicializa mm1 en cero
    mov     eax , esp
    mov     ebp , eax        ; ebp= esp
    paddq   mm0 , [ebp+4]    ; Parametro 1: Valor a sumar
    paddq   mm1 , [ebp+12]   ; Parametro 2: Valor del acumulador
    paddusw mm0 , mm1        ; Suma SIMD de param1 y param2 como enteros empaquetados
    movd    eax , mm0
    psrlq   mm0 , 32         ; Shiftea a la derecha 32 veces (Divide por 2³²)
    movd    edx , mm0
    mov     ebp , ebx
    ret

qword_addition:
    mov     ebx , ebp        ; resguardo el base pointer
    pxor    mm0 , mm0       
    pxor    mm1 , mm1
    mov     eax , esp
    mov     ebp , eax        ; ebp= esp
    paddq   mm0 , [ebp+4]    ; Parametro 1: Valor a sumar
    paddq   mm1 , [ebp+12]   ; Parametro 2: Valor del acumulador
    paddq   mm0 , mm1        ; Suma param1 y param2 como enteros empaquetados
    movd    eax , mm0
    psrlq   mm0 , 32         ; Shiftea a la derecha 32 veces (Divide por 2³²)
    movd    edx , mm0
    mov     ebp , ebx
    ret