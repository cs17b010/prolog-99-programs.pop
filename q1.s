.data

	a: .word 1, 2, 1, 1, 2, 2	#array
	n: .word 7			#size
	c: .word 0			#count
	x: .word 2			#element to be found	
.text

main:
	la $a0,a
	lw $a1,n
	lw $a2,x
	lw $s1,c
	addi $s2,$s2,1
	addi $s3,$s3,4
	addi $s4,$s4,0
	addi $v0,$0,0
	jal solve
	
	sw $v0,c
	lw $v1,c
	addi $t7,$v1,0
	li $v0,10
	syscall
        

	
solve:	
	sub $sp,$sp,12
	sw $ra,0($sp)
	sw $s6,4($sp)
	sw $s7,8($sp)

	beq $a1,$0,Exit
	lw $s5,0($a0)
	addi $s6,$s5,0
	addi $a0,$a0,4
	sub $a1,$a1,1

	jal solve
	
	beq $s6,$a2,Exit1

Exit:
	lw $ra,0($sp)
	lw $s6,4($sp)
	lw $s7,8($sp)
	addi $sp,$sp,12
	j $ra
Exit1:
	addi $s7,$0,1
	addi $v0,$v0,1
	j Exit
