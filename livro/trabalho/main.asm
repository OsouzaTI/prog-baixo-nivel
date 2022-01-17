;---------------------------------------;
;   Todas as funcoes implementadas      ;
; foram usadas, diretamente no _start   ;
; ou indiretamente por outras funcoes   ;
; do conjunto implementado.             ;   
;---------------------------------------------------;
; Alunos:                                           ;
;   Ozeias Silva Souza              | 2019013277    ;
;   Pedro Vinícius da Silva Ribeiro | 2019033903    ;
; Extras:                                           ;
;  https://github.com/OsouzaTI/prog-baixo-nivel.git ;
;---------------------------------------------------;


%macro exibir 1
    mov rax, rdx
    add rax, %1
    call intprint
%endmacro

global _start

section .data
    string0: db "Teste String", 0
    numero0: db "2022", 0
    numero1: db "-2022", 0

section .bss
    buffer0: resb 20    ; buffer usado para copiar alguma string

section .text
%include "livro/lib.asm"

_start:    

    ; impressão de string com uma quebra de linha
    mov r8, string0
    call strprint

    ; copiando string para um buffer
    mov rdi, string0    ; string de origem
    mov rsi, buffer0    ; buffer de destino
    mov rdx, 20         ; tamanho do buffer
    
    ; dentro do strcpy esta sendo chamada a funcao strlen
    ; que recebe um ponteiro para uma string e retorna o 
    ; tamanho dela
    
    call strcpy         ; strcpy    
    mov r8, buffer0     ; passando o endereco do buffer
    call strprint       ; printando o buffer destino

    ; imprimindo um numero inteiro (negativ ou positivo)
    mov rax, -1930      ; numero a ser impresso
    call intprint       ; chamando funcao

    ; parse de numero positivo
    mov rdi, numero0
    call intparse

    ; exibindo numero acima adicionando 0
    exibir 0
    
    ; parse de numero negativo
    mov rdi, numero1
    call intparse

    ; exibindo numero acima adicionando 10
    exibir 10

    exit 0

