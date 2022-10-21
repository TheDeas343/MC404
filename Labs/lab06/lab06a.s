.bss
input: .skip 262160 # buffer

.data
input_file: .asciz "imagem.pgm"

.text

# Funcoes estruturais
  
open:
    # A chamada open retorna o file descriptor (fd) do arquivo em a0. 

    la a0, input_file    # endereço do caminho para o arquivo
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # modo
    li a7, 1024          # syscall open 
    ecall
    ret

read:

    # a0 : file descriptor recebido pelo open 
    la a1, input #  buffer
    li a2, 262160
    li a7, 63   # syscall read (63)
    ecall
    ret

# Fucnoes Canvas 

setPixel:
    # a0 : coordenada x
    # a1 : coordenada y
    # a2 : tonalidade de cor
    li a7, 2200 # syscall setGSPixel (2200)
    ecall
    ret


setCanvasSize:
    # a0: largura do quadro
    # a1: comprimento do quadro
    li a7, 2201
    ecall
    ret

# Funcoes Auxiliares

getSize:
    # recebe o input no registrador a3 
    # retorna o numero de linhas em a0
    # retorna o numero de colunas em a1

    addi a3, a3, 3

    li a0, 0
    li a1, 0
    li t1, ' '
    li t4, '\n'
    li t3, 10

    1:
        lb t0, 0(a3)
        addi a3, a3, 1
        beq t0, t1, 2f

        mul a0, a0, t3
        addi t0, t0, -48
        add a0, a0, t0
        j 1b

    2:
        lb t0, 0(a3)
        addi a3, a3, 1
        beq t0, t4, 3f
        
        mul a1, a1, t3
        addi t0, t0, -48
        add a1, a1, t0
        j 2b  
    3: 
    addi a3,a3, 4 # pular a string " 255 " que representa o maximo da tonalidade da cor
    ret



 
 createColor:
    # recebe a2, e gera um int do tipo a2 / a2 / a2 / 255
    li a5 , 0
    
    add a5, a5, a2

    slli a5, a5, 8
    add a5, a5, a2

    slli a5, a5, 8
    add a5, a5, a2

    slli a5, a5, 8
    addi a5, a5 , 255

    mv a2, a5
    ret


.globl _start
_start:

    jal ra, open # pegar o fd do arquivo em a0
    jal ra, read 
    
    # a3 : endereco do input

    la a3, input 

    jal ra , getSize
    jal ra, setCanvasSize

    # t0 : valor max linha
    # t1 : valor max coluna
    
    
    mv t0, a0
    mv t1, a1
    
    # a0 : contador de linhas da matriz para enviar para SetPixel
    # a1: contador de colunas da matriz para enviar para SetPixel
    # a2 : registrador para guardar o byte para enviar para SetPixel
    
    li a1, 0
    
    for_linha: 
    li a0, 0

        for_coluna:

        lbu a2, 0(a3)

        jal ra, createColor
        jal ra, setPixel
        
        addi a3, a3, 1
        addi a0, a0, 1
    
        blt a0 , t0, for_coluna

    addi a1, a1, 1
    blt a1 , t1, for_linha