.section .data
	format_in: .asciz "%c%s"
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

pushl $0
call exit
