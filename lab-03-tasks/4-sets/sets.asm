%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;cele doua multimi se gasesc in eax si ebx
    mov eax, 139 ; A = {0, 1, 3, 7}
    mov ebx, 169 ; B = {0, 3, 5, 7}
    PRINT_STRING "A = "
    PRINT_DEC 4, eax ; afiseaza prima multime
    NEWLINE
    PRINT_STRING "B = "
    PRINT_DEC 4, ebx ; afiseaza cea de-a doua multime
    NEWLINE
    PRINT_STRING "----------------"
    NEWLINE
    
    
    ; Pentru a pastra multimile initiale, vom asocia rezultatul urmatoarelor operatii cu ecx
    ; TODO1: reuniunea a doua multimi
    mov ecx, eax
    or ecx, ebx
    PRINT_STRING "1. A or B = " ; {0, 1, 3, 5, 7}
    PRINT_DEC 4, ecx
    NEWLINE
    
    ; TODO2: adaugarea unui element in multime
    mov ecx, eax
    or ecx, 16      ; adaugam 4 la A
    or ecx, 4       ; adaugam 2 --"--
    PRINT_STRING "2. A + {2, 4} = " ; {0, 1, 3, 4, 5, 7}
    PRINT_DEC 4, ecx
    NEWLINE

    ; TODO3: intersectia a doua multimi
    mov ecx, eax
    and ecx, ebx
    PRINT_STRING "3. A and B = " ; {0, 3, 7}
    PRINT_DEC 4, ecx
    NEWLINE

    ; TODO4: complementul unei multimi
    mov ecx, eax
    not ecx ; {2, 4, 5, 6}
    
    PRINT_STRING "3. !A = "
    PRINT_DEC 4, ecx
    NEWLINE
    
    ; TODO5: eliminarea unui element
    mov ecx, eax
    xor ecx, 8
    PRINT_STRING "4. A \ {3} = " ; {0, 5, 7}
    PRINT_DEC 4, ecx
    NEWLINE

    ; TODO6: diferenta de multimi EAX-EBX
    mov ecx, eax
    xor ecx, ebx
    and ecx, eax
    PRINT_STRING "5. A \ B = " ; {1}
    PRINT_DEC 4, ecx
    
    xor eax, eax
    ret
