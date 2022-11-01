# char * puts ( char * str );
.globl puts
puts:
    # a0 : buffer da String

    mv a1, a0
    li a0, 1            # fd = 1 (stdout)
 
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
    mv a2, t0             # size
    li a7, 64             # syscall write (64)
    ecall


    addi sp, sp, -16
    sw ra, 12(sp)
    sw fp, 8(sp)
    addi fp, sp, 16

    li a0, 1
    li a1, '\n'
    sw a1, 0(sp)
    mv a1, sp
    li a2, 1
    li a7, 64
    ecall

    lw fp, 8(sp)
    addi sp, sp, 16
    ret


# char * gets ( char * str );
.globl gets
gets:
    mv t3, a0       
    mv a1, a0               # a1: endereco do buffer
    
    li t0, '\n'
    li t4, 0               # EOF / NULL

    1:
        li a0, 0                # fd = 0 (stdin)
        li a2, 1                # size
        li a7, 63               # syscall read 63

        ecall
        lb t2, 0(a1)
        beq t2, t0, 1f
        beq t2, t4, 1f
        addi a1, a1, 1
        j 1b
    1:
        sb t4, 0(a1)

    mv a0, t3
    ret


# int atoi (const char * str);
.globl atoi
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

#char *  itoa ( int value, char * str, int base );
.globl itoa
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





#int time();
.globl time
time:
  addi sp, sp, -32
  mv t0, sp  
  mv a0, sp
  addi t0, t0, 12
  mv a1, t0

  li a7, 169 # chamada de sistema gettimeofday
  ecall
  mv a0, sp

  lw t1, 0(a0) # tempo em segundos
  lw t2, 8(a0) # fração do tempo em microssegundos
  li t3, 1000
  mul t1, t1, t3
  div t2, t2, t3
  add a0, t2, t1
  
  addi sp, sp, 32
  ret
#void sleep(int ms);
.globl sleep
sleep:
    # recebe o tempo de espera em a0
    addi sp,sp,-16
    sw ra, 12(sp) # salvando ra
    sw s0, 0(sp)
    sw s1, 4(sp)
    mv s0, a0 # tempo a esperar
    jal ra, time
    mv s1, a0 # primeiro tempo
     1:
        jal ra, time
        sub t0, a0, s1
        bge t0, s0, 2f
        j 1b
     2:
        lw ra, 12(sp)
        lw s0, 0(sp)
        lw s1, 4(sp)
        addi sp, sp, 16
        ret   
#int approx_sqrt(int x, int iterations);
.globl approx_sqrt
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
# void exit(int code);   
.globl exit 
exit:
    #code a0
    li a7, 93 # exit syscall
    ecall
    ret
#void imageFilter(char * img, int width, int height, char filter[3][3]);
.globl imageFilter
imageFilter:
    ret




