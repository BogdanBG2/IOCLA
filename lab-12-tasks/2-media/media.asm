%include "io.inc"

section .data
    vector dq 1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9
    n      dd ($-vector)/8
    format db "Media elementelor: %.2f", 10, 0

section .text
    global CMAIN

extern printf

CMAIN:
    ; incarca valoarea 0 pe stiva FPU
    fldz ; FSP = 0 (Float Stack Pointer)

    ; TODO: parcurgerea tuturor elementelor si adunare la valoarea din varful stivei FPU
    mov eax, vector
    mov ecx, dword [n]
repeat:
    ; aduna la valoarea de pe stiva cate o valoare din vector
    fadd qword [vector + 8*(ecx-1)] ; FSP += vector[ecx-1]
    dec ecx
    jne repeat

    ; TODO: impartirea sumei la numarul de elemente
    mov eax, n
    fidiv dword [eax]

    sub esp, 8
    fstp qword [esp]

    ; TODO Afisarea rezultatului
    push format
    call printf
    add esp, 12

    xor eax, eax
    ret
