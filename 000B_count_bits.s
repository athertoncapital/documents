main:
	addiu	$a0, $zero, 37
	jal	nb
	li	$v0, 10	
	syscall

nb:
	add	$t0, $zero, $zero

nb_tst:
	beq	$a0, $zero, done
	srl	$a0, $a0, 1
	addi	$t0, $t0, 1
	j	nb_tst

done:
	add	$v0, $zero, $t0
	jr	$ra
