; *****************************************************************************************
; ***************************** RUTINAS EN ASM ********************************************
; *****************************************************************************************

USE32

GLOBAL dword_addition                           ; exporta etiquetas
GLOBAL qword_addition
GLOBAL init_basic_TSS
GLOBAL init_my_TSS_lvl00
GLOBAL init_my_TSS_lvl03
GLOBAL td3_halt
GLOBAL td3_read
GLOBAL td3_print
GLOBAL td3_write

EXTERN DS_SEL                                   ; importa etiquetas
EXTERN CS_SEL
EXTERN TSS_SEL
EXTERN CS_SEL_11
EXTERN DS_SEL_11

EXTERN KERNEL_TSS_VMA
EXTERN DPT_KERNEL_VMA
EXTERN STACK32_END_VMA
EXTERN while1

EXTERN ACTION
EXTERN HALT
EXTERN READ
EXTERN PRINT
EXTERN WRITE

;____________________________________________________________________________________
section .functions

; *****************************************************************************************
; ************************** RUTINAS PARA INICIALIZAR EL TSS EN ASM ***********************
; *****************************************************************************************
; Inicializacion de task state segment de arquitectura x86 (https://wiki.osdev.org/Task_State_Segment)
init_basic_TSS:
    mov eax, KERNEL_TSS_VMA

;   LINK                                        ; Reserva memoria para:
    mov [eax + 4*00], dword(0)                  ; Previous task link  
;   STACK00
    mov [eax + 4*01], dword(STACK32_END_VMA-5*04)    ; ESP0  
    mov [eax + 4*02], dword(DS_SEL)             ; SS0                     
;   STACK01
    mov [eax + 4*03], dword(0)                  ; ESP1
    mov [eax + 4*04], dword(0)                  ; SS1   
;   STACK02
    mov [eax + 4*05], dword(0)                  ; ESP2
    mov [eax + 4*06], dword(0)                  ; SS2    
;   DPT
    mov [eax + 4*07], dword(DPT_KERNEL_VMA)     ; CR3
;   INSTRUCTION POINTER
    mov [eax + 4*08], dword(while1)             ; EIP
;   EFLAGS
    mov [eax + 4*09], dword(0x202)              ; EFLAGS
;   REGISTROS PROPOSITO GENERAL                 
    mov [eax + 4*10], dword(0)                  ; EAX
    mov [eax + 4*11], dword(0)                  ; ECX
    mov [eax + 4*12], dword(0)                  ; EDX
    mov [eax + 4*13], dword(0)                  ; EBX
    mov [eax + 4*14], dword(0)                  ; ESP
    mov [eax + 4*15], dword(0)                  ; EBP
    mov [eax + 4*16], dword(0)                  ; ESI
    mov [eax + 4*17], dword(0)                  ; EDI
;   REGISTROS DE SEGMENTO
    mov [eax + 4*18], dword(DS_SEL)             ; ES    
    mov [eax + 4*19], dword(CS_SEL)             ; CS    
    mov [eax + 4*20], dword(DS_SEL)             ; SS    
    mov [eax + 4*21], dword(DS_SEL)             ; DS    
    mov [eax + 4*22], dword(DS_SEL)             ; FS    
    mov [eax + 4*23], dword(DS_SEL)             ; GS    
;   LDTR & IOPB
    mov [eax + 4*24], dword(0)                  ; LDTR  
    mov [eax + 4*25], dword(0)                  ; IOPB  

    xor eax, eax
    mov ax, TSS_SEL 
    ltr ax                                      ; Load task register

    ret

init_my_TSS_lvl00:
;   RECIBE POR PARAMETRO: TASK0X_TSS_VMA
    mov eax, [esp+20]                                       
;   LINK                                        Reserva memoria para:
    mov [eax + 4*00], dword(0)                  ; Previous task link
;   STACK00                                     
    mov     ebx     , [esp+08]
    mov [eax + 4*01],    ebx                    ; ESP0= STACK32_TX_END_VMA
    mov [eax + 4*02], dword(DS_SEL)             ; SS0 
;   STACK01
    mov [eax + 4*03], dword(0)                  ; ESP1
    mov [eax + 4*04], dword(0)                  ; SS1  
;   STACK02
    mov [eax + 4*05], dword(0)                  ; ESP2
    mov [eax + 4*06], dword(0)                  ; SS2 
;   DPT
    mov     ebx     , [esp+04]
    mov [eax + 4*07],    ebx                    ; CR3= DPT_TASK0X_VMA
;   INSTRUCTION POINTER
    mov     ebx     , [esp+16]
    mov [eax + 4*08],    ebx                    ; EIP= TASK0X_TEXT_VMA
;   EFLAGS
    mov [eax + 4*09], dword(0x202)              ; EFLAGS
;   REGISTROS PROPOSITO GENERAL                 
    mov [eax + 4*10], dword(0)                  ; EAX
    mov [eax + 4*11], dword(0)                  ; ECX
    mov [eax + 4*12], dword(0)                  ; EDX
    mov [eax + 4*13], dword(0)                  ; EBX
    mov     ebx     , [esp+12]
    mov [eax + 4*14],    ebx                    ; ESP= STACK_TASK0X_END_VMA
    mov [eax + 4*15],    ebx                    ; EBP= STACK_TASK0X_END_VMA
    mov [eax + 4*16], dword(0)                  ; ESI
    mov [eax + 4*17], dword(0)                  ; EDI
;   REGISTROS DE SEGMENTO
    mov [eax + 4*18], dword(DS_SEL)             ; ES   
    mov [eax + 4*19], dword(CS_SEL)             ; CS   
    mov [eax + 4*20], dword(DS_SEL)             ; SS   
    mov [eax + 4*21], dword(DS_SEL)             ; DS   
    mov [eax + 4*22], dword(DS_SEL)             ; FS   
    mov [eax + 4*23], dword(DS_SEL)             ; GS   
;   LDTR & IOPB
    mov [eax + 4*24], dword(0)                  ; LDTR  
    mov [eax + 4*25], dword(0)                  ; IOPB 

; ** ----------------------------------------------------------------------**
; ** BLOQUE DE CODIGO PARA PRECARGAR LOS STACKS CON SS3,ESP3,EFLAGS,CS,EIP **
; ** ----------------------------------------------------------------------**
; ;   GUARDA SS & ESP DE LA PILA DE USUARIO EN LA PILA DE SUPERVISOR
;     mov     ebx     , [eax + 4*01]      ; ESP0: STACK32_TX_END_VMA
;     mov     ecx     , [eax + 4*20]      ; SS3: STACK_TASK0X_END_VMA
;     mov [ebx - 4*01],     ecx
;     mov     ecx     , [eax + 4*14]      ; ESP3: STACK_TASK0X_END_VMA
;     mov [ebx - 4*02],     ecx
; ;   GUARDA EFLAGS EN LA PILA DE SUPERVISOR
;     mov     ecx     , [eax + 4*09]      ; EFLAGS
;     mov [ebx - 4*03],     ecx
; ;   GUARDA CS EN LA PILA DE SUPERVISOR
;     mov     ecx     , [eax + 4*19]      ; CS
;     mov [ebx - 4*04],     ecx
; ;   GUARDA EIP EN LA PILA DE SUPERVISOR
;     mov     ecx     , [eax + 4*08]      ; EIP
;     mov [ebx - 4*05],     ecx

    ret

init_my_TSS_lvl03:
;   RECIBE POR PARAMETRO: TASK0X_TSS_VMA
    mov eax, [esp+20]                                       
;   LINK                                        Reserva memoria para:
    mov [eax + 4*00], dword(0)                  ; Previous task link
;   STACK00                                     
    mov     ebx     , [esp+08]
    mov [eax + 4*01],    ebx                    ; ESP0= STACK32_TX_END_VMA
    mov [eax + 4*02], dword(DS_SEL)             ; SS0 
;   STACK01
    mov [eax + 4*03], dword(0)                  ; ESP1
    mov [eax + 4*04], dword(0)                  ; SS1  
;   STACK02
    mov [eax + 4*05], dword(0)                  ; ESP2
    mov [eax + 4*06], dword(0)                  ; SS2 
;   DPT
    mov     ebx     , [esp+04]
    mov [eax + 4*07],    ebx                    ; CR3= DPT_TASK0X_VMA
;   INSTRUCTION POINTER
    mov     ebx     , [esp+16]
    mov [eax + 4*08],    ebx                    ; EIP= TASK0X_TEXT_VMA
;   EFLAGS
    mov [eax + 4*09], dword(0x202)              ; EFLAGS
;   REGISTROS PROPOSITO GENERAL                 
    mov [eax + 4*10], dword(0)                  ; EAX
    mov [eax + 4*11], dword(0)                  ; ECX
    mov [eax + 4*12], dword(0)                  ; EDX
    mov [eax + 4*13], dword(0)                  ; EBX
    mov     ebx     , [esp+12]
    mov [eax + 4*14],    ebx                    ; ESP= STACK_TASK0X_END_VMA
    mov [eax + 4*15],    ebx                    ; EBP= STACK_TASK0X_END_VMA
    mov [eax + 4*16], dword(0)                  ; ESI
    mov [eax + 4*17], dword(0)                  ; EDI
;   REGISTROS DE SEGMENTO
    mov [eax + 4*18], dword(DS_SEL_11+3)          ; ES   
    mov [eax + 4*19], dword(CS_SEL_11+3)          ; CS   
    mov [eax + 4*20], dword(DS_SEL_11+3)          ; SS   
    mov [eax + 4*21], dword(DS_SEL_11+3)          ; DS   
    mov [eax + 4*22], dword(DS_SEL_11+3)          ; FS   
    mov [eax + 4*23], dword(DS_SEL_11+3)          ; GS   
;   LDTR & IOPB
    mov [eax + 4*24], dword(0)                  ; LDTR  
    mov [eax + 4*25], dword(0)                  ; IOPB 

; ** ----------------------------------------------------------------------**
; ** BLOQUE DE CODIGO PARA PRECARGAR LOS STACKS CON SS3,ESP3,EFLAGS,CS,EIP **
; ** ----------------------------------------------------------------------**
; Con esto evitamos que el scheduler deba pushearlos cada vez que haga el "iret"
; ;   GUARDA SS & ESP DE LA PILA DE USUARIO EN LA PILA DE SUPERVISOR
;     mov     ebx     , [eax + 4*01]      ; ESP0: STACK32_TX_END_VMA
;     mov     ecx     , [eax + 4*20]      ; SS3: STACK_TASK0X_END_VMA
;     mov [ebx - 4*01],     ecx
;     mov     ecx     , [eax + 4*14]      ; ESP3: STACK_TASK0X_END_VMA
;     mov [ebx - 4*02],     ecx
; ;   GUARDA EFLAGS EN LA PILA DE SUPERVISOR
;     mov     ecx     , [eax + 4*09]      ; EFLAGS
;     mov [ebx - 4*03],     ecx
; ;   GUARDA CS EN LA PILA DE SUPERVISOR
;     mov     ecx     , [eax + 4*19]      ; CS
;     mov [ebx - 4*04],     ecx
; ;   GUARDA EIP EN LA PILA DE SUPERVISOR
;     mov     ecx     , [eax + 4*08]      ; EIP
;     mov [ebx - 4*05],     ecx

    ret

; *****************************************************************************************
; ******************************* RUTINAS PARA SYSCALLS EN ASM  ***************************
; *****************************************************************************************
td3_halt:
    mov dword [ACTION], HALT
    int 0x80
    ret

td3_read:
    mov dword [ACTION], READ
    mov ebx,[esp+4*1]   ; &BUFFER
    mov ecx,[esp+4*2]   ; OFFSET
    int 0x80
    ret

td3_print:
    mov dword [ACTION], PRINT
    mov ecx,[esp+4*1]   ; Posicion X
    mov ebx,[esp+4*2]   ; Posicion Y
    mov edi,[esp+4*3]   ; Mensaje
    int 0x80
    ret

td3_write:
    mov dword [ACTION], WRITE
    mov ebx,[esp+4*1]   ; &BUFFER
    mov ecx,[esp+4*2]   ; OFFSET
    mov edi,[esp+4*3]   ; Mensaje
    int 0x80
    ret
;____________________________________________________________________________________
section .task02

; *****************************************************************************************
; ******************************* RUTINA PARA TAREA 2 EN ASM  *****************************
; *****************************************************************************************
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

;____________________________________________________________________________________
section .task03

; *****************************************************************************************
; ******************************* RUTINA PARA TAREA 3 EN ASM  *****************************
; *****************************************************************************************
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
;____________________________________________________________________________________