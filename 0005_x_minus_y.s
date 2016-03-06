	.text	#what follows are instructions
	.globl main
main:
	#print string msg1
	li $v0, 4 #print_string syscall code = 4
	la $a0, msg1 #load the address of msg
	syscall

	#Get input x from user and save
	li $v0, 5 #read_int syscall code = 5
	syscall
	move $t0, $v0 #syscall results return in $v0

	#print string msg2
	li $v0, 4 #print_string syscall code = 4
	la $a0, msg2 #load the address of msg
	syscall

	#Get input y from users and save
	li $v0, 5 #read_int syscall code = 5
	syscall
	move $t1, $v0 # syscall return in $v0

	#Math!
	blt $t1, $0, True #goto True if $t1<0

	sub $t0, $t1, $t0

	#print string msg3
	li $v0, 4
	la $a0, msg4
	syscall

	#print y-x
	li $v0, 1 #print_int syscall code = 1
	move $a0, $t0 #int to print must be loaded into $a0
	syscall

	#print \n
	li $v0, 4 #print_string syscall code = 4
	la $a0, newline
	syscall
	li $v0, 10 #exit
	j Exit
True:
	sub $t0, $t0, $t1

	#print string msg4
	li $v0, 4
	la $a0, msg3
	syscall
	#print x-y
	li $v0, 1 #print_int syscall code = 1
	move $a0, $t0 #int to print must be loaded into $a0
	syscall
Exit:
	#print \n
	li $v0, 4 #print_string syscall code = 4
	la $a0, newline
	syscall
	li $v0, 10 #exit

	#start .data segment
	.data
msg1:		.asciiz "Enter x: "
msg2:		.asciiz "Enter y: "
msg3:		.asciiz "x-y = "
msg4:		.asciiz "y-x = "
newline:	 .asciiz "\n "


	
