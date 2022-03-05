#  
#  COMMIT (Compiler & Micro-architecture)
#

    HOME=/cygdrive/c/2021_CA_RISCV_project/Project1/sw/riscv32_cross_compiler
    RV=$(HOME)/bin
    AS=$(RV)/riscv32-unknown-elf-as
    LD=$(RV)/riscv32-unknown-elf-ld
	CC=$(RV)/riscv32-unknown-elf-gcc
	CPP=$(RV)/riscv32-unknown-elf-cpp        
    OBJDUMP=$(RV)/riscv32-unknown-elf-objdump
    OBJCOPY=$(RV)/riscv32-unknown-elf-objcopy
    ASFLAGS= -g -march=rv32im
    LDFLAGS= -N -X -T sections.lds
    CCFLAGS= -c -g -march=rv32im


    all:  main_code

    #############################
    ####  Problem 1
    #############################

    main_code: problem1.o init.o
	$(LD) $(LDFLAGS) init.o problem1.o -o out 
	$(OBJDUMP) -D  out > out.dump
	$(OBJCOPY) -O  binary out out.bin
	./bin2hex_out.perl > problem1_inst.hex

    problem1.o:	problem1.c 
	$(CC) $(CCFLAGS) problem1.c -o problem1.o

    init.o: init.S
	$(AS) $(ASFLAGS) init.S -o init.o

    clean:
	rm -rf *.o *.dump *.hex *.bin out
