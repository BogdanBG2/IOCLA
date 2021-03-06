%include "io.inc"

%define ARRAY_SIZE 13
%define DECIMAL_PLACES 5

section .data
    num_array dw 76, 12, 65, 19, 781, 671, 431, 761, 782, 12, 91, 25, 9
    array_sum_prefix db "Sum of numbers: ",0
    array_mean_prefix db "Numbers mean: ",0
    decimal_point db ".",0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    
    xor eax, eax
    mov ecx, 13

    ; TODO1 - compute the sum of the vector numbers - store it in ax
    
L1: 
    add ax, word [num_array + 2 * (ecx - 1)]
    loop L1

    PRINT_STRING array_sum_prefix
    PRINT_UDEC 2, ax
    NEWLINE

    ; TODO2 - compute the quotient of the mean

    PRINT_STRING "AX (result) = "
    PRINT_UDEC 2, ax
    NEWLINE
    
    push eax
    mov bx, 13
    mov edx, 0 ; zero-extension
    div bx
    
    PRINT_STRING "DX (rest) = "
    PRINT_UDEC 2, dx
    NEWLINE
    
    PRINT_STRING array_mean_prefix
    PRINT_UDEC 2, ax
    PRINT_STRING decimal_point

    mov ecx, DECIMAL_PLACES
    pop eax
    
    mov ecx, 7
compute_decimal_place:
    ; TODO3 - compute the current decimal place - store it in ax
    xchg edx, eax ; cat -> edx, rest -> eax
    mov bx, 10
    mul bx ; rest -> rest * 10
    mov bx, ARRAY_SIZE
    div bx ; rest * 10 / ArraySize
    
    PRINT_UDEC 2, ax ; se afiseaza catul impartirii de mai sus 
    dec ecx
    jg compute_decimal_place

    NEWLINE

    xor eax, eax
    ret
