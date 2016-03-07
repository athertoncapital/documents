main:
	lw	$a0, num
	jal	is_prm		
	add	$a0, $zero, $v0	
	li	$v0, 1		
	syscall
	li	$v0, 10		
	syscall
	# $v0	1 true, 0 false
is_prm:
	addi	$t0, $zero, 2
tst:
	slt	$t1, $t0, $a0
	bne	$t1, $zero, loop
	addi	$v0, $zero, 1
	jr	$ra	
loop:		
	div	$a0, $t0
	mfhi	$t3	
	slti	$t4, $t3, 1
	beq	$t4, $zero, conti
	addi	$v0, $zero, 0		
	jr	$ra				
conti:
	addi $t0, $t0, 1			
	j	tst			
		.data
num:		.word	889932
		.text
