%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging

    mov eax, 211    ; to be broken down into powers of 2
    mov ebx, 1      ; stores the current power
    mov ecx, 8
    
    ; TODO - print the powers of 2 that generate number stored in EAX
    L1:
    mov edx, eax
    and edx, ebx
    
    shl ebx, 1
    test edx, edx
    jg pn
    jmp next
    
    xor ebx, ebx
    xor eax, eax
    
pn:
    PRINT_UDEC 4, edx
    NEWLINE

next:
    dec ecx
    jg L1