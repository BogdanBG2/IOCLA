%include "io.inc"

section .data
    num dd 3
section .text
global CMAIN
CMAIN:
    ;write your code here
    xor eax, eax
    
    mov eax, 1
    mov ecx, dword [num]
    xor edx, edx
    
    PRINT_STRING "n = "
    PRINT_UDEC 4, ecx
    NEWLINE
L1:
    mul ecx
    loop L1
    
    PRINT_STRING "n! = "
    PRINT_UDEC 4, eax
    ret