%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;cele doua numere se gasesc in eax si ebx
    mov eax, 4
    mov ebx, 1
    
    ; TODO: aflati minimul
    PRINT_STRING 'min( '
    PRINT_DEC 4, eax
    PRINT_STRING ' , '
    PRINT_DEC 4, ebx
    PRINT_STRING" ) = "
    
    cmp eax, ebx
    jge schimba
    
    PRINT_DEC 4, eax
    ret
    
schimba:
    xchg eax, ebx ; interschimbam eax cu ebx
    PRINT_DEC 4, eax
    ret