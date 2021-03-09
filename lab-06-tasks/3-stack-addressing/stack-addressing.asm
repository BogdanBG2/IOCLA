%include "io.inc"

%define NUM 5

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    mov edx, 0
    ; TODO 1: replace every push by an equivalent sequence of commands

push_stack:
    mov ecx, NUM
push_nums:
    sub esp, 4
    mov [esp], ecx
    loop push_nums

    mov eax, 0
    sub esp, 4
    mov [esp], eax
    
    mov eax, "mere"
    sub esp, 4
    mov [esp], eax
    
    mov eax, "are "
    sub esp, 4
    mov [esp], eax
    
    mov eax, "Ana "
    sub esp, 4
    mov [esp], eax

    cmp edx, 0
    je task1
    jg task2    
    ;PRINT_STRING [esp]
    ;NEWLINE

    ; TODO 2: print the stack in "address: value" format in the range of [ESP:EBP]
task1:
L1:
    PRINT_STRING "0x"
    PRINT_HEX 4, esp
    PRINT_STRING ": "
    PRINT_UDEC 1, [esp]
    inc esp
    NEWLINE
    cmp [esp], ebp
    jge L1
    PRINT_STRING "-------------------"
    NEWLINE

    inc edx
    jmp push_stack

    ; TODO 3: print the string    
task2:
    mov ecx, 12
loop:
    mov al, [esp]
    PRINT_CHAR al
    inc esp
    dec ecx
    jg loop
    
    add esp, 4 ; mai aveam un 0 de la capatul sirului de caractere
    NEWLINE
    mov ecx, NUM
    
L3:
    PRINT_UDEC 1, [esp]
    PRINT_STRING " "
    add esp, 4
    dec ecx
    jg L3
    
    ; restore the previous value of the EBP (Base Pointer)
    mov esp, ebp

    ; exit without errors
    xor eax, eax
    ret
