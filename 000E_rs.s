	.text
	.globl  main
main:
	subu    $sp, $sp, 4
	sw      $ra, 0($sp)

	li      $v0, 5
	syscall
	move    $a0, $v0
	jal     sum
	move    $a0, $v0
	li      $v0, 1
	syscall
	lw      $ra, 0($sp)
	addu    $sp, $sp, 4
	li      $v0, 10
	syscall
sum:
	addi    $sp, $sp, -8
	sw      $ra, 4($sp)
	sw      $s0, 0($sp)
	li      $t0, 1
	bgt     $a0, $t0, gt_1
	li      $v0, 1
	j       done
gt_1:
	move	$s0, $a0
	addi    $a0, $a0, -1
	jal     sum
	add     $v0, $s0, $v0
done:
	lw      $ra, 4($sp)
	lw      $s0, 0($sp)
	addi    $sp, $sp, 8
	jr 	$ra
