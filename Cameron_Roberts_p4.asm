# Who:  Cameron Roberts
# What: Cameron_Roberts_p4.asm
# When: DUE:12/5/18
# How:  XOR .txt with passphrase

.data

    bufferSource:               .space   1000
    bufferPassphrase:           .space   1000
    bufferDestination:          .space   1000
    .align 2
    bufferSize:                 .word    500
    
    sourcePrompt:               .asciiz  "Enter File SourcePath: "
    passPrompt:                 .asciiz  "Enter Unique Passphrase: "
    destinationPrompt:          .asciiz  "Enter File DestinationPath: "
    newline:                    .asciiz  "\n"
    goodByePrompt:                    .asciiz  "Have a Nice Day"
 
.text
.globl main


main:	# program entry


jal dataAcquisition       #source=$s0, passphrase=$s1, destination=$s2


jal openFiles             #sourceDescriptor=$s3, DestinationDescriptor=$s4

#jal xor_Loop             #Failed to get xor_loop to work correctly

jal goodBye

li $v0, 10		# terminate the program
syscall

xor_Loop:
li $v0, 13              #open source file
la $a0, testAddress
li $a1, 0
li $a2, 0
syscall

move $s3, $v0


li $v0, 13              #open destination file
la $a0, testAddress2
li $a1, 257
li $a2, 0
syscall

move $s4, $v0


move $a0, $s3

li $v0, 14
la $a1, fileBuffer
li $a2, 500
syscall

move $t0, $a0
move $t2, $s1


loop:

lbu $t1, 0($t0)                      #load each individual byte into temp address
lbu $t3, 0($t2)
xor $t1, $t1, $t3                    #xor both bytes

sb $t1, 0($t0)                       #store xor

addi $t0, $t0, 1           
j loop

jr $ra


goodBye:
li $v0, 4
la $a0, goodByePrompt
syscall
jr $ra

openFiles:
li $v0, 13              #open source file
la $a0, 0($s0)
li $a1, 0
li $a2, 0
syscall

move $s3, $v0          #store file descriptor on $s3, source

li $v0, 13
la $a0, 0($s2)
li $a1, 257
li $a2, 0
syscall

move $s4, $v0        #store file descriptor on $s4, destination

jr $ra

dataAcquisition:

la $a0, sourcePrompt               #output prompt
li $v0, 4
syscall

la $a0, bufferSource                     #load address of buffer
la $a1, bufferSize                  #load address of bufferSize
lw $a1, 0($a1)                      #load buffer size into $a1
li $v0, 8
syscall

move $t0, $a0                       #$t1 = address of array storing file source name

la $a0, passPrompt                  #output prompt
li $v0, 4
syscall

la $a0, bufferPassphrase                #load address of buffer
                                        #no need to load size, already in $a1
li $v0, 8
syscall

move $t1, $a0                       #$t2 = address of array storing passphrase

la $a0, destinationPrompt                  #output prompt
li $v0, 4
syscall

la $a0, bufferDestination                #load address of buffer
                                        #no need to load size, already in $a1
li $v0, 8
syscall

move $t2, $a0                      #$t3 = address array storing destination filepath

move $s0, $t0
move $s1, $t1
move $s2, $t2


jr $ra                            #return to call location



