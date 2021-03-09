%include "includes/io.inc"

extern getAST
extern freeAST

; ----------------------------------------------------------------------------------------------------------------------------------------------------------
;                                           Introducere in Organizarea Calculatoarelor si Limbaj de Asamblare (IOCLA)
;                                                                       TEMA 1 - PREFIX AST
;                                                                                   de Bogdan - Andrei Buga, grupa 322CB
; ----------------------------------------------------------------------------------------------------------------------------------------------------------

section .data
                                                            ; 200 de operatii implica 200 de simboluri + 201 numere = 401 elemente in vector 
       
    symbol_array:   times 401 dd 0                          ; vectorul in care retinem validitatea operatiilor din noduri
    number_array:   times 401 dd 0                          ; vectorul in care retinem valoarea numerica a nodurilor
    len:            dd 0                                    ; lungimea vectorului rezultat (echivalent cu numarul de noduri din arbore)
    max_index:      dd -2                                   ; indicele pana la care vom face parcurgerea vectorilor in main
    
section .bss
    root:           resd 1                                  ; radacina arborelui
    operand_sign:   resb 1                                  ; folosit in string2num
    
section .text

; ----------------------------------------------------------------------------------------------------------------------------------------------------------
;   string2num(char*) transforma sirul de caractere dat ca parametru intr-un numar intreg.
;   Valori returnate: - valoarea numarului, daca este un numar valid
;                     - 0, daca nu este un numar valid sau daca e totusi numar valid, si anume, 0  
; ----------------------------------------------------------------------------------------------------------------------------------------------------------
string2num:
    push        ebp
    mov         ebp, esp
    mov         esi, [ebp + 8]                              ; sirul ce trebuie evaluat
    xor         eax, eax                                    ; eax initial = 0
    xor         ecx, ecx                                    ; contor de parcurgere al sirului de evaluat
    mov         byte [operand_sign], 0
    cmp         byte [esi], '/'                             ; numar invlaid; returnam 0
    je          exit_string2num_
    cmp         byte [esi], '+'                             ; numar invlaid; returnam 0
    je          exit_string2num_ 
    cmp         byte [esi], '*'                             ; numar invalid; returnam 0
    je          exit_string2num_   
    cmp         byte [esi], '-'                             ; Daca nu incepe cu '-', avem garantia ca e numar (chiar numar pozitiv).
    jne         loop_string2num_
    cmp         byte [esi + 1], 0                           ; Daca incepe cu -, dar nu mai are nimic dupa, rezulta un numar invalid.
    je          exit_string2num_
    inc         ecx                                         ; La numere negative, incepem evaluarea de la ecx = 1.
    inc         byte [operand_sign]                         ; 1, daca incepe cu '-'; 0, altfel
    
loop_string2num_:
    xor         ebx, ebx
    mov         bl, byte [esi + ecx]                        ; cifra de pe pozitia "ecx"
    sub         bl, '0'
    imul        eax, 10
 
    add         eax, ebx
    inc         ecx
    cmp         byte [esi + ecx], 0
    jne         loop_string2num_                            ; Daca nu ajungem pe '\0', continuam parcurgerea cifrelor.
        
    cmp         byte [operand_sign], 1                      ; Daca operand_sign == 1, inmultim eax cu -1.
    jne         exit_string2num_
    not         eax                     
    inc         eax
    jmp         exit_string2num_
    
exit_string2num_:
    pop         ebp
    ret
    
; ----------------------------------------------------------------------------------------------------------------------------------------------------------
; operation_type(char*) returneaza:
;   - valoarea operatiei, daca parametrul reprezinta o operatie valida
;   - 0, in caz contrar
; ----------------------------------------------------------------------------------------------------------------------------------------------------------
operation_type:
    push        ebp
    mov         ebp, esp
    xor         eax, eax                                    ; 0, in cazul in care nu ar fi o operatie valida
    mov         edi, [ebp + 8]                              ; sirul ce trebuie evaluat

    cmp         byte [edi + 1], 0
    jne         exit_operation_type_                        ; Daca avem mai mult de 1 caracter in sir, nu este o operatie valida.
    
    cmp         byte [edi], '+'
    je          true_operation_type_
    cmp         byte [edi], '-'
    je          true_operation_type_
    cmp         byte [edi], '*'
    je          true_operation_type_
    cmp         byte [edi], '/'
    je          true_operation_type_
    jmp         exit_operation_type_
    
true_operation_type_:                                       ; Daca ajungem printr-un salt la aceasta eticheta, 
    mov         al, byte [edi]                              ; se modifica valoarea lui eax cu valoarea numerica a operatiei respective.

exit_operation_type_:
    pop         ebp
    ret
    
; ----------------------------------------------------------------------------------------------------------------------------------------------------------
;   execute_operation(int, int, int) efectueaza operatia
;       - argument1 + argument2, daca argument3 == 43 ('+')
;       - argument1 - argument2, daca argument3 == 45 ('-')
;       - argument1 * argument2, daca argument3 == 42 ('*')
;       - argument1 / argument2, daca argument3 == 47 ('/')
; ----------------------------------------------------------------------------------------------------------------------------------------------------------
execute_operation:
    push        ebp
    mov         ebp, esp       

    mov         eax, [ebp + 8]                              ; operand 1
    mov         ebx, [ebp + 12]                             ; operand 2
    mov         edi, [ebp + 16]                             ; operatie

    cmp         edi, "+"                                    ; suma
    je          sum
    cmp         edi, "-"                                    ; diferenta
    je          diff
    cmp         edi, "*"                                    ; produs
    je          product
    cmp         edi, "/"                                    ; impartire
    je          division
    
sum:
    add         eax, ebx
    jmp         exit_execute_operation_                     ; Odata efectuata operatia, sarim la iesirea din functie.
diff:
    sub         eax, ebx
    jmp         exit_execute_operation_                     ; analog ca la ultimul comentariu
product:
    imul        eax, ebx
    jmp         exit_execute_operation_                     ; analog ca la penultimul comentariu
division:
    push        edx                                         ; retinerea lui edx in cazul in care avem deja o valoare folosita in program in edx
    xor         edx, edx                                    ; initializarea restului returnat de idiv
    cdq                                                     ; sign extend
    idiv        ebx
    pop         edx                                         ; refacerea lui edx
        
exit_execute_operation_:
    pop         ebp
    ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------
;       Functia iterateAST(node*) itereaza, in preordine (radacina -> stanga -> dreapta) aroberele sintactic abstract si adauga in vectori informatiile 
;   despre nodul curent, astfel incat Q_array[i] sa corespunda informatiei din al i-lea nod al arborelui parcurs in preordine (Q = number sau Q = symbol).
; ----------------------------------------------------------------------------------------------------------------------------------------------------------
iterate_AST:
    push        ebp
    mov         ebp, esp
    mov         ebx, [ebp + 8]                              ; ebx = argumentul functiei
    cmp         ebx, 0                                      ; Daca nodul curent este nul,
    je          exit_iterate_AST_                           ; se iese din functie.
    mov         ebx, [ebx]                                  ; ebx -> valoarea din nodul curent al arborelui   
    
    mov         esi, ebx                                    ; Folosim esi ca registru auxiliar.
    push        esi
    call        operation_type                              ; Calculam daca e o operatie valida si ,daca da, ce fel de operatie este.
    pop         esi
    mov         ecx, dword [len]                            ; Preluam lungimea celor 2 vectori
    mov         dword [symbol_array + 4*ecx], eax           ; si adaugam simbolul rezultat pe ultima pozitie a vectorului symbol_array.
    
    push        esi
    call        string2num                                  ; Calculam daca e un numar valid si ,daca da, valoarea acestuia.
    pop         esi 
    mov         ecx, dword [len]                            ; Preluam lungimea celor 2 vectori
    mov         dword [number_array + 4*ecx], eax           ; si adaugam numarul rezultat pe ultima pozitie a vectorului number_array.


    inc         dword [len]                                 ; Dupa adaugarea noilor elemente, lungimea vectorilor creste
    inc         dword [max_index]                           ; si, implicit, si ultimul indice de parcurs.
    
    mov         ebx, [ebp + 8]
    mov         ebx, [ebx + 4]                              ; adresa fiului stang
    push        ebx
    call        iterate_AST                                 ; apel recursiv la stanga
    pop         ebx                                         ; revenirea in nodul parinte
    
    mov         ebx, [ebp + 8]
    mov         ebx, [ebx + 8]                              ; adresa fiului drept
    push        ebx
    call        iterate_AST                                 ; apel recursiv la dreapta
    pop         ebx                                         ; revenirea la nodul parinte
    
exit_iterate_AST_:
    pop         ebp 
    ret
    

global main
main:
    push        ebp
    mov         ebp, esp                                    ; pentru debugging corect
    
    
    call        getAST                                      ; Se citeste arborele si se scrie la adresa indicata mai sus.
    mov         [root], eax
   
    mov         edx, [root]
    push        dword [root]
    call        iterate_AST                                 ; Cu aceasta functie, iteram in preordine arborele rezultat din radacina.
    pop         dword [root]
    
while_loop:
    xor         ecx, ecx                                    ; Cat timp lungimea celor 2 vectori este diferita de 1 
                                                            ; (cei doi vectori folositi au mereu aceeasi lungime "len"),
                                                            ; se vor parcurge cei doi vectori si vom modifica valorile elementelor si a lungimii
                                                            ; in functie de operatiile intalnite

i_loop:                                                     ; i = ecx -> indicele de parcurgere a vectorilor de la 0 la max_index
    
                                        
    cmp         dword [symbol_array + 4 * ecx], 0           ; Daca symbol_array[i] != 0 (operatie valida),
    je          i_next
    cmp         dword [symbol_array + 4 * (ecx + 1)], 0     ; symbol_array[i+1] == 0 (operatie invalida <==> numar valid)
    jne         i_next
    cmp         dword [symbol_array + 4 * (ecx + 2)], 0     ; si symbol_array[i+2] == 0 (operatie invalida <==> numar valid),
    jne         i_next
    
    
    push        dword [symbol_array + 4 * ecx]
    push        dword [number_array + 4 * (ecx + 2)]
    push        dword [number_array + 4 * (ecx + 1)]
    call        execute_operation                           ; se efectueaza execute_operation(number_array[i+1], number_array[i+2], symbol_array[i]), 
                                                            ; rezultat retinut in eax,
    add         esp, 12                                     ; (se restaureaza stiva)
    
    mov         dword [number_array + 4 * ecx], eax         ; iar pozitia i a ambilor vectori se modifica.
    mov         dword [symbol_array + 4 * ecx], 0           ; (number_array[i], symbol_array[i]) = (eax, 0)

    push        ecx                                         ; Retinem valoarea lui i pe stiva.
    inc         ecx                                         ; ecx -> j = i+1 -> indicele de la care mutam vectorul in stanga cu doua elemente
    
j_loop:
    mov         ebx, dword [number_array + 4 * (ecx + 2)]   ; Stergem din vector numerele folosite la apelul lui execute_operation 
    mov         dword [number_array + 4 * ecx], ebx         ; prin mutarea la stanga cu 2 pozitii a elementelor ramase
    
    mov         ebx, dword [symbol_array + 4 * (ecx + 2)]   ; La vectorul de simboluri, procedam analog ca la vectorul de numere.
    mov         dword [symbol_array + 4 * ecx], ebx
    
    inc         ecx                                         ; Continuam parcurgerea subvectorului pana la indicele max_index (care va fi mereu (len - 2) ).
    cmp         ecx, dword [max_index]
    jl          j_loop
    
    sub         dword [len], 2                              ; La fiecare operatie efectuata, lungimea scade cu 2.
    sub         dword [max_index], 2
    pop         ecx                                         ; Revenim cu ecx la valoarea lui i.
    
i_next:
    inc         ecx                                         ; Continuam parcurgerea vectorului, indiferent daca acesta a fost sau nu modificat,
    cmp         ecx, dword [max_index]                      ; pana la indicele max_index.
    jl          i_loop

    cmp         dword [len], 1                              ; La fiecare operatie efectuata, lungimea scade cu 2.
                                                            ; Daca nu ajungem cu lungimea la 1 (adica nu se efectueaza toate operatiile din arbore),
    jg          while_loop                                  ; reluam while_loop de la capat cu noii vectori.

    PRINT_DEC   4, [number_array]                           ; Rezultatul cerut este stocat in number_array[0].

exit_main_:
    mov         esp, ebp
    push        dword [root]
    call        freeAST
    
    mov         esp, ebp
    xor         eax, eax
    leave
    ret
