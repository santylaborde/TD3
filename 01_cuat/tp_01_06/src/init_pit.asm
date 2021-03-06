;------------------------------------------------------------------------------------------------------------
;		init_pit
;
;	Funcion: 	Inicializa el programmable interval timer
;				
;------------------------------------------------------------------------------------------------------------
GLOBAL init_pit

USE32

;____________________________________________________________________________________
section .init32
init_pit:
    push    ax
    mov     al,00110100b
    out     43h,al            ; le avisa al PIT que usamos el channel 0
    mov     ax,1193     
    mov     cx,10
    mul     cx                ; 1193*10 = 11930
    out     40h,al
    mov     al,ah
    out     40h,al
    pop     ax
    ret
;____________________________________________________________________________________
