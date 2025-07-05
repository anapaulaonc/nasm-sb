ASM = nasm
CC = clang
TARGET = switch_example
SRC = switch_example.asm
OBJ = switch_example.o

# Flags para x86_64 M1/M2 Mac
ASMFLAGS = -f macho64
CCFLAGS = -arch x86_64


all: $(TARGET)

# Compila o programa
$(TARGET): $(OBJ)
	@echo "Linkando..."
	$(CC) $(CCFLAGS) $(OBJ) -o $(TARGET)
	@echo "Programa compilado: $(TARGET)"

# Compila o arquivo assembly
$(OBJ): $(SRC)
	@echo "Compilando $(SRC)..."
	$(ASM) $(ASMFLAGS) $(SRC) -o $(OBJ)

# Executa o programa
run: $(TARGET)
	@echo "Executando..."
	./$(TARGET)

# Limpa arquivos
clean:
	rm -f *.o $(TARGET) *.lst

# Debug - gera arquivo de listagem
debug: $(SRC)
	$(ASM) $(ASMFLAGS) -l switch_example.lst $(SRC) -o $(OBJ)
	@echo "Arquivo de debug gerado: switch_example.lst"

# Mostra informações
info:
	@echo "Arquivo fonte: $(SRC)"
	@echo "Executavel: $(TARGET)"
	@echo "Arquitetura do Mac: $(shell uname -m)"
	@echo "Compilando para: x86_64 (via Rosetta se necessario)"

# Testa ferramentas
test:
	@echo "Testando NASM..."
	@$(ASM) --version | head -1
	@echo "Testando Clang..."
	@$(CC) --version | head -1
	@echo "Teste OK!"

# Compilação manual (em caso de emergência)
manual:
	@echo "Compilacao manual..."
	$(ASM) -f macho64 $(SRC) -o $(OBJ)
	$(CC) -arch x86_64 $(OBJ) -o $(TARGET)
	@echo "Feito! Execute: ./$(TARGET)"

.PHONY: all run clean debug info test manual