	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"lab03.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	addi	a7, zero, 63	# syscall read (63) 
	ecall	

	mv	a3, a0
	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	addi	a7, zero, 64	# syscall write (64) 
	ecall	

	#NO_APP
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	inicializate
	.p2align	2
	.type	inicializate,@function
inicializate:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	lw	a1, -12(s0)
	mv	a0, zero
	sb	a0, 35(a1)
	lw	a1, -16(s0)
	sb	a0, 11(a1)
	lw	a1, -20(s0)
	sb	a0, 12(a1)
	lw	a1, -24(s0)
	sb	a0, 12(a1)
	lw	a2, -12(s0)
	addi	a1, zero, 10
	sb	a1, 34(a2)
	lw	a2, -16(s0)
	sb	a1, 10(a2)
	lw	a2, -20(s0)
	sb	a1, 11(a2)
	lw	a2, -24(s0)
	sb	a1, 11(a2)
	sw	a0, -28(s0)
	j	.LBB2_1
.LBB2_1:
	lw	a1, -28(s0)
	addi	a0, zero, 33
	blt	a0, a1, .LBB2_4
	j	.LBB2_2
.LBB2_2:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB2_3
.LBB2_3:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB2_1
.LBB2_4:
	mv	a0, zero
	sw	a0, -32(s0)
	j	.LBB2_5
.LBB2_5:
	lw	a1, -32(s0)
	addi	a0, zero, 9
	blt	a0, a1, .LBB2_8
	j	.LBB2_6
.LBB2_6:
	lw	a0, -16(s0)
	lw	a1, -32(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB2_7
.LBB2_7:
	lw	a0, -32(s0)
	addi	a0, a0, 1
	sw	a0, -32(s0)
	j	.LBB2_5
.LBB2_8:
	mv	a0, zero
	sw	a0, -36(s0)
	j	.LBB2_9
.LBB2_9:
	lw	a1, -36(s0)
	addi	a0, zero, 10
	blt	a0, a1, .LBB2_12
	j	.LBB2_10
.LBB2_10:
	lw	a0, -20(s0)
	lw	a1, -36(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB2_11
.LBB2_11:
	lw	a0, -36(s0)
	addi	a0, a0, 1
	sw	a0, -36(s0)
	j	.LBB2_9
.LBB2_12:
	mv	a0, zero
	sw	a0, -40(s0)
	j	.LBB2_13
.LBB2_13:
	lw	a1, -40(s0)
	addi	a0, zero, 10
	blt	a0, a1, .LBB2_16
	j	.LBB2_14
.LBB2_14:
	lw	a0, -24(s0)
	lw	a1, -40(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB2_15
.LBB2_15:
	lw	a0, -40(s0)
	addi	a0, a0, 1
	sw	a0, -40(s0)
	j	.LBB2_13
.LBB2_16:
	lw	s0, 40(sp)
	lw	ra, 44(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end2:
	.size	inicializate, .Lfunc_end2-inicializate

	.globl	stringlen
	.p2align	2
	.type	stringlen,@function
stringlen:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	mv	a0, zero
	sw	a0, -16(s0)
	j	.LBB3_1
.LBB3_1:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	mv	a1, zero
	beq	a0, a1, .LBB3_4
	j	.LBB3_2
.LBB3_2:
	j	.LBB3_3
.LBB3_3:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB3_1
.LBB3_4:
	lw	a0, -16(s0)
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end3:
	.size	stringlen, .Lfunc_end3-stringlen

	.globl	power
	.p2align	2
	.type	power,@function
power:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	addi	a0, zero, 1
	sw	a0, -20(s0)
	mv	a0, zero
	sw	a0, -24(s0)
	j	.LBB4_1
.LBB4_1:
	lw	a0, -24(s0)
	lw	a1, -16(s0)
	bge	a0, a1, .LBB4_4
	j	.LBB4_2
.LBB4_2:
	lw	a0, -20(s0)
	lw	a1, -12(s0)
	mul	a0, a0, a1
	sw	a0, -20(s0)
	j	.LBB4_3
.LBB4_3:
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB4_1
.LBB4_4:
	lw	a0, -20(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end4:
	.size	power, .Lfunc_end4-power

	.globl	copy
	.p2align	2
	.type	copy,@function
copy:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a0, -20(s0)
	sw	a0, -24(s0)
	mv	a0, zero
	sw	a0, -28(s0)
	j	.LBB5_1
.LBB5_1:
	lw	a1, -12(s0)
	lw	a0, -24(s0)
	lw	a2, -28(s0)
	sub	a0, a0, a2
	add	a0, a0, a1
	lbu	a0, -1(a0)
	addi	a1, zero, 120
	beq	a0, a1, .LBB5_4
	j	.LBB5_2
.LBB5_2:
	lw	a1, -12(s0)
	lw	a0, -24(s0)
	lw	a2, -28(s0)
	sub	a0, a0, a2
	add	a0, a0, a1
	lb	a0, -1(a0)
	lw	a1, -16(s0)
	sub	a1, a1, a2
	sb	a0, 10(a1)
	j	.LBB5_3
.LBB5_3:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB5_1
.LBB5_4:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	copy, .Lfunc_end5-copy

	.globl	number
	.p2align	2
	.type	number,@function
number:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	stringlen
	addi	a0, a0, -2
	sw	a0, -16(s0)
	mv	a0, zero
	sw	a0, -20(s0)
	sw	a0, -24(s0)
	lw	a0, -12(s0)
	lbu	a0, 0(a0)
	addi	a1, zero, 45
	bne	a0, a1, .LBB6_2
	j	.LBB6_1
.LBB6_1:
	addi	a0, zero, 1
	sw	a0, -20(s0)
	j	.LBB6_2
.LBB6_2:
	lw	a0, -20(s0)
	sw	a0, -28(s0)
	j	.LBB6_3
.LBB6_3:
	lw	a0, -28(s0)
	sw	a0, -32(s0)
	lw	a0, -12(s0)
	call	stringlen
	mv	a1, a0
	lw	a0, -32(s0)
	addi	a1, a1, -1
	bge	a0, a1, .LBB6_6
	j	.LBB6_4
.LBB6_4:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -48
	sw	a0, -36(s0)
	lw	a0, -16(s0)
	sub	a1, a0, a1
	addi	a0, zero, 10
	call	power
	mv	a1, a0
	lw	a0, -36(s0)
	mul	a1, a0, a1
	lw	a0, -24(s0)
	add	a0, a0, a1
	sw	a0, -24(s0)
	j	.LBB6_5
.LBB6_5:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB6_3
.LBB6_6:
	lw	a0, -24(s0)
	lw	s0, 40(sp)
	lw	ra, 44(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end6:
	.size	number, .Lfunc_end6-number

	.globl	Dec_Bin
	.p2align	2
	.type	Dec_Bin,@function
Dec_Bin:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	addi	a0, zero, 33
	sw	a0, -20(s0)
	j	.LBB7_1
.LBB7_1:
	lw	a0, -12(s0)
	mv	a1, zero
	beq	a0, a1, .LBB7_3
	j	.LBB7_2
.LBB7_2:
	lw	a0, -12(s0)
	andi	a0, a0, 1
	ori	a0, a0, 48
	lw	a1, -16(s0)
	lw	a2, -20(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -20(s0)
	addi	a0, a0, -1
	sw	a0, -20(s0)
	lw	a0, -12(s0)
	srli	a0, a0, 1
	sw	a0, -12(s0)
	j	.LBB7_1
.LBB7_3:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end7:
	.size	Dec_Bin, .Lfunc_end7-Dec_Bin

	.globl	Dec_Hex
	.p2align	2
	.type	Dec_Hex,@function
Dec_Hex:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	addi	a0, zero, 9
	sw	a0, -20(s0)
	j	.LBB8_1
.LBB8_1:
	lw	a0, -12(s0)
	mv	a1, zero
	beq	a0, a1, .LBB8_6
	j	.LBB8_2
.LBB8_2:
	lw	a0, -12(s0)
	andi	a0, a0, 15
	sw	a0, -24(s0)
	lw	a1, -24(s0)
	addi	a0, zero, 9
	blt	a0, a1, .LBB8_4
	j	.LBB8_3
.LBB8_3:
	lw	a0, -24(s0)
	addi	a0, a0, 48
	sw	a0, -24(s0)
	j	.LBB8_5
.LBB8_4:
	lw	a0, -24(s0)
	addi	a0, a0, 87
	sw	a0, -24(s0)
	j	.LBB8_5
.LBB8_5:
	lw	a0, -24(s0)
	lw	a1, -16(s0)
	lw	a2, -20(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -20(s0)
	addi	a0, a0, -1
	sw	a0, -20(s0)
	lw	a0, -12(s0)
	srli	a0, a0, 4
	sw	a0, -12(s0)
	j	.LBB8_1
.LBB8_6:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end8:
	.size	Dec_Hex, .Lfunc_end8-Dec_Hex

	.globl	Hex_Dec
	.p2align	2
	.type	Hex_Dec,@function
Hex_Dec:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	addi	a0, zero, 9
	sw	a0, -20(s0)
	mv	a0, zero
	sw	a0, -24(s0)
	sw	a0, -28(s0)
	j	.LBB9_1
.LBB9_1:
	lw	a0, -20(s0)
	addi	a1, zero, 2
	blt	a0, a1, .LBB9_6
	j	.LBB9_2
.LBB9_2:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	addi	a1, zero, 97
	blt	a0, a1, .LBB9_4
	j	.LBB9_3
.LBB9_3:
	lw	a0, -16(s0)
	addi	a0, a0, -87
	sw	a0, -16(s0)
	j	.LBB9_5
.LBB9_4:
	lw	a0, -16(s0)
	addi	a0, a0, -48
	sw	a0, -16(s0)
	j	.LBB9_5
.LBB9_5:
	lw	a0, -16(s0)
	sw	a0, -32(s0)
	lw	a1, -24(s0)
	addi	a0, zero, 16
	call	power
	mv	a1, a0
	lw	a0, -32(s0)
	mul	a1, a0, a1
	lw	a0, -28(s0)
	add	a0, a0, a1
	sw	a0, -28(s0)
	lw	a0, -20(s0)
	addi	a0, a0, -1
	sw	a0, -20(s0)
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB9_1
.LBB9_6:
	lw	a0, -28(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end9:
	.size	Hex_Dec, .Lfunc_end9-Hex_Dec

	.globl	Complement_Bin
	.p2align	2
	.type	Complement_Bin,@function
Complement_Bin:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	addi	a0, zero, 2
	sw	a0, -16(s0)
	j	.LBB10_1
.LBB10_1:
	lw	a1, -16(s0)
	addi	a0, zero, 34
	blt	a0, a1, .LBB10_4
	j	.LBB10_2
.LBB10_2:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	lb	a2, 0(a1)
	addi	a0, zero, 97
	sub	a0, a0, a2
	sb	a0, 0(a1)
	j	.LBB10_3
.LBB10_3:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB10_1
.LBB10_4:
	addi	a0, zero, 34
	sw	a0, -16(s0)
	j	.LBB10_5
.LBB10_5:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 48
	beq	a0, a1, .LBB10_8
	j	.LBB10_6
.LBB10_6:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB10_7
.LBB10_7:
	lw	a0, -16(s0)
	addi	a0, a0, -1
	sw	a0, -16(s0)
	j	.LBB10_5
.LBB10_8:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	addi	a0, zero, 49
	sb	a0, 0(a1)
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end10:
	.size	Complement_Bin, .Lfunc_end10-Complement_Bin

	.globl	Complement_Hex
	.p2align	2
	.type	Complement_Hex,@function
Complement_Hex:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	addi	a0, zero, 2
	sw	a0, -16(s0)
	j	.LBB11_1
.LBB11_1:
	lw	a1, -16(s0)
	addi	a0, zero, 9
	blt	a0, a1, .LBB11_7
	j	.LBB11_2
.LBB11_2:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 97
	blt	a0, a1, .LBB11_4
	j	.LBB11_3
.LBB11_3:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	lb	a2, 0(a1)
	addi	a0, zero, 102
	sub	a0, a0, a2
	sb	a0, 0(a1)
	j	.LBB11_5
.LBB11_4:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	lb	a2, 0(a1)
	addi	a0, zero, 63
	sub	a0, a0, a2
	sb	a0, 0(a1)
	j	.LBB11_5
.LBB11_5:
	j	.LBB11_6
.LBB11_6:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB11_1
.LBB11_7:
	addi	a0, zero, 9
	sw	a0, -16(s0)
	j	.LBB11_8
.LBB11_8:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 15
	bne	a0, a1, .LBB11_11
	j	.LBB11_9
.LBB11_9:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	mv	a0, zero
	sb	a0, 0(a1)
	j	.LBB11_10
.LBB11_10:
	lw	a0, -16(s0)
	addi	a0, a0, -1
	sw	a0, -16(s0)
	j	.LBB11_8
.LBB11_11:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	lb	a0, 0(a1)
	addi	a0, a0, 1
	sb	a0, 0(a1)
	addi	a0, zero, 2
	sw	a0, -16(s0)
	j	.LBB11_12
.LBB11_12:
	lw	a1, -16(s0)
	addi	a0, zero, 9
	blt	a0, a1, .LBB11_18
	j	.LBB11_13
.LBB11_13:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 10
	blt	a0, a1, .LBB11_15
	j	.LBB11_14
.LBB11_14:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	lb	a0, 0(a1)
	addi	a0, a0, 87
	sb	a0, 0(a1)
	j	.LBB11_16
.LBB11_15:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	lb	a0, 0(a1)
	addi	a0, a0, 48
	sb	a0, 0(a1)
	j	.LBB11_16
.LBB11_16:
	j	.LBB11_17
.LBB11_17:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB11_12
.LBB11_18:
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end11:
	.size	Complement_Hex, .Lfunc_end11-Complement_Hex

	.globl	Endianess
	.p2align	2
	.type	Endianess,@function
Endianess:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	addi	a1, zero, 10
	sb	a1, -21(s0)
	mv	a0, zero
	sb	a0, -22(s0)
	sb	a1, -23(s0)
	sw	a0, -40(s0)
	j	.LBB12_1
.LBB12_1:
	lw	a1, -40(s0)
	addi	a0, zero, 9
	blt	a0, a1, .LBB12_4
	j	.LBB12_2
.LBB12_2:
	lw	a1, -40(s0)
	addi	a0, s0, -33
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB12_3
.LBB12_3:
	lw	a0, -40(s0)
	addi	a0, a0, 1
	sw	a0, -40(s0)
	j	.LBB12_1
.LBB12_4:
	addi	a0, zero, 2
	sw	a0, -20(s0)
	j	.LBB12_5
.LBB12_5:
	lw	a1, -20(s0)
	addi	a0, zero, 9
	blt	a0, a1, .LBB12_8
	j	.LBB12_6
.LBB12_6:
	lw	a0, -12(s0)
	lw	a2, -20(s0)
	sub	a0, a0, a2
	lb	a0, 11(a0)
	addi	a1, s0, -33
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB12_7
.LBB12_7:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB12_5
.LBB12_8:
	addi	a0, zero, 2
	sw	a0, -20(s0)
	j	.LBB12_9
.LBB12_9:
	lw	a1, -20(s0)
	addi	a0, zero, 10
	blt	a0, a1, .LBB12_11
	j	.LBB12_10
.LBB12_10:
	lw	a0, -20(s0)
	addi	a2, s0, -33
	add	a0, a2, a0
	lbu	a0, 0(a0)
	sw	a0, -16(s0)
	lw	a0, -20(s0)
	add	a1, a2, a0
	lb	a0, 1(a1)
	sb	a0, 0(a1)
	lw	a0, -16(s0)
	lw	a1, -20(s0)
	add	a1, a1, a2
	sb	a0, 1(a1)
	lw	a0, -20(s0)
	addi	a0, a0, 2
	sw	a0, -20(s0)
	j	.LBB12_9
.LBB12_11:
	addi	a0, s0, -33
	call	Hex_Dec
	lw	s0, 40(sp)
	lw	ra, 44(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end12:
	.size	Endianess, .Lfunc_end12-Endianess

	.globl	int_str
	.p2align	2
	.type	int_str,@function
int_str:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a0, -12(s0)
	call	stringlen
	addi	a0, a0, -2
	sw	a0, -20(s0)
	lw	a0, -16(s0)
	sw	a0, -24(s0)
	j	.LBB13_1
.LBB13_1:
	lw	a0, -24(s0)
	mv	a1, zero
	beq	a0, a1, .LBB13_3
	j	.LBB13_2
.LBB13_2:
	lw	a0, -24(s0)
	lui	a1, 838861
	addi	a1, a1, -819
	mulhu	a2, a0, a1
	srli	a2, a2, 3
	addi	a3, zero, 10
	mul	a2, a2, a3
	sub	a0, a0, a2
	ori	a0, a0, 48
	lw	a2, -12(s0)
	lw	a3, -20(s0)
	add	a2, a2, a3
	sb	a0, 0(a2)
	lw	a0, -20(s0)
	addi	a0, a0, -1
	sw	a0, -20(s0)
	lw	a0, -24(s0)
	mulhu	a0, a0, a1
	srli	a0, a0, 3
	sw	a0, -24(s0)
	j	.LBB13_1
.LBB13_3:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end13:
	.size	int_str, .Lfunc_end13-int_str

	.globl	str_cut
	.p2align	2
	.type	str_cut,@function
str_cut:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	mv	a0, zero
	sw	a0, -24(s0)
	addi	a0, zero, 2
	sw	a0, -28(s0)
	lw	a0, -12(s0)
	lbu	a0, 1(a0)
	addi	a1, zero, 98
	bne	a0, a1, .LBB14_2
	j	.LBB14_1
.LBB14_1:
	addi	a0, zero, 35
	sw	a0, -20(s0)
	j	.LBB14_9
.LBB14_2:
	lw	a0, -12(s0)
	lbu	a0, 1(a0)
	addi	a1, zero, 120
	bne	a0, a1, .LBB14_4
	j	.LBB14_3
.LBB14_3:
	addi	a0, zero, 10
	sw	a0, -20(s0)
	j	.LBB14_8
.LBB14_4:
	lw	a0, -12(s0)
	lbu	a0, 0(a0)
	addi	a1, zero, 45
	bne	a0, a1, .LBB14_6
	j	.LBB14_5
.LBB14_5:
	addi	a0, zero, 11
	sw	a0, -20(s0)
	addi	a0, zero, 1
	sw	a0, -28(s0)
	j	.LBB14_7
.LBB14_6:
	addi	a0, zero, 11
	sw	a0, -20(s0)
	mv	a0, zero
	sw	a0, -28(s0)
	j	.LBB14_7
.LBB14_7:
	j	.LBB14_8
.LBB14_8:
	j	.LBB14_9
.LBB14_9:
	lw	a0, -28(s0)
	sw	a0, -16(s0)
	j	.LBB14_10
.LBB14_10:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 48
	bne	a0, a1, .LBB14_13
	j	.LBB14_11
.LBB14_11:
	j	.LBB14_12
.LBB14_12:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB14_10
.LBB14_13:
	j	.LBB14_14
.LBB14_14:
	lw	a0, -16(s0)
	lw	a1, -24(s0)
	add	a0, a0, a1
	lw	a1, -20(s0)
	bge	a0, a1, .LBB14_16
	j	.LBB14_15
.LBB14_15:
	lw	a1, -12(s0)
	lw	a0, -16(s0)
	lw	a3, -24(s0)
	add	a0, a0, a3
	add	a0, a1, a0
	lb	a0, 0(a0)
	lw	a2, -28(s0)
	add	a2, a2, a3
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB14_14
.LBB14_16:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	lw	a2, -24(s0)
	add	a1, a1, a2
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 0(a1)
	lw	a0, -28(s0)
	lw	a1, -24(s0)
	add	a0, a0, a1
	addi	a0, a0, 1
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end14:
	.size	str_cut, .Lfunc_end14-str_cut

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -144
	sw	ra, 140(sp)
	sw	s0, 136(sp)
	addi	s0, sp, 144
	mv	a0, zero
	sw	a0, -132(s0)
	sw	a0, -12(s0)
	addi	a0, zero, 10
	sb	a0, -26(s0)
	addi	a0, s0, -68
	addi	a1, s0, -80
	addi	a2, s0, -93
	addi	a3, s0, -106
	call	inicializate
	lw	a0, -132(s0)
	addi	a1, s0, -25
	addi	a2, zero, 13
	call	read
	sw	a0, -112(s0)
	lbu	a0, -24(s0)
	addi	a1, zero, 120
	bne	a0, a1, .LBB15_2
	j	.LBB15_1
.LBB15_1:
	lw	a2, -112(s0)
	addi	a0, s0, -25
	addi	a1, s0, -80
	sw	a1, -136(s0)
	call	copy
	lw	a0, -136(s0)
	call	Hex_Dec
	sw	a0, -32(s0)
	lw	a0, -32(s0)
	addi	a1, s0, -68
	call	Dec_Bin
	j	.LBB15_5
.LBB15_2:
	addi	a0, s0, -25
	call	number
	sw	a0, -32(s0)
	lw	a0, -32(s0)
	addi	a1, s0, -68
	call	Dec_Bin
	lw	a0, -32(s0)
	addi	a1, s0, -80
	call	Dec_Hex
	lbu	a0, -25(s0)
	addi	a1, zero, 45
	bne	a0, a1, .LBB15_4
	j	.LBB15_3
.LBB15_3:
	addi	a0, s0, -68
	call	Complement_Bin
	addi	a0, s0, -80
	call	Complement_Hex
	j	.LBB15_4
.LBB15_4:
	j	.LBB15_5
.LBB15_5:
	lw	a1, -32(s0)
	addi	a0, s0, -93
	call	int_str
	addi	a0, s0, -80
	call	Endianess
	mv	a1, a0
	addi	a0, s0, -106
	call	int_str
	lbu	a0, -66(s0)
	addi	a1, zero, 49
	bne	a0, a1, .LBB15_7
	j	.LBB15_6
.LBB15_6:
	addi	a0, zero, 45
	sb	a0, -93(s0)
	j	.LBB15_7
.LBB15_7:
	addi	a0, zero, 98
	sb	a0, -67(s0)
	addi	a0, zero, 120
	sw	a0, -140(s0)
	sb	a0, -79(s0)
	addi	a0, s0, -68
	sw	a0, -144(s0)
	call	str_cut
	sw	a0, -116(s0)
	addi	a0, s0, -93
	call	str_cut
	sw	a0, -120(s0)
	addi	a0, s0, -80
	call	str_cut
	sw	a0, -124(s0)
	addi	a0, s0, -106
	call	str_cut
	lw	a1, -144(s0)
	sw	a0, -128(s0)
	lw	a2, -116(s0)
	addi	a0, zero, 1
	call	write
	lw	a1, -140(s0)
	lbu	a0, -24(s0)
	beq	a0, a1, .LBB15_9
	j	.LBB15_8
.LBB15_8:
	lw	a2, -112(s0)
	addi	a0, zero, 1
	addi	a1, s0, -25
	call	write
	j	.LBB15_10
.LBB15_9:
	lw	a2, -120(s0)
	addi	a0, zero, 1
	addi	a1, s0, -93
	call	write
	j	.LBB15_10
.LBB15_10:
	lbu	a0, -24(s0)
	addi	a1, zero, 120
	bne	a0, a1, .LBB15_12
	j	.LBB15_11
.LBB15_11:
	lw	a2, -112(s0)
	addi	a0, zero, 1
	addi	a1, s0, -25
	call	write
	j	.LBB15_13
.LBB15_12:
	lw	a2, -124(s0)
	addi	a0, zero, 1
	addi	a1, s0, -80
	call	write
	j	.LBB15_13
.LBB15_13:
	lw	a2, -128(s0)
	addi	a0, zero, 1
	addi	a1, s0, -106
	call	write
	mv	a0, zero
	lw	s0, 136(sp)
	lw	ra, 140(sp)
	addi	sp, sp, 144
	ret
.Lfunc_end15:
	.size	main, .Lfunc_end15-main

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	main
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end16:
	.size	_start, .Lfunc_end16-_start

	.type	.L__const.Endianess.space,@object
	.section	.rodata,"a",@progbits
.L__const.Endianess.space:
	.byte	10
	.size	.L__const.Endianess.space, 1

	.type	.L__const.main.space,@object
.L__const.main.space:
	.byte	10
	.size	.L__const.main.space, 1

	.ident	"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym inicializate
	.addrsig_sym stringlen
	.addrsig_sym power
	.addrsig_sym copy
	.addrsig_sym number
	.addrsig_sym Dec_Bin
	.addrsig_sym Dec_Hex
	.addrsig_sym Hex_Dec
	.addrsig_sym Complement_Bin
	.addrsig_sym Complement_Hex
	.addrsig_sym Endianess
	.addrsig_sym int_str
	.addrsig_sym str_cut
	.addrsig_sym main
