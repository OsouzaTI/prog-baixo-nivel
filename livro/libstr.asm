section .data
newln0: db 10

section .text

global newline
global strprint
global strlen


newln:
    mov rax, 1      ; syscall write
    mov rdi, 1      ; descritor stdout
    mov rsi, newln0 ; endereco do codigo de newline
    mov rdx, 1      ; quantidade de bytes
    syscall
    ret

strprint:
    mov rax, 1                  ; syscall write
    mov rdi, 1                  ; descritor de stdout
    mov rsi, string0            ; endereco do byte
    mov rdx, 6                  ; quantidade de bytes
    syscall 
    call newln
    ret

strlen:
    xor rax, rax
    .loop:
        cmp byte [rdi+rax], 0
        je .end
        inc rax
        jmp .loop
    .end:
        ret