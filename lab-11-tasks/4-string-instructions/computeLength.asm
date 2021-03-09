global computeLength1
global computeLength2

section .text
computeLength1:
        push    ebp
        mov     ebp, esp
;TODO: Implement byte count using a software loop
	
        mov     edi, [ebp + 8]
        xor     ecx, ecx
strlen_loop:
        inc     ecx
        cmp     byte [edi + ecx], 0
        jne     strlen_loop
        
        mov     eax, ecx
        mov     esp, ebp
        pop     ebp
        ret

computeLength2:
        push    ebp
        mov     ebp, esp
;TODO: Implement byte count using a hardware loop
		xor 	ecx, ecx
        dec		ecx
        mov     edi, [ebp + 8]
        xor 	eax, eax
        cld
        repne   scasb
        inc     ecx
        not     ecx
        mov     eax, ecx
        
        mov     esp, ebp
        pop     ebp
        ret
