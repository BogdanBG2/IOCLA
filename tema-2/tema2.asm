%include "include/io.inc"

extern              atoi
extern              printf
extern              exit
extern              calloc
extern              free

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern              read_image
extern              free_image
; void print_image(int* image, int width, int height);
extern              print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern              get_image_width
extern              get_image_height

; ----------------------------------------------------------------------------------------------------------------------------------------------------------
;                                           Introducere in Organizarea Calculatoarelor si Limbaj de Asamblare (IOCLA)
;                                                               TEMA 2 - Steganograpie
;                                                                                   de Bogdan - Andrei Buga, grupa 322CB
; ----------------------------------------------------------------------------------------------------------------------------------------------------------
section .data
    use_str         db "Use with ./tema2 <image_path> <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:           resd 1
    img:            resd 1
    img_width:      resd 1
    img_height:     resd 1

    len:            resd 1
    
    sem:            resb 1
    width_task1:    resd 1
    message_task1:  resb 100
    
    width_task6:    resd 1
    height_task6:   resd 1
    
section .text

; -------------------------------------------------------------------------- TASK 1 ------------------------------------------------------------------------
bruteforce_singlebyte_xor:
    push        ebp
    mov         ebp, esp

    mov         ebx, [ebp + 8]                          ; EBX = imaginea
    
    ; SETAREA DIMENSIUNII MATRICEI
    push        ebx
    mov         eax, dword [img_height]
    mov         ebx, dword [img_width]
    mul         ebx
    mov         dword [len], eax                        ; in len retinem numarul total de elemente ale matricei
    xor         eax, eax                                ; initializarea rezultatului dorit
    pop         ebx
    
    
    ; SETAREA NUMARULUI MAXIM DE COLOANE CARE TREBUIE EVALUAT
    mov         eax, dword [img_width]
    sub         eax, 7                                  ; latinme - strlen("revient")
    mov         dword [width_task1], eax
    
    xor         eax, eax                                ; EAX = rezultatul returnat
    mov         byte [sem], al
    xor         ecx, ecx                                ; ECX = contorul de cheie!


key_loop:
    cmp         byte [sem], 1                           ; Daca mesajul a fost deja gasit (sem == 1),
    je          exit_bruteforce_singlebyte_xor          ; iesim din key_loop.
    ; IMAGINE XOR CHEIE
    mov         edx, dword [len]
xor_lock_pixel:
    xor         byte [ebx + 4 * (edx - 1)], cl
    dec         edx
    jne         xor_lock_pixel

    ; PARCURGEREA PE LINII DE LA 0 LA WIDTH-7
    mov         esi, 0                                  ; ESI = CONTORUL DE LINIE
line_loop_xor:
    mov         edx, dword [img_width]                  ; EDX = indice element matrice = WIDTH * esi + edi
    
    xor         edi, edi                                ; EDI = CONTORUL DE COLOANA
column_loop_xor:
    push        edx                                     ; retinem multiplicatorul pe stiva
    imul        edx, esi
    add         edx, edi                                ; EDX = pozitia in matrice
    
    ; CAUTAREA CUVANTULUI "REVIENT" DIN POZITIA CURENTA
    cmp         byte [ebx + 4 * edx], 'r'
    jne         next_char_xor
    cmp         byte [ebx + 4 * (edx + 1)], 'e'
    jne         next_char_xor
    cmp         byte [ebx + 4 * (edx + 2)], 'v'
    jne         next_char_xor
    cmp         byte [ebx + 4 * (edx + 3)], 'i'
    jne         next_char_xor
    cmp         byte [ebx + 4 * (edx + 4)], 'e'
    jne         next_char_xor
    cmp         byte [ebx + 4 * (edx + 5)], 'n'
    jne         next_char_xor
    cmp         byte [ebx + 4 * (edx + 6)], 't'
    jne         next_char_xor
        
    inc         byte [sem]                              ; sem = 1 => mesajul a fost gasit
    sub         edx, edi                                ; de la (ESI, EDI) la (ESI, 0)
    push        ecx                                     ; vechiul ECX (cheia) e pus pe stiva, ECX fiind folosit aici drept contor de mesaj
    xor         ecx, ecx                                ; ECX ia valori de la 0 la strlen(message_task1) 
    push        esi                                     ; vechiul ESI (linia) e pus pe stiva, ESI fiind folosit aici drept contor de matrice 
    mov         esi, edx                                ; ESI ia valori de la EDX la EDX + strlen(message_task1)
set_message_task1:
    mov         al, byte [ebx + 4 * esi]
    mov         byte [message_task1 + ecx], al
    
    inc         ecx
    inc         esi
    cmp         byte [ebx + 4 * esi], 0
    jne         set_message_task1
    
    ; REFACEREA STIVEI 
    pop         esi                                     ; refacerea liniei
    pop         ecx                                     ; refacerea cheii
    add         esp, 4                                  ; echivalent cu pop edx de la next_char_loop
    
    ; STABILIREA REZULTATULUI RETURNAT
    xor         eax, eax
    mov         eax, ecx
    shl         eax, 16                                 ; pe bitii din EAX care nu sunt in AX, stocam cheia necesara
    or          eax, esi                                ; pe bitii din AX, stocam linia necesara 
    jmp         restore_if_found                        ; odata descifrat mesajul, nu mai are rost sa evaluam restul elementelor matricei
    
next_char_xor:
    pop         edx                                     ; eliminarea multiplicatorului
    
    inc         edi                                     ; urmatoarea coloana
    cmp         edi, dword [width_task1]
    jl          column_loop_xor
    
    inc         esi                                     ; urmatoarea linie
    cmp         esi, dword [img_height]
    jl          line_loop_xor
    
restore_if_found:                                       ; sarim peste next_char_xor doar daca mesajul nostru a fost gasit 
    
    ; (IMAGINE XOR CHEIE) XOR CHEIE
    mov         edx, dword [len]
xor_unlock_pixel:
    xor         byte [ebx + 4 * (edx - 1)], cl
    dec         edx
    jne         xor_unlock_pixel
            
    inc         ecx                                     ; urmatoarea cheie
    cmp         ecx, 255
    jle         key_loop

exit_bruteforce_singlebyte_xor:
    leave
    ret
; -------------------------------------------------------------------------- TASK 2 ------------------------------------------------------------------------
predefined_xor:
    push        ebp
    mov         ebp, esp
    
    mov         ebx, [ebp + 8]                          ; EBX = imaginea
    
    ; PRELUAREA REZULTATELOR DE LA TASK1
    push        ebx
    call        bruteforce_singlebyte_xor
    pop         ebx
    
    mov         ecx, dword [len]
    push        eax                                     ; retinem linia pe stiva
    shr         eax, 16                                 ; cheia rezultata

    ; OBTINEREA MATRICEI INITIALE
unlock_old_key:
    xor         byte [ebx + 4 * (ecx - 1)], al
    dec         ecx
    jne         unlock_old_key 
    
    ; OBTINEREA LINIEI DORITE
    mov         edx, [esp]
    and         edx, 0x0000FFFF
    inc         edx
    
    ; ADAUGAREA MESAJULUI NECESAR : "C'est un proverbe francais."
    imul        edx, dword [img_width]                  ; indicele de start
    mov         byte [ebx + 4 * (edx + 0)], "C"
    mov         byte [ebx + 4 * (edx + 1)], "'"
    mov         byte [ebx + 4 * (edx + 2)], "e"
    mov         byte [ebx + 4 * (edx + 3)], "s"
    mov         byte [ebx + 4 * (edx + 4)], "t"
    mov         byte [ebx + 4 * (edx + 5)], " "
    mov         byte [ebx + 4 * (edx + 6)], "u"
    mov         byte [ebx + 4 * (edx + 7)], "n"
    mov         byte [ebx + 4 * (edx + 8)], " "
    mov         byte [ebx + 4 * (edx + 9)], "p"
    mov         byte [ebx + 4 * (edx + 10)], "r"
    mov         byte [ebx + 4 * (edx + 11)], "o"
    mov         byte [ebx + 4 * (edx + 12)], "v"
    mov         byte [ebx + 4 * (edx + 13)], "e"
    mov         byte [ebx + 4 * (edx + 14)], "r"
    mov         byte [ebx + 4 * (edx + 15)], "b"
    mov         byte [ebx + 4 * (edx + 16)], "e"
    mov         byte [ebx + 4 * (edx + 17)], " "
    mov         byte [ebx + 4 * (edx + 18)], "f"
    mov         byte [ebx + 4 * (edx + 19)], "r"
    mov         byte [ebx + 4 * (edx + 20)], "a"
    mov         byte [ebx + 4 * (edx + 21)], "n"
    mov         byte [ebx + 4 * (edx + 22)], "c"
    mov         byte [ebx + 4 * (edx + 23)], "a"
    mov         byte [ebx + 4 * (edx + 24)], "i"
    mov         byte [ebx + 4 * (edx + 25)], "s"
    mov         byte [ebx + 4 * (edx + 26)], "."
    mov         byte [ebx + 4 * (edx + 27)], 0
    
    ; PRELUAREA CHEII DIN EAX
    pop         eax
    shr         eax, 16
    
    ; CHEIE_NOUA = (2 * CHEIE_VECHE + 3) / 5 - 4
    shl         al, 1
    add         al, 3
    mov         cl, 5                                   ; ECX = 0 din unlock_old_key
    div         cl
    xor         ah, ah                                  ; restul de la impartire va vi neglijat
    sub         al, 4
    
    ; OBTINEREA NOII MATRICE
    mov         ecx, dword [len]
lock_new_key:
    xor         byte [ebx + 4 * (ecx - 1)], al
    dec         ecx
    jne         lock_new_key
    
    push        dword [img_height]
    push        dword [img_width]
    push        ebx
    call        print_image
    add         esp, 12

    leave
    ret

; -------------------------------------------------------------------------- TASK 3 ------------------------------------------------------------------------
morse_encrypt:
    push        ebp
    mov         ebp, esp
    
    mov         eax, [ebp + 8]                          ; EAX = matricea
    mov         esi, [ebp + 12]                         ; ESI = mesajul de criptat in matrice cu codul Morse
    mov         ecx, [ebp + 16]                         ; ECX = inidicele de start din matrice
    
    ; ANALIZAREA FIECARUI CARACTER DIN MESAJ SI SUPRASCRIEREA PIXELILOR CU CODUL MORSE CORESPUNZATOR CARACTERULUI CURENT
    mov         edi, 0                                  ; EDI = contor mesaj
string_loop_morse: 
    cmp         byte [esi + edi], "A"
    je          morse_a
    cmp         byte [esi + edi], "B"
    je          morse_b
    cmp         byte [esi + edi], "C"
    je          morse_c
    cmp         byte [esi + edi], "D"
    je          morse_d
    cmp         byte [esi + edi], "E"
    je          morse_e
    cmp         byte [esi + edi], "F"
    je          morse_f
    cmp         byte [esi + edi], "G"
    je          morse_g
    cmp         byte [esi + edi], "H"
    je          morse_h
    cmp         byte [esi + edi], "I"
    je          morse_i
    cmp         byte [esi + edi], "J"
    je          morse_j
    cmp         byte [esi + edi], "K"
    je          morse_k
    cmp         byte [esi + edi], "L"
    je          morse_l
    cmp         byte [esi + edi], "M"
    je          morse_m
    cmp         byte [esi + edi], "N"
    je          morse_n
    cmp         byte [esi + edi], "O"
    je          morse_o
    cmp         byte [esi + edi], "P"
    je          morse_p
    cmp         byte [esi + edi], "Q"
    je          morse_q
    cmp         byte [esi + edi], "R"
    je          morse_r
    cmp         byte [esi + edi], "S"
    je          morse_s
    cmp         byte [esi + edi], "T"
    je          morse_t
    cmp         byte [esi + edi], "U"
    je          morse_u
    cmp         byte [esi + edi], "V"
    je          morse_v
    cmp         byte [esi + edi], "W"
    je          morse_w
    cmp         byte [esi + edi], "X"
    je          morse_x
    cmp         byte [esi + edi], "Y"
    je          morse_y
    cmp         byte [esi + edi], "Z"
    je          morse_z
    cmp         byte [esi + edi], "0"
    je          morse_0
    cmp         byte [esi + edi], "1"
    je          morse_1
    cmp         byte [esi + edi], "2"
    je          morse_2
    cmp         byte [esi + edi], "3"
    je          morse_3
    cmp         byte [esi + edi], "4"
    je          morse_4
    cmp         byte [esi + edi], "5"
    je          morse_5
    cmp         byte [esi + edi], "6"
    je          morse_6
    cmp         byte [esi + edi], "7"
    je          morse_7
    cmp         byte [esi + edi], "8"
    je          morse_8
    cmp         byte [esi + edi], "9"
    je          morse_9
    cmp         byte [esi + edi], " "
    je          morse_space
    cmp         byte [esi + edi], ","
    je          morse_comma
    
morse_a:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    add         ecx, 2
    jmp         has_next_letter
morse_b:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    add         ecx, 4
    jmp         has_next_letter
morse_c:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    add         ecx, 4
    jmp         has_next_letter
morse_d:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    add         ecx, 3
    jmp         has_next_letter
morse_e:
    mov         byte [eax + 4 * ecx], '.'
    inc         ecx
    jmp         has_next_letter
morse_f:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    add         ecx, 4
    jmp         has_next_letter
morse_g:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    add         ecx, 3
    jmp         has_next_letter
morse_h:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    add         ecx, 4
    jmp         has_next_letter
morse_i:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * ecx + 4], '.'
    add         ecx, 2
    jmp         has_next_letter
morse_j:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    add         ecx, 4
    jmp         has_next_letter
morse_k:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    add         ecx, 3
    jmp         has_next_letter
morse_l:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    add         ecx, 4
    jmp         has_next_letter
morse_m:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * ecx + 4], '-'
    add         ecx, 2
    jmp         has_next_letter
morse_n:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * ecx + 4], '.'
    add         ecx, 2
    jmp         has_next_letter
morse_o:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    add         ecx, 3
    jmp         has_next_letter
morse_p:
    mov         dword [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    add         ecx, 4
    jmp         has_next_letter
morse_q:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    add         ecx, 4
    jmp         has_next_letter
morse_r:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    add         ecx, 3
    jmp         has_next_letter
morse_s:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    add         ecx, 3
    jmp         has_next_letter
morse_t:
    mov         byte [eax + 4 * ecx], '-'
    inc         ecx
    jmp         has_next_letter
morse_u:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    add         ecx, 3
    jmp         has_next_letter
morse_v:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    add         ecx, 4
    jmp         has_next_letter
morse_w:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    add         ecx, 3
    jmp         has_next_letter
morse_x:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    add         ecx, 4
    jmp         has_next_letter
morse_y:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    add         ecx, 4
    jmp         has_next_letter
morse_z:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    add         ecx, 4
    jmp         has_next_letter
morse_space:
    mov         byte [eax + 4 * ecx], '|'
    inc         ecx
    jmp         has_next_letter
morse_comma:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    mov         byte [eax + 4 * (ecx + 4)], '-'
    mov         byte [eax + 4 * (ecx + 5)], '-'
    add         ecx, 6
    jmp         has_next_letter
morse_0:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    mov         byte [eax + 4 * (ecx + 4)], '-'
    add         ecx, 5
    jmp         has_next_letter
morse_1:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    mov         byte [eax + 4 * (ecx + 4)], '-'
    add         ecx, 5
    jmp         has_next_letter
morse_2:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    mov         byte [eax + 4 * (ecx + 4)], '-'
    add         ecx, 5
    jmp         has_next_letter
morse_3:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    mov         byte [eax + 4 * (ecx + 4)], '-'
    add         ecx, 5
    jmp         has_next_letter
morse_4:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    mov         byte [eax + 4 * (ecx + 4)], '-'
    add         ecx, 5
    jmp         has_next_letter
morse_5:
    mov         byte [eax + 4 * ecx], '.'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    mov         byte [eax + 4 * (ecx + 4)], '.'
    add         ecx, 5
    jmp         has_next_letter
morse_6:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '.'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    mov         byte [eax + 4 * (ecx + 4)], '.'
    add         ecx, 5
    jmp         has_next_letter
morse_7:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '.'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    mov         byte [eax + 4 * (ecx + 4)], '.'
    add         ecx, 5
    jmp         has_next_letter
morse_8:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '.'
    mov         byte [eax + 4 * (ecx + 4)], '.'
    add         ecx, 5
    jmp         has_next_letter
morse_9:
    mov         byte [eax + 4 * ecx], '-'
    mov         byte [eax + 4 * (ecx + 1)], '-'
    mov         byte [eax + 4 * (ecx + 2)], '-'
    mov         byte [eax + 4 * (ecx + 3)], '-'
    mov         byte [eax + 4 * (ecx + 4)], '.'
    add         ecx, 5


has_next_letter:
    cmp         byte [esi + edi + 1], 0
    je          morse_exit
    mov         byte [eax + 4 * ecx], ' '               ; punem spatiu daca mai avem caractere nenule
    inc         ecx                                     ; urmatorul indice din matrice
    
    inc         edi                                     ; urmatorul caracter din mesaj
    jmp         string_loop_morse

morse_exit:
    mov         byte [eax + 4 * ecx], 0                 ; ultimul caracter din sirul rezultat
    push        dword [img_height]
    push        dword [img_width]
    push        eax
    call        print_image
    add         esp, 12
    
    leave
    ret
    
; -------------------------------------------------------------------------- TASK 4 ------------------------------------------------------------------------
lsb_encode:
    push        ebp
    mov         ebp, esp
    mov         eax, [ebp + 8]                          ; EAX = img
    mov         esi, [ebp + 12]                         ; ESI = mesaj
    mov         ecx, [ebp + 16]                         ; ECX = byte id
    dec         ecx
    
    ; OBTINEREA LUNGIMII MESAJULUI
    xor         edx, edx
get_msg_len:
    inc         edx
    cmp         byte [esi + edx], 0
    jne         get_msg_len
    inc         edx
    mov         dword [len], edx                        ; len -> cate caractere trebuie analizate, inclusiv caracterul nul de la sfarsit 
    
    
    xor         edi, edi                                ; EDI = contor mesaj
char_loop_lsb_encode:
    mov         edx, ecx
    add         edx, edi                                ; EDX = indicele din matrice

    ; Din moment ce nu se poate efectua operatia "shr (registru), (registru)",
    ; ci doar "shr (registru), (numar)",
    ; vom lua fiecare bit de la MSB la LSB pe o metoda bruta, fara vreo bucla.
    ; BH == BL => pixelul nu se modifica; trecem la urmatorul pixel, respectiv la urmatorul bit din mesaj
    ; BH != BL => EAX[ECX + EDI] ^= 1
    mov         bh, byte [esi + edi]
    shr         bh, 7                                   ; BH = bitul 7 al caracterului curent
    and         bh, 1
    mov         bl, byte [eax + 4 * ecx]
    and         bl, 1                                   ; BL = LSB pixel curent
    cmp         bl, bh
    je          bit_six
    xor         byte [eax + 4 * ecx], 1

bit_six:
    inc         ecx                                     ; urmatorul element al matricei
    mov         bh, byte [esi + edi]
    shr         bh, 6                                   ; bitul 6 al caracterului curent
    and         bh, 1
    mov         bl, byte [eax + 4 * ecx]
    and         bl, 1                                   ; LSB pixel curent
    cmp         bl, bh
    je          bit_five
    xor         byte [eax + 4 * ecx], 1
    
bit_five:
    inc         ecx                                     ; urmatorul element al matricei
    mov         bh, byte [esi + edi]
    shr         bh, 5                                   ; bitul 5 al caracterului curent
    and         bh, 1
    mov         bl, byte [eax + 4 * ecx]
    and         bl, 1                                   ; LSB pixel curent
    cmp         bl, bh
    je          bit_four
    xor         byte [eax + 4 * ecx], 1
    
bit_four:
    inc         ecx                                     ; urmatorul element al matricei
    mov         bh, byte [esi + edi]
    shr         bh, 4                                   ; bitul 4 al caracterului curent
    and         bh, 1
    mov         bl, byte [eax + 4 * ecx]
    and         bl, 1                                   ; LSB pixel curent
    cmp         bl, bh
    je          bit_three
    xor         byte [eax + 4 * ecx], 1
    
bit_three:
    inc         ecx                                     ; urmatorul element al matricei
    mov         bh, byte [esi + edi]
    shr         bh, 3                                   ; bitul 3 al caracterului curent
    and         bh, 1
    mov         bl, byte [eax + 4 * ecx]
    and         bl, 1                                   ; LSB pixel curent
    cmp         bl, bh
    je          bit_two
    xor         byte [eax + 4 * ecx], 1
    
bit_two:
    inc         ecx                                     ; urmatorul element al matricei
    mov         bh, byte [esi + edi]
    shr         bh, 2                                   ; bitul 2 al caracterului curent
    and         bh, 1
    mov         bl, byte [eax + 4 * ecx]
    and         bl, 1                                   ; LSB pixel curent
    cmp         bl, bh
    je          bit_one
    xor         byte [eax + 4 * ecx], 1
    
bit_one:
    inc         ecx                                     ; urmatorul element al matricei
    mov         bh, byte [esi + edi]
    shr         bh, 1                                   ; bitul 1 al caracterului curent
    and         bh, 1
    mov         bl, byte [eax + 4 * ecx]
    and         bl, 1                                   ; LSB pixel curent
    cmp         bl, bh
    je          bit_zero
    xor         byte [eax + 4 * ecx], 1
        
bit_zero:
    inc         ecx                                     ; urmatorul element al matricei
    mov         bh, byte [esi + edi]
    and         bh, 1                                   ; bitul 0 al matricei
    mov         bl, byte [eax + 4 * ecx]
    and         bl, 1                                   ; LSB 
    cmp         bl, bh 
    je          next_char_lsb_encode
    xor         byte [eax + 4 * ecx], 1
    
    ; EVALUAREA URMATORULUI CARACTER (cand este cazul)
next_char_lsb_encode:
    inc         ecx                                     ; urmatorul element al matricei
    inc         edi                                     ; urmatorul caracter
    cmp         edi, dword [len]
    jl          char_loop_lsb_encode

    push        dword [img_height]
    push        dword [img_width]
    push        eax
    call        print_image
    add         esp, 12
    
    leave
    ret

; -------------------------------------------------------------------------- TASK 5 ------------------------------------------------------------------------
lsb_decode:
    push        ebp
    mov         ebp, esp

    mov         eax, [ebp + 8]                          ; EAX = matricea
    mov         ebx, [ebp + 12]                         ; EBX = byte id
    dec         ebx
char_generator:

    ; BUCLA DE GENERARE A CARACTERELOR DIN MESAJ
    xor         cx, cx
generator_loop:
    mov         edx, dword [eax + 4 * ebx]
    and         edx, 1                                  ; LSB pixel curent
    shl         cl, 1
    add         cl, dl
    inc         ebx                                     ; uramtorul pixel
    inc         ch                                      ; urmatorul bit
    cmp         ch, 8
    jl          generator_loop
        
    cmp         cl, 0
    je          exit_lsb_decode                         ; daca obtinem caracterul '\0', se termina bucla
    PRINT_CHAR  cl                                      ; daca caracterul obtinut este nenul, acesta va fi afisat in consola
    jmp         char_generator

exit_lsb_decode:
    leave
    ret

; -------------------------------------------------------------------------- TASK 6 ------------------------------------------------------------------------
blur:
    push        ebp
    mov         ebp, esp
    
    mov         ebx, [ebp + 8]                          ; EBX = matricea originala / sursa
    
    ; OBTINEREA INDICILOR MAXIMI DE LUNGIME SI LATIME
    mov         eax, dword [img_width]
    dec         eax
    mov         dword [width_task6], eax
    
    mov         eax, dword [img_height]
    dec         eax
    mov         dword [height_task6], eax
    
    ; OBTINEREA NUMARULUI TOTAL DE ELEMENTE DIN MATRICE
    push        ebx
    mov         eax, dword [img_height]
    mov         ebx, dword [img_width]
    mul         ebx
    mov         dword [len], eax
    pop         ebx

    ; ALOCAREA DINAMICA A UNEI COPII A MATRICEI DATE CA PARAMETRU
    push        4
    push        eax
    call        calloc
    add         esp, 8
    mov         ecx, eax

    ; COPIEREA IMAGINII IN MATRICEA ALOCATA DINAMIC CE VA FI MODIFICATA CONFORM CERINTEI
    push        ecx                                     ; salvarea spatiului alocat dinamic pe stiva [*]
    mov         edi, dword [len]
image_copy:
    mov         eax, dword [ebx + 4 * (edi - 1)]
    mov         dword [ecx + 4 * (edi - 1)], eax  
    dec         edi
    jne         image_copy

    ; APLICAREA FILTRULUI PE IMAGINE
    mov         esi, 1                                  ; ESI = indice de linie
line_loop_blur:
    mov         edx, dword [img_width]                  ; EDX = multiplicator indice linie
    mov         edi, 1                                  ; EDI = indice de coloana
    
column_loop_blur:
    push        edx                                     ; retinerea multiplicatorului
    imul        edx, esi
    add         edx, edi                                ; EDX = pozitia in matrice

    ; PIXEL_NOU = (PIXEL_VECHI + PIXEL_VECHI_STANGA + PIXEL_VECHI_DREAPTA + PIXEL_VECHI_JOS + PIXEL_VECHI_SUS) / 5
    mov         eax, dword [ebx + 4 * edx]
    add         eax, dword [ebx + 4 * (edx - 1)]        ; stanga
    add         eax, dword [ebx + 4 * (edx + 1)]        ; dreapta
    
    push        edx                                     ; retinerea centrului
    add         edx, dword [img_width]                  ; jos
    add         eax, dword [ebx + 4 * edx]

    mov         edx, [esp]                              ; refacerea centrului cu pastrarea valorii centrului in varful stivei
    sub         edx, dword [img_width]                  ; sus
    add         eax, dword [ebx + 4 * edx]
    
    xor         edx, edx                                ; initializarea restului la impartire; valoarea originala a pozitiei din matrice este deja pe stiva
    push        ebx                                     ; mov folosi EBX ca impartitor, dar mai intai trebuie sa retinem matricea pe stiva
    mov         ebx, 5
    div         ebx

    pop         ebx                                     ; refacerea imaginii
    pop         edx                                     ; refacerea pozitiei curente
    
    mov         dword [ecx + 4 * edx], eax              ; actualizarea rezultatului
    pop         edx                                     ; refacerea multiplicatorului 

    inc         edi                                     ; urmatoarea coloana
    cmp         edi, dword [width_task6]
    jl          column_loop_blur

    inc         esi                                     ; urmatoarea linie
    cmp         esi, dword [height_task6]
    jl          line_loop_blur

    push        dword [img_height]
    push        dword [img_width]
    push        ecx
    call        print_image
    add         esp, 12

    ; ELIBERAREA MATRICEI ALOCATE DINAMIC
    pop         ecx                                     ; refacerea lui ECX dupa modificare
    push        ecx
    call        free                                    ; am ramas cu imaginea din [*], imagine care trebuie eliberata
    add         esp, 4
    leave
    ret

; --------------------------------------------------------------------------- MAIN -------------------------------------------------------------------------
global main
main:
    push        ebp
    mov         ebp, esp

    mov eax,    [ebp + 8]
    cmp         eax, 1
    jne         not_zero_param

    push        use_str
    call        printf
    add         esp, 4

    push        -1
    call        exit

not_zero_param:
    mov         eax, [ebp + 12]
    push        dword [eax + 4]
    call        read_image
    add         esp, 4
    mov         [img], eax

    call        get_image_width
    mov         [img_width], eax

    call        get_image_height
    mov         [img_height], eax
    
    mov         eax, [ebp + 12]
    push        dword [eax + 8]
    call        atoi
    add         esp, 4
    mov         [task], eax

    ; CE TASK TREBUIE REZOLVAT?
    mov         eax, [task]
    cmp         eax, 1
    je          solve_task1
    cmp         eax, 2
    je          solve_task2
    cmp         eax, 3
    je          solve_task3
    cmp         eax, 4
    je          solve_task4
    cmp         eax, 5
    je          solve_task5
    cmp         eax, 6
    je          solve_task6
    jmp         done

solve_task1:
    push        dword [img]
    call        bruteforce_singlebyte_xor
    add         esp, 4
    
    ; AFISAREA REZULTATELOR OBTINUTE
    PRINT_STRING message_task1                          ; se afiseaza, mai intai, mesajul
    NEWLINE
    mov         ebx, eax
    shr         ebx, 16
    PRINT_UDEC  4, ebx                                  ; se afiseaza cheia
    NEWLINE
    PRINT_UDEC  2, ax                                   ; se afiseaza linia
    jmp         done
    
solve_task2:
    push        dword [img]
    call        predefined_xor
    add         esp, 4
    jmp         done
    
solve_task3:
    mov         ecx, [ebp + 12]
    
    mov         esi, dword [ecx + 12]
    push        dword [ecx + 16]
    call        atoi
    add         esp, 4

    push        eax
    push        esi
    push        dword [img]
    call        morse_encrypt
    add         esp, 12
    jmp         done
    
solve_task4:
    mov         ecx, [ebp + 12]
    mov         esi, dword [ecx + 12]
    push        dword [ecx + 16]
    call        atoi
    add         esp, 4

    push        eax
    push        esi
    push        dword [img]
    call        lsb_encode
    add         esp, 12 

    jmp         done
    
solve_task5:
    mov         ecx, [ebp + 12]
    push        dword [ecx + 12]
    call        atoi
    add         esp, 4
    
    push        eax
    push        dword [img]
    call        lsb_decode
    add         esp, 8
    jmp         done
    
solve_task6:
    push        dword [img]
    call        blur
    add         esp, 4
    jmp         done

done:
    push        dword [img]
    call        free_image
    add         esp, 4

    xor         eax, eax
    leave
    ret