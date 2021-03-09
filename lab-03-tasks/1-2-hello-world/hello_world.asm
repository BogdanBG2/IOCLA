%include "io.inc"

section .data
    Sir1: db "Hello, World!", 10, "My name is Larry!", 0
    Sir2: db "Goodbye, World!", 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp ; for correct debugging
    mov ecx, 6 ; in acest casz, n = 6
    mov eax, 3 
    mov ebx, 2
    cmp eax, ebx ; TODO1: eax > ebx? 
    jg print
    ret

print:
L1: ; TODO 2.2
    PRINT_STRING Sir1
    NEWLINE
    dec ecx
    jg L1

    NEWLINE
    PRINT_STRING Sir2 ;TODO 2.1