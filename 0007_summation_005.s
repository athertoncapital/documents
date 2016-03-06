	.text
	.globl        main
main:
	addi    $sp, $sp, -4      
	sw      $ra, 0($sp)       
	li      $v0, 5            
	syscall                   
	move    $t0, $v0          
	li      $v0, 5           
	syscall                  
	move    $t1, $v0         
	
	slt     $t2, $t1, $zero   
	beq     $t2, $zero, t2eq0
	#branch	
	sub     $a0, $t0, $t1
	li      $v0, 1       
	syscall              
	j done               
t2eq0:
	sub     $a0, $t1, $t0  
	li      $v0, 1         
	syscall                
done:
	lw      $ra, 0($sp) 
	addu    $sp, $sp, 4 
	li      $v0, 10
	syscall
	
