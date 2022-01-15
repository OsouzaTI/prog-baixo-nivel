%macro exit 1
    ; chamada de saida
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro

global _start

section .data
numero: db "-123", 0
symb_negative: db 45
newln0: db 10

section .text

negative:
    mov rax, 1             ; syscall write
    mov rdi, 1             ; descritor stdout
    mov rsi, symb_negative ; endereco do codigo de newline
    mov rdx, 1             ; quantidade de bytes
    syscall
    ret

newline:
    mov rax, 1      ; syscall write
    mov rdi, 1      ; descritor stdout
    mov rsi, newln0 ; endereco do codigo de newline
    mov rdx, 1      ; quantidade de bytes
    syscall
    ret

; modificado para printar o valor armazenado em rsp (topo da pilha de hardware)
strprint:
    mov rax, 1                  ; syscall write
    mov rdi, 1                  ; descritor de stdout
    mov rsi, r8                 ; endereco do byte
    mov rdx, rcx                ; quantidade de bytes
    push rcx
    syscall 
    call newline
    pop rcx

    ret

;---------------------------------------------
;   O comando div, realiza a operacao          
; de divisao resultando em um dado de 128bits
; armazenado em dois registradores: rdx e rax
;----------------------------------------------
intprint:    
    xor rcx, rcx
    mov r15, 10     ; constante de divisao
    cmp rax, 0      ; compara rax com 0
    jge .loop       ; caso for maior ou igual a 0 -> jump loop
    ; caso for menor que 0
    push rax        ; guarda rax
    push rcx        ; guarda rcx
    call negative   ; chama a funcao que imprime o simbolo '-'
    pop rcx         ; restaura rcx
    pop rax         ; restaura rax    
    neg rax         ; inverte o sinal de rax (negativo -> positivo)

.loop:
    xor rdx, rdx    ; limpa o registrador.
    div r15         ; div usa implicitamente o rax
                    ; como segundo argumento.
    add dl, 0x30    ; dl amazena o byte mais significante
                    ; de rdx, adicionando 0x30 ('0' na tabela ascii).
    dec rsp         ; alocando um byte de memoria no ultimo elemento
                    ; da pilha
    mov [rsp], dl   ; movendo o digito devidamente tratrado
    inc rcx         ; contador de digitos
    test rax, rax   ; verificando se rax == 0
    jnz .loop

    mov r8, rsp     ; armazenando o valor de rsp em r8
    call strprint   ; chamada de funcao

    add rsp, rcx    ; liberando topo da pilha de hardware
    ret

intparse:
    xor rcx, rcx    ; limpa rax
    xor rdx, rdx    ; limpa rdx
    xor rsi, rsi    ; flag de numero negativo   
.loop:
    
    movzx r8, byte [rdi + rcx]
    test r8, r8
    je .end

    cmp r8, 0x2d    ; verifica se tem o symbolo '-'
    je .L1          ; jump se for igual
    
    sub r8, 0x30    ; transforma de ascii para decimal
    imul rdx, 10
    add rdx, r8
    jmp .L2
.L1:                ; numero negativo
    mov rsi, 1      ; definido como (0) positivo | (1) negativo
.L2:
    inc rcx    
    jmp .loop

.L3:
    neg rdx         ; inverte o sinal do numero
    ret             ; retorna
.end:
    cmp rsi, 1      ; se for negativo
    je  .L3         ; jump se for igual
    ret             ; retorna

_start:
    mov rdi, numero
    call intparse
    mov rax, rdx
    add rax, 10
    call intprint

    exit 0