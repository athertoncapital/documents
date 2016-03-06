	.text
main:
	addi	$a0, $zero, 10
	addi	$a1, $zero, 2
	jal	mdiv

	li	$v0, 10			# calls exit command (code 10)
	syscall
	
mdiv:
	addu	$t7, $zero $zero	# i = 0

mdiv_test:
	slt	$t6, $a0, $a1		# if: ( a < b )
	bne	$t6, $zero, doned	
	sub	$a0, $a0, $a1		# else: a -= b
	addi	$t7, $t7, 1		#  ++i 
	j	mdiv_test		

done:
	addu	$t0, $zero, $t7		#
	addu	$t1, $zero, $a0		#
	jr	$ra	
