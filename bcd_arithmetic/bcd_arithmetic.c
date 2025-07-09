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

int main()
{


    int operation;
    u4 a;
    u4 b;
    u4 result;
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
            a = convert_u4_to_bcd(a);
            printf("0x%x", a);
            printf("\nsegundo operando: ");
            scanf("%u", &b);
            b = convert_u4_to_bcd(b);
            printf("0x%x", b);
            result = soma(a, b);
            break;
        case 2:
            printf("\nSubtracao escolhida!\n");
            printf("primeiro operando: ");
            scanf("%u", &a);
            a = convert_u4_to_bcd(a);
            printf("\nsegundo operando: ");
            scanf("%u", &b);
            b = convert_u4_to_bcd(b);
            result = subtracao(a, b);
            break;
        default:
            break;
    }
    printf("\nResultado: %x\n", result);
    return 0;
}
