.section .data
	format_out: .asciz "%c%s"
.section .text

.global main
main:

	xor %eax,%eax
	movb var_char, %al
	
	pushl $array
	pushl %eax
	pushl $format_out
	call printf

	add $12,%esp

xor %eax,%eax
ret
