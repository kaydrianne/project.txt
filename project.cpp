	.text
	.globl _start
_start:
	la $a0, ask
	li #v0, 4
	syscall

	li $v0, 8
	syscall

	la $t0, buffer
	move $t0, $v0
	syscall

	la $a0, ret
	li $v0, 4
	syscall

	move $a0, $t0
	li $v0, 4
	syscall

	.data
ask: .ascii "Enter String: "
ret: .asciiz "You Wrote: "
buffer:		.space 100

