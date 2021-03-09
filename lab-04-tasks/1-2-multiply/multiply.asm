%include "io.inc"

; https://en.wikibooks.org/wiki/X86_Assembly/Arithmetic

section .data
    newline db 13, 10, 0
    num1 db 37
    num2 db 44
    num1_w dw 1349
    num2_w dw 9949
    num1_d dd 134932
    num2_d dd 994912
    print_mesaj dd 'Rezultatul este:    ', 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp

    ; Multiplication for db
    mov al, byte [num1]
    ;mov bl, byte [num2]
    mul byte [num2]
    
    ; Print result in hexa
    PRINT_STRING [print_mesaj]
    PRINT_HEX 1, ah
    PRINT_STRING " : "
    PRINT_HEX 1, al
    NEWLINE

   ; TODO: Implement multiplication for dw and dd data types.
    mov ax, word [num1_w]
    ;mov bx, word [num2_w]
    mul word [num2_w]
    
    PRINT_STRING [print_mesaj]
    PRINT_HEX 2, dx
    PRINT_STRING " : "
    PRINT_HEX 2, ax
    NEWLINE
    
    mov eax, dword [num1_d]
    ;mov ebx, dword [num2_d]
    mul dword [num2_d]
    
    PRINT_STRING [print_mesaj]
    PRINT_HEX 4, edx
    PRINT_STRING " : "
    PRINT_HEX 4, eax
    NEWLINE

    leave
    ret
