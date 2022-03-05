#  
#  COMMIT (Compiler & Micro-architecture)
#

    HOME=/home/최유호/work/riscv32_cross_compiler
    RV=$(HOME)/bin
    AS=$(RV)/riscv32-unknown-elf-as
    LD=$(RV)/riscv32-unknown-elf-ld
	CC=$(RV)/riscv32-unknown-elf-gcc
	CPP=$(RV)/riscv32-unknown-elf-cpp        
    OBJDUMP=$(RV)/riscv32-unknown-elf-objdump
    OBJCOPY=$(RV)/riscv32-unknown-elf-objcopy
    ASFLAGS= -g -march=rv32i
    LDFLAGS= -N -X -T sections.lds
    CCFLAGS= -c -g -march=rv32i


    all: cache_eviction main_code

    #############################
    ####  Problem 1
    #############################

    cache_eviction: riscv_cache_test.o
	$(LD) $(LDFLAGS) riscv_cache_test.o  -o riscv_cache_test 
	$(OBJDUMP) -D  riscv_cache_test > riscv_cache_test.dump
	$(OBJCOPY) -O  binary riscv_cache_test riscv_cache_test.bin
	./bin2hex_cache.perl > riscv_cache_test.hex    

    riscv_cache_test.o: riscv_cache_test.S
	$(AS) $(ASFLAGS) riscv_cache_test.S -o riscv_cache_test.o    

    #############################
    ####  Problem 2
    #############################

    main_code: loop_test.o init.o
	$(LD) $(LDFLAGS) init.o loop_test.o -o out 
	$(OBJDUMP) -D  out > out.dump
	$(OBJCOPY) -O  binary out out.bin
	./bin2hex_out.perl > out.hex

    loop_test.o:	loop_test.c 
	$(CC) $(CCFLAGS) loop_test.c -o loop_test.o

    init.o: init.S
	$(AS) $(ASFLAGS) init.S -o init.o

    clean:
	rm -rf *.o *.dump *.hex *.bin out
