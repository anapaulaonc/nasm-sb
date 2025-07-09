; Strings e constantes
section .data
    msg_case1 db 'Caso 1 executado', 10, 0      ; String para caso 1 + quebra de linha + terminador nulo
    msg_case2 db 'Caso 2 executado', 10, 0      ; String para caso 2 + quebra de linha + terminador nulo
    msg_case3 db 'Caso 3 executado', 10, 0      ; String para caso 3 + quebra de linha + terminador nulo
    msg_default db 'Caso default executado', 10, 0  ; String para caso padrão + quebra de linha + terminador nulo
    msg_input db 'Digite qual caso quer que seja executado: ', 0  ; Prompt para entrada do usuário + terminador nulo
    msg_thanks db 'Programa finalizado', 10, 0   ; Mensagem de fim + quebra de linha + terminador nulo
    format_in db '%d', 0                         ; String de formato para scanf ler inteiro + terminador nulo

; Variáveis não inicializadas
section .bss
    input_var resd 1                             ; Reserva 1 dword (4 bytes) para armazenar entrada do usuário

; SEÇÃO DE CÓDIGO - Declarações externas e função principal
section .text
    extern _printf, _scanf                       ; Declara funções externas do C (com _ para macOS)
    global _main                                 ; Torna _main visível para o linker (ponto de entrada)

; DEFINIÇÃO DAS MACROS

; Macro para comparacao e jump - recebe 2 parâmetros
%macro CHECK_CASE 2
    cmp eax, %1                                  ; Compara eax com primeiro parâmetro (%1)
    je %2                                        ; Pula para segundo parâmetro (%2) se iguais
%endmacro

; Macro para imprimir mensagem - recebe 1 parâmetro
%macro PRINT_MSG 1
    lea rdi, [rel %1]                            ; Carrega endereço da string (%1) em rdi (1º arg para printf)
    xor rax, rax                                 ; Zera rax (printf é função variádica, precisa de rax=0)
    call _printf                                 ; Chama função printf
%endmacro

; Macro para ler inteiro - recebe 1 parâmetro (variável destino)
%macro READ_INT 1
    lea rdi, [rel format_in]                     ; Carrega endereço do formato "%d" em rdi (1º arg)
    lea rsi, [rel %1]                            ; Carrega endereço da variável (%1) em rsi (2º arg)
    xor rax, rax                                 ; Zera rax (scanf é função variádica)
    call _scanf                                  ; Chama função scanf
%endmacro

; Macro para carregar valor de variável - recebe 2 parâmetros (registrador, variável)
%macro LOAD_VAR 2
    mov %1, [rel %2]                             ; Move valor da variável (%2) para registrador (%1)
%endmacro

; Macro para inicializar função - sem parâmetros
%macro FUNCTION_START 0
    push rbp                                     ; Salva frame pointer anterior na pilha
    mov rbp, rsp                                 ; Estabelece novo frame pointer
    sub rsp, 16                                  ; Aloca 16 bytes na pilha (alinhamento 16-byte para macOS)
%endmacro

; Macro para finalizar função - sem parâmetros
%macro FUNCTION_END 0
    mov rsp, rbp                                 ; Restaura stack pointer (desfaz alocações locais)
    pop rbp                                      ; Restaura frame pointer anterior
    mov rax, 0                                   ; Define valor de retorno como 0 (sucesso)
    ret                                          ; Retorna para quem chamou a função
%endmacro

; ===============================================
; FUNÇÃO PRINCIPAL
; ===============================================

_main:                                           ; Label da função principal (ponto de entrada)
    FUNCTION_START                               ; Expande para: push rbp; mov rbp, rsp; sub rsp, 16
    
    ; Solicita entrada do usuário
    PRINT_MSG msg_input                          ; Expande para: lea rdi, [rel msg_input]; xor rax, rax; call _printf
    
    ; Lê entrada do usuário
    READ_INT input_var                           ; Expande para: lea rdi, [rel format_in]; lea rsi, [rel input_var]; xor rax, rax; call _scanf
    
    ; Carrega valor lido para comparação
    LOAD_VAR eax, input_var                      ; Expande para: mov eax, [rel input_var]
    
    ; Implementa estrutura switch usando macros
    CHECK_CASE 1, .case_1                        ; Expande para: cmp eax, 1; je .case_1
    CHECK_CASE 2, .case_2                        ; Expande para: cmp eax, 2; je .case_2
    CHECK_CASE 3, .case_3                        ; Expande para: cmp eax, 3; je .case_3
    jmp .default_case                            ; Pula para caso padrão se nenhum case anterior foi executado
    
.case_1:                                         ; Label para caso 1
    PRINT_MSG msg_case1                          ; Imprime mensagem do caso 1
    jmp .switch_end                              ; Pula para fim do switch (equivale ao break)
    
.case_2:                                         ; Label para caso 2
    PRINT_MSG msg_case2                          ; Imprime mensagem do caso 2
    jmp .switch_end                              ; Pula para fim do switch (equivale ao break)
    
.case_3:                                         ; Label para caso 3
    PRINT_MSG msg_case3                          ; Imprime mensagem do caso 3
    jmp .switch_end                              ; Pula para fim do switch (equivale ao break)
    
.default_case:                                   ; Label para caso padrão
    PRINT_MSG msg_default                        ; Imprime mensagem do caso padrão
    
.switch_end:                                     ; Label de fim do switch
    PRINT_MSG msg_thanks                         ; Imprime mensagem de finalização
    
    FUNCTION_END                                 ; Expande para: mov rsp, rbp; pop rbp; mov rax, 0; ret