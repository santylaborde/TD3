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
GLOBAL scheduler_back

EXTERN ISR32_handler_PIT_C                  ; importamos etiquetas de handlers en C
EXTERN ISR33_handler_KEYBOARD_C 
EXTERN ISR14_handler_PF_C
EXTERN RING_BUFFER_VMA
EXTERN TIMER_VMA   
EXTERN scheduler

PORT_A_8042 EQU 0x60
STORE_CR2 EQU 0x00000000

USE32

;____________________________________________________________________________________
section .isr_handler

;***********************
default_isr:
    hlt
    xchg bx,bx
    jmp default_isr
    iret

;***********************
ISR0_handler_DE:
    mov dl, 0
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR2_handler_NMI:
    mov dl, 2
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR3_handler_BP:
    mov dl, 3
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR4_handler_OF:
    mov dl, 4
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR5_handler_BR:
    mov dl, 5
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR6_handler_UD:
    mov dl, 6
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR7_handler_NM:
    mov dl, 7
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR8_handler_DF:
    mov dl, 8
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR10_handler_TS:
    mov dl, 10
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR11_handler_NP:
    mov dl, 11
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR12_handler_SS:
    mov dl, 12
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR13_handler_GP:
    mov dl, 13
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR14_handler_PF:
    mov dl, 14
    xchg bx,bx
    
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

    mov al, 0x20                        ; limpia la interrupcion del pic
    out 0x20, al
    pop eax 
    iret

ALIGN 8

;***********************
ISR16_handler_MF:
    mov dl, 16
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR17_handler_AC:
    mov dl, 17
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR18_handler_MC:
    mov dl, 18
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
ISR19_handler_XF:
    mov dl, 19
    xchg bx,bx
    jmp default_isr
ALIGN 8

;***********************
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
; ;____________________________________________________________________________________

; ; ******************************* SCHEDULER  ****************************************
; ; ********** CODIGO ********************** Comentarios ******************************

; ;GLOBAL scheduler                        ; exporta etiqueta

; EXTERN DPT_TASK01_VMA                   ; importa etiquetas
; EXTERN DPT_TASK02_VMA
; EXTERN DPT_TASK03_VMA
; EXTERN DPT_TASK04_VMA
; EXTERN TASK01_TSS_VMA
; EXTERN TASK02_TSS_VMA
; EXTERN TASK03_TSS_VMA
; EXTERN TASK04_TSS_VMA
; TASK01 EQU 0                            ; defines
; TASK02 EQU 1
; TASK03 EQU 2
; TASK04 EQU 3

; TICKS01 db 0                            ; variables
; TICKS02 db 0
; TICKS03 db 0
; CURRENT_TASK db 0
; NEXT_TASK db 0

; ;********************************
; scheduler:
;     inc byte [TICKS01]       
;     inc byte [TICKS02]       
;     inc byte [TICKS03]

; check_ticks:
;     cmp byte [TICKS01], 10              ; 100ms
;     je task02_time

;     cmp byte [TICKS02], 20              ; 200ms
;     je task03_time

;     cmp byte [TICKS03], 50              ; 500ms
;     je task01_time

;     jmp task04_time
; ;--------------------------------
; ; choose_task
; task01_time:
;     mov byte [NEXT_TASK], 1
;     mov byte [TICKS01], 0
;     jmp run_task

; task02_time:
;     mov byte [NEXT_TASK], 2
;     mov byte [TICKS02], 0
;     jmp run_task

; task03_time:
;     mov byte [NEXT_TASK], 3
;     mov byte [TICKS03], 0
;     jmp run_task

; task04_time:
;     mov byte [NEXT_TASK], 4
;     jmp run_task
; ;--------------------------------
; run_task:
;     cmp byte [CURRENT_TASK], NEXT_TASK  ; proxima tarea igual a la actual
;     je end

; switch_task:
;     push ebp
;     mov ebp, esp
;     push CURRENT_TASK
;     call save_context   ; JMP (call te mueve los registros del stack) 
;     leave  

;     push ebp
;     mov ebp, esp
;     push NEXT_TASK
;     call load_context  
;     leave

;     mov byte [CURRENT_TASK], NEXT_TASK
; ;--------------------------------
; end:
;     iret
; ;********************************
; save_context:
;     push eax                            ; Resguardo el eax

; ;   SALVA CONTEXTO DE CURRENT_TASK EN TSS
;     cmp byte [TASK01], CURRENT_TASK
;     cmove eax, [TASK01_TSS_VMA]         ; Move if Equal

;     cmp byte [TASK02], CURRENT_TASK
;     cmove eax, [TASK02_TSS_VMA]         ; Move if Equal

;     cmp byte [TASK03], CURRENT_TASK
;     cmove eax, [TASK03_TSS_VMA]         ; Move if Equal

;     cmp byte [TASK04], CURRENT_TASK
;     cmove eax, [TASK04_TSS_VMA]         ; Move if Equal

;     mov [eax+13*04], ebx                ; Salva ebx
;     pop ebx
;     mov [eax+10*04], eax                ; Salva eax ¡¡¡OJO ACA!!!!
;     mov [eax+11*04], ecx                ; Salva ecx
;     mov [eax+12*04], edx                ; Salva edx
; ;    mov [eax+14*04], [esp+16]           ; Salva esp
;     mov [eax+15*04], ebp                ; Salva ebp
;     mov [eax+16*04], esi                ; Salva esi
;     mov [eax+17*04], edi                ; Salva edi
    

; ;   REGISTROS DE STACK
;     mov ebx, [esp+04*1]                  
;     mov [eax+8*04], ebx                  ; Salva eip
;     mov ebx, [esp+04*2]                  
;     mov [eax+19*04],ebx                  ; reserved / CS del stack
;     mov ax, [esp+04*3]                   ; EFLAGS 16 bits
;     mov [eax+9*04], ax                   ; EFLAGS del stack
    

; ;   REGISTROS DE SEGMENTO
;     mov [eax+18*04], es                  ; Salva es    
;     mov [eax+20*04], ss                  ; Salva ss
;     mov [eax+21*04], ds                  ; Salva ds   
;     mov [eax+22*04], fs                  ; Salva fs       
;     mov [eax+23*04], gs                  ; Salva gs

;     ret

; load_context:
; ;   CARGA EL DPT DE NEXT_TASK EN CR3
;     cmp byte [TASK01], NEXT_TASK
;     cmove eax, [DPT_TASK01_VMA]         ; Move if Equal

;     cmp byte [TASK02], NEXT_TASK
;     cmove eax, [DPT_TASK02_VMA]         ; Move if Equal

;     cmp byte [TASK03], NEXT_TASK
;     cmove eax, [DPT_TASK03_VMA]         ; Move if Equal

;     cmp byte [TASK04], NEXT_TASK
;     cmove eax, [DPT_TASK04_VMA]         ; Move if Equal
    
;     mov cr3, eax

; ;   RECUPERA CONTEXTO DE NEXT_TASK DESDE LA TSS
;     cmp byte [TASK01], NEXT_TASK
;     cmove eax, [TASK01_TSS_VMA]         ; Move if Equal

;     cmp byte [TASK02], NEXT_TASK
;     cmove eax, [TASK02_TSS_VMA]         ; Move if Equal

;     cmp byte [TASK03], NEXT_TASK
;     cmove eax, [TASK03_TSS_VMA]         ; Move if Equal

;     cmp byte [TASK04], NEXT_TASK
;     cmove eax, [TASK04_TSS_VMA]         ; Move if Equal

;     mov ebx, [eax + 0]                  ; Recupera ebx
;     mov ecx, [eax + 4]                  ; Recupera ecx
;     mov edx, [eax + 16] 
;     mov esi, edx                        ; Recupera esi
;     mov edx, [eax + 20]
;     mov edi, edx                        ; Recupera edi
;     mov edx, [eax + 24]
;     mov ebp, edx                        ; Guarda ebp
;     mov edx, [eax + 32]
;     mov gs,  edx                        ; Recupera gs
;     mov edx, [eax + 36]
;     mov fs,  edx                        ; Recupera fs
;     mov edx, [eax + 44]
;     mov es,  edx                        ; Recupera es
;     mov edx, [eax + 48]
;     mov ds,  edx                        ; Recupera ds

;     ret    
