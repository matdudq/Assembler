.section .data
	format_in: .asciz "%c%s"
	format_out: .asciz "%c%s"
.section .bss
	char_memory: .zero 1
	string_memory: .zero 101
	
.section .text

.global main
main:

pushl $string_memory
pushl $char_memory
pushl $format_in
call scanf

#addl $12, %esp

xor %eax,%eax
movb char_memory, %al

pushl $string_memory
pushl %eax
pushl $format_out
call printf

#addl $12, %esp

pushl $0
call exit
