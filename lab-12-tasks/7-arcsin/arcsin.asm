%include "io.inc"

extern printf

section .data
    valoare_sin dq 0.123
    max    dq   1.57079632679
    min    dq   0.0
    eroare dq   0.0005

    med    dq   0.0
    format db   "Unghi gasit: %.20f", 10, 0

    sin    dq   0.0

section .text
global CMAIN
CMAIN:

repeat:
    ; med = (max + min) / 2
    push 2
    fld qword [max]
    fadd qword [min]
    fidiv dword [esp]
    fst qword [med]
    add esp, 4

    ; TODO sin(med) - valoarea med este deja pe stiva
    fsin

    ; TODO stocare rezultat in variabila sin
    fst qword [sin]

    ; TODO comparatie cu valaorea cautata (valoare_sin)
    fld qword [valoare_sin]
    fcomip

    ; TODO ajustare interval in functie de rezultatul comparatiei
    ja dreapta

    fld qword [med]
    fstp qword [max]
    jmp continue

dreapta:
    fld qword [med]
    fstp qword [min]
continue:

    fstp ST0    ; scoate valoarea ramasa pe stiva

    ; TODO verificare eroare (abs(valoare_sin-sin) < eroare)
    fld qword [valoare_sin]
    fsub qword [sin]
    fabs

    fld qword [eroare]
    fcomip
    fstp ST0

    jb repeat

    ; TODO afisare rezultat. Valoarea trebuie sa fie aproximativ 0.123312275
    fld qword [med]
    sub esp, 8
    fstp qword [esp]
    push format
    call printf
    add esp, 12

    xor eax, eax
    ret
