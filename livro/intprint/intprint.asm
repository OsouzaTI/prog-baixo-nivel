%macro exit 1
    ; chamada de saida
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro

global _start
global newline
global strprint

section .data
newln0: db 10

section .text

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


_start:
    mov rax, 2021   ; numero a ser impresso
    call intprint   ; chamando funcao
    exit 0          ; saida 0 -> sem erros

