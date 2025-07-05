
section .data
    msg_case1 db 'Caso 1 executado', 10, 0
    msg_case2 db 'Caso 2 executado', 10, 0  
    msg_case3 db 'Caso 3 executado', 10, 0
    msg_default db 'Caso default executado', 10, 0
    msg_input db 'Digite qual caso quer que seja executado: ', 0
    msg_thanks db 'Programa finalizado', 10, 0
    format_in db '%d', 0

section .bss
    input_var resd 1

section .text
    extern _printf, _scanf
    global _main

_main:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    
    ; Solicita entrada
    lea rdi, [rel msg_input]
    xor rax, rax
    call _printf
    
    ; Le entrada do usuario
    lea rdi, [rel format_in]
    lea rsi, [rel input_var]
    xor rax, rax
    call _scanf
    
    ; Carrega valor para comparacao
    mov eax, [rel input_var]
    
    ; Implementacao do switch
    cmp eax, 1
    je .case_1
    cmp eax, 2
    je .case_2
    cmp eax, 3
    je .case_3
    jmp .default_case
    
.case_1:
    lea rdi, [rel msg_case1]
    xor rax, rax
    call _printf
    jmp .switch_end
    
.case_2:
    lea rdi, [rel msg_case2]
    xor rax, rax
    call _printf
    jmp .switch_end
    
.case_3:
    lea rdi, [rel msg_case3]
    xor rax, rax
    call _printf
    jmp .switch_end
    
.default_case:
    lea rdi, [rel msg_default]
    xor rax, rax
    call _printf
    
.switch_end:
    ; Mensagem final
    lea rdi, [rel msg_thanks]
    xor rax, rax
    call _printf
    
    ; Retorno
    mov rsp, rbp
    pop rbp
    mov rax, 0
    ret



; Macro para comparacao e jump
%macro CHECK_CASE 2
    cmp eax, %1
    je %2
%endmacro

; Macro para imprimir mensagem
%macro PRINT_MSG 1
    lea rdi, [rel %1]
    xor rax, rax
    call _printf
%endmacro