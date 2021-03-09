%include "io.inc"

section .data
    X db 1, 2, 3, 4, 6, 8, 70

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    mov ebp, esp ; for correct debugging
    
    xor eax, eax
    mov ecx, 7
    xor edx, edx ; nr. pozitive
    xor ebx, ebx ; nr. negative
    
L1:
    mov al, [X + ecx - 1]
    and al, 1
    jg odd
    je even
    
    xor eax, eax
    ret
    
print:
    PRINT_STRING 'Odd integers: '
    PRINT_UDEC 4, edx
    NEWLINE
    PRINT_STRING 'Even integers: '
    PRINT_UDEC 4, ebx
    NEWLINE

    
odd:
    inc edx

    dec ecx
    jg L1
    je print
    ret
        
even:
    inc ebx

    dec ecx
    jg L1   
    je print
    ret
