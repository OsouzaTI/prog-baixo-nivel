section .data

section .text

global newline
global strprint
global strlen
global strcpy
global strcmp
global intparse

;------------ MACROS -----------------;
%macro exit 1
    mov rax, 60 ; codigo de sida
    mov rdi, %1 
    syscall
%endmacro
;------------- END MACROS ------------;


;-------------------------------------;
; NEW LINE: gera uma quebra de linha  ;
;-------------------------------------;
newln:
    mov rax, 1      ; syscall write
    mov rdi, 1      ; descritor stdout
    mov rsi, 0x0a   ; endereco do codigo de newline
    mov rdx, 1      ; quantidade de bytes
    syscall
    ret

;----------------------------------------;
; STRING PRINT: recebe uma string em 'r8';
; ---------------------------------------;
strprint: ; TODO: testar strlen automatico
    mov rdi, r8  ; movendo para rdi o endereco da string
    call strlen  ; chamando o strlen -> retorna o tamanho em rax
    mov rcx, rax ; movendo o tamanho da string para rcx

    mov rax, 1   ; syscall write
    mov rdi, 1   ; descritor de stdout
    mov rsi, r8  ; endereco do byte
    mov rdx, rcx ; quantidade de bytes
    syscall 
    call newln
    ret

;-----------------------------------------;
; STRLEN: recebe um endereco de string em ;
; 'rdi' e retorna em 'rax' o tamanho.     ;
;-----------------------------------------;
strlen:
    xor rax, rax
    .loop:
        cmp byte [rdi+rax], 0
        je .end
        inc rax
        jmp .loop
    .end:
        ret
;------------------------------------------------;
; STRCPY: recebe um endereco de buffer em        ;
; 'rsi' e um endereco de uma string em 'rdi',    ;
; o tamanho do buffer (bytes) a ser usado sera   ;
; recebido em 'rdx'. Em caso de overflow o codigo;
; sera interrompido com saida 1.                 ;
;------------------------------------------------;

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

;------------------------------------------------;
; STRCMP: recebe dois ponteiros para strings     ;
; em 'rdi' e 'rsi', retorna em 'r8':             ;
;   0 - Se as strings forem diferentes           ;
;   1 - Se as string forem iguais                ;
;------------------------------------------------;

strcmp:
    xor rax, rax                ; limpa o registrador que sera usado como saida
    mov r8,    1                ; limpa o registrador que sera usado como saida

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

;---------------------------------------------------;
; INT PARSE: recebe um ponteiro para uma string     ;
; contendo um numero (positivo ou negativo) sera    ;
; retornado em rdx o valor convertido para decimal  ;
;---------------------------------------------------;

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


;-----------------------------------------------;
; INT PRINT: recebe um valor numerico decimal   ;
; em 'rax', sera mostrado no terminal o numero  ;
; impresso (caso negativo iniciara com '-')     ;
;-----------------------------------------------;
negative:
    mov rax, 1       ; syscall write
    mov rdi, 1       ; descritor stdout
    mov rsi, 0x2d    ; endereco do codigo de newline
    mov rdx, 1       ; quantidade de bytes
    syscall
    ret


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
;---------------------------------------------
;   O comando div, realiza a operacao          
; de divisao resultando em um dado de 128bits
; armazenado em dois registradores: rdx e rax
;----------------------------------------------
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