global _start

section .data
message: db 'hello, world', 10

section .text

_start:

    mov rax, 1  // numero da chamada de sistema que sera executada pela instrucao
    mov rdi, 1
    mov rsi, message
    mov rdx, 14
    syscall

