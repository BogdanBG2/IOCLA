%include "io.inc"

; https://en.wikibooks.org/wiki/X86_Assembly/Arithmetic

section .data
    string_quotient db "Quotient: ", 0
    string_remainder db "Remainder: ", 0
    dividend1 db 91
    divisor1 db 27
    dividend2 dd 67254
    divisor2 dw 1349
    dividend3 dq 69094148
    divisor3 dd 87621

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp

    xor eax, eax

    mov al, byte [dividend1]
    mov bl, byte [divisor1]
    div bl
    
    PRINT_STRING "IMPARTIREA 1"
    NEWLINE
    PRINT_STRING string_quotient
    PRINT_UDEC 1, al
    NEWLINE
    PRINT_STRING string_remainder
    PRINT_UDEC 1, ah
    NEWLINE
    NEWLINE


    ; TODO: Calculate quotient and remainder for 67254 / 1349.
    xor eax, eax
    xor ebx, ebx
    xor edx, edx

    mov ax, word [dividend2]
    mov bx, word [divisor2]
    div bx
    
    PRINT_STRING "IMPARTIREA 2"
    NEWLINE
    PRINT_STRING string_quotient
    PRINT_UDEC 4, ax
    NEWLINE
    PRINT_STRING string_remainder
    PRINT_UDEC 4, dx
    NEWLINE
    NEWLINE

    ; TODO: Calculate quotient and remainder for 69094148 / 87621.
    xor eax, eax
    xor ebx, ebx
    xor edx, edx

    mov eax, dword [dividend3]
    mov ebx, dword [divisor3]
    div ebx
    
    PRINT_STRING "IMPARTIREA 3"
    NEWLINE
    PRINT_STRING string_quotient
    PRINT_UDEC 4, eax
    NEWLINE
    PRINT_STRING string_remainder
    PRINT_UDEC 4, edx
    NEWLINE
    NEWLINE
    
    leave
    ret
