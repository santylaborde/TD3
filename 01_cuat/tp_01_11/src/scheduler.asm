; ******************************* SCHEDULER  ****************************************
; ********** CODIGO ********************** Comentarios ******************************

USE32
GLOBAL scheduler                        ; exporta etiqueta

EXTERN DPT_TASK01_VMA                   ; importa etiquetas
EXTERN DPT_TASK02_VMA
EXTERN DPT_TASK03_VMA
EXTERN DPT_TASK04_VMA
EXTERN TASK01_TSS_VMA
EXTERN TASK02_TSS_VMA
EXTERN TASK03_TSS_VMA
EXTERN TASK04_TSS_VMA
EXTERN scheduler_back

TASK01 EQU 1                            ; defines
TASK02 EQU 2
TASK03 EQU 3
TASK04 EQU 4
FIRST  EQU 0

section .data
TICKS01:                                ; variables
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

;____________________________________________________________________________________
section .my_scheduler
;********************************
scheduler:
;   Incrementa contadores
    inc byte [TICKS01]       
    inc byte [TICKS02]       
    inc byte [TICKS03] 

;   Determina a que TAREA le toca correr
check_ticks:
    cmp byte [TICKS02], 60             ; 100ms
    je task02_time

    cmp byte [TICKS03], 20             ; 200ms
    je task03_time

    cmp byte [TICKS01], 50             ; 500ms
    je task01_time

    jmp task04_time

;   Setea el FLAG de NEXT_TASK con la TAREA a correr   
task01_time:
    mov dword [NEXT_TASK], TASK01
    mov dword [TICKS01], 0
    jmp run_task

task02_time:
    mov dword [NEXT_TASK], TASK02
    mov dword [TICKS02], 0
    jmp run_task

task03_time:
    mov dword [NEXT_TASK], TASK03
    mov dword [TICKS03], 0
    jmp run_task

task04_time:
    mov dword [NEXT_TASK], TASK04
    jmp run_task

;   Cambia el contexto actual por el siguiente
switch_task:
    jmp save_context   
    save_context_back:
    
    switched:
    mov eax, [NEXT_TASK]
    mov [CURRENT_TASK], eax
    
    jmp load_context  
    load_context_back:

;   Corre la tarea
run_task:
    cmp byte [CURRENT_TASK], FIRST        ; tarea actual igual a la primera?
    je switched                           ; Move if Equal

    cmp [CURRENT_TASK], eax               ; tarea actual igual a la proxima?
    jne switch_task

;   Sale del scheduler
end:
    jmp scheduler_back
;********************************

save_context:
;   SALVA CONTEXTO DE CURRENT_TASK EN TSS
    mov eax, TASK01_TSS_VMA
    cmp byte [CURRENT_TASK], TASK01
    je tss_ready_for_saving             ; cmove eax, TASK01_TSS_VMA (Move if Equal)      

    mov eax, TASK02_TSS_VMA
    cmp byte [CURRENT_TASK], TASK02
    je tss_ready_for_saving             ; cmove eax, TASK02_TSS_VMA (Move if Equal)

    mov eax, TASK03_TSS_VMA
    cmp byte [CURRENT_TASK], TASK03
    je tss_ready_for_saving             ; cmove eax, TASK03_TSS_VMA (Move if Equal)

    mov eax, TASK04_TSS_VMA
    cmp byte [CURRENT_TASK], TASK04     ; cmove eax, TASK04_TSS_VMA (Move if Equal)
    jne end                   

    tss_ready_for_saving:
;   RECUPERA DE LA PILA PARA GUARDAR EN TSS
;   REGISTROS PROPOSITO GENERAL (PUSHAD) 
    mov     ebx     , [esp+4*07]          ; Recupera eax  
    mov [eax+4*00]  ,   ebx               ; Guarda eax
    mov     ebx     , [esp+4*04]          ; Recupera ebx
    mov [eax+4*01]  ,   ebx               ; Guarda ebx
    mov     ebx     , [esp+4*06]          ; Recupera ecx
    mov [eax+4*02]  ,   ebx               ; Guarda ecx
    mov     ebx     , [esp+4*05]          ; Recupera edx
    mov [eax+4*03]  ,   ebx               ; Guarda edx
    mov     ebx     , [esp+4*01]          ; Recupera esi
    mov [eax+4*04]  ,   ebx               ; Guarda esi
    mov     ebx     , [esp+4*00]          ; Recupera edi
    mov [eax+4*05]  ,   ebx               ; Guarda edi
    mov     ebx     , [esp+4*02]          ; Recupera ebp
    mov [eax+4*06]  ,   ebx               ; Guarda ebp
    mov     ebx     , [esp+4*03]          ; Recupera esp
    add     ebx     ,   12
    mov [eax+4*07]  ,   ebx               ; Guarda esp
;   INSTRUCTION POINTER
    mov     ebx     , [esp+4*08]          ; Recupera eip
    mov [eax+4*08]  ,   ebx               ; Guarda eip
;   EFLAGS  
    mov     ebx     , [esp+4*10]          ; Recupera eflags
    mov [eax+4*09]  ,   ebx               ; Guarda eflags
;   REGISTROS DE SEGMENTO
    mov     ebx     , [esp+4*09]          ; Recupera cs
    mov [eax+4*10]  ,   ebx               ; Guarda cs
    mov [eax+4*11]  ,   ds                ; Guarda ds
    mov [eax+4*12]  ,   es                ; Guarda es
    mov [eax+4*13]  ,   ss                ; Guarda ss
    mov [eax+4*14]  ,   fs                ; Guarda fs
    mov [eax+4*15]  ,   gs                ; Guarda gs

    jmp save_context_back

load_context:
;   CARGA EL DPT DE NEXT_TASK EN CR3
    mov eax, DPT_TASK01_VMA
    cmp byte [NEXT_TASK], TASK01
    je cr3_ready_for_loading            ; cmove eax, DPT_TASK01_VMA (Move if Equal)      

    mov eax, DPT_TASK02_VMA
    cmp byte [NEXT_TASK], TASK02
    je cr3_ready_for_loading            ; cmove eax, DPT_TASK02_VMA (Move if Equal)

    mov eax, DPT_TASK03_VMA
    cmp byte [NEXT_TASK], TASK03
    je cr3_ready_for_loading            ; cmove eax, DPT_TASK03_VMA (Move if Equal)

    mov eax, DPT_TASK04_VMA
    cmp byte [NEXT_TASK], TASK04
    jne end                             ; cmove eax, DPT_TASK04_VMA (Move if Equal)

    cr3_ready_for_loading:
    mov cr3, eax

;   RECUPERA CONTEXTO DE NEXT_TASK DESDE LA TSS
    mov eax, TASK01_TSS_VMA
    cmp byte [NEXT_TASK], TASK01
    je tss_ready_for_loading            ; cmove eax, TASK01_TSS_VMA (Move if Equal)      

    mov eax, TASK02_TSS_VMA
    cmp byte [NEXT_TASK], TASK02
    je tss_ready_for_loading            ; cmove eax, TASK02_TSS_VMA (Move if Equal)      

    mov eax, TASK03_TSS_VMA
    cmp byte [NEXT_TASK], TASK03
    je tss_ready_for_loading            ; cmove eax, TASK03_TSS_VMA (Move if Equal)      

    mov eax, TASK04_TSS_VMA
    cmp byte [NEXT_TASK], TASK04        ; cmove eax, TASK04_TSS_VMA (Move if Equal)      
    jne end

    tss_ready_for_loading:
;   CAMBIO DE STACK
	mov  esp , [eax+4*07]               ; esp = ebp
	mov  ss  , [eax+4*13]               ; ss  = ss

;   REGISTROS PROPOSITO GENERAL                 
    mov  ecx , [eax+4*02]               ; ecx
    mov  edx , [eax+4*03]               ; edx
    mov  ebx , [eax+4*04]
    mov  esi ,    ebx                   ; esi
    mov  ebx , [eax+4*05]
    mov  edi ,    ebx                   ; edi
    mov  ebx , [eax+4*06]
    mov  ebp ,    ebx                   ; ebp
;   REGISTROS DE SEGMENTO
    mov  ebx , [eax+4*11]               
    mov  ds  ,     ebx                  ; ds
    mov  ebx , [eax+4*12]               
    mov  es  ,     ebx                  ; es
    mov  ebx , [eax+4*14]               
    mov  fs  ,     ebx                  ; fs
    mov  ebx , [eax+4*15]                   
    mov  gs  ,     ebx                  ; gs
;   EFLAGS
    mov  ebx , [eax+4*09]              ; eflags
    push ebx                           ; Resguarda en STACK
;   CS
    mov  ebx , [eax+4*10]              ; cs
    push ebx                           ; Resguarda en STACK
;   INSTRUCTION POINTER
    mov  ebx , [eax+4*08]              ; eip
    push ebx                           ; Resguarda en STACK

;   EAX & EBX
    mov  eax , [eax+4*00]              ; eax 
    mov  ebx , [eax+4*01]              ; ebx

    iret                               ; Retoma ejecución de la tarea
    jmp load_context_back    
;____________________________________________________________________________________
