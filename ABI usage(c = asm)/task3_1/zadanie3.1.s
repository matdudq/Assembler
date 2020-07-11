.section .data
	format_in: .asciz "%c%s"
	format_out: .asciz "%c%s"
.section .bss
	char_memory: .zero 1
	string_memory: .zero 101

.section .text

.global main
main:
	
	push $string_memory
	push $char_memory
	push $format_in
	
	call scanf
	
	add $12,%esp

	xor %eax,%eax
	movb char_memory, %al
	
	push $string_memory
	push %eax
	push $format_out

	call printf

	add $12,%esp

xor %eax, %eax
ret
