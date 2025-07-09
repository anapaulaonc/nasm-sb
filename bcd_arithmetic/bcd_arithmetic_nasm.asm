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
    push esi            ; Salva ESI, será usado
    push edi            ; Salva EDI, será usado

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

    ; --- Nibble 3 ---
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
    mov edx, 1          ; Carry para o próximo nibble
    jmp .nibble3_store
.nibble3_ok:
    mov edx, 0          ; Sem carry
.nibble3_store:
    push ecx            ; Salva nibble 3 na pilha

    ; --- Nibble 4 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 16         ; Desloca para pegar o nibble 4
    and ecx, 0x0F       ; Isola o nibble 4
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 16         ; Desloca para pegar o nibble 4
    and esi, 0x0F       ; Isola o nibble 4
    add ecx, esi        ; Soma os nibbles
    add ecx, edx        ; Adiciona carry do nibble anterior
    cmp ecx, 9
    jle .nibble4_ok
    sub ecx, 10
    mov edx, 1          ; Carry para o próximo nibble
    jmp .nibble4_store
.nibble4_ok:
    mov edx, 0          ; Sem carry
.nibble4_store:
    push ecx            ; Salva nibble 4 na pilha

    ; --- Nibble 5 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 20         ; Desloca para pegar o nibble 5
    and ecx, 0x0F       ; Isola o nibble 5
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 20         ; Desloca para pegar o nibble 5
    and esi, 0x0F       ; Isola o nibble 5
    add ecx, esi        ; Soma os nibbles
    add ecx, edx        ; Adiciona carry do nibble anterior
    cmp ecx, 9
    jle .nibble5_ok
    sub ecx, 10
    mov edx, 1          ; Carry para o próximo nibble
    jmp .nibble5_store
.nibble5_ok:
    mov edx, 0          ; Sem carry
.nibble5_store:
    push ecx            ; Salva nibble 5 na pilha

    ; --- Nibble 6 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 24         ; Desloca para pegar o nibble 6
    and ecx, 0x0F       ; Isola o nibble 6
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 24         ; Desloca para pegar o nibble 6
    and esi, 0x0F       ; Isola o nibble 6
    add ecx, esi        ; Soma os nibbles
    add ecx, edx        ; Adiciona carry do nibble anterior
    cmp ecx, 9
    jle .nibble6_ok
    sub ecx, 10
    mov edx, 1          ; Carry para o próximo nibble
    jmp .nibble6_store
.nibble6_ok:
    mov edx, 0          ; Sem carry
.nibble6_store:
    push ecx            ; Salva nibble 6 na pilha

    ; --- Nibble 7 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 28         ; Desloca para pegar o nibble 7
    and ecx, 0x0F       ; Isola o nibble 7
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 28         ; Desloca para pegar o nibble 7
    and esi, 0x0F       ; Isola o nibble 7
    add ecx, esi        ; Soma os nibbles
    add ecx, edx        ; Adiciona carry do nibble anterior
    cmp ecx, 9
    jle .nibble7_ok
    sub ecx, 10
    mov edx, 1          ; Carry para o próximo nibble
    jmp .nibble7_store
.nibble7_ok:
    mov edx, 0          ; Sem carry
.nibble7_store:
    push ecx            ; Salva nibble 7 na pilha

    ; Monta o resultado final (8 nibbles)
    pop ecx             ; nibble 7
    shl ecx, 28
    pop ebx             ; nibble 6
    shl ebx, 24
    pop esi             ; nibble 5
    shl esi, 20
    pop edx             ; nibble 4
    shl edx, 16
    pop ebp             ; nibble 3
    shl ebp, 12
    pop edi             ; nibble 2
    shl edi, 8
    pop eax             ; nibble 1
    shl eax, 4
    pop ebx             ; nibble 0
    or ebx, eax
    or ebx, edi
    or ebx, ebp
    or ebx, edx
    or ebx, esi
    or ebx, ebx
    or ebx, ecx
    mov eax, ebx

    pop edi
    pop esi
    pop ecx
    pop edx
    pop ebx
    pop ebp
    ret

global subtracao
subtracao:
    push ebp
    mov ebp, esp

    push ebx
    push edx
    push ecx
    push esi
    push edi

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

    ; --- Nibble 3 ---
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
    mov edx, 1          ; Borrow para o próximo nibble
    jmp .sub_nibble3_store
.sub_nibble3_ok:
    mov edx, 0          ; Sem borrow
.sub_nibble3_store:
    push ecx            ; Salva nibble 3 na pilha

    ; --- Nibble 4 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 16         ; Desloca para pegar o nibble 4
    and ecx, 0x0F       ; Isola o nibble 4
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 16         ; Desloca para pegar o nibble 4
    and esi, 0x0F       ; Isola o nibble 4
    sub ecx, esi        ; Subtrai os nibbles
    sub ecx, edx        ; Subtrai borrow do nibble anterior
    cmp ecx, 0
    jge .sub_nibble4_ok
    add ecx, 10
    mov edx, 1          ; Borrow para o próximo nibble
    jmp .sub_nibble4_store
.sub_nibble4_ok:
    mov edx, 0          ; Sem borrow
.sub_nibble4_store:
    push ecx            ; Salva nibble 4 na pilha

    ; --- Nibble 5 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 20         ; Desloca para pegar o nibble 5
    and ecx, 0x0F       ; Isola o nibble 5
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 20         ; Desloca para pegar o nibble 5
    and esi, 0x0F       ; Isola o nibble 5
    sub ecx, esi        ; Subtrai os nibbles
    sub ecx, edx        ; Subtrai borrow do nibble anterior
    cmp ecx, 0
    jge .sub_nibble5_ok
    add ecx, 10
    mov edx, 1          ; Borrow para o próximo nibble
    jmp .sub_nibble5_store
.sub_nibble5_ok:
    mov edx, 0          ; Sem borrow
.sub_nibble5_store:
    push ecx            ; Salva nibble 5 na pilha

    ; --- Nibble 6 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 24         ; Desloca para pegar o nibble 6
    and ecx, 0x0F       ; Isola o nibble 6
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 24         ; Desloca para pegar o nibble 6
    and esi, 0x0F       ; Isola o nibble 6
    sub ecx, esi        ; Subtrai os nibbles
    sub ecx, edx        ; Subtrai borrow do nibble anterior
    cmp ecx, 0
    jge .sub_nibble6_ok
    add ecx, 10
    mov edx, 1          ; Borrow para o próximo nibble
    jmp .sub_nibble6_store
.sub_nibble6_ok:
    mov edx, 0          ; Sem borrow
.sub_nibble6_store:
    push ecx            ; Salva nibble 6 na pilha

    ; --- Nibble 7 ---
    mov ecx, eax        ; Copia 'a' para ECX
    shr ecx, 28         ; Desloca para pegar o nibble 7
    and ecx, 0x0F       ; Isola o nibble 7
    mov esi, ebx        ; Copia 'b' para ESI
    shr esi, 28         ; Desloca para pegar o nibble 7
    and esi, 0x0F       ; Isola o nibble 7
    sub ecx, esi        ; Subtrai os nibbles
    sub ecx, edx        ; Subtrai borrow do nibble anterior
    cmp ecx, 0
    jge .sub_nibble7_ok
    add ecx, 10
    mov edx, 1          ; Borrow para o próximo nibble
    jmp .sub_nibble7_store
.sub_nibble7_ok:
    mov edx, 0          ; Sem borrow
.sub_nibble7_store:
    push ecx            ; Salva nibble 7 na pilha

    ; Monta o resultado final (8 nibbles)
    pop ecx             ; nibble 7
    shl ecx, 28
    pop ebx             ; nibble 6
    shl ebx, 24
    pop esi             ; nibble 5
    shl esi, 20
    pop edx             ; nibble 4
    shl edx, 16
    pop ebp             ; nibble 3
    shl ebp, 12
    pop edi             ; nibble 2
    shl edi, 8
    pop eax             ; nibble 1
    shl eax, 4
    pop ebx             ; nibble 0
    or ebx, eax
    or ebx, edi
    or ebx, ebp
    or ebx, edx
    or ebx, esi
    or ebx, ebx
    or ebx, ecx
    mov eax, ebx

    pop edi
    pop esi
    pop ecx
    pop edx
    pop ebx
    pop ebp
    ret
