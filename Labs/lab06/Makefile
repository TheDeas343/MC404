
lab06a.o: lab06a.s
	clang-12 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab06a.s -c -o lab06a.o
lab06a.x: lab06a.o
	ld.lld-12 lab06a.o -o lab06a.x