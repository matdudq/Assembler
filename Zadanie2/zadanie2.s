SYSEXIT =1
SYSREAD =3
SYSWRITE =4
STDIN =0
STDOUT = 1
EXIT_SUCCESS = 0

MULTIPLICANT_BYTES_LENGTH =256
MULTIPLIER_BYTES_LENGTH =256
PRODUCT_BYTES_LENGTH =512

.align 32

.macro exit code
	movl $SYSEXIT, %eax
	movl \code, %ebx
	int $0x80
.endm

.macro write str,len
	movl $SYSWRITE, %eax
	movl $STDOUT, %ebx
	movl \str, %ecx
	movl \len, %edx
	int $0x80
.endm

.data
	.space PRODUCT_BYTES_LENGTH*2
	.lcomm multiplicant, MULTIPLICANT_BYTES_LENGTH
	.lcomm multiplier, MULTIPLIER_BYTES_LENGTH
	.lcomm product, PRODUCT_BYTES_LENGTH
	.lcomm partial_product, PRODUCT_BYTES_LENGTH
.text

.global _start
_start:

#Reading 256 bytes from standard input
read:
	movl $SYSREAD, %eax
	movl $STDIN, %ebx
	movl $multiplicant, %ecx
	movl $MULTIPLICANT_BYTES_LENGTH, %edx
	int $0x80

	movl $SYSREAD, %eax
	movl $STDIN, %ebx
	movl $multiplier, %ecx
	movl $MULTIPLIER_BYTES_LENGTH, %edx
	int $0x80

#We are comparing read function status, if %eax is 0 we read 0 bytes so exit
	cmpl $0,%eax
	je ex

handle_operation:
	#using ESI reg and EDI reg as a indicators	
	#setting up 0 to SI and DI
	
	movl $0, %esi
multiplicant_loop:
	cmpl $(MULTIPLICANT_BYTES_LENGTH/4),%esi
	jge write

	movl $0, %edi
	movl multiplicant(,%esi,4), %ecx
	
	multiplier_loop:
		cmpl $(MULTIPLIER_BYTES_LENGTH/4),%edi
		jge next_multiplicant

		movl multiplier(,%edi,4), %eax
		mul %ecx
		
		movl %edi,%ebx
		addl %esi,%ebx

		addl %eax, product(,%ebx,4)
		incl %edi

		addl %edx, product(,%ebx,4)
	jmp multiplier_loop

	next_multiplicant:

	incl %esi

jmp multiplicant_loop
write:
	write $product, $PRODUCT_BYTES_LENGTH
	
	movl $0, %edi
	
clear_memory:
	cmpl $(PRODUCT_BYTES_LENGTH/4),%edi
	jge read
		movl $0, product(,%edi,4);		
		incl %edi;
	jmp clear_memory

ex:

exit $0

