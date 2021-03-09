%include "io.inc"

%define NUM_FIBO 9

section .text
global CMAIN
CMAIN:
    mov ebp, esp

    ; TODO - replace below instruction with the algorithm for the Fibonacci sequence
    sub esp, NUM_FIBO * 4
    mov ecx, NUM_FIBO
    mov ebx, 0
    mov eax, 1
    
L1:
    mov [esp + 4 * (ecx - 1)], ebx
    
    push eax
    push ebx
    pop eax
    pop ebx

    add eax, ebx
    loop L1

    mov ecx, NUM_FIBO
print:
    PRINT_UDEC 4, [esp + (ecx - 1) * 4]
    NEWLINE
    dec ecx
    jg print

    mov esp, ebp
    xor eax, eax
    ret
