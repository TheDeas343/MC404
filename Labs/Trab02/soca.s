.set BASE_GPT, 0xFFFF0100
.set BASE_CAR, 0xFFFF0300
.set BASE_SP, 0xFFFF0500
.set BASE_CANV, 0xFFFF0700

.data
palavra: .ascii "Cheguei 5\n"
.bss
    .align 4
    #Pilha ISR
    isr_stack: .skip 1024 # Aloca 1024 bytes para a pilha
    isr_stack_end: # Base da pilha das ISRs
    #Pilha USUARIO
    user_stack: .skip 1024 # Aloca 1024 bytes para a pilha
    user_stack_end: # Base da pilha do Usuário

.text
.align 4

int_handler:
  ###### Tratador de interrupções e syscalls ######
  
  # Salvar o contexto
    csrrw sp, mscratch, sp # Troca sp com mscratch
    addi sp, sp, -32      # Aloca espaço na pilha da ISR
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)

 # Tratamento da SYSCALL

    li t0, 10
    beq a7, t0, set_engine_and_steering
    li t0, 11
    beq a7, t0, set_handbreak
    li t0, 12
    beq a7, t0, read_sensors
    li t0, 13
    beq a7, t0, read_sensor_distance
    li t0, 15
    beq a7, t0, get_position
    li t0, 16
    beq a7, t0, get_rotation
    li t0, 17
    beq a7, t0, read
    li t0, 18
    beq a7, t0, write
    li t0, 19
    beq a7, t0, draw_line
    li t0, 20
    beq a7, t0, get_systime  
    j end_syscall

    set_engine_and_steering:
        # a0: Sentido do deslocamento
        # a1: Ângulo do volante

        # Checar parâmetros
        li t0, 1
        blt t0, a0, 1f
        li t0, -1
        blt a0, t0, 1f
        li t0, 127
        blt t0, a1, 1f
        li t0, -127
        blt a1, t0, 1f

        #SUCCESS
        li t0, BASE_CAR
        sb a0, 0x21(t0)
        sb a1, 0x20(t0)

        li a0, 0
        j end_syscall

        1: #FAIL
            li a0, -1
            j end_syscall
        
    set_handbreak:
        # a0: valor dizendo se o freio de mão deve ser acionado

        # Checar parâmetros
        li t0, 1
        bne t0, a0, 1f

        # SUCCESS
        li t0, BASE_CAR
        sb a0, 0x22(t0)

        li a0, 0
        j end_syscall

        1:
            li a0, -1
            j end_syscall
        
    
    read_sensors:
        # a0: endereco de um vetor de 256 posicoes

        li a2, BASE_CAR
    
        # Busy Waiting
        li a3, 1
        sb a3, 0x1(a2)
        1:
            lb a4, 0x1(a2)
            bne a4, zero, 1b

        # Copiar vetor
        li a3, 0
        li a4, 256
        1:
            lw a1, 0x24(a2)
            sw a1, 0(a0)
            addi a0, a0, 4
            addi a2, a2, 4
            addi a3, a3, 4
            bne a3, a4, 1b
    
        j end_syscall
        
    read_sensor_distance:
        # Iniciar leitura da Sensor Ultarssonico
        li t0, 1
        li t1, BASE_CAR
        sb t0, 0x2(t1)
        # Busy-Waiting para o termino da leitura do GPS
        1:
        lb t0, 0x2(t1)
        bne t0, zero, 1b

        lw a0, 0x1C(t1)

        j end_syscall

    get_position:
        # Iniciar leitura do GPS
        li t0, 1
        li t1, BASE_CAR
        sb t0, 0(t1)
        # Busy-Waiting para o termino da leitura do GPS
        1:
        lb t0, 0(t1)
        bne t0, zero, 1b

        li t3, BASE_CAR
        # Ler a posição (x,z) do carro
        lw t0, 0x10(t3) # X position
        lw t1, 0x14(t3) # Y position
        lw t2, 0x18(t3) # Z position

        sw t0, 0(a0)
        sw t1, 0(a1)
        sw t2, 0(a2)
        j end_syscall

    get_rotation:
        # Iniciar leitura do GPS
        li t0, 1
        li t1, BASE_CAR
        sb t0, 0(t1)

        # Busy-Waiting para o termino da leitura do GPS
        1:
        lb t0, 0(t1)
        bne t0, zero, 1b

        li t3, BASE_CAR
        # Ler o angulo do carro
        lw t0, 0x4(t3) # X angle
        lw t1, 0x8(t3) # Y angle
        lw t2, 0xc(t3) # Z angle

        sw t0, 0(a0)
        sw t1, 0(a1)
        sw t2, 0(a2)
        

        j end_syscall


    read:
        # a0: fd
        # a1: buffer
        # a2: size
        li a0, 0
        li t2, 0

        2:
            # Iniciar leitura 
            li t0, 1
            li t1, BASE_SP
            sb t0, 0x2(t1)
            # Busy-Waiting para o termino da leitura 
            1:
            lb t0, 0x2(t1)
            bne t0, zero, 1b

            # Leitura de um byte
            lb t0, 0x3(t1)
            sb t0, 0(a1) 

            addi a1, a1, 1
            addi t2, t2, 1
            
            beq t2, a2, 2f
            j 2b

        2:
            mv a0, t2

        j end_syscall

    write:
        # a0: fd
        # a1: buffer
        # a2: size
    
        li t2, 0
        li t1, BASE_SP
        li a0 , 1

        2:

            lb t0, 0(a1)
            sb t0, 1(t1) 

            # BusyWanting to Write
            li t0, 1
            sb t0, 0(t1)
            # Busy-Waiting para 
            1:
            lb t0, 0(t1)
            bne t0, zero, 1b

            addi a1, a1, 1
            addi t2, t2, 1
    
            beq t2, a2, 2f
        j 2b

        2:
        j end_syscall

    draw_line:
        # a0: endereco de memoria para o array
        li t0, BASE_CANV

        li t1, 0
        li t2, 256

        1:
            lbu a1, 0x0(a0)

            # Criar a cor 255 / a1 / a1 / a1
            li a2 , 255
            
            slli a2, a2, 8
            add a2, a2, a1

            slli a2, a2, 8
            add a2, a2, a1

            slli a2, a2, 8
            add a2, a2, a1

            # Setar no canvas   

            # Tamanho do array no canvas
            li t3, 4
            sh t3, 0x2(t0) 

            # setar os pixel do canvas de 4 em 4 bytes
            li t3, 4
            mul t3, t1, t3
            sw t3, 0x4(t0)

            # Setar o vetor para ser printado
            sw a2, 0x8(t0)

            # Iniciar leitura do CANVAS
            li t3, 1
            sb t3, 0(t0)
            # Busy-Waiting para o termino da leitura 
            2:
                lb t3, 0(t0)
                bne t3, zero, 2b

            # loop
            addi a0, a0, 1
            addi t1, t1, 1
            bne t1, t2, 1b
        
        j end_syscall

    get_systime: 
        # Iniciar leitura 
            li t0, 1
            li t1, BASE_GPT
            sb t0, 0x0(t1)
            # Busy-Waiting para o termino da leitura 
            1:
            lb t0, 0x0(t1)
            bne t0, zero, 1b

            lw a0, 0x4(t1)

        j end_syscall

    end_syscall:

    # Recuperar o contexto 
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    addi sp, sp, 32         # Desaloca espaço na pilha da ISR
    csrrw sp, mscratch, sp   #  Troca sp com mscratch novamente
                             # Retorna da interrupção
    csrr t0, mepc  # carrega endereço de retorno (endereço 
                    # da instrução que invocou a syscall)
    addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall) 
    csrw mepc, t0  # armazena endereço de retorno de volta no mepc
    mret           # Recuperar o restante do contexto (pc <- mepc)
    


.globl _start
_start:

   la t0, int_handler   # Carregar o endereço da rotina que tratará as interrupções
   csrw mtvec, t0       # (e syscalls) em no registrador MTVEC para configurar
                       # o vetor de interrupções.

    # Muda o privilégio do usuário
    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800      # field (bits 11 and 12)
    and t1, t1, t2      # with value 00 (User-mode) Fazer um AND entre o MSTATUS e colocar 00 nos bits 11 e 12
                        # Fazer um AND com negação de 0x1800 = 1100000000000 -> 0011111111, fazendo um AND vai zerar os BITS 11 e 12 de MSTATUS
    csrw mstatus, t1
    la t0, main    # Loads the user software
    csrw mepc, t0       # entry point into mepc

    la sp, user_stack_end

    la t0, isr_stack_end # t0 <= base da pilha
    csrw mscratch, t0    # mscratch <= t0

    mret                # PC <= MEPC; mode <= MPP;