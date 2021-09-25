all:
	mkdir -p bin
	mkdir -p obj
	gcc ./src/hello_world.c -o ./bin/hello_world

exec:
	./bin/hello_world

elf:
	objdump -s ./bin/hello_world

clean:
	rm -R ./bin
	rm -R ./obj
	