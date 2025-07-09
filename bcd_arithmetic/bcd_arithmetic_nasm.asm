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

    push ebx 
    push edx 
    push ecx 
    push esi 
    push edi 

    mov eax, [ebp + 8]  ; EAX = primeiro operando (a) - valor BCD
    mov ebx, [ebp + 12] ; EBX = segundo operando (b) - valor BCD
    
    ; Processa cada byte BCD separadamente (2 dígitos por vez)
    ; Byte 0 (dígitos 0-1)
    mov al, al          ; Primeiro byte de 'a' (já está em AL)
    add al, bl          ; Adiciona primeiro byte de 'b'
    daa                 ; Ajusta para BCD
    mov [esp-4], al     ; Salva resultado temporariamente
    
    ; Byte 1 (dígitos 2-3)
    mov al, ah          ; Segundo byte de 'a'
    adc al, bh          ; Adiciona segundo byte de 'b' com carry
    daa                 ; Ajusta para BCD
    mov [esp-8], al     ; Salva resultado temporariamente
    
    ; Byte 2 (dígitos 4-5)
    shr eax, 16         ; Move bytes 2-3 para posição baixa
    shr ebx, 16         ; Move bytes 2-3 de 'b' para posição baixa
    mov al, al          ; Terceiro byte de 'a'
    adc al, bl          ; Adiciona terceiro byte de 'b' com carry
    daa                 ; Ajusta para BCD
    mov [esp-12], al    ; Salva resultado temporariamente
    
    ; Byte 3 (dígitos 6-7)
    mov al, ah          ; Quarto byte de 'a'
    adc al, bh          ; Adiciona quarto byte de 'b' com carry
    daa                 ; Ajusta para BCD
    mov [esp-16], al    ; Salva resultado temporariamente
    
    ; Monta o resultado final
    mov al, [esp-4]     ; Byte 0
    mov ah, [esp-8]     ; Byte 1
    mov ebx, eax        ; Salva bytes 0-1
    mov al, [esp-12]    ; Byte 2
    mov ah, [esp-16]    ; Byte 3
    shl eax, 16         ; Move bytes 2-3 para posição alta
    or eax, ebx         ; Combina com bytes 0-1

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

    ; Processa cada byte BCD separadamente (2 dígitos por vez)
    ; Byte 0 (dígitos 0-1)
    mov al, al          ; Primeiro byte de 'a' (já está em AL)
    sub al, bl          ; Subtrai primeiro byte de 'b'
    das                 ; Ajusta para BCD
    mov [esp-4], al     ; Salva resultado temporariamente
    
    ; Byte 1 (dígitos 2-3)
    mov al, ah          ; Segundo byte de 'a'
    sbb al, bh          ; Subtrai segundo byte de 'b' com borrow
    das                 ; Ajusta para BCD
    mov [esp-8], al     ; Salva resultado temporariamente
    
    ; Byte 2 (dígitos 4-5)
    shr eax, 16         ; Move bytes 2-3 para posição baixa
    shr ebx, 16         ; Move bytes 2-3 de 'b' para posição baixa
    mov al, al          ; Terceiro byte de 'a'
    sbb al, bl          ; Subtrai terceiro byte de 'b' com borrow
    das                 ; Ajusta para BCD
    mov [esp-12], al    ; Salva resultado temporariamente
    
    ; Byte 3 (dígitos 6-7)
    mov al, ah          ; Quarto byte de 'a'
    sbb al, bh          ; Subtrai quarto byte de 'b' com borrow
    das                 ; Ajusta para BCD
    mov [esp-16], al    ; Salva resultado temporariamente
    
    ; Monta o resultado final
    mov al, [esp-4]     ; Byte 0
    mov ah, [esp-8]     ; Byte 1
    mov ebx, eax        ; Salva bytes 0-1
    mov al, [esp-12]    ; Byte 2
    mov ah, [esp-16]    ; Byte 3
    shl eax, 16         ; Move bytes 2-3 para posição alta
    or eax, ebx         ; Combina com bytes 0-1

    pop edi
    pop esi
    pop ecx
    pop edx
    pop ebx
    pop ebp
    ret
