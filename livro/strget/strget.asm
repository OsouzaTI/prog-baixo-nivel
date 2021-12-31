%macro exit 1
    ; chamada de saida
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro


global _start
global strget
global charget
global strprint
global newline

section .data
newln0: db 10
message: db "Digite seu nome: ", 0

section .text

;-------------PRINT STRING---------------------

newline:
    mov rax, 1      ; syscall write
    mov rdi, 1      ; descritor stdout
    mov rsi, newln0 ; endereco do codigo de newline
    mov rdx, 1      ; quantidade de bytes
    syscall
    ret

strprint:

    mov rax, 1      ; syscall write
    mov rdi, 1      ; descritor de stdout
    mov rsi, rcx    ; endereco do byte
    mov rdx, r8      ; quantidade de bytes
    syscall 
    call newline
    ret

;------------------------------------------------

charget:
    push 0            ; alocando 8 bytes

    mov rax, 0        ; rax = 0
    mov rdi, 0        ; descritor stdin
    mov rsi, rsp      ; endereco do espaco armazenado
    mov rdx, 1        ; bytes lidos
    syscall
    
    pop rax             ; liberando 8 bytes
    ret

strget:
    xor r8, r8
.loop:    
    push rdi                ; endereco do buffer
    call charget            ; ler um caractere     
    pop rdi                 ; restaurando o endereco

    mov byte[rdi + r8], al  ; escreve em rdi o valor lido
    inc r8                  ; incrementa o contador
    cmp r8, 6               ; limite de caracteres
    jnae .loop

    mov byte [rdi + r8], 0       ; null terminator
    mov rax, rdi                 ; movendo para rax o endereco inicial do buffer
    mov rdx, r8                  ; movendo o contador para rdx

    ret


_start:
    mov rcx, message
    mov r8, 17
    call strprint

    push 0          ; alocando 8bytes memoria
    mov rdi, rsp    ; endereco inicial do buffer
    call strget     ; lendo string

    mov rcx, rax    ; movendo para rcx o endereco retornado pela funcao strget
    mov r8, 6
    call strprint   ; print string
    exit 0  ; retorno com codigo 0


