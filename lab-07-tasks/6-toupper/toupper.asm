%include "io.inc"
extern printf

section .data
    before_format db "Before:   %s", 13, 10, 0
    after_format db "After:      %s", 13, 10, 0
    mystring db 10,"Cerinta sase", 0

section .text
global CMAIN

toupper:
    push ebp
    mov ebp, esp

    ; TODO
    mov eax, [ebp + 8]
    push eax    
    
L1:
    cmp byte [eax], 'a'
    jl NEXT
    cmp byte [eax], 'z'
    jg NEXT
    sub byte [eax], 32
        
NEXT:
    inc eax
    cmp byte [eax], 0
    jg L1
    
    pop eax
    leave
    ret

CMAIN:
    push ebp
    mov ebp, esp

    push mystring
    push before_format
    call printf
    mov esp, ebp
    
    push mystring
    call toupper
    mov esp, ebp
    
    push mystring
    push after_format
    call printf
    mov esp, ebp
    
    leave
    ret
