%macro exit 1
    mov rax, 60         ; codigo de sida
    mov rdi, %1
    syscall
%endmacro

%macro newln 1
    push rax            ; guardando rax na pilha
    xor r8, r8          ; zerando r8
    .loop1:
        mov rax, 1      ; syscall write
        mov rdi, 1      ; descritor stdout
        mov rsi, newln0 ; endereco do codigo de newline
        mov rdx, 1      ; quantidade de bytes
        syscall
        inc r8          ; incrementa rax em 1
        cmp r8, %1      ; comparando r8 com %1
        jne .loop1      ; jump caso nao for igual
    pop rax             ; restaurando rax da pilha
%endmacro


global _start

section .data
newln0: db 10
string0: db "ozeias", 0


strinfo:
    xor rax, rax                ; zerando o rax

.loop:
    cmp byte [rdi + rax], 0     ; comparando se é o byte nulo
    je .end
    
    push rax                    ; guardando o valor de rax na pilha

    mov rax, 1                  ; syscall write
    mov rdi, 1                  ; descritor de stdout
    mov rsi, string0            ; endereco do byte
    mov rdx, 1                  ; quantidade de bytes
    syscall
    newln 2

    pop rax                     ; restaurando o valor de rax

.end:
    ret

_start:
    mov rdi, string0
    call strinfo
    exit 0