%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ecx, 9
    mov eax, 1 ; f(n). La inceput, n = 1
    mov ebx, 0 ; f(n - 1)
    xor edx, edx ; vom calcula suma in edx
    
    L1:
    add edx, ebx
    PRINT_DEC 4, ebx
    PRINT_STRING ' '
    xchg eax, ebx
    add eax, ebx
    dec ecx
    cmp ecx, 0
    jg L1
    
    NEWLINE
    PRINT_STRING "Suma acestor termeni = "
    PRINT_UDEC 4, edx
    ret