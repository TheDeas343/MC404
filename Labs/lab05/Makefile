
raiz.o: raiz.s
	clang-12 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax raiz.s -c -o raiz.o
raiz.x: raiz.o
	ld.lld-12 raiz.o -o raiz.x