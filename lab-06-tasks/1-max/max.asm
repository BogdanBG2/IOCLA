%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ; cele doua numere se gasesc in eax si ebx
    mov eax, 4
    mov ebx, 1

    ; TODO: aflati maximul folosind doar o instructiune de salt si push/pop
    PRINT_STRING "BEFORE: a = "
    PRINT_UDEC 4, eax
    PRINT_STRING ", b = "
    PRINT_UDEC 4, ebx
    NEWLINE
    
    cmp eax, ebx
    jl schimba
    
print:
    
    PRINT_STRING "AFTER:    a = "
    PRINT_UDEC 4, eax
    PRINT_STRING ", b = "
    PRINT_UDEC 4, ebx
    NEWLINE
    ret

schimba:
    push eax
    ;mov eax, ebx
    ;pop ebx
    push ebx
    pop eax
    pop ebx
    jmp print
    ret
