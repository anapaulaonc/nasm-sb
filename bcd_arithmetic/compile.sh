#!/bin/bash

echo "=== Compilando Calculadora BCD ==="

# Verifica se NASM está instalado
if ! command -v nasm &> /dev/null; then
    echo "❌ NASM não encontrado. Instalando..."
    sudo apt update
    sudo apt install -y nasm
fi

# Verifica se GCC está instalado
if ! command -v gcc &> /dev/null; then
    echo "❌ GCC não encontrado. Instalando..."
    sudo apt update
    sudo apt install -y gcc
fi

echo "✅ Ferramentas verificadas"

# Compila o arquivo assembly
echo "📦 Compilando bcd_arithmetic_nasm.asm..."
nasm -f elf32 bcd_arithmetic_nasm.asm -o bcd_arithmetic_nasm.o

if [ $? -ne 0 ]; then
    echo "❌ Erro ao compilar assembly"
    exit 1
fi

# Compila o arquivo C
echo "📦 Compilando bcd_arithmetic.c..."
gcc -m32 -c bcd_arithmetic.c -o bcd_arithmetic.o

if [ $? -ne 0 ]; then
    echo "❌ Erro ao compilar C"
    exit 1
fi

# Linka os arquivos
echo "🔗 Linkando..."
gcc -m32 bcd_arithmetic.o bcd_arithmetic_nasm.o -o bcd_arithmetic

if [ $? -ne 0 ]; then
    echo "❌ Erro ao linkar"
    exit 1
fi

echo "✅ Compilação concluída!"
echo "🚀 Para executar: ./bcd_arithmetic" 