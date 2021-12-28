%macro exit 1
    mov rax, 60         ; codigo de sida
    mov rdi, %1
    syscall
%endmacro

global _start

section .data
newln0: db 10
string0: db "ozeias", 0

newline:
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
    call newline
    ret

_start:
    mov rdi, string0
    call strprint
    exit 0