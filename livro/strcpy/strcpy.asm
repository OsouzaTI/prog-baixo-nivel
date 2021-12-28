%macro strlen 1
    push rax
    xor rax, rax
    .loop:
        cmp byte [rdi+rax], 0
        je .end
        inc rax
        jmp .loop
    pop rax
%endmacro

%macro exit 1
    mov rax, 60         ; codigo de sida
    mov rdi, %1
    syscall
%endmacro


global _start

section .data
string0: db "origem", 0

section .bss
buffer0: resb 20
buffer1: resb 10
buffer2: resb 3

section .text

strprint:
    mov rax, 1                  ; syscall write
    mov rdi, 1                  ; descritor de stdout
    mov rsi, buffer2            ; endereco do byte
    mov rdx, 6                  ; quantidade de bytes
    syscall 
    ret

strcpy:
    xor rax, rax

.loop:
    mov dl, byte [rdi + rax]
    mov [rsi + rax], dl
    inc rax
    cmp byte [rdi + rax], 0
    je .end
    jmp .loop
.end:
    ret

_start:
    mov rdi, string0
    mov rsi, buffer2
    call strcpy
    call strprint
    exit 0
