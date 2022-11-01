
lib.o: lib.s
	clang-12 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lib.s -c -o lib.o
lib.x: lib.o
	ld.lld-12 lib.o -o lib.x

clean:
	rm *.o
	rm *.x