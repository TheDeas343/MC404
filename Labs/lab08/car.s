.set BASE, 0xFFFF0100

.text
exit:
    #code a0
    li a7, 93 # exit syscall
    ecall
    ret
.globl _start
_start:

li s0, BASE
# Armazenar as coordenadas finais : x = 73 e z = -19
li s1, 73
li s2, -19

# Loop infinito até a chegado no destino
LOOP:

    # Iniciar leitura do GPS
    li t0, 1
    sb t0, 0(s0)

    # Busy-Waiting para o termino da leitura do GPS
    1:
    lb t0, 0(s0)
    bne t0, zero, 1b

    # Ler a posição (x,z) do carro
    lw a0, 0x10(s0)
    lw a1, 0x18(s0)

    # Calcular a distânca ate o destino

    sub t1, a0, s1
    sub t2, a1, s2

    mul t1, t1, t1
    mul t2, t2, t2

    add t0, t1, t2
    li t1, 1000
    bge t1, t0, BREAK


    # Calcular o coeficiente angular para decidir esquerda ou direita
    li t0, 1
    sb t0, 0x21(s0)
    li t0, -14
    sb t0, 0x20(s0)

    j LOOP

    BREAK:
        li a0,0
        0:
        li t0, -1
        sb t0, 0x21(s0)
        li t0, 1
        sb t0, 0x22(s0)
        li t0, 10000
        addi a0, a0 ,1
        blt a0, t0, 0b

# Finaliza o programa
li a0, 1
jal ra, exit