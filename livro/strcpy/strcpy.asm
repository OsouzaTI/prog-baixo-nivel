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

strlen:
    xor rax, rax
.loop0:
    cmp byte [rdi+rax], 0
    je .end0
    inc rax
    jmp .loop0
.end0:
    ret

strprint:
    mov rax, 1                  ; syscall write
    mov rdi, 1                  ; descritor de stdout
    mov rsi, buffer0            ; endereco do byte
    mov rdx, 6                  ; quantidade de bytes
    syscall 
    ret

strcpy:
    call strlen
    cmp rax, rdx
    jg .overflow
    xor rax, rax    
.loop:
    mov dl, byte [rdi + rax]
    mov [rsi + rax], dl
    inc rax
    cmp byte [rdi + rax], 0
    je .end
    jmp .loop

.overflow:
    exit 1

.end:
    ret

_start:
    mov rdi, string0    ; string de origem
    mov rsi, buffer0    ; buffer de destino
    mov rdx, 20         ; tamanho do buffer
    call strcpy         ; strcpy
    call strprint       ; printando o buffer destino
    exit 0              ; saindo com 0
