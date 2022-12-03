
.bss
    .align 4
    isr_stack: .skip 1024 # Aloca 1024 bytes para a pilha
    isr_stack_end: # Base da pilha das ISRs

.set BASE_GPT, 0xFFFF0100
.set BASE_MIDI, 0xFFFF0300

.globl _system_time
.data
_system_time: .word 0

.text
#void play_note(int ch, int inst, int note, int vel, int dur);
.globl play_note
play_note:
    li t0, BASE_MIDI
    sb a0, 0(t0)
    sh a1, 2(t0)
    sb a2, 4(t0)
    sb a3, 5(t0)
    sh a4, 6(t0)
    ret

.globl main_isr
main_isr:
    
    # Salvar o contexto
        csrrw sp, mscratch, sp # Troca sp com mscratch
        addi sp, sp, -128      # Aloca espaço na pilha da ISR
        sw x0, 0(sp) 
        sw x1, 4(sp)
        sw x2, 8(sp) 
        sw x3, 12(sp) 
        sw x4, 16(sp) 
        sw x5, 20(sp) 
        sw x6, 24(sp) 
        sw x7, 28(sp) 
        sw x8, 32(sp) 
        sw x9, 36(sp) 
        sw x10, 40(sp) 
        sw x11, 44(sp) 
        sw x12, 48(sp) 
        sw x13, 52(sp) 
        sw x14, 56(sp) 
        sw x15, 60(sp) 
        sw x16, 64(sp)
        sw x17, 68(sp) 
        sw x18, 72(sp)
        sw x19, 76(sp) 
        sw x20, 80(sp) 
        sw x21, 84(sp) 
        sw x22, 88(sp) 
        sw x23, 92(sp) 
        sw x24, 96(sp) 
        sw x25, 100(sp) 
        sw x26, 104(sp) 
        sw x27, 108(sp) 
        sw x28, 112(sp) 
        sw x29, 116(sp) 
        sw x30, 120(sp) 
        sw x31, 124(sp) 

        #INTERRUPCAO

        li t0, 100
        li t1, BASE_GPT
        sw t0, 8(t1)
    
        # incremente o tempo em _system_time
            la t0, _system_time
            lw t1, 0(t0)
            addi t1, t1, 100
            sw t1, 0(t0)



        # Recuperar o contexto 
        lw x0, 0(sp) 
        lw x1, 4(sp)
        lw x2, 8(sp) 
        lw x3, 12(sp) 
        lw x4, 16(sp) 
        lw x5, 20(sp) 
        lw x6, 24(sp) 
        lw x7, 28(sp) 
        lw x8, 32(sp) 
        lw x9, 36(sp) 
        lw x10, 40(sp) 
        lw x11, 44(sp) 
        lw x12, 48(sp) 
        lw x13, 52(sp) 
        lw x14, 56(sp) 
        lw x15, 60(sp) 
        lw x16, 64(sp)
        lw x17, 68(sp) 
        lw x18, 72(sp)
        lw x19, 76(sp) 
        lw x20, 80(sp) 
        lw x21, 84(sp) 
        lw x22, 88(sp) 
        lw x23, 92(sp) 
        lw x24, 96(sp) 
        lw x25, 100(sp) 
        lw x26, 104(sp) 
        lw x27, 108(sp) 
        lw x28, 112(sp) 
        lw x29, 116(sp) 
        lw x30, 120(sp) 
        lw x31, 124(sp) 
        addi sp, sp, 128         # Desaloca espaço na pilha da ISR
        csrrw sp, mscratch, sp   #  Troca sp com mscratch novamente
        mret                     # Retorna da interrupção




.globl _start
_start:
    # Configuração das interrupcoes / GTP

    # Registrar a ISR (interrupt service routine)
        la t0, main_isr # Carrega o endereço da main_isr
        csrw mtvec, t0 # em mtvec
    
    # Configura mscratch com o topo da pilha das ISRs.
        la t0, isr_stack_end # t0 <= base da pilha
        csrw mscratch, t0 # mscratch <= t0

    # Habilita Interrupções Externas
        csrr t1, mie # Seta o bit 11 (MEIE)
        li t2, 0x800 # do registrador mie
        or t1, t1, t2
        csrw mie, t1

    # Habilita Interrupções Global
        csrr t1, mstatus # Seta o bit 3 (MIE)
        ori t1, t1, 0x8 # do registrador mstatus
        csrw mstatus, t1

    # Configurar uma interrupcao a cada 100 ms, depois no tratamento da instrucao colocar mais 100 ms para interrupcao
    li t0, 100
    li t1, BASE_GPT
    sw t0, 8(t1)

    jal ra, main