%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov eax, 7       ; vrem sa aflam al N-lea numar din sirul Fibonacci; N = 7
    ; TODO: calculati al N-lea numar fibonacci (f(0) = 0, f(1) = 1)
    mov ecx, eax ; ecx = 7 si va cobori pana la 0
    mov eax, 1 ; f(n). La inceput, n = 1
    mov ebx, 0 ; f(n - 1)
    
    ; Explicatie: la Fibonacci avem a, b, b + a, 2b + a, 3b + 2a ...
    L1:
    PRINT_DEC 4, eax
    NEWLINE ; afisam fiecare numar din sir pe cate o linie
    xchg eax, ebx ; (b, a) -> (a, b) (presupunem ca b este dupa a)
    add eax, ebx ; (a, b) -> (b + a, b). Se respecta conditia de recurenta
    dec ecx
    jg L1
    
    ret