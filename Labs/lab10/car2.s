.set BASE, 0xFFFF0100

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
    addi sp, sp, -16      # Aloca espaço na pilha da ISR
    sw t0, 0(sp)
    sw t1, 4(sp)

 # Tratamento da SYSCALL

    li t0, 10
    beq a7, t0, set_engine_and_steering
    li t0, 11
    beq a7, t0, set_handbreak
    li t0, 15
    beq a7, t0, get_position
    j end_syscall

    set_engine_and_steering:
        # a0: Sentido do deslocamento
        # a1:  ângulo do volante

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
        li t0, BASE
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
        li t0, BASE
        sb a0, 0x22(t0)

        li a0, 0
        j end_syscall

        1:
            li a0, -1
            j end_syscall
        
    
    get_position:
        # Iniciar leitura do GPS
        li t0, 1
        li t1, BASE
        sb t0, 0(t1)

        # Busy-Waiting para o termino da leitura do GPS
        1:
        lb t0, 0(t1)
        bne t0, zero, 1b

        # Ler a posição (x,z) do carro
        lw a0, 0x10(t1) # X position
        lw a1, 0x14(t1) # Y position
        lw a2, 0x18(t1) # Z position
        j end_syscall

    end_syscall:

    # Recuperar o contexto 
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 1         # Desaloca espaço na pilha da ISR
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
    la t0, user_main    # Loads the user software
    csrw mepc, t0       # entry point into mepc

    la sp, user_stack_end

    la t0, isr_stack_end # t0 <= base da pilha
    csrw mscratch, t0    # mscratch <= t0

    mret                # PC <= MEPC; mode <= MPP;

.globl logica_controle
logica_controle:
    # Armazenar as coordenadas finais : x = 73 e z = -19
    li s1, 73
    li s2, -19
    
    li a7, 15
    # Calcular a distânca ate o destino

    sub t1, a0, s1
    sub t2, a2, s2

    mul t1, t1, t1
    mul t2, t2, t2

    add t0, t1, t2
    li t1, 1000
    bge t1, t0, BREAK

    # Mover o carro no angulo certo
    li a0 , 1
    li a1, -14
    li a7, 10
    ecall
    ret

    BREAK:
        li a0,0
        0:
        li a0, -1
        li a1, 0
        li a7, 10
        ecall

        li a0, 1
        li a7, 11
        ecall

        li t0, 10000
        addi a0, a0 ,1
        blt a0, t0, 0b
