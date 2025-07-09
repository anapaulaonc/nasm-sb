section .text

;################### PARAMETROS #################

;rdi - primeiro parametro
;rsi - segundo parametro
;rax - saida

;################################################
extern printf
global soma
soma:
    push ebp            ; Salva o base pointer
    mov ebp, esp        ; Configura o novo base pointer

    push ebx            ; Salva EBX, será usado
    push edx            ; Salva EDX, será usado

    mov eax, [ebp + 8]  ; EAX = primeiro operando (a)
    mov ebx, [ebp + 12] ; EBX = segundo operando (b)
    xor edx, edx        ; EDX = resultado (inicialmente zero)

    clc                 ; Limpa o Carry Flag (para a primeira adição)

    ; Processa byte 0 (menos significativo)
    mov al, byte [eax]  ; Carrega o byte 0 de 'a' em AL
    adc al, byte [ebx]  ; Adiciona o byte 0 de 'b' com carry para AL
    das                 ; Ajusta o byte 0
    mov byte [edx], al  ; Salva o byte 0 ajustado em EDX (resultado)

    ; Processa byte 1
    mov al, byte [eax+1] ; Carrega o byte 1 de 'a' em AL
    adc al, byte [ebx+1] ; Adiciona o byte 1 de 'b' com carry para AL
    das                  ; Ajusta o byte 1
    mov byte [edx+1], al ; Salva o byte 1 ajustado em EDX

    ; Processa byte 2
    mov al, byte [eax+2] ; Carrega o byte 2 de 'a' em AL
    adc al, byte [ebx+2] ; Adiciona o byte 2 de 'b' com carry para AL
    das                  ; Ajusta o byte 2
    mov byte [edx+2], al ; Salva o byte 2 ajustado em EDX

    ; Processa byte 3 (mais significativo)
    mov al, byte [eax+3] ; Carrega o byte 3 de 'a' em AL
    adc al, byte [ebx+3] ; Adiciona o byte 3 de 'b' com carry para AL
    das                  ; Ajusta o byte 3
    mov byte [edx+3], al ; Salva o byte 3 ajustado em EDX

    mov eax, edx        ; Move o resultado final de EDX para EAX
    pop edx             ; Restaura EDX
    pop ebx             ; Restaura EBX
    pop ebp             ; Restaura EBP
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
