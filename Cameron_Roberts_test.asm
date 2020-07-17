# Who:  Me
# What: project_template.asm
# Why:  A template to be used for all CS264 labs
# When: Created when? Due when?
# How:  List the uses of registers

.data

    array:               .word    400
    initialPrompt:       .asciiz  "Total Number of Integers: "
    promptData:          .asciiz  "Enter Int: "
.text
.globl main


main:	# program entry

la $s0, array           #$s0 holds array start

li $v0, 4
la $a0, initialPrompt   #output prompt for N
syscall

li $v0, 5               #get N in $v0
syscall

move $s1, $v0           #move number of ints into $s1

sll $s2, $s1, 2
addu $s2, $s0, $s2      #take ints mult by 4, and to base to get top address, $s2

li $t0, 0               #make iterator 0
move $t1, $s0           #make $t1 start of array

input:
beq $t0, $s1, exit_loop

li $v0, 4
la $a0, promptData
syscall

li $v0, 5
syscall

sw $v0, 0($t1)

addi $t0, $t0, 1
addi $t1, $t1, 4

j input

exit_loop:

li $v0, 10		# terminate the program
syscall






########start of sortArray
sortArray:
move $t0, $s0                  #move address of 1st element into $t0
sll $t1, $s3, 2                #store number of ints * 4 in $t1
addu $t0, $t0, $t1             #add (ints*4) to base address to get top address

outerloop:
li $t1, 0                      #flag to test sorted
move $a0, $s0                  #move base address into $a0
innerloop:
lw $t2, 0($a0)                 #load $a0 into $t2                  
lw $t3, 4($a0)                 #load offset 4($a0) into $t3
slt $t4, $t3, $t2              #set $t4 to 1 if $t2>$t3
beq $t4, $zero, continue       #$t4 = 1, then swap array values
addi $t1, $zero, 1             #if swap performed check again
sw $t2, 4($a0)                 #store greater contents in next element
sw $t3, 0($a0)                 #store lesser in past element
continue:
addi $a0, $a0, 4               #advance the array to the next location
bne $a0, $t0, innerloop        #if $a0 is not at the end of array, innerloop again
bne $t1, $zero, outerloop      #$t1 = 1, another pass

jr $ra                         #return