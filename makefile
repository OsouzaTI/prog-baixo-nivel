P	= .
F 	= main
EXT = asm

build:
	nasm -felf64 $(P)/$(F).$(EXT) -o $(P)/$(F).o
	ld -o $(P)/$(F) $(P)/$(F).o
	chmod u+x $(P)/$(F)

exited:
	@echo 'command exited with $(.SHELLSTATUS)'

run:
	./$(P)/$(F)