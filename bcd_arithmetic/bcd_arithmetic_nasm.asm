section .text

;################### PARAMETROS #################

;rdi - primeiro parametro
;rsi - segundo parametro
;rax - saida

;################################################
extern printf
global soma
soma:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    add eax, [ebp + 12]
    das

    pop ebp
    ret

global subtracao
subtracao:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    sub eax, [ebp + 12]
    das

    pop ebp
    ret
