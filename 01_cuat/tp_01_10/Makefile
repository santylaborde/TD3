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
ELFS = $(BINPATH)init16.elf $(BINPATH)init32.elf $(BINPATH)reset.elf $(BINPATH)sys_tables.elf $(BINPATH)main.elf $(BINPATH)functions_ram.elf $(BINPATH)functions_rom.elf $(BINPATH)init_pic.elf $(BINPATH)isr_handler.elf $(BINPATH)init_pit.elf $(BINPATH)init_screen.elf $(BINPATH)tasks.elf $(BINPATH)isr_handler_C.elf $(BINPATH)paging.elf  
#LIST = $(SUPPATH)$(SRC_NAME).lst 
MAP = $(SRC_NAME).map 
BOCHS = $(SUPPATH)bochsrc.txt 
LDSCRIPT = linker.ld

# Flags
AFLAGS = -f elf32 #-Wall
LDFLAGS = -z max-page-size=0x01000 --oformat=binary -m elf_i386 -Map $(MAP)
CFLAGS = -c -m32 -fno-stack-protector -fno-asynchronous-unwind-tables -fno-PIC #-Wall
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
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)sys_tables.elf: $(SRCPATH)sys_tables.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)reset.elf: $(SRCPATH)reset.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)init16.elf: $(SRCPATH)init16.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)init32.elf: $(SRCPATH)init32.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)init_pic.elf: $(SRCPATH)init_pic.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)isr_handler.elf: $(SRCPATH)isr_handler.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)init_pit.elf: $(SRCPATH)init_pit.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)init_screen.elf: $(SRCPATH)init_screen.asm
	mkdir -p bin
	$(AC) $(AFLAGS) $< -o $@ -l $(@:.elf=.lst)

$(BINPATH)functions_ram.elf: $(SRCPATH)functions_ram.c
	mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

$(BINPATH)functions_rom.elf: $(SRCPATH)functions_rom.c
	mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

$(BINPATH)tasks.elf: $(SRCPATH)tasks.c
	mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

$(BINPATH)isr_handler_C.elf: $(SRCPATH)isr_handler_C.c
	mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

$(BINPATH)paging.elf: $(SRCPATH)paging.c
	mkdir -p bin
	$(CC) $(CFLAGS) $< -o $@

bochs: clean all
	bochs -q -f $(BOCHS)

clean:
	rm -fr $(BINPATH) *.map *.ini $(DOCPATH)
