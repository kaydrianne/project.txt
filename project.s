.data
	create_space: .space 9 							#Create space for 8 characters and NULL
	error: .asciiz "Invalid hexadecimal number."	#Output to be printed on invalid input
	newline: .asciiz "\n"							

.text
main:
	li $v0, 8				#Syscall for v0 = 8 is Read String
	la $t0, create_space	#Create Space in $t0
	la $a0, 0($t0)			#Loads Input into Argument
	la $a1, 9				#Loads Length of Input
	syscall 				#Calls syscall 8 - Read String

	addi $t7, $t0, 8		#Move 9th byte of Input to Register
	addi $s5, $t0, 0		#Move input to Register
	add $s3, $zero, $zero   #Intialize Register to Zero

length_of_input:				#Count length of Input
	lb $t1, 0($s5)
	beq $t1, 0, revert
	beq $t1, 10, revert
	addi $s3, $s3, 4
	addi $s5, $s5, 1 
	j length_of_input

revert:					#To revert back to last position in Input, rather than /n or NULL
	addi $s3, $s3, -4
	
test_valid_invalid:					#Testing for Valid Input	
	lb $t1, 0($t0)					#Load Byte from 0 offset to a pointer in address of Input
	beq $t1, 0, handle_signed		#Branch to Handle large (signed to unsigned) numbers
	beq $t1, 10, handle_signed
	blt $t1, 48, invalid_input		#Branch on less than 48 - ASCII for 0 - Invalid Input
	addi $s1, $0, 48				#Store Subtraction in Register
	blt $t1, 58, valid_input		#Branch on less than 58 - ASCII for 9 - Valid Input
	blt $t1, 65, invalid_input		#Branch on less than 65 - ASCII for A - Invalid Input
	addi $s1, $0, 55				#Store Subtraction in Register
	blt $t1, 71, valid_input		#Branch on less than 71 - ASCII for G - Valid Input
	blt $t1, 97, invalid_input		#Branch on less than 97 - ASCII for a - Invalid Input
	addi $s1, $0, 87				#Store Subtraction in Register
	blt $t1, 103, valid_input		#Branch on less than 103 - ASCII for g - Valid Input
	bgt $t1, 102, invalid_input		#Branch on greater than 102 - ASCII for f - Invalid Input
	
invalid_input:				#Must throw error on Invalid input
	li $v0, 4				#Syscall for v0 = 4 is Print String
	la $a0, error			#Loads error prompt into Register
	syscall 				#Calls syscall 4 - Print String
	li $v0, 10				#Syscall for v0 = 10 is Exit Program
	syscall 				#Calls syscall 10 - Exit Program

valid_input:								#Must compute Decimal value on Valid input
	addi $t0, $t0, 1					#Point to next address of Input
	sub $s4, $t1, $s1					#Subtract from ASCII value to get Decimal Value of character
	sllv $s4, $s4, $s3					#Shifting Left is the same as Multiplying
	addi $s3, $s3, -4
	add $s2, $s4, $s2				
	bne $t0, $t7, test_valid_invalid	#If not end of Input (NULL/n) continue iterating through Loop

handle_signed:					#To Handle Large (signed to unsigned) numbers
	addi $s0, $0, 10		
	addi $t0, $t0, -1			#Point to Previous Byte in Input
	lb $t1, 0($t0)
	blt $t1, 58, end_program	#Branch on less than 58 - ASCII for 9
	divu $s2, $s0				#Unsigned Division with 10
	mflo $a0					#Printing Quotient
	li $v0, 1					#Syscall for v0 = 1 is Print Signed Integer
	syscall 					#Calls syscall 1 - Print Signed Integer
	mfhi $s2					#Priting Remainder
	
end_program:
	la $a0, newline     #Loads Argument for Syscall
	li $v0, 4			#Syscall for v0 = 4 is Print String
	syscall             #Call syscall 4 - Print String
	li $v0, 1			#Syscall for v0 = 1 is Print Signed Integer
	addi $a0, $s2, 0	#Loads Argument for Syscall
	syscall 			#Calls syscall 1 - Print Signed Integer
	li $v0, 10			#Syscall for v0 = 10 is Exit Program
	syscall 			#Calls syscall 10 - Exit Program
