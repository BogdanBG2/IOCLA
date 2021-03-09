section .text

global get_max

get_max:
    push rbp
    mov rbp, rsp
    
    mov rbx, rdi ;[ebp+8]
    mov rcx, rsi ;[ebp+12]
    xor rax, rax
    dec rcx

compare:
    cmp eax, dword [rbx + 4 * (rcx-1)]
    jge check_end
    mov eax, dword [rbx + 4 * (rcx-1)]
    
check_end:
    dec rcx
    cmp rcx, 0
    jge compare
    
    leave
    ret