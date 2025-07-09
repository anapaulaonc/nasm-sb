section .text

;################### PARAMETROS #################

;rdi - primeiro parametro
;rsi - segundo parametro
;rax - saida

;################################################

global soma
soma:
    mov rax, rdi
    add rax, rsi
    das
    ret

global subtracao
subtracao:
    mov rax, rdi
    sub rax, rsi
    dasb
    ret



