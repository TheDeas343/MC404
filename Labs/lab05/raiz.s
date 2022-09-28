.set num_it, 10

.data
    count: .word 1
.bss
    input: .skip 20         # buffer
    num .skip 4

.text

write:
    li a0, 1                # file descriptor = 1 (stdout)
    la a1, input            # buffer
    li a2, 20               # size
    li a7, 64               # syscall write (64)
    ecall
    ret

read:
    li a0, 0                # file descriptor = 0 (stdin)
    la a1, input            #  buffer
    li a2, 20               # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63               # syscall read (63)
    ecall
    ret

Str_Int:
    li a7, 10
    li a3, 0
    la a0, input
    la a2, count           

    lb a1, count(a0)        # Pegando o primeiro byte da string
    addi a1, a1, -'0'       # Transferindo para numero
    addi a2, a2, 1
    addi a3, a3, a1
   

    lb a1, count(a0)        # Pegando o primeiro byte da string
    addi a1, a1, -'0'       # Transferindo para numero
    addi a2, a2, 1
    mul a1, a1, a7
    addi a3, a3, a1
    
    lb a1, count(a0)        # Pegando o primeiro byte da string
    addi a1, a1, -'0'       # Transferindo para numero
    addi a2, a2, 1
    mul a1, a1, a7
    mul a1, a1, a7
    addi a3, a3, a1
    
    lb a1, count(a0)        # Pegando o primeiro byte da string
    addi a1, a1, -'0'       # Transferindo para numero
    addi a2, a2, 1
    mul a1, a1, a7
    mul a1, a1, a7
    mul a1, a1, a7
    addi a3, a3, a1

    la a5, num
    sw a2, 0(a5)
    ret

Int_Str:
    
    

.globl _start
_start:
    jal ra, read

    jal ra, Str_Int


    jal ra, write
    
    