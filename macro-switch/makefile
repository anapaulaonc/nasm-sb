# Makefile para Switch NASM - Linux

ASM = nasm
CC = gcc
TARGET = switch_example
ASM_SRC = switch_example.asm
ASM_OBJ = switch_example.o

# Flags para Linux 32-bit
ASMFLAGS = -f elf32
CCFLAGS = -m32 -no-pie

# Cores para output
GREEN = \033[32m
BLUE = \033[34m
YELLOW = \033[33m
NC = \033[0m

all: info $(TARGET)

info:
	@echo "$(BLUE)================================$(NC)"
	@echo "$(GREEN)   Switch NASM para Linux$(NC)"
	@echo "$(BLUE)================================$(NC)"
	@echo "Sistema: Linux i386 (32-bit)"
	@echo "ASM: $(ASM) $(ASMFLAGS)"
	@echo "CC: $(CC) $(CCFLAGS)"
	@echo "$(BLUE)================================$(NC)"

$(TARGET): $(ASM_OBJ)
	@echo "$(YELLOW)Linkando...$(NC)"
	$(CC) $(CCFLAGS) $(ASM_OBJ) -o $(TARGET)
	@echo "$(GREEN)✓ Compilado: $(TARGET)$(NC)"

$(ASM_OBJ): $(ASM_SRC)
	@echo "$(YELLOW)Compilando Assembly...$(NC)"
	$(ASM) $(ASMFLAGS) $(ASM_SRC) -o $(ASM_OBJ)

run: $(TARGET)
	@echo "$(BLUE)Executando $(TARGET):$(NC)"
	@echo "$(BLUE)====================$(NC)"
	./$(TARGET)

clean:
	@echo "$(YELLOW)Limpando arquivos...$(NC)"
	rm -f *.o $(TARGET) *.lst
	@echo "$(GREEN)✓ Limpeza concluída$(NC)"

debug: $(ASM_SRC)
	@echo "$(YELLOW)Gerando debug...$(NC)"
	$(ASM) $(ASMFLAGS) -l switch_example.lst $(ASM_SRC) -o $(ASM_OBJ)
	@echo "$(GREEN)✓ Debug: switch_example.lst$(NC)"

show-macros: debug
	@echo "$(BLUE)Macros expandidas:$(NC)"
	@echo "=================="
	@grep -n -A 2 -B 1 "CHECK_CASE\|PRINT_MSG\|READ_INT" switch_example.lst | head -20

test-tools:
	@echo "$(YELLOW)Verificando ferramentas...$(NC)"
	@command -v $(ASM) >/dev/null 2>&1 && echo "✓ NASM: $$(nasm --version | head -1)" || echo "✗ NASM não encontrado"
	@command -v $(CC) >/dev/null 2>&1 && echo "✓ GCC: $$(gcc --version | head -1)" || echo "✗ GCC não encontrado"

install-deps:
	@echo "$(YELLOW)Instalando dependências...$(NC)"
	@if command -v apt >/dev/null 2>&1; then \
		sudo apt update && sudo apt install -y nasm gcc; \
	elif command -v yum >/dev/null 2>&1; then \
		sudo yum install -y nasm gcc; \
	elif command -v dnf >/dev/null 2>&1; then \
		sudo dnf install -y nasm gcc; \
	elif command -v pacman >/dev/null 2>&1; then \
		sudo pacman -S nasm gcc; \
	else \
		echo "$(YELLOW)Distribuição não reconhecida. Instale manualmente: nasm gcc$(NC)"; \
	fi

test: clean all
	@echo "$(YELLOW)Teste automático:$(NC)"
	@echo "1" | ./$(TARGET) | grep -q "Caso 1" && echo "$(GREEN)✓ Teste passou!$(NC)" || echo "$(YELLOW)⚠ Teste não passou$(NC)"

manual:
	@echo "$(YELLOW)Compilação manual:$(NC)"
	nasm -f elf64 $(ASM_SRC) -o $(ASM_OBJ)
	gcc -m64 -no-pie $(ASM_OBJ) -o $(TARGET)
	@echo "$(GREEN)✓ Compilado manualmente!$(NC)"

help:
	@echo "$(BLUE)Comandos disponíveis:$(NC)"
	@echo "  make              - Compila o programa"
	@echo "  make run          - Executa o programa"
	@echo "  make clean        - Remove arquivos gerados"
	@echo "  make debug        - Gera arquivo de debug"
	@echo "  make show-macros  - Mostra macros expandidas"
	@echo "  make test-tools   - Verifica ferramentas"
	@echo "  make install-deps - Instala dependências"
	@echo "  make test         - Teste automático"
	@echo "  make manual       - Compilação manual"

.PHONY: all run clean debug info help test-tools install-deps test manual show-macros
