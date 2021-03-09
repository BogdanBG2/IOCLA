%include "io.inc"

section .data
    X dd 1, 3, -4, 5, -6, -11, 0

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
    mov al, [X + 4 * (ecx - 1)]
    test al, al
    jge pozitive
    jl negative
    
    xor eax, eax
    ret
    
print:
    PRINT_STRING 'Pozitive integers: '
    PRINT_UDEC 4, edx
    NEWLINE
    PRINT_STRING 'Negative integers: '
    PRINT_UDEC 4, ebx
    NEWLINE

    
pozitive:
    inc edx

    dec ecx
    jg L1
    je print
    ret
        
negative:
    inc ebx

    dec ecx
    jg L1   
    je print
    ret
