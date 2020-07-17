# Who:  Cameron Roberts

# What: Cameron_Roberts_p3.asm

# Why:  because you said so
# When: due: Nov. 9 2018
# How:  sort array and binary search

.data




    array1:           .space  400
    initialPrompt:    .asciiz     "Total Number of Integers(>0): "
    newline:          .asciiz     "\n"
    newspace:         .asciiz     " "
    dataPrompt:       .asciiz     "Enter Int: "
    searchPrompt:     .asciiz     "Enter Search Value(-999 to exit): "
    failPrompt:       .asciiz     "Input must be greater than zero."
    valueNotFound:    .asciiz     ", search value not present!"
    valueFound:       .asciiz     ", search value found!"
    exitPrompt:       .asciiz     "Have a nice day!"
.align 2

.text



.globl main




main:                                 # program entry


la $s0, array1                  #store initial start @ $s0

li $v0, 4
la $a0, initialPrompt                 #output prompt
syscall


li $v0, 5                      #get user input for how many ints
syscall

bgt $v0, $zero, NEXT

li $v0, 4
la $a0, failPrompt
syscall

li $v0, 4
la $a0, newline
syscall

j main

NEXT:

move $s3, $v0                  #save number of ints in array to $s3


li $t0, 1


input_loop:
bgt $t0, $s3, exit_loop

li $v0, 4
la $a0, dataPrompt
syscall

li $v0, 5
syscall

sll $t1, $t0, 2
add $t1, $t1, $s0
move $a0, $t1
move $a1, $v0



jal insertion

addi $t0, $t0, 1
j input_loop

exit_loop:

addi $s0, $s0, 4               #insertion increments the array up by 4, address base accordingly

jal outputArray                #go to outputArray Function


sll $s2, $s3, 2                #mult ints by 4 to get space
add $s2, $s2, $s0              #add mult ints to base address to get end, end = $s2

search:

li $v0, 4
la $a0, searchPrompt
syscall

li $v0, 5                          #take in user search int
syscall

li $t9, -999

beq $v0, $t9, exit 

move $s4, $v0                     #store user search int to $s4

move $a0, $s0                     #$a0 = start
move $a1, $s2                     #$a1 = end

jal binarySearch

move $a0, $v0
li $v0, 1
syscall

beq $a0, $zero, NEXT1
li $v0, 4
la $a0, valueFound
syscall

li $v0, 4
la $a0, newline
syscall

j search

NEXT1:
li $v0, 4
la $a0, valueNotFound
syscall

li $v0, 4
la $a0, newline
syscall

j search


exit:

li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, exitPrompt
syscall

li $v0, 10                     # terminate the program

syscall


########start of insertion
insertion:
move $t7, $s0                   #base case insertion
addi $t7, $t7, 4
beq $t7, $a0, store_int


lw $t3, -4($a0)
bge $a1, $t3, store_int         #if user int> first int, store, else increment $a0 to move next
sw $t3, 0($a0)
addi $a0, $a0, -4
j insertion

store_int:
sw $a1, 0($a0)
jr $ra


#######start of outputArray
outputArray:
move $t0, $s3                          #store total number ints in $t0 iterator
move $t1, $s0                          #store location of array1 in $t1

outputLoopStart:
beq $t0, $zero, outputLoopEnd           #if total ints = 0 end loop

li $v0, 1
lw $a0, 0($t1)                          #store value in array on $a0               
syscall                                 #output $a0

li $v0, 4
la $a0, newspace                        #output a space
syscall

addi $t0, $t0, -1                       #increment iterator as each int printed
addi $t1, $t1, 4                        #increment array1 iterator

j outputLoopStart                       #jump outPutLoopStart
outputLoopEnd:
li $v0, 4
la $a0, newline                       #output a line
syscall
jr $ra                             #return


#######start of binarySearch
#$s0 address of array, $s4 = user searchval
#$a0 address of first element, $a1 address of last
binarySearch:

addi $sp, $sp, -4           #make room on stack for $ra
sw $ra, 0($sp)              #store $ra

addu $t0, $a1, $a0           #add last address+first address
srl $t0, $t0, 3             #divide by two to get middle address, stored in $t0
sll $t0, $t0, 2

beq $t0, $s2, returnNegative   #test if middle is above end, will falsely return 1 some cases otherwise


bgt $a0, $a1, returnNegative   #if the start > end go to return negative

lw $t1, 0($t0)              #load value of middle element into $t1

beq $t1, $s4, returnFound     #if middle = searchvalue, returnfound

bgt $t1, $s4, returnGreater   #middle>value go to returnGreater

blt $t1, $s4, returnLesser    #middle<val go to returnLesser



returnNegative:
li $v0, 0
j exit_search

returnFound:
li $v0, 1
j exit_search

returnGreater:

move $t2, $t0            #middle address= temp
addi $t2, $t2, -4        #temp--
move $a1, $t2            #end = temp
jal binarySearch         #call self again

j exit_search

returnLesser:
move $t2, $t0           #middle address = temp
addi $t2, $t2, 4        #increment temp address
move $a0, $t2           #start = temp
jal binarySearch        #call self again

j exit_search



exit_search:
lw $ra, 0($sp)                  #load $ra from stack
addi $sp, $sp, 4                #return stack to original position

jr $ra                          #return










     