%include "io.inc"

section .data
    string db 'Lorem ipsum dolor sit amet.', 0
    print_strlen db "strlen: ", 10, 0
    print_occ db "occurences of `m`:", 10, 0

    occurences dd 0
    length dd 0    
    char db 'm'

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging

; ------------------------ TASK 2 -------------------
    xor ecx, ecx
    xor ebx, ebx
    xor eax, eax
        
    mov cl, 100
    mov edi, string
    mov al, 0
    mov byte [length], cl
    
    cld
    repne scasb
    
    inc ecx
    sub [length], ecx
    
    PRINT_STRING print_strlen
    PRINT_UDEC 4, length
    NEWLINE

;------------------------ TASK 3 -------------------
    xor ecx, ecx
    xor ebx, ebx
    xor eax, eax
    
    mov cl, byte [length]
    mov edi, string    
    mov al, byte [char]
    
L1:
    cld
    repne scasb
    inc bl
    cmp ecx, 0
    jg L1
        
    dec bl
    mov byte [occurences], bl
    PRINT_STRING print_occ
    PRINT_UDEC 4, occurences
    NEWLINE