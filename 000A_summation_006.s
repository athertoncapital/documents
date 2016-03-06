	.text
	.globl        main
main:
	subu    $sp, $sp, 4             
	sw      $ra, 0($sp)             
	li      $t1, 0                  
	li      $v0, 5                  
	syscall                         
	move    $t0, $v0                
lp_tst:
	blt     $t0, $zero, done        
	add     $t1, $t1, $t0           
	li      $v0, 5                  
	syscall                         
	move    $t0, $v0                
	j       lp_tst                  
done:
	li      $v0, 1                  
	move    $a0, $t1                
	syscall                         
	lw      $ra, 0($sp)             
	addu    $sp, $sp, 4             
	li      $v0, 10
	syscall
