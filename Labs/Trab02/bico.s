
.text 
.globl set_motor
# int set_motor(char vertical, char horizontal);
set_motor:
    # a0: Movimento vertical
    # a1: Movimento Horizontal
    li a7, 10
    ecall
ret

.globl set_handbreak
# int set_handbreak(char valor);
set_handbreak:
    # a0: acionar o freio
    li a7, 11
    ecall
ret

.globl read_camera
# void read_camera(unsigned char* img);
read_camera:
    # a0: vetor de bytes(char) - 256bytes
    li a7, 12
    ecall
ret 


.globl read_sensor_distance
# int read_sensor_distance(void);
read_sensor_distance:
    li a7, 13
    ecall
ret

.globl get_position
# void get_position(int* x, int* y, int* z);
get_position:
    # a0: endereço de x
    # a1: endereço de y
    # a2: endereço de z

    addi sp, sp ,-16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)

    li a7, 15
    ecall

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp , 16
    
ret

.globl get_rotation
# void get_rotation(int* x, int* y, int* z);
get_rotation:
    # a0: endereço de x
    # a1: endereço de y
    # a2: endereço de z
    addi sp, sp ,-16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)

    li a7, 16
    ecall

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp , 16

ret

.globl get_time
# unsigned int get_time(void);
get_time:
    li a7, 20
    ecall
ret

.globl display_image
# void display_image(char * img);  
display_image:
    # a0: array representando a imagem
    addi sp, sp, -16
    sw a0, 0(sp)

    li a7, 19
    ecall

    lw a0, 0(sp)
    addi sp, sp, 16

ret

.globl puts
# void puts ( const char * str );
puts:
    # a0 : buffer da String
    addi sp, sp, -16

    mv a1, a0
               
    #contar o tamanho da string
    li t0, 0
    li t1, 0 # 0 em ascii é NULL
    mv a3, a1

    1:
        lbu a4, 0(a3)
        beq a4, t1, 1f

        addi t0, t0, 1
        addi a3, a3, 1
        j 1b
    1:
    li a0, 1            # fd = 1 (stdout)
    mv a2, t0           # size
    li a7, 18            
    ecall

    #Imprimir um \n

    li a0, 1
    li a1, '\n'
    sw a1, 0(sp)
    mv a1, sp
    li a2, 1
    li a7, 18
    ecall

    
    addi sp, sp, 16

ret

.globl gets
# char * gets ( char * str );
gets:
    # a0 : vetor de char
    addi sp, sp, -16

    mv t3, a0       
    mv a1, a0               # a1: endereco do buffer
    
    1:
        li a0, 0                # fd = 0 (stdin)
        li a2, 1                # size
        li a7, 17    

        sw a1, 0(sp)
        ecall
        lw a1, 0(sp)
        
        lb t2, 0(a1)

        li t0, '\n'
        li t4, 0 
        beq t2, t0, 1f
        beq t2, t4, 1f
        addi a1, a1, 1
        j 1b
    1:
        sb t4, 0(a1)

    mv a0, t3
    addi sp, sp, 16

ret

.globl atoi
# int atoi (const char * str);
atoi:
    # Recebe uma string trnasfomra em int e retorna
    mv a1, a0

    li a7, 1 # indica se o numero é positivo ou negativo

    li a0, 0
    li a3, '+'
    li t1, ' '
    li t2, '-'
    li t3, 10
    li t4, '\n'
    li t5, '0'
    li t6, '9'

    1:
        lb t0, 0(a1)
        addi a1, a1, 1

        beq t0, t1, 1b
        beq t0, t2, 2f
        beq t0, a3, 1b
        beq t0, t4, 1f
        blt t6, t0, 1f
        blt t0, t5, 1f
    
        mul a0, a0, t3
        addi t0, t0, -48
        add a0, a0, t0
        j 1b

        2:
            li a7, -1
            j 1b

    1: 
        li t0, -1
        bne t0, a7, 2f
        mul a0, a0, t0
    2:
ret

#char * base10( int value, char * str):
base10: 
        # Converte Int em String
        mv a7, a1
        bge a0, zero, 4f
        # Coloca o '-' no inicio da String
        li t1 , '-'
        sb t1, 0(a1)
        addi a1, a1, 1
        li t1, -1
        mul a0,a0,t1
            
        4:
        # Contar o numero de digitos
        li t0, 10
        li t1, 0 # Numero de digitos
        mv a4, a0
           5:
             div a4, a4, t0
             addi t1, t1, 1
             bne a4, zero, 5b  
        
        add t3, t1, a1 # Soma o numero de digitos ao endereço do buffer
        sb zero, 0(t3) # Adicionar o caracter nulo ao final

        mv a4, a0
        li t0, 10
        addi t3,t3,-1
        6:
            rem t1,a4,t0
            div a4,a4,t0
            addi t1,t1,'0'
            sb t1, 0(t3)
            addi t3, t3, -1
            blt zero, a4, 6b
        mv a0, a7
ret

#char * base16( int value, char * str):
base16: 
        # Converte Decimal em Hexadecimal
        blt a0, zero, 1f
        j 2f
        1: # Em hexadecimal o resultado é unsigned
            li t0, -1
            mul a0, a0, t0
        2:
        # Contar o numero de digitos
        li t0, 10
        li t1, 0 # Numero de digitos
        mv a4, a0
           5:
             div a4, a4, t0
             addi t1, t1, 1
             bne a4, zero, 5b  
        
        add t3, t1, a1 # Soma o numero de digitos ao endereço do buffer
        sb zero, 0(t3) # Adicionar o caracter nulo ao final
        addi t3,t3,-1

        mv a4, a0
        li t0, 16
        li t1, 10
        li t4, 0 # contador de digitos em base hexadecimal

        6:
            rem t2,a4,t0
            div a4,a4,t0
            bge t2, t1, 7f
            j 8f
            7:
              addi t2, t2, 7 # mapear na parte de letras de A a F  
            8:
            addi t2,t2,'0'
            sb t2, 0(t3)
            addi t4, t4, 1
            addi t3, t3, -1
            blt zero, a4, 6b
            addi t3, t3, 1
        mv a0, t3
ret

.globl itoa
#char *  itoa ( int value, char * str, int base );
itoa:
    # Recebe int em a0 / Recebe string em a1 / recebe base em a2
    addi sp, sp, -16
    sw ra, 0(sp)

    li t1, 16
    beq a2, t1, 2f

    1: 
        jal ra , base10
        j 3f
        
    2: 
        jal ra, base16
        j 3f
    3:
        lw ra,0(sp)
        addi sp, sp, 16
ret

.globl sleep
#void sleep(int ms);
sleep:
    # recebe o tempo de espera em a0
    addi sp,sp,-16
    sw ra, 12(sp) # salvando ra
    sw s0, 0(sp)
    sw s1, 4(sp)
    mv s0, a0 # tempo a esperar
    jal ra, get_time
    mv s1, a0 # primeiro tempo
     1:
        jal ra, get_time
        sub t0, a0, s1
        bge t0, s0, 2f
        j 1b
     2:
        lw ra, 12(sp)
        lw s0, 0(sp)
        lw s1, 4(sp)
        addi sp, sp, 16
ret 

.globl approx_sqrt
#int approx_sqrt(int x, int iterations);
approx_sqrt:
    # a0 num
    # a1 iterecoes
    li a7,2
    li t0,0
    div a2,a0,a7
    1:
        div a4,a0,a2
        add a2,a2,a4
        div a2,a2,a7
        addi t0,t0,1
        blt t0,a1,1b
    mv a0,a2
ret

# void filter_1d_image(char * img, char * filter);
.globl filter_1d_image
filter_1d_image:
    # a0 - vetor de 256 bytes
    # a1 - filtro de 3 bytes
    
    addi sp, sp, -256 #salvar o resultado da convolução na pilha
    mv a6, sp
    mv a7, a0

    li t0, 0
    li t1, 255
    1:  
        #tratar as bordas i = 0 e i = 255
        bgt t0, t1, 1f
        beq t0, t1, 2f
        beq t0, zero, 2f
        j 3f
        2:
            sb zero, (sp)
            j 2f
        3:
            # Apicar a convolucao e guardar em a2
            
            lb a3, 0(a1)
            lb a4, 1(a1)
            lb a5, 2(a1)

            # Posicao Anterior
            addi a0, a0, -1
            lbu t2, 0(a0)
            mul a2, a3, t2

            # Posicao Central
            addi a0, a0, 1
            lbu t2, 0(a0)
            mul t2, a4, t2
            add a2, a2, t2

            # Posicao Posterior
            addi a0, a0, 1
            lbu t2, 0(a0)
            mul t2, a5, t2
            add a2, a2, t2

            addi a0, a0, -1

            # Analisar se passam do tamanho de 1 byte unsigned
            blt a2, zero, 3f
            bgt a2, t1, 4f
            j 5f
            3:
                li a2, 0
                j 5f
            4:
                li a2, 255
                j 5f
            5:
            sb a2, 0(sp)
        2:
        addi t0, t0, 1
        addi a0, a0, 1
        addi sp, sp, 1
        j 1b
    1:
    #Voltar para o inicio dos vetores
    li t0, 0
    li t1, 255

    addi a0, a0, -256
    addi sp, sp, -256
    1:    
        #Copiar a pilha para a0
        bgt t0, t1, 1f
        lbu t2, 0(sp)
        sb t2, 0(a0)
        addi t0, t0, 1
        addi a0, a0, 1
        addi sp, sp, 1
        j 1b
    1:
    mv a0, a7
    ret