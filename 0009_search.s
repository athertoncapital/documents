main:
	.text
	.globl  main
	addi    $sp, $sp, -416
	sw      $ra, 412($sp)
	sw      $s0, 408($sp)
	sw      $s1, 404($sp)
	sw      $s2, 400($sp)
	move    $s0, $sp
	li      $v0, 5
	syscall
	move    $s1, $v0
	move    $a0, $s0
	move    $a1, $s1
	jal     rd_lst
	li      $v0, 5
	syscall
	move    $s2, $v0
	move    $a0, $s0
	move    $a1, $s1
	move    $a2, $s2
	jal 	bsrch
	move    $a0, $v0
	li      $v0, 1
	syscall
	lw      $ra, 412($sp)
	lw      $s0, 408($sp)
	lw      $s1, 404($sp)
	lw      $s2, 400($sp)
	addi    $sp, $sp, 412
	li      $v0, 10
	syscall

rd_lst:
	addi    $sp, $sp, -4
	sw      $ra, 0($sp)
	move    $t0, $zero
rd_tst:
	bge $t0, $a1, rddone
	li      $v0, 5
	syscall
	sll     $t1, $t0, 2
	add     $t1, $a0, $t1
	sw      $v0, 0($t1)
	addi    $t0, $t0, 1
	j       rd_tst
rddone:
	lw      $ra, 0($sp)
	addi    $sp, $sp 4
	jr      $ra
pr_lst:
	addi    $sp, $sp, -4
	sw      $ra, 0($sp)
	move    $t2, $a0
pr_tst:
	bge $t0, $a1, prdone
	sll     $t1, $t0, 2
	add     $t1, $t2, $t1
	lw      $a0, 0($t1)
	li      $v0, 1
	syscall
	la      $a0, space
	li      $v0, 4
	syscall
	addi    $t0, $t0, 1
	j       pr_tst

prdone:
	la      $a0, newln
	li      $v0, 4
	syscall
	lw      $ra, 0($sp)
	addi    $sp, $sp 4
	jr      $ra

bsrch:
	li      $t0, 0
	add     $t1, $a1, -1
while:
	bgt $t0, $t1, srchdn
	add $t2, $t0, $t1
	srl $t2, $t2, 1
	sll $t3, $t2, 2
	add $t3, $t3, $a0
	lw  $t4, 0($t3)
	bne $a2, $t4, not_eq
	move $v0, $t2
	jr	$ra
not_eq:
	bgt $a2, $t4, grter
	addi $t1, $t2, -1
	j while
grter:
	addi $t0, $t2, 1
	j while
srchdn:
	li $v0, -1
	jr $ra

	.data
space:	  .asciiz " "
newln:	  .asciiz "\n"
