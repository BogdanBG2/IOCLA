%include "io.inc"

section .data
    vector dd 30, 31, 100, 86, 23, 9, 64, 90, 25, 96
    n      dd ($-vector)/4
    format db "Media elementelor: %.2f", 10, 0

section .text
    global CMAIN

extern printf

CMAIN:
    ; incarca valoarea 0 pe stiva FPU
    fldz

    ; TODO: parcurgerea tuturor elementelor si adunare la valoarea din varful stivei FPU
    mov ecx, dword [n]
repeat:

    ; aduna la valoarea de pe stiva cate o valoare din vector
    fiadd dword [vector + 4*(ecx-1)]
    dec ecx
    jnz repeat

    mov eax, n

    ; TODO: impartirea sumei la numarul de elemente
    fidiv dword [eax]

    sub esp, 8
    fstp qword [esp]

    ; TODO Afisarea rezultatului;
    ; Rezultatul ar trebui sa fie 55.4
    push format
    call printf
    add esp, 12

    xor eax, eax
    ret
