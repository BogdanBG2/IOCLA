%include "io.inc"
extern printf
extern puts

section .data
    mystring db "Idi", 0, "NaHuy", 0, "Blyat", 0
    len db 15
section .text
global CMAIN

ROT13:
    push ebp
    mov ebp, esp

    ; TODO
    mov eax, [ebp + 8]
    push eax    
    xor ecx, ecx ; ecx ia valori din [0, len - 1]
    mov ebx, len
L1:
    cmp byte [eax], 'Z'
    jle instr1
    
    cmp byte [eax], 'a'
    jge instr2
        
instr1: ; litera mare [65, 90]
    cmp byte [eax], 0 ; 'Space'
    je SPACE
    cmp byte [eax], 'A'
    jl NEXT
    
    cmp byte [eax], 'N'
    jl PLUS
    jge MINUS

instr2: ; litera mica [97, 122]
    cmp byte [eax], 'z'
    jg NEXT
    
    cmp byte [eax], 'n'
    jl PLUS
    cmp byte [eax], 'n'
    jge MINUS

PLUS:
    add byte [eax], 13
    jmp NEXT
    
MINUS:
    sub byte [eax], 13
    jmp NEXT

SPACE:
    mov byte [eax], 32
    
NEXT:
    inc ecx
    inc eax
    cmp ecx, [len]
    jl L1
            
    pop eax
    leave
    ret

CMAIN:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp

    push mystring
    call ROT13
    call puts
    mov esp, ebp
    
    leave
    ret
