# ******************************************************************** #
# **************************    MAKEFILE     ************************* #
# ******************************************************************** #

# Defines ************************************************************ #
out=bin/mibios.bin
NASM=nasm
NFLAGS=-fbin -l$(LIST) -Wall
OBJS=
BIN=mibios.bin
SOURCES=src/mboot.asm
LIST=sup/mboot.lst

# Rules ************************************************************* #

$(out): all $(SOURCES) Makefile
	$(NASM) $(NFLAGS) $(SOURCES) -o$@ 
	@echo "Make done!"

all:
	@mkdir -p bin

bochs:
	bochs -f ./sup/bochsrc.txt -q

clean:
	rm -r bin sup/*.lst *.ini
	@echo "Clean done!"
