
; Dados inicializados (strings)
section .data
    msg_case1 db 'Caso 1 executado', 10, 0      ; Define string "Caso 1 executado" + quebra de linha (10) + terminador nulo (0)
    msg_case2 db 'Caso 2 executado', 10, 0      ; Define string "Caso 2 executado" + quebra de linha + terminador nulo
    msg_case3 db 'Caso 3 executado', 10, 0      ; Define string "Caso 3 executado" + quebra de linha + terminador nulo
    msg_default db 'Caso default executado', 10, 0  ; Define string para caso padrão + quebra de linha + terminador nulo
    msg_input db 'Digite qual caso quer que seja executado: ', 0  ; String de prompt para usuário + terminador nulo
    msg_thanks db 'Programa finalizado', 10, 0   ; String de despedida + quebra de linha + terminador nulo
    format_in db '%d', 0                         ; String de formato para scanf ler inteiros + terminador nulo


; Dados não inicializados (variáveis)
section .bss
    input_var resd 1                             ; Reserva espaço para 1 dword (4 bytes) para armazenar entrada do usuário

;  executável
section .text
    extern printf, scanf                         ; Declara que printf e scanf são funções externas (da libc)
    global main                                  ; Torna 'main' visível para o linker (ponto de entrada do programa)

; DEFINIÇÃO DAS MACROS

; Macro para comparacao e jump - recebe 2 parâmetros
%macro CHECK_CASE 2                              ; Define macro CHECK_CASE que aceita 2 parâmetros
    cmp eax, %1                                  ; Compara conteúdo de eax com primeiro parâmetro (%1)
    je %2                                        ; Se iguais, pula para o label especificado no segundo parâmetro (%2)
%endmacro                                        ; Fim da definição da macro

; Macro para imprimir mensagem - recebe 1 parâmetro
%macro PRINT_MSG 1                               ; Define macro PRINT_MSG que aceita 1 parâmetro
    push %1                                      ; Empilha o endereço da string (%1) como parâmetro para printf
    call printf                                  ; Chama a função printf para imprimir a string
    add esp, 4                                   ; Ajusta stack pointer para remover 1 parâmetro (4 bytes) da pilha
%endmacro                                        ; Fim da definição da macro

; Macro para ler inteiro - recebe 1 parâmetro (variável destino)
%macro READ_INT 1                                ; Define macro READ_INT que aceita 1 parâmetro
    push %1                                      ; Empilha endereço da variável destino (%1) como segundo parâmetro
    push format_in                               ; Empilha endereço da string de formato "%d" como primeiro parâmetro
    call scanf                                   ; Chama função scanf para ler um inteiro do usuário
    add esp, 8                                   ; Ajusta stack pointer para remover 2 parâmetros (8 bytes) da pilha
%endmacro                                        ; Fim da definição da macro

; Macro para carregar valor de variável - recebe 2 parâmetros (registrador, variável)
%macro LOAD_VAR 2                                ; Define macro LOAD_VAR que aceita 2 parâmetros
    mov %1, [%2]                                 ; Move o valor armazenado na variável (%2) para o registrador (%1)
%endmacro                                        ; Fim da definição da macro

; Macro para inicializar função - sem parâmetros
%macro FUNCTION_START 0                          ; Define macro FUNCTION_START que não aceita parâmetros
    push ebp                                     ; Salva o frame pointer atual (ebp) na pilha
    mov ebp, esp                                 ; Estabelece novo frame pointer copiando stack pointer para ebp
    sub esp, 16                                  ; Aloca 16 bytes na pilha para variáveis locais (reserva espaço)
%endmacro                                        ; Fim da definição da macro

; Macro para finalizar função - sem parâmetros
%macro FUNCTION_END 0                            ; Define macro FUNCTION_END que não aceita parâmetros
    mov esp, ebp                                 ; Restaura stack pointer para o valor do frame pointer (libera espaço local)
    pop ebp                                      ; Restaura frame pointer anterior da pilha
    mov eax, 0                                   ; Define valor de retorno da função como 0 (sucesso)
    ret                                          ; Retorna o controle para quem chamou a função
%endmacro                                        ; Fim da definição da macro


; FUNÇÃO PRINCIPAL

main:                                            ; Label que marca o início da função principal
    FUNCTION_START                               ; Chama macro FUNCTION_START (expande: push ebp; mov ebp, esp; sub esp, 16)

    ; Solicita entrada do usuário
    PRINT_MSG msg_input                          ; Chama macro PRINT_MSG com msg_input (expande: push msg_input; call printf; add esp, 4)

    ; Lê entrada do usuário
    READ_INT input_var                           ; Chama macro READ_INT com input_var (expande: push input_var; push format_in; call scanf; add esp, 8)

    ; Carrega valor lido para comparação
    LOAD_VAR eax, input_var                      ; Chama macro LOAD_VAR (expande: mov eax, [input_var]) - carrega valor digitado em eax

    ; Implementa estrutura switch usando macros
    CHECK_CASE 1, .case_1                        ; Chama macro CHECK_CASE (expande: cmp eax, 1; je .case_1) - se digitou 1, vai para .case_1
    CHECK_CASE 2, .case_2                        ; Chama macro CHECK_CASE (expande: cmp eax, 2; je .case_2) - se digitou 2, vai para .case_2
    CHECK_CASE 3, .case_3                        ; Chama macro CHECK_CASE (expande: cmp eax, 3; je .case_3) - se digitou 3, vai para .case_3
    jmp .default_case                            ; Pula incondicionalmente para .default_case se nenhum case anterior foi executado

.case_1:                                         ; Label que marca o início do código para caso 1
    PRINT_MSG msg_case1                          ; Chama macro PRINT_MSG para imprimir "Caso 1 executado"
    jmp .switch_end                              ; Pula para o fim do switch (equivale ao 'break' em C)

.case_2:                                         ; Label que marca o início do código para caso 2
    PRINT_MSG msg_case2                          ; Chama macro PRINT_MSG para imprimir "Caso 2 executado"
    jmp .switch_end                              ; Pula para o fim do switch (equivale ao 'break' em C)

.case_3:                                         ; Label que marca o início do código para caso 3
    PRINT_MSG msg_case3                          ; Chama macro PRINT_MSG para imprimir "Caso 3 executado"
    jmp .switch_end                              ; Pula para o fim do switch (equivale ao 'break' em C)

.default_case:                                   ; Label que marca o código do caso padrão
    PRINT_MSG msg_default                        ; Chama macro PRINT_MSG para imprimir "Caso default executado"

.switch_end:                                     ; Label que marca o fim da estrutura switch
    PRINT_MSG msg_thanks                         ; Chama macro PRINT_MSG para imprimir "Programa finalizado"

    FUNCTION_END                                 ; Chama macro FUNCTION_END (expande: mov esp, ebp; pop ebp; mov eax, 0; ret)
