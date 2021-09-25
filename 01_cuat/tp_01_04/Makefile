# Compilers
AC = nasm
CC = gcc

# Paths
BINPATH = ./bin/
DOCPATH = ./doc/
INCPATH = ./inc/
LIBPATH = ./lib/
SRCPATH = ./src/
SUPPATH = ./sup/

# Files
SRC_NAME = mibios
OUTPUT = $(BINPATH)$(SRC_NAME).bin
ELFS = $(BINPATH)init16.elf $(BINPATH)init32.elf $(BINPATH)reset.elf $(BINPATH)sys_tables.elf $(BINPATH)main.elf $(BINPATH)funciones.elf $(BINPATH)funciones_rom.elf
#LIST = $(SUPPATH)$(SRC_NAME).lst 
MAP = $(SRC_NAME).map 
BOCHS = $(SUPPATH)bochsrc.txt 
LDSCRIPT = linker.ld

# Flags
AFLAGS = -f elf32 -Wall
LDFLAGS = -z max-page-size=0x01000 --oformat=binary -m elf_i386 -Map $(MAP)
CFLAGS = -c -m32 -fno-stack-protector -fno-asynchronous-unwind-tables -Wall -fno-PIC
ODFLAGS = -CprsSx --prefix-addresses

# Instrucciones
all: $(OUTPUT) $(BINPATH)$(SRC_NAME).elf
	mkdir -p doc
	hexdump -C $(BINPATH)$(SRC_NAME).bin > $(DOCPATH)$(SRC_NAME)_hexdump.txt
	objdump $(ODFLAGS) $(BINPATH)$(SRC_NAME).elf > $(DOCPATH)$(SRC_NAME)_objdump.txt
	readelf -a $(BINPATH)$(SRC_NAME).elf > $(DOCPATH)$(SRC_NAME)_readelf.txt

$(OUTPUT): $(ELFS)
	ld $(LDFLAGS) -T $(LDSCRIPT) $(ELFS) -o $@ 

$(BINPATH)$(SRC_NAME).elf: $(ELFS)
	ld -z max-page-size=0x01000 -m elf_i386 -T $(LDSCRIPT) $(ELFS) -o $@

$(BINPATH)main.elf: $(SRCPATH)main.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)sys_tables.elf: $(SRCPATH)sys_tables.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)reset.elf: $(SRCPATH)reset.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)init16.elf: $(SRCPATH)init16.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)init32.elf: $(SRCPATH)init32.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $@.lst

$(BINPATH)funciones.elf: $(SRCPATH)funciones.c
	mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

$(BINPATH)funciones_rom.elf: $(SRCPATH)funciones_rom.c
	mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

bochs:
	bochs -q -f $(BOCHS)

clean:
	rm -r $(BINPATH) *.map -r $(DOCPATH) *.ini