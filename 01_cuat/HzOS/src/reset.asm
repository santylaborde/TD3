BITS 16
GLOBAL Reset
EXTERN Init16

SECTION .Reset
Reset:          ;0xfffffff0
    cli         ;fffffff1 (1)
    jmp Init16  ;ffff fff3 (2)
    ALIGN 16    ;(nop) -> 0x90

    