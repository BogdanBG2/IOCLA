BITS 64

section .text

global get_max

get_max:
    push ebp
    mov ebp, esp
    push ebx
    ; [ebp+8] is array pointer
    ; [ebp+12] is array length

    mov ebx, [ebp + 8]
    mov ecx, [ebp + 12]
    mov edx, [ebp + 16]
    xor eax, eax

compare:
    cmp eax, [ebx + 4 * (ecx - 1)]
    jge check_end
    mov dword [edx], ecx
    mov eax, [ebx+ 4 * (ecx - 1)]
check_end:
    loopnz compare
    dec dword [edx]
    pop ebx
    leave
    ret
