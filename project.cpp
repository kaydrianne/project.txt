.data 
	create_space: .space 9		#space for 8 charachter plus null
	error: .asciiz "Invalid hexidecimal number." #printed when input is invalid

.text
main:
	li $v0, 8					#Syscall for v0 = 8 is Read String
	la $t0, create_space		#Create Space in $t0
	la $a0, 0($t0)				#Loads Input into Argument
	la $a1, 9					#Loads Length of Input
	syscall 					#Calls syscall 8 - Read String

	addi $t7, $t0, 8			#Move 9th byte of Input to Register
	addi $s5, $t0, 0			#Move input to Register
	add $s3, $zero, $zero   	#Intialize Register to Zero



end_program:
	la $a0, newline     #Loads Argument for Syscall
	li $v0, 4			#Syscall for v0 = 4 is Print String
	syscall             #Call syscall 4 - Print String
	li $v0, 10			#Syscall for v0 = 10 is Exit Program
	syscall 			#Calls syscall 10 - Exit Program

