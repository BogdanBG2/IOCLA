%include "io.inc"

section .data
    vector dq -86.601, 12.11, 84.4483, -31.1, -76.606, 91.2086, -18.12, -70.73, -0.09922
    n      dd ($-vector)/8

    format db "Valoarea maxima: %.2f", 10, 0
    max    dq -1000000.0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging

    mov ecx, dword [n]
    mov eax, vector

repeat:
    fld qword [vector + 8*(ecx-1)]
    fld qword [max]

    fcomip              ; compara primele 2 valori de pe stiva + pop
    ja above
    fstp qword [max]    ; pop the value from FPU stack to max
above:
    fstp ST0            ; just free the stack

    dec ecx
    jnz repeat

    ; Store max on stack
    ; It has 8 bytes, store it in two steps.
    push dword [max + 4]
    push dword [max]
    push format
    call printf

    add esp, 12

    xor eax, eax
    ret
