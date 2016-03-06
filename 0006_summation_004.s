	.text
	.globl main
main:
	#get input val
	li $v0, 5 #read_int syscall code = 5
	syscall
	move $t1, $v0
L1:
	blt $t1, $0, Exit
	add $t0, $t0, $t1
	li $v0, 5
	syscall
	move $t1, $v0
	j L1
Exit:
	li $v0, 1
	move $a0, $t0
	syscall

	#print \n
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 10 #exit

	#start .data segment
	.data
newline:		 .asciiz "\n "
