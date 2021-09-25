; ******************************* SCHEDULER  ****************************************
; ********** CODIGO ********************** Comentarios ******************************
%include "inc/procesor-flags.h"

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
EXTERN KERNEL_TSS_VMA
EXTERN TASK02_MMX_VMA
EXTERN TASK03_MMX_VMA
EXTERN scheduler_back

EXTERN TICKS01                          ; importa de seccion "data"                         
EXTERN TICKS02
EXTERN TICKS03
EXTERN CURRENT_TASK
EXTERN NEXT_TASK    
EXTERN LAST_MMX

EXTERN TASK01                           ; importa defines    
EXTERN TASK02
EXTERN TASK03
EXTERN TASK04
EXTERN FIRST 

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
    cmp byte [TICKS02], 10             ; 100ms
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

    mov eax, [NEXT_TASK]
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
;   LINK
;   mov [eax+4*00] ,  
;   STACK00
;   mov [eax+4*01] , ESP0  (Hace falta)
;   mov [eax+4*02] , SS0 (Hace falta)
;   STACK01
;   mov [eax+4*03] ,
;   mov [eax+4*04] , 
;   STACK02
;   mov [eax+4*05] ,
;   mov [eax+4*06] ,
;   DPT
;   mov [eax+4*07]  
;   INSTRUCTION POINTER
;   mov     ebx     , [esp+4*08]          ; Recupera eip
;   mov [eax+4*08]  ,    ebx              ; Guarda eip
;   EFLAGS  
;   mov     ebx     , [esp+4*10]          ; Recupera eflags
;   mov [eax+4*09]  ,    ebx              ; Guarda eflags
;   REGISTROS PROPOSITO GENERAL (PUSHAD) 
    mov     ebx     , [esp+4*07]          ; Recupera eax  
    mov [eax+4*10]  ,    ebx              ; Guarda eax
    mov     ebx     , [esp+4*06]          ; Recupera ecx
    mov [eax+4*11]  ,    ebx              ; Guarda ecx
    mov     ebx     , [esp+4*05]          ; Recupera edx
    mov [eax+4*12]  ,    ebx              ; Guarda edx
    mov     ebx     , [esp+4*04]          ; Recupera ebx
    mov [eax+4*13]  ,    ebx              ; Guarda ebx
    mov     ebx     , [esp+4*03]          
    add     ebx     ,     12              
    mov     ebx     , [esp+4*02]          ; Recupera esp
;   mov [eax+4*14]  ,    ebx              ; Guarda esp
;   mov [eax+4*15]  ,    ebx              ; Guarda ebp
    mov     ebx     , [esp+4*01]          ; Recupera esi
    mov [eax+4*16]  ,    ebx              ; Guarda esi
    mov     ebx     , [esp+4*00]          ; Recupera edi
    mov [eax+4*17]  ,    ebx              ; Guarda edi
;   REGISTROS DE SEGMENTO
    mov [eax+4*18]  ,     es              ; Guarda es
;   mov     ebx     , [esp+4*09]          ; Recupera cs
;   mov [eax+4*19]  ,    ebx              ; Guarda cs
;   mov [eax+4*20]  ,     ss              ; Guarda ss
    mov [eax+4*21]  ,     ds              ; Guarda ds
    mov [eax+4*22]  ,     fs              ; Guarda fs
    mov [eax+4*23]  ,     gs              ; Guarda gs
;   LDTR & IOPB (INIT VALUE)
;   mov [eax+4*24]  
;   mov [eax+4*25]  

    mov eax, [LAST_MMX]                   ; FLAG seteado por ISR7_handler_NM
    cmp [CURRENT_TASK], eax
    je save_mmx_context

    mmx_saved:    
    jmp save_context_back

    save_mmx_context:
    mov eax, TASK02_MMX_VMA
    cmp byte [LAST_MMX], TASK02
    je fx_save

    mov eax, TASK03_MMX_VMA
    cmp byte [LAST_MMX], TASK03
    jne mmx_saved

    fx_save:
    fxsave &eax
    mov dword [LAST_MMX], FIRST
    jmp mmx_saved

;********************************
load_context:
;   SETEA EL BIT CR0.TS (TASK SWITCH)
    mov eax, cr0
    or  eax, X86_CR0_TS
    mov cr0, eax

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
;   CARGA CONTEXTO DESDE EL "TSS" DE LA TAREA
;   CAMBIO DE STACK A STACK00
	mov  esp , [eax + 4*01]             ; ESP = ESP0
	mov   ss , [eax + 4*02]             ; SS  = SS0
;   CAMBIO DE STACK A STACK01
;	mov  esp , [eax + 4*03]             ; ESP = ESP1
;	mov   ss , [eax + 4*04]             ; SS  = SS1
;   REGISTROS PROPOSITO GENERAL              
;   mov  eax , [eax + 4*10]             ; EAX (Lo voy a usar hasta el final)   
;   mov  ecx , [eax + 4*11]             ; ECX (Lo voy a usar hasta el final)   
    mov  edx , [eax + 4*12]             ; EDX
    mov  ebx , [eax + 4*13]             ; EBX
;   mov  esp , [eax + 4*14]             ; ESP (Lo cargamos al principio)
    mov  ebp , [eax + 4*15]             ; EBP
    mov  esi , [eax + 4*16]             ; ESI    
    mov  edi , [eax + 4*17]             ; EDI
;   REGISTROS DE SEGMENTO
    mov   es , [eax + 4*18]             ; ES
;   mov   cs , [eax + 4*19]             ; CS  (Se pushea)
;   mov   ss , [eax + 4*20]             ; SS  (Lo cargamos al principio) 
    mov   ds , [eax + 4*21]             ; DS
    mov   fs , [eax + 4*22]             ; FS      
    mov   gs , [eax + 4*23]             ; GS
;   GUARDA EN STACK SS
    mov  ecx , [eax + 4*20]             ; SS3
    push ecx
;   GUARDA EN STACK ESP
    mov  ecx , [eax + 4*14]             ; ESP3
    push ecx
;   GUARDA EN STACK EFLAGS
    mov  ecx , [eax + 4*09]             ; EFLAGS
    push ecx  
;   GUARDA EN STACK CS
    mov  ecx , [eax + 4*19]             ; CS
    push ecx  
;   GUARDA EN STACK EIP
    mov  ecx , [eax + 4*08]             ; EIP
    push ecx  

;   CARGA CONTEXTO EN EL TSS DEL KERNEL
;   EAX = TASK0X_TSS_VMA
    mov  ecx, [eax + 4*00]
    mov  [KERNEL_TSS_VMA + 4*00], ecx   ; Previous task link  (INIT VALUE)
    mov  ecx, [eax + 4*01]
    mov  [KERNEL_TSS_VMA + 4*01], ecx   ; ESP0
    mov  ecx, [eax + 4*02]
    mov  [KERNEL_TSS_VMA + 4*02], ecx   ; SS0 
    mov  ecx, [eax + 4*03]
    mov  [KERNEL_TSS_VMA + 4*03], ecx   ; ESP1 (INIT VALUE)
    mov  ecx, [eax + 4*04]
    mov  [KERNEL_TSS_VMA + 4*04], ecx   ; SS1  (INIT VALUE)
    mov  ecx, [eax + 4*05]
    mov  [KERNEL_TSS_VMA + 4*05], ecx   ; ESP2 
    mov  ecx, [eax + 4*06]
    mov  [KERNEL_TSS_VMA + 4*06], ecx   ; SS2  
    mov  ecx, [eax + 4*07]
    mov  [KERNEL_TSS_VMA + 4*07], ecx   ; CR3
    mov  ecx, [eax + 4*08]
    mov  [KERNEL_TSS_VMA + 4*08], ecx   ; EIP
    mov  ecx, [eax + 4*09]
    mov  [KERNEL_TSS_VMA + 4*09], ecx   ; EFLAGS
    mov  ecx, [eax + 4*10]
    mov  [KERNEL_TSS_VMA + 4*10], ecx   ; EAX
    mov  ecx, [eax + 4*11]
    mov  [KERNEL_TSS_VMA + 4*11], ecx   ; ECX
    mov  ecx, [eax + 4*12]
    mov  [KERNEL_TSS_VMA + 4*12], ecx   ; EDX
    mov  ecx, [eax + 4*13]
    mov  [KERNEL_TSS_VMA + 4*13], ecx   ; EBX
    mov  ecx, [eax + 4*14]
    mov  [KERNEL_TSS_VMA + 4*14], ecx   ; ESP
    mov  ecx, [eax + 4*15]
    mov  [KERNEL_TSS_VMA + 4*15], ecx   ; EBP
    mov  ecx, [eax + 4*16]
    mov  [KERNEL_TSS_VMA + 4*16], ecx   ; ESI
    mov  ecx, [eax + 4*17]
    mov  [KERNEL_TSS_VMA + 4*17], ecx   ; EDI
    mov  ecx, [eax + 4*18]
    mov  [KERNEL_TSS_VMA + 4*18], ecx   ; ES
    mov  ecx, [eax + 4*19]
    mov  [KERNEL_TSS_VMA + 4*19], ecx   ; CS
    mov  ecx, [eax + 4*20]
    mov  [KERNEL_TSS_VMA + 4*20], ecx   ; SS
    mov  ecx, [eax + 4*21]
    mov  [KERNEL_TSS_VMA + 4*21], ecx   ; DS
    mov  ecx, [eax + 4*22]
    mov  [KERNEL_TSS_VMA + 4*22], ecx   ; FS
    mov  ecx, [eax + 4*23]
    mov  [KERNEL_TSS_VMA + 4*23], ecx   ; GS
    mov  ecx, [eax + 4*24]
    mov  [KERNEL_TSS_VMA + 4*24], ecx   ; LDTR (INIT VALUE)
    mov  ecx, [eax + 4*25]
    mov  [KERNEL_TSS_VMA + 4*25], ecx   ; IOPB (INIT VALUE)

    ;   ECX & EAX
    mov  ecx , [eax + 4*08]             ; ECX
    mov  eax , [eax + 4*07]             ; EAX

    iret                                ; Retoma la ejecución de la tarea
    jmp load_context_back
;____________________________________________________________________________________
