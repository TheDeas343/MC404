.bss
input: .skip 262160 # buffer
matrizW: .skip 36 # Matriz de 9 ints

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
    mv a3, s0
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
    mv s0 , a3
    ret



 
 createColor:
    # recebe a2, e gera um int do tipo a2 / a2 / a2 / 255
    # retorna a cor em a2
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
# Funcao Lab06b - Filtro

aplicarFiltro:
        # Registradores:
            # a0: linha da matriz
            # a1: coluna da matriz
            
            # s1: apontador pro comeco da matriz
            # s3: valor max coluna
            # s4: Armazena a soma
            # s10: armazenando o ra final

            # t0: contador de coluna
            # t1: contador de linha

        mv s10, ra

        # Pintar as Bordas
        li t0 , 0
        beq a0, t0, black

        li t0, 0
        addi t0, s2, -1
        beq a0, t0, black

        li t0 , 0
        beq a1, t0, black

        li t0, 0
        addi t0, s3, -1
        beq a1, t0, black

        # Tratar a Matriz menor , Aplicar a fomrula do filtro 

        li s4, 0
        li t1, 0
        Sum1: 
            li t0, 0

            Sum2:
                # s9: armazena o valor da matriz W
                # s8: armazena o valor da matriz M

                li t2 , 1
                bne t1, t2, 1f
                bne t0, t2, 1f
                li s9, 8
                j 2f
                1:
                  li s9, -1
                2:

                # MATRIZ M
                mv a5, s1
                
                li t4, 0 # t4 armazena a linha que sera utilizada de M
                add t4, a1, t0
                addi t4, t4, -1

                li t5, 0 # t5 armazena a coluna que sera utilizada de M
                add t5, a0, t1
                addi t5, t5, -1


                # pegando a linha de M
                mul t3, t4, s3
                # pegando a coluna de M
                add t3, t3, t5

                add a5, a5, t3
                lbu s8, 0(a5)
                

                mul a2, s8, s9
                add s4, s4, a2
                addi t0, t0, 1

                li t2 , 3
                blt t0 , t2, Sum2

        addi t1, t1, 1
        li t2 , 3
        blt t1 , t2, Sum1

        mv a2,s4

        li t0 , 0
        li t1 , 255

        blt a2, t0, m0
        blt t1, a2, m255
        j 2f

        m0:
            li a2, 0
            j 2f
        m255:
            li a2, 255
            j 2f

        2:
        jal ra, createColor
        j 1f

        black:
            li a2, 0x000000FF

        1:
            mv ra, s10
            ret


.globl _start
_start:

    jal ra, open # pegar o fd do arquivo em a0
    jal ra, read 
    
    # s0 : endereco do input para impressão
    # s1 : endereço que sempre apontara para o comeco da matriz

    la s0, input 
    
    jal ra , getSize
    jal ra, setCanvasSize

    mv s1, s0

    # s2 : valor max linha
    # s3 : valor max coluna

    mv s2, a0
    mv s3, a1

    # a0 : contador de linhas da matriz para enviar para SetPixel
    # a1: contador de colunas da matriz para enviar para SetPixel
    # a2 : registrador para guardar o byte para enviar para SetPixel
    
    li a1, 0
    
    for_linha: 
    li a0, 0

        for_coluna:

            jal ra, aplicarFiltro

            jal ra, setPixel
            
            addi s0, s0, 1
            addi a0, a0, 1
        
            blt a0 , s2, for_coluna

    addi a1, a1, 1
    blt a1 , s3, for_linha