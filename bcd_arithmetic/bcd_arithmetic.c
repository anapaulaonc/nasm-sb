#include <stdio.h>
#include <stdint.h>

typedef uint32_t u4;
typedef uint64_t u8;

extern u4 soma(u4 a, u4 b);
extern u4 subtracao(u4 a, u4 b);

u4 convert_u4_to_bcd (u4 num)
{
    unsigned int bcd = 0, pos = 0;

    //extrair o caracter desejado utilizando operacao modular
    while (num > 0)
    {
        int digit = num % 10;
        bcd |= (digit << (pos * 4));
        num /= 10;
        pos++;
    }

    return bcd;
}

u4 convert_bcd_to_u4(u4 bcd)
{
    u4 result = 0;
    u4 multiplier = 1;
    
    // Extrai cada dígito BCD (4 bits cada)
    for (int i = 0; i < 8; i++) {
        u4 digit = (bcd >> (i * 4)) & 0xF;
        result += digit * multiplier;
        multiplier *= 10;
    }
    
    return result;
}

int main()
{
    int operation;
    u4 a;
    u4 b;
    u4 result;
    u4 result_decimal;
    
    printf("=== Calculadora BCD em NASM ===\n");
    printf("Escolha uma operacao: \n");
    printf("1 - soma \n");
    printf("2 - subtracao \n");
    printf("Escolhido:  ");
    scanf("%d", &operation);

    switch(operation)
    {
        case 1:
            printf("\nSoma escolhida! Escolha os operandos: \n");
            printf("primeiro operando: ");
            scanf("%u", &a);
            u4 a_bcd = convert_u4_to_bcd(a);
            printf("Decimal: %u -> BCD: 0x%08x\n", a, a_bcd);
            
            printf("segundo operando: ");
            scanf("%u", &b);
            u4 b_bcd = convert_u4_to_bcd(b);
            printf("Decimal: %u -> BCD: 0x%08x\n", b, b_bcd);
            
            result = soma(a_bcd, b_bcd);
            result_decimal = convert_bcd_to_u4(result);
            break;
            
        case 2:
            printf("\nSubtracao escolhida!\n");
            printf("primeiro operando: ");
            scanf("%u", &a);
            a_bcd = convert_u4_to_bcd(a);
            printf("Decimal: %u -> BCD: 0x%08x\n", a, a_bcd);
            
            printf("segundo operando: ");
            scanf("%u", &b);
            b_bcd = convert_u4_to_bcd(b);
            printf("Decimal: %u -> BCD: 0x%08x\n", b, b_bcd);
            
            result = subtracao(a_bcd, b_bcd);
            result_decimal = convert_bcd_to_u4(result);
            break;
            
        default:
            printf("Operacao invalida!\n");
            return 1;
    }
    
    printf("\n=== Resultado ===\n");
    printf("BCD: 0x%08x\n", result);
    printf("Decimal: %u\n", result_decimal);
    
    return 0;
}
