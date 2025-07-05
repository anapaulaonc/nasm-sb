
%ifdef __MACHO__
    ; macOS
    %define PRINTF_FUNC _printf
    %define SCANF_FUNC _scanf
    %define MAIN_FUNC _main
%else
    ; Linux
    %define PRINTF_FUNC printf
    %define SCANF_FUNC scanf
    %define MAIN_FUNC main
%endif

section .data
    msg_case1 db 'Caso 1 executado!', 10, 0
    msg_case2 db 'Caso 2 executado!', 10, 0
    msg_case3 db 'Caso 3 executado!', 10, 0
    msg_default db 'Caso default executado!', 10, 0
    msg_input db 'Digite um numero (1-3): ', 0
    msg_thanks db 'Programa finalizado!', 10, 0
    format_in db '%d', 0

section .bss
    input_var resd 1

section .text
    extern PRINTF_FUNC, SCANF_FUNC
    global MAIN_FUNC

MAIN_FUNC:
    push rbp
    mov rbp, rsp
    sub rsp, 16


    lea rdi, [rel msg_input]
    xor rax, rax
    call PRINTF_FUNC

    lea rdi, [rel format_in]
    lea rsi, [rel input_var]
    xor rax, rax
    call SCANF_FUNC


    mov eax, [rel input_var]

    ; switch
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
    call PRINTF_FUNC
    jmp .switch_end

.case_2:
    lea rdi, [rel msg_case2]
    xor rax, rax
    call PRINTF_FUNC
    jmp .switch_end

.case_3:
    lea rdi, [rel msg_case3]
    xor rax, rax
    call PRINTF_FUNC
    jmp .switch_end

.default_case:
    lea rdi, [rel msg_default]
    xor rax, rax
    call PRINTF_FUNC

.switch_end:
    lea rdi, [rel msg_thanks]
    xor rax, rax
    call PRINTF_FUNC

    mov rsp, rbp
    pop rbp
    mov rax, 0
    ret



%macro LOAD_ADDR 2
%ifdef __MACHO__
    lea %1, [rel %2]
%else
    mov %1, %2
%endif
%endmacro

; comparacao e jump
%macro CHECK_CASE 2
    cmp eax, %1
    je %2
%endmacro

%macro PRINT_MSG 1
    LOAD_ADDR rdi, %1
    xor rax, rax
    call PRINTF_FUNC
%endmacro
