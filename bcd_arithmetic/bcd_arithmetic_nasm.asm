section .text

;################### PARAMETROS #################
;rdi - primeiro parametro (em sistemas 64-bit)
;rsi - segundo parametro (em sistemas 64-bit)
;rax - saida

; Para sistemas 32-bit:
; [esp+4] - primeiro parametro
; [esp+8] - segundo parametro
; eax - saida

;################################################
extern printf
global soma
soma:
    push ebp            ; Salva o base pointer
    mov ebp, esp        ; Configura o novo base pointer
    push ebx            ; Salva EBX, será usado
    push edx            ; Salva EDX, será usado
    push ecx            ; Salva ECX, será usado

    mov eax, [ebp + 8]  ; EAX = primeiro operando (a) - valor BCD
    mov ebx, [ebp + 12] ; EBX = segundo operando (b) - valor BCD
    
    ; --- Nibble 0 (menos significativo) ---
    mov ecx, eax        ; Copia 'a' para ECX
    and ecx, 0x0F       ; Isola o nibble 0
    mov edx, ebx        ; Copia 'b' para EDX
    and edx, 0x0F       ; Isola o nibble 0 de 'b'
    add ecx, edx        ; Soma os nibbles
    cmp ecx, 9
    jle .nibble0_ok
    sub ecx, 10
    mov edx, 1          ; Carry para o próximo nibble
    jmp .nibble0_store
.nibble0_ok:
    mov edx, 0          ; Sem carry
.nibble0_store:
    push ecx            ; Salva nibble 0 na pilha

    ; --- Nibble 1 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 4          ; Desloca para pegar o nibble 1
    and ecx, 0x0F       ; Isola o nibble 1
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 4          ; Desloca para pegar o nibble 1
    and esi, 0x0F       ; Isola o nibble 1
    add ecx, esi        ; Soma os nibbles
    add ecx, edx        ; Adiciona carry do nibble anterior
    cmp ecx, 9
    jle .nibble1_ok
    sub ecx, 10
    mov edx, 1          ; Carry para o próximo nibble
    jmp .nibble1_store
.nibble1_ok:
    mov edx, 0          ; Sem carry
.nibble1_store:
    push ecx            ; Salva nibble 1 na pilha

    ; --- Nibble 2 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 8          ; Desloca para pegar o nibble 2
    and ecx, 0x0F       ; Isola o nibble 2
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 8          ; Desloca para pegar o nibble 2
    and esi, 0x0F       ; Isola o nibble 2
    add ecx, esi        ; Soma os nibbles
    add ecx, edx        ; Adiciona carry do nibble anterior
    cmp ecx, 9
    jle .nibble2_ok
    sub ecx, 10
    mov edx, 1          ; Carry para o próximo nibble
    jmp .nibble2_store
.nibble2_ok:
    mov edx, 0          ; Sem carry
.nibble2_store:
    push ecx            ; Salva nibble 2 na pilha

    ; --- Nibble 3 (mais significativo) ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 12         ; Desloca para pegar o nibble 3
    and ecx, 0x0F       ; Isola o nibble 3
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 12         ; Desloca para pegar o nibble 3
    and esi, 0x0F       ; Isola o nibble 3
    add ecx, esi        ; Soma os nibbles
    add ecx, edx        ; Adiciona carry do nibble anterior
    cmp ecx, 9
    jle .nibble3_ok
    sub ecx, 10
    ; Carry seria perdido aqui, mas para 4 dígitos BCD é aceitável
.nibble3_ok:
    push ecx            ; Salva nibble 3 na pilha

    ; Monta o resultado final
    pop edi             ; Recupera nibble 3 (mais significativo)
    pop esi             ; Recupera nibble 2
    pop ebx             ; Recupera nibble 1
    pop ecx             ; Recupera nibble 0 (menos significativo)

    shl edi, 12         ; Posiciona nibble 3
    shl esi, 8          ; Posiciona nibble 2
    shl ebx, 4          ; Posiciona nibble 1
    ; ecx já está na posição correta (nibble 0)

    mov eax, ecx        ; Resultado inicial = nibble 0
    or eax, ebx         ; Adiciona nibble 1
    or eax, esi         ; Adiciona nibble 2
    or eax, edi         ; Adiciona nibble 3

    pop ecx             ; Restaura ECX
    pop edx             ; Restaura EDX
    pop ebx             ; Restaura EBX
    pop ebp             ; Restaura EBP
    ret

global subtracao
subtracao:
    push ebp
    mov ebp, esp

    push ebx
    push edx
    push ecx

    mov eax, [ebp + 8]  ; EAX = primeiro operando (a) - valor BCD
    mov ebx, [ebp + 12] ; EBX = segundo operando (b) - valor BCD

    ; --- Nibble 0 (menos significativo) ---
    mov ecx, eax        ; Copia 'a' para ECX
    and ecx, 0x0F       ; Isola o nibble 0
    mov edx, ebx        ; Copia 'b' para EDX
    and edx, 0x0F       ; Isola o nibble 0 de 'b'
    sub ecx, edx        ; Subtrai os nibbles
    cmp ecx, 0
    jge .sub_nibble0_ok
    add ecx, 10
    mov edx, 1          ; Borrow para o próximo nibble
    jmp .sub_nibble0_store
.sub_nibble0_ok:
    mov edx, 0          ; Sem borrow
.sub_nibble0_store:
    push ecx            ; Salva nibble 0 na pilha

    ; --- Nibble 1 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 4          ; Desloca para pegar o nibble 1
    and ecx, 0x0F       ; Isola o nibble 1
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 4          ; Desloca para pegar o nibble 1
    and esi, 0x0F       ; Isola o nibble 1
    sub ecx, esi        ; Subtrai os nibbles
    sub ecx, edx        ; Subtrai borrow do nibble anterior
    cmp ecx, 0
    jge .sub_nibble1_ok
    add ecx, 10
    mov edx, 1          ; Borrow para o próximo nibble
    jmp .sub_nibble1_store
.sub_nibble1_ok:
    mov edx, 0          ; Sem borrow
.sub_nibble1_store:
    push ecx            ; Salva nibble 1 na pilha

    ; --- Nibble 2 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 8          ; Desloca para pegar o nibble 2
    and ecx, 0x0F       ; Isola o nibble 2
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 8          ; Desloca para pegar o nibble 2
    and esi, 0x0F       ; Isola o nibble 2
    sub ecx, esi        ; Subtrai os nibbles
    sub ecx, edx        ; Subtrai borrow do nibble anterior
    cmp ecx, 0
    jge .sub_nibble2_ok
    add ecx, 10
    mov edx, 1          ; Borrow para o próximo nibble
    jmp .sub_nibble2_store
.sub_nibble2_ok:
    mov edx, 0          ; Sem borrow
.sub_nibble2_store:
    push ecx            ; Salva nibble 2 na pilha

    ; --- Nibble 3 (mais significativo) ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 12         ; Desloca para pegar o nibble 3
    and ecx, 0x0F       ; Isola o nibble 3
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 12         ; Desloca para pegar o nibble 3
    and esi, 0x0F       ; Isola o nibble 3
    sub ecx, esi        ; Subtrai os nibbles
    sub ecx, edx        ; Subtrai borrow do nibble anterior
    cmp ecx, 0
    jge .sub_nibble3_ok
    add ecx, 10
    ; Borrow seria perdido aqui, mas para 4 dígitos BCD é aceitável
.sub_nibble3_ok:
    push ecx            ; Salva nibble 3 na pilha

    ; Monta o resultado final
    pop edi             ; Recupera nibble 3 (mais significativo)
    pop esi             ; Recupera nibble 2
    pop ebx             ; Recupera nibble 1
    pop ecx             ; Recupera nibble 0 (menos significativo)

    shl edi, 12         ; Posiciona nibble 3
    shl esi, 8          ; Posiciona nibble 2
    shl ebx, 4          ; Posiciona nibble 1
    ; ecx já está na posição correta (nibble 0)

    mov eax, ecx        ; Resultado inicial = nibble 0
    or eax, ebx         ; Adiciona nibble 1
    or eax, esi         ; Adiciona nibble 2
    or eax, edi         ; Adiciona nibble 3

    pop ecx
    pop edx
    pop ebx
    pop ebp
    ret
