
ASM = nasm
TARGET = bcd_arithmetic
SRC = bcd_arithmetic.asm
OBJ = bcd_arithmetic.o

# Detecta sistema operacional e arquitetura
OS := $(shell uname -s)
ARCH := $(shell uname -m)

ifeq ($(OS),Darwin)
    CC = clang
    ASMFLAGS = -f macho64
    CCFLAGS = -arch x86_64
    PLATFORM_MSG = macOS
    ifeq ($(ARCH),arm64)
        ARCH_MSG = Apple Silicon (via Rosetta)
    else
        ARCH_MSG = Intel nativo
    endif
else ifeq ($(OS),Linux)
    # Linux
    CC = gcc
    ASMFLAGS = -f elf64
    CCFLAGS = -m64 -no-pie -static
    PLATFORM_MSG = Linux
    ARCH_MSG = $(ARCH)
else
    CC = gcc
    ASMFLAGS = -f elf64
    CCFLAGS = -m64
    PLATFORM_MSG = Outro/Windows
    ARCH_MSG = $(ARCH)
endif

# Mensagens coloridas (se suportado)
GREEN = \033[32m
BLUE = \033[34m
YELLOW = \033[33m
RED = \033[31m
NC = \033[0m

# Regra padrão
all: info $(TARGET)

# Mostra informações da plataforma
info:
	@echo "$(BLUE)========================================$(NC)"
	@echo "$(GREEN)  NASM Switch - Compilação Universal$(NC)"
	@echo "$(BLUE)========================================$(NC)"
	@echo "Sistema: $(PLATFORM_MSG)"
	@echo "Arquitetura: $(ARCH_MSG)"
	@echo "Assembler: $(ASM) $(ASMFLAGS)"
	@echo "Compiler: $(CC) $(CCFLAGS)"
	@echo "$(BLUE)========================================$(NC)"

# Compila o programa
$(TARGET): $(OBJ)
	@echo "$(YELLOW)Linkando para $(PLATFORM_MSG)...$(NC)"
	$(CC) $(CCFLAGS) $(OBJ) -o $(TARGET)
	@echo "$(GREEN)✓ Programa compilado: $(TARGET)$(NC)"

# Compila o arquivo assembly
$(OBJ): $(SRC)
	@echo "$(YELLOW)Compilando $(SRC)...$(NC)"
	$(ASM) $(ASMFLAGS) $(SRC) -o $(OBJ)

# Executa o programa
run: $(TARGET)
	@echo "$(BLUE)Executando $(TARGET)...$(NC)"
	@echo "$(BLUE)========================================$(NC)"
	./$(TARGET)
	@echo "$(BLUE)========================================$(NC)"

# Limpa arquivos gerados
clean:
	@echo "$(YELLOW)Limpando arquivos...$(NC)"
	rm -f *.o $(TARGET) *.lst
	@echo "$(GREEN)✓ Limpeza concluída$(NC)"

# Debug - gera arquivo de listagem
debug: $(SRC)
	@echo "$(YELLOW)Gerando arquivo de debug...$(NC)"
	$(ASM) $(ASMFLAGS) -l bcd_arithmetic.lst $(SRC) -o $(OBJ)
	@echo "$(GREEN)✓ Debug gerado: bcd_arithmetic.lst$(NC)"

# Testa se as ferramentas estão instaladas
test-tools:
	@echo "$(BLUE)Testando ferramentas para $(PLATFORM_MSG)...$(NC)"
	@echo ""
	@echo "NASM:"
	@command -v $(ASM) >/dev/null 2>&1 && $(ASM) --version | head -1 || echo "$(RED)❌ NASM não encontrado$(NC)"
	@echo ""
	@echo "Compiler:"
	@command -v $(CC) >/dev/null 2>&1 && $(CC) --version | head -1 || echo "$(RED)❌ $(CC) não encontrado$(NC)"
	@echo ""

# Instala dependências baseado no sistema
install-deps:
	@echo "$(YELLOW)Instalando dependências para $(PLATFORM_MSG)...$(NC)"
ifeq ($(OS),Darwin)
	@echo "Instalando via Homebrew..."
	@command -v brew >/dev/null 2>&1 || { echo "$(RED)Homebrew não encontrado. Instale primeiro!$(NC)"; exit 1; }
	brew install nasm
	@echo "$(GREEN)✓ NASM instalado. Clang já vem com Xcode.$(NC)"
else ifeq ($(OS),Linux)
	@echo "Detectando distribuição Linux..."
	@if command -v apt >/dev/null 2>&1; then \
		echo "Ubuntu/Debian detectado"; \
		sudo apt update && sudo apt install -y nasm gcc; \
	elif command -v yum >/dev/null 2>&1; then \
		echo "RedHat/CentOS detectado"; \
		sudo yum install -y nasm gcc; \
	elif command -v dnf >/dev/null 2>&1; then \
		echo "Fedora detectado"; \
		sudo dnf install -y nasm gcc; \
	elif command -v pacman >/dev/null 2>&1; then \
		echo "Arch Linux detectado"; \
		sudo pacman -S nasm gcc; \
	else \
		echo "$(RED)Distribuição não reconhecida. Instale manualmente: nasm e gcc$(NC)"; \
	fi
	@echo "$(GREEN)✓ Dependências instaladas$(NC)"
else
	@echo "$(RED)Sistema não suportado para instalação automática$(NC)"
	@echo "Instale manualmente: NASM e GCC/Clang"
endif


portable: clean
	@echo "$(YELLOW)Criando versão portátil...$(NC)"
	@mkdir -p nasm-switch-portable
	@cp $(SRC) Makefile nasm-switch-portable/
	@echo "$(GREEN)✓ Versão portátil criada em: nasm-switch-portable/$(NC)"
	@echo "Para usar: cd nasm-switch-portable && make"

# Compila para múltiplas arquiteturas (apenas macOS)
universal: clean
ifeq ($(OS),Darwin)
	@echo "$(YELLOW)Compilando versão universal para macOS...$(NC)"
	# x86_64
	$(ASM) -f macho64 $(SRC) -o $(TARGET)_x86.o
	$(CC) -arch x86_64 $(TARGET)_x86.o -o $(TARGET)_x86
	# Verifica se consegue compilar ARM64 nativo
	@if $(ASM) -f macho64 --target=aarch64-apple-macos $(SRC) -o $(TARGET)_arm.o 2>/dev/null; then \
		$(CC) -arch arm64 $(TARGET)_arm.o -o $(TARGET)_arm; \
		lipo -create $(TARGET)_x86 $(TARGET)_arm -output $(TARGET)_universal; \
		echo "$(GREEN)✓ Binário universal criado: $(TARGET)_universal$(NC)"; \
		rm $(TARGET)_x86 $(TARGET)_arm *.o; \
	else \
		echo "$(YELLOW)ARM64 nativo não suportado, usando apenas x86_64$(NC)"; \
		mv $(TARGET)_x86 $(TARGET)_universal; \
		rm *.o; \
	fi
	@file $(TARGET)_universal
else
	@echo "$(RED)Binário universal só disponível no macOS$(NC)"
endif

# Estatísticas do código
stats:
	@echo "$(BLUE)Estatísticas do código:$(NC)"
	@echo "Linhas totais: $$(wc -l < $(SRC))"
	@echo "Linhas de código: $$(grep -v '^[[:space:]]*;' $(SRC) | grep -v '^[[:space:]]*$$' | wc -l)"
	@echo "Comentários: $$(grep '^[[:space:]]*;' $(SRC) | wc -l)"
	@echo "Tamanho: $$(du -h $(SRC) | cut -f1)"

# Ajuda com exemplos
help:
	@echo "$(BLUE)========================================$(NC)"
	@echo "$(GREEN)     Comandos Disponíveis$(NC)"
	@echo "$(BLUE)========================================$(NC)"
	@echo ""
	@echo "$(YELLOW)Básicos:$(NC)"
	@echo "  make              - Compila o programa"
	@echo "  make run          - Compila e executa"
	@echo "  make clean        - Remove arquivos gerados"
	@echo ""
	@echo "$(YELLOW)Desenvolvimento:$(NC)"
	@echo "  make debug        - Gera arquivo de listagem"
	@echo "  make test-tools   - Verifica ferramentas"
	@echo "  make stats        - Estatísticas do código"
	@echo ""
	@echo "$(YELLOW)Instalação:$(NC)"
	@echo "  make install-deps - Instala dependências"
	@echo "  make portable     - Cria versão portátil"
	@echo ""
	@echo "$(YELLOW)macOS específicos:$(NC)"
	@echo "  make universal    - Compila para Intel+ARM"
	@echo ""
	@echo "$(YELLOW)Exemplos de uso:$(NC)"
	@echo "  # Compilar e executar"
	@echo "  make && make run"
	@echo ""
	@echo "  # Compartilhar com amigos"
	@echo "  make portable"
	@echo "  # Envie a pasta nasm-switch-portable/"
	@echo ""
	@echo "  # Debug de problemas"
	@echo "  make debug"
	@echo "  cat bcd_arithmetic.lst"

# Força recompilação
rebuild: clean all


quick-test: clean
	@echo "$(YELLOW)Teste rápido...$(NC)"
	@$(MAKE) --no-print-directory all
	@echo "1" | ./$(TARGET) > /dev/null 2>&1 && echo "$(GREEN)✓ Teste passou!$(NC)" || echo "$(RED)✗ Teste falhou!$(NC)"

.PHONY: all run clean debug info help test-tools install-deps portable universal stats rebuild quick-test
