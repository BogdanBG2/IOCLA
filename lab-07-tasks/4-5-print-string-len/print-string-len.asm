%include "io.inc"
extern puts
extern printf

section .data
    mystring db "This is my string", 0
    format db "String length is %u", 10, 0
    reverse_result times 64 db 0
section .text
global CMAIN


str_reverse:
    push ebp
    mov ebp, esp

    mov eax, dword [ebp+8] ; eax = 1st parameter (char*)
    mov ecx, dword [ebp+12] ; ecx = 2nd parameter (length)
    add eax, ecx
    dec eax
    mov edx, dword [ebp+16] ; edx = 3rd parameter (char*)

copy_one_byte:
    mov bl, byte [eax]
    mov byte [edx], bl
    dec eax
    inc edx
    loopnz copy_one_byte

    inc edx
    mov byte [edx], 0
    leave
    ret
    
CMAIN:
    push ebp
    mov ebp, esp ; for correct debugging

    mov eax, mystring
    xor ecx, ecx

test_one_byte:
    mov bl, byte [eax]
    test bl, bl
    je out ;
    inc eax
    inc ecx
    jmp test_one_byte

out:
    push ecx
    push format
    call printf
    add esp, 4
    pop ecx
    
; ------------------------- TASK 5
    mov eax, mystring
    mov edx, reverse_result
        
    push edx
    push ecx
    push eax
    call str_reverse
    mov esp, ebp
     
    mov edx, reverse_result
    push edx
    call puts
    mov esp, ebp
    leave
    ret
