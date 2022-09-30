.bss
    input: .skip 20         # buffer
    output: .skip 20

.text

write:
    li a0, 1                # file descriptor = 1 (stdout)
    la a1, output            # buffer
    li a2, 20             # size
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
             
    lb a1, 3(a0)        # Pegando o primeiro byte da string
    addi a1, a1, -48       # Transferindo para numero
    addi a2, a2, 1
    add a3, a3, a1
   

    lb a1, 2(a0)        # Pegando o primeiro byte da string
    addi a1, a1, -48      # Transferindo para numero
    addi a2, a2, 1
    mul a1, a1, a7
    add a3, a3, a1
    
    lb a1, 1(a0)        # Pegando o primeiro byte da string
    addi a1, a1, -48      # Transferindo para numero
    mul a1, a1, a7
    mul a1, a1, a7
    add a3, a3, a1
    
    lb a1, 0(a0)        # Pegando o primeiro byte da string
    addi a1, a1, -48       # Transferindo para numero
    mul a1, a1, a7
    mul a1, a1, a7
    mul a1, a1, a7
    add a3, a3, a1

    ret

Sqrt:
    li a7,2
    li a6,0
    li a5,10
    div a2,a3,a7
    1:
        div a4,a3,a2
        add a2,a2,a4
        div a2,a2,a7
        addi a6,a6,1
        blt a6,a5,1b
    ret

Int_Str:
    li a7,10
    

    rem a4,a2,a7
    div a2,a2,a7
    addi a4,a4,'0'
    sb a4, 3(s0)

    rem a4,a2,a7
    div a2,a2,a7
    addi a4,a4,'0'
    sb a4, 2(s0)

    rem a4,a2,a7
    div a2,a2,a7
    addi a4,a4,'0'
    sb a4, 1(s0)

    rem a4,a2,a7
    div a2,a2,a7
    addi a4,a4,'0'
    sb a4, 0(s0)

    ret



.globl _start
_start:
    
    jal ra, read
    la a0, input
    
    la s0, output
    #Transformar uma string em int tirar sua raiz e inserir o int em uma string 

    # Number 1
    jal ra, Str_Int
    jal ra, Sqrt
    jal ra, Int_Str
    li a5, ' '
    sb a5, 4(s0)
    
    # Number 2
    addi a0, a0, 5
    addi s0, s0, 5
    jal ra, Str_Int
    jal ra, Sqrt
    jal ra, Int_Str
    li a5, ' '
    sb a5, 4(s0)

    # Number 3
    addi a0, a0, 5
    addi s0, s0, 5
    jal ra, Str_Int
    jal ra, Sqrt
    jal ra, Int_Str
    li a5, ' '
    sb a5, 4(s0)

    # Number 4
    addi a0, a0, 5
    addi s0, s0, 5
    jal ra, Str_Int
    jal ra, Sqrt
    jal ra, Int_Str
    li a5, '\n'
    sb a5, 4(s0)

    jal ra,write