%include "io.inc"

section .data
source_text: db "ABCABCBABCBABCBBBABABBCBABCBAAACCCB", 0
substring: db "BABC", 0

source_length: resd 1
substr_length: dd 4
;offset: dd 35
print_format: db "Substring found at index: ", 0

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    ; TODO: Fill source_length with the length of the source_text string.
    mov eax, 0
    mov edi, source_text
    mov ecx, 100
    mov dword [source_length], ecx
    cld
    repne scasb
    inc ecx
    sub dword [source_length], ecx
    PRINT_STRING "Source Length: "
    PRINT_UDEC 4, source_length
    NEWLINE
    
    ; Find the length of the string using scasb.
    mov eax, 0
    mov edi, substring
    mov ecx, 100
    mov dword [substr_length], ecx
    cld
    repne scasb
    inc ecx
    sub dword [substr_length], ecx
    PRINT_STRING "Substring Length: "
    PRINT_UDEC 4, substr_length
    NEWLINE
        
    ; TODO: Print the start indices for all occurrences of the substring in source_text
    mov ebx, 0 ; retinem rezultatul necesar in ebx

    mov edi, source_text
    m;ov edi, substring
L1: 
    mov esi, substring
    ;mov esi, source_text
    mov ecx, dword [substr_length]
   
    cld
    repne cmpsb
    cmp ecx, 0
    jg L2
    
    inc ebx
L2:
    inc edi
    cmp byte [edi], 0
    jg L1 
    
    PRINT_STRING "Number of substring occurences: "
    PRINT_UDEC 4, ebx
    leave
    ret
