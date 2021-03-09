%include "io.inc"

section .data
    n    dq 421.9461
    print_format1 db "Partea intreaga: %d", 10, 0
    print_format2 db "Partea fractionara: %f", 10, 0

section .text
global CMAIN
CMAIN:

    ; TODO incarca numarul pe stiva FPU
    fld qword [n] ; Float Load

    ; TODO salveaza valoarea cu trunchiere la intreg (instructiunea FISTTP)
    sub esp, 4
    FISTTP dword [esp] ; obtinerea partii intregi

    ; TODO afisare parte intreaga
    push print_format1
    call printf
    add esp, 4 ; doar 4. Vrem sa pastram partea intreaga in esp

    ; TODO scade din n partea intreaga (instructiunea fisub)
    fld qword [n]
    fisub dword [esp] ; {n} = n - [n]

    ; TODO Extragerea partii fractionare si afisarea rezultatului
    sub esp, 4 ; === esp = (esp + 4) - 8
    fstp qword [esp]
    push print_format2
    call printf
    add esp, 12

    xor eax, eax
    ret
