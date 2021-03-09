%include "io.inc"

section .data

%define ARRAY_LEN 7

    input dd 122, 184, 199, 242, 263, 845, 911
    output times ARRAY_LEN dd 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging

    ; TODO push the elements of the array on the stack
    xor ecx, ecx
L1:
    push dword [input + 4 * ecx]
    inc ecx
    cmp ecx, ARRAY_LEN
    jb L1
    
    ; TODO retrieve the elements (pop) from the stack into the output array

    PRINT_STRING "Reversed array:"
    NEWLINE
    xor ecx, ecx
    
print_array:
    pop dword [output + 4 * ecx]
    PRINT_UDEC 4, [output + 4 * ecx]
    NEWLINE
    inc ecx
    cmp ecx, ARRAY_LEN
    jb print_array

    xor eax, eax
    ret
