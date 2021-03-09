global runAssemblyCode

extern printf

section .data
    str: db "%d",10,13

section .text
runAssemblyCode:
    push ebp
    mov ebp, esp

    xor eax, eax
    mov edx, [ebp + 8]
    mov ecx, [ebp + 12]

L1:
    add eax, [edx + 4 * (ecx - 1)]
    dec ecx
    jnz L1
    
    mov esp, ebp
    pop ebp
    ret
