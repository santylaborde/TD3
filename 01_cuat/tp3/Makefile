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
ELFS = $(BINPATH)reset.elf $(BINPATH)init16.elf $(BINPATH)memcopy.elf
#LIST = $(SUPPATH)$(SRC_NAME).lst 
MAP = $(SRC_NAME).map 
BOCHS = $(SUPPATH)bochsrc.txt 
LDSCRIPT = linker.ld

# Flags
AFLAGS = -f elf32 -Wall
LDFLAGS = -z max-page-size=0x01000 --oformat=binary -m elf_i386 -Map $(MAP)
ODFLAGS = -h -t

# Instrucciones
$(OUTPUT): $(ELFS) Makefile
	ld $(LDFLAGS) -T $(LDSCRIPT) $(ELFS) -o$(OUTPUT)

$(BINPATH)reset.elf: $(SRCPATH)reset.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)init16.elf: $(SRCPATH)init16.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)memcopy.elf: $(SRCPATH)memcopy.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

bochs:
	bochs -q -f $(BOCHS)

clean:
	rm -r $(BINPATH) $(MAP) *.ini
