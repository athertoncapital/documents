	#Count_sort.s William H Chuang
	.text
	.globl        main
main:

	addi        $sp, $sp, -412      # Make additional stack space.
	#   3 words for $ra, $s0, $s1
	#   100 words for list


	sw      $ra, 408($sp)           # Put contents of $ra on stack
	sw      $s0, 404($sp)           # Put $s0 on stack
	sw      $s1, 400($sp)           # Put $s1 on stack

	move    $s0, $sp                # $s0 = stores start address of list
	#     = $sp

	# Ask the OS to read a number and put it in $s1 = n
	li        $v0, 5                # Code for read int.
	syscall                         # Ask the system for service.
	move    $s1, $v0                # Put the input value (n) in a safe
	#    place

	# Now read in the list
	move    $a0, $s0                # First arg is list
	move    $a1, $s1                # Second arg is n
	jal     rd_lst

	# Now sort the list
	move    $a0, $s0                # First arg is list
	move    $a1, $s1                # Second arg is n
	jal     count_sort

	# Now print the list
	move    $a0, $s0                # First arg is list
	move    $a1, $s1                # Second arg is n
	jal     pr_lst

	# Prepare for return
	lw      $ra, 408($sp)           # Retrieve return address
	lw      $s0, 404($sp)           # Retrieve $s0
	lw      $s1, 400($sp)           # Retrieve $s1
	addi    $sp, $sp, 412           # Make additional stack space.
	# jr    $ra                     # Return, for SPIM

	li      $v0, 10                 # For MARS
	syscall


	###############################################################
	# Read_list function
	#    $a0 is the address of the beginning of list (In/out)
	#    $a1 is n (In)
	#
	# Note:  $a0 isn't changed:  the block of memory it refers
	#    to is changed
rd_lst:
	# Setup
	addi    $sp, $sp, -4            # Make space for return address
	sw      $ra, 0($sp)             # Save return address

	# Main for loop
	move    $t0, $zero              # $t0 = i = 0
rd_tst:	 bge     $t0, $a1, rddone        # If  i = $t0 >= $a1 = n
	#    branch out of loop.
	#    Otherwise continue.
	li      $v0, 5                  # Code for read int.
	syscall                         # Ask the system for service.
	sll     $t1, $t0, 2             # Words are 4 bytes:  use 4*i, not i
	add     $t1, $a0, $t1           # $t1 = list + i
	sw      $v0, 0($t1)             # Put the input value in $v0 in
	#    list[i]
	addi    $t0, $t0, 1             # i++
	j       rd_tst                  # Go to the loop test

	# Prepare for return
rddone:	 lw      $ra, 0($sp)             # retrieve return address
	addi    $sp, $sp 4              # adjust stack pointer
	jr      $ra                     # return


	###############################################################
	# Print_list function
	#    $a0 is the address of the beginning of list (In)
	#    $a1 is n  (In)
pr_lst:
	# Setup
	addi    $sp, $sp, -4            # Make space for return address
	sw      $ra, 0($sp)             # Save return address

	# Main for loop
	move    $t2, $a0                # Need $a0 for syscall:  so
	#    copy to t2
	move    $t0, $zero              # $t0 = i = 0
pr_tst:	 bge     $t0, $a1, prdone        # If  i = $t0 >= $a1 = n
	#    branch out of loop.
	#    Otherwise continue.
	sll     $t1, $t0, 2             # Words are 4 bytes:  use 4*i, not i
	add     $t1, $t2, $t1           # $t1 = list + i
	lw      $a0, 0($t1)             # Put the value to print in $a0
	li      $v0, 1                  # Code for print int.
	syscall

	# Print a space
	la      $a0, space              #
	li      $v0, 4                  # Code for print string
	syscall

	addi    $t0, $t0, 1             # i++
	j       pr_tst                  # Go to the loop test

	# print a newline
prdone:
	la      $a0, newln
	li      $v0, 4                  # code for print string
	syscall

	# Prepare for return
	lw      $ra, 0($sp)             # retrieve return address
	addi    $sp, $sp 4              # adjust stack pointer
	jr      $ra                     # return


	###############################################################
	# Sel_sort function
	#    $a0 is the address of the beginning of list (In/out)
	#    $a1 is n
	# Note:  $a0 isn't changed:  the block of memory it refers
	#    to is changed
count_sort:
	# Setup
	addi    $sp, $sp, -424           # Make space for registers
	sw      $ra, 420($sp)            # Save return address
	sw      $s0, 416($sp)            # We'll be using $s0, $s1,
	sw      $s1, 412($sp)            #    $s2, $s3, $s4.  To avoid
	sw      $s2, 408($sp)            #    trashing current contents
	sw      $s3, 404($sp)            #    put onto stack.
	sw      $s4, 400($sp)            #


	# We'll be using $a0, $a1 in function calls
	move    $s0, $a0                # $s0 is list
	move    $s1, $a1                # $s1 is n


	# Main for loop
	addi    $s3, $s1, 0            # Terminate when i >= n = $s3


	move    $s2, $zero              # $s2 = i = 0
lp_tst:	 bge     $s2, $s3, lpdone        # If  i = $s2 >= $s3 = n
	add     $t6, $zero, $zero      #initialize $t6
	#    branch out of loop.
	#    Otherwise continue.

	# Find the new location
	move    $a0, $s0                # Third arg is list
	move    $a1, $s2                # Second arg is i

	add     $t9, $zero, $zero       # initialize $t7
	lw      $t9, 4($s0)             #

	add     $t7, $zero, $zero       # initialize $t7
	add     $t6, $t6, $s2
	sll     $t6, $t6, 2             #
	addu    $t7, $s0, $t6           # address of list[i]
	lw      $a3, 0($t7)             # First arg is list[i]
	move    $a2, $s3                # Fourth arg is n

	jal     Find_pos                  # Call Loc_min function
	move    $s4, $v0                # Put loc in a safe place
	addi    $t6, $zero, 0
	add     $t6, $s4, $zero
	sll     $t6, $t6, 2             # $t1 counts ints, $t2 counts bytes
	add     $t7, $zero, $zero       # initialize $t7
	addu    $t7, $sp, $t6           # address of list[i]






	#new_list[loc] = list[i] ;
	#loc=$s4
	#i=$a1
	#list[i] = $a3
	#new_list[loc] =
	sw $a3, 0($t7)
	# Increment i
	addi    $s2, $s2, 1             # i++
	j       lp_tst                  # Go to the loop test

	# Prepare for return
lpdone:
	add $a0, $zero, $zero
	addu $a0, $zero, $sp
	#copy_list(new_list, list, n)
	move $a1, $s0
	move $a2, $s3
	jal copy_list

	lw      $ra, 420($sp)            # Retrieve return address
	lw      $s0, 416($sp)            # Retrieve $s0
	lw      $s1, 412($sp)            # Retrieve $s1
	lw      $s2,  408($sp)            # Retrieve $s2
	lw      $s3,  404($sp)            # Retrieve $s3
	lw      $s4,  400($sp)            # Retrieve $s4
	addi    $sp, $sp, 424            # Adjust stack pointer
	jr      $ra                     # return


	###############################################################
	# Find_pos function

Find_pos:


	# Get min_loc and list[min_loc]
	addi    $t8, $zero, 0       #$t8=count=0
	addi    $t1, $zero, 0           # j = Loop var = $t1.  Start
	#    at j=0
	# Start for loop
	addi    $t2, $zero, 0

lm_lp:
	bge     $t1, $a2, lmdone        # When j = $t1 > $a2 = last, break
	#    out of loop
	# Load list[j]
	sll     $t2, $t1, 2             # $t1 counts ints, $t2 counts bytes
	addu    $t2, $a0, $t2           # $t2 is address of list[j]
	lw      $t4, 0($t2)             # $t4 = list[j]
	#for testing if $t4=list[j] < val=$a3
	blt $t4, $a3, if
	addi    $t1, $t1, 1             # j++
	j       lm_lp
	#for testing else if(list[j] == val && j<i)
	beq $t4, $a3, con1
	addi    $t1, $t1, 1             # j++
	j       lm_lp
con1:	   blt $t1, $a1, con2
	#if not, then go to the next iteration
	addi    $t1, $t1, 1             # j++
	j       lm_lp
con2:	   #else if(list[j] == val && j<i)
	addi    $t8, $t8, 1             #count++
	addi    $t1, $t1, 1             # j++
	j       lm_lp

if:	 	#if $t4=list[j] < val=$a3
	addi    $t8, $t8, 1             #count++
	addi    $t1, $t1, 1             # j++
	j       lm_lp

lmdone:
	move    $v0 $t8                 # Set return val = min_loc
	jr      $ra                     # Return


	###############################################################
	# Copy_list function

copy_list:

	add $t0, $zero, $zero #$t0 = i =0
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
loop:

	blt $t0, $a2, true
	# else: return
	jr      $ra
true:	 #list[i] = new_list[i]

	sll $t1, $t0, 2
	addu $t2, $a1, $t1
	addu $t4, $a0, $t1

	lw $t3, 0($t4)

	sw $t3, 0($t2)
	addi $t0, $t0, 1

	j loop
	jr      $ra


	###############################################################
	# Data
	.data
space:	  .asciiz " "
newln:	  .asciiz "\n"
	
