%include "io.inc"
extern printf

section .data
    before_format   db "Before:   %s", 13, 10, 0
    after_format    db "---- RESULT ----", 10, "%s", 0
    mystring        db "Ana", 0, "are", 0, "mere", 0
    len             dw 12

section .text
global CMAIN

ROT13:
    push    ebp
    mov     ebp, esp

    ; TODO
    mov     eax, [ebp + 8]
    push    eax
    mov     ecx, 0
L1:
    cmp     byte [eax], 0
    je      ZERO
    cmp     byte [eax], 90
    jle     instr1    
    cmp     byte [eax], 97
    jge     instr2    
instr1: ; litera mare [65, 90]
    cmp     byte [eax], 65
    jl      NEXT    
    cmp     byte [eax], 78
    jl      PLUS
    cmp     byte [eax], 78
    jge     MINUS
instr2: ; litera mica [97, 122]
    cmp     byte [eax], 122
    jg      NEXT    
    cmp     byte [eax], 110
    jl      PLUS
    cmp     byte [eax], 110
    jge     MINUS        
PLUS:
    add     byte [eax], 13
    jmp     NEXT    
MINUS:
    sub     byte [eax], 13
    jmp     NEXT
ZERO:
    mov     byte [eax], 32
NEXT:
    inc     eax
    inc     ecx
    cmp     ecx, [len]
    jl      L1        
    pop     eax
    leave
    ret

CMAIN:
    push    ebp
    mov     ebp, esp

    ;push    mystring
    ;push    before_format
    ;call    printf
    ;mov     esp, ebp

    push    mystring
    call    ROT13
    mov     esp, ebp
    
    push    mystring
    push    after_format
    call    printf
    mov     esp, ebp
    
    leave
    ret
