#gcc file1.c file2.c -o file3.exe

# Compilers
CC = gcc

# Flags
CFLAGS 	= -Wall

# Paths
EXEPATH = ./exe/
BINPATH = ./bin/
DOCPATH = ./doc/
INCPATH = ./inc/
LIBPATH = ./lib/
SRCPATH = ./src/
SUPPATH = ./sup/

# Files
SRCFILE = $(wildcard)$(SRCPATH)*.c	# all the ".c" in src directory
EXEFILE = server.exe
OUTPUT 	= $(EXEPATH)$(EXEFILE)

# Instructions:
# Compile
all: 
	@echo "\n*****************************"
	@echo "********* Compiling *********"
	@echo "-----------------------------"
	mkdir -p exe
	$(CC) $(SRCFILE) -o $(OUTPUT) $(CFLAGS)

# Clean
clean:
	@echo "*****************************"
	@echo "********* Cleaning **********"
	@echo "-----------------------------"
	rm -fr $(EXEPATH)

# Run
run: clean all 
	@echo "\n*****************************"
	@echo "********** Running **********"
	@echo "-----------------------------"
	@$(EXEPATH)/$(EXEFILE)