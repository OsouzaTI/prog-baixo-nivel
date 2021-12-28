global _start
section .data
string0: db "ozeias", 0
string1: db "ozeiasq", 0


section .text
strcmp:
    xor rax, rax            ; limpa o registrador que sera usado como saida
    mov r8,    1            ; limpa o registrador que sera usado como saida

.loop:
    cmp byte [rdi+rax], 0   ; compara se a string acabou
    je .end                 ; jump para o final da funcao
    cmp byte [rsi+rax], 0   ; compara se a string acabou
    je .end                 ; jump para o final da funcao
    inc rax                 ; incrementa o rax

    mov cl, [rsi + rax]
    cmp [rdi+rax], cl       ; compara se os dois bytes de string sao iguais
    jne .not_equal          ; jump para flag que define a ocorrencia    

.finally:
    cmp r8, 0               ; compara se r8 == 0
    je .end                 ; caso for igual, finaliza a execucao
    jmp .loop               ; caso o jump acima não for executado volte para .loop

.not_equal:
    dec r8  ; decrementa registrador r8
    jmp .finally

.end:
    ret

_start:
    mov rdi, string0
    mov rsi, string1
    call strcmp
    mov rdi, r8
    mov rax, 60
    syscall