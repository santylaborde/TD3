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
GLOBAL ISR128_handler_SYSCALLS
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

EXTERN TASK01
EXTERN TASK02
EXTERN TASK03
EXTERN TASK04

EXTERN ACTION
EXTERN HALT
EXTERN READ
EXTERN PRINT
EXTERN WRITE

EXTERN screen_print

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
    pushad
    mov dl, 7

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
    pushad                              ; OJO me desplazo 32BYTES en el stack respecto del inicio del handler                              
                                        ; Entramos a la interrupcion con el STACK cargado con CS, EIP y EFLAGS 
    mov dl, 14                          ; El EIP es importante! Nos indica que direccion lineal de codigo quizo
                                        ; acceder a la direccion que produjo la page fault.
            

    cli                                 ; deshabilita interrupciones
    ;mov edx, esp
    mov edx, [esp+32]                   ; ESP apunta, en el comienzo del handler, a la direccion del stack con el ERROR CODE
                                        ; El offset de 32 se debe a que el pushad nos desplazo 4 BYTES*8 REGISTROS de lo inicial

    mov eax,cr2                         ; CR2 contiene la dirección lineal que produjo el fallo.
                                        ; OJO el EIP tiene la dirección de codigo que quizo acceder a la dirección que contiene el CR2
    mov dword [STORE_CR2], eax          ; resguarda el CR2 por si aparece otra #PF

    push ebp                            ; resguarda el base pointer para retornar luego de la funcion en C
    mov ebp, esp                        
    push eax                            ; Argumento 2: CR2
    push edx                            ; Argumento 1: ERROR_CODE
    call ISR14_handler_PF_C             ; Llama a funcion que analiza el ERROR CODE de la #PF
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
    pushad 
    mov dl, 32
                             ; salva en la pila el valor de los registros de proposito general
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
    push eax
    mov dl, 33
    xor eax, eax
    in al, PORT_A_8042
    bt eax,7

    ; Llama al handler en C del teclado
    push ebp
    mov ebp, esp
    push eax                            ; Argumento 2 de la funcion (tecla presionada)
    push RING_BUFFER_VMA                ; Argumento 1 de la funcion (direccion del ringbuffer)
    call ISR33_handler_KEYBOARD_C
    leave                               ; Dejo la pila donde estaba
    
    ; Limpia las interrupciones
    mov al, 0x20                        
    out 0x20, al     
    pop eax 
    iret
ALIGN 8

;***********************
; Syscalls (INT 0x80)
; Interrupcion con DPL=3, los servicios del Kernel se exponen a las tareas de nivel usuario a traves de SYSTEM CALLS. 
; Ejemplo: TAREA -> KERNEL -> BUFFER DE VIDEO
; En LINUX mediante "int 0x80" (interrupcion de software) se puede hacer saltos de nivel de privilegio. 
ISR128_handler_SYSCALLS:
    mov dl, 128

    ; Limpia las interrupciones
    mov al, 0x20                        
    out 0x20, al

    cmp byte [ACTION], HALT
    je SYSCALL_HALT

    cmp byte [ACTION], READ
    je SYSCALL_READ

    cmp byte [ACTION], PRINT    
    je SYSCALL_PRINT

    cmp byte [ACTION], WRITE    
    je SYSCALL_WRITE

    jmp end_ISR128

    SYSCALL_HALT:
        sti                                 ; habilita nuevamente las interrupciones
        hlt
        jmp end_ISR128

    SYSCALL_READ:
        ; PARAMETROS CARGADOS EN REGISTROS
        ; ECX: "OFFSET EN BITS"
        ; EBX: "BUFFER"
        mov  eax,   8
        mul  ecx                ; "OFFSET EN BYTES"
        add  ebx,  eax          ;  BUFFER+OFFSET

        ; **************   CHEQUEA PERMISOS  *********************
        ; push ebx                ;  GUARDA EN PILA (POR LAS DUDAS)
        ; jmp check_permits
        ; check_permits_back:     ;  TODO OK
        ;     pop  ebx            ;  RECUPERA EBX  
        ; ********************************************************
        mov  eax, [ebx]     ;  LEE

        jmp end_ISR128

    SYSCALL_PRINT:
        ; PARAMETROS CARGADOS EN REGISTROS
        ; EDI: "MSG"
        ; EBX: "Y"
        ; ECX: "X"
        push ebp                    ; resguarda el ebp en stack
        mov  ebp, esp  
        push edi                    ; manda argumentos
        push ebx
        push ecx
        call screen_print           ; llama a funcion en C
        leave

        jmp end_ISR128

    SYSCALL_WRITE
        ; PARAMETROS CARGADOS EN REGISTROS
        ; EDI: "MSG"
        ; EBX: "OFFSET EN BITS"
        ; ECX: "BUFFER"
        mov  eax ,   8
        mul  ecx                 ; "OFFSET EN BYTES"
        add  ebx ,  eax          ;  BUFFER+OFFSET

        ; **************   CHEQUEA PERMISOS  *********************
        ; push ebx                ;  GUARDA EN PILA (POR LAS DUDAS)
        ; jmp check_permits
        ; check_permits_back:     ;  TODO OK
        ;     pop  ebx            ;  RECUPERA EBX  
        ; ********************************************************
        mov [ebx],  edi          ;  ESCRIBE
        
    end_ISR128: 
    iret

    check_permits:
        ; EBX:  BUFFER+OFFSET
        ; DPT ENTRY
        mov eax, ebx
        and eax, 0xFFC00000      ; Bits 31-22
        shr eax, 22              ; Shiftea 22 veces a la derecha
                                 ; EAX = N° ENTRY EN LA DPT
        
        mov ecx, CR3
        add eax, ecx             ; ECX= CR3 + 0xXXX

        and eax, 0xFFFFF000

        ; PT ENTRY
        mov ecx, ebx
        and ecx, 0x003FF000      ; Bits 21-12
        shr ecx, 12              ; Shiftea 12 veces a la derecha
                                 ; ECX = N° ENTRY EN LA PT
        
        add eax, ecx             ; Atributos: US-RW-P
                                 ;             x-x-x
        
        cmp eax, 000b            ; SUPERVISOR, READABLE , NOT PRESENT 
        ; je check_readable_back

        cmp eax, 001b            ; SUPERVISOR, READABLE , PRESENT 
        ; je check_readable_back

        cmp eax, 010b            ; SUPERVISOR, WRITEABLE, NOT PRESENT 
        ; je check_readable_back

        cmp eax, 011b            ; SUPERVISOR, WRITEABLE, PRESENT 
        ; je check_readable_back

        cmp eax, 100b            ; USER      , READABLE , NOT PRESENT 
        je end_ISR128

        cmp eax, 101b            ; USER      , READABLE , PRESENT 
        je end_ISR128

        cmp eax, 110b            ; USER      , WRITEABLE, NOT PRESENT 
        je end_ISR128

        cmp eax, 111b            ; USER      , WRITEABLE, PRESENT 
        je end_ISR128
    
        jmp end_ISR128
ALIGN 8
        
        