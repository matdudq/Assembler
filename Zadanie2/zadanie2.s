SYSEXIT =1
SYSREAD =3
SYSWRITE =4
STDIN =0
STDOUT = 1
EXIT_SUCCESS = 0

MULTIPLICANT_BYTES_LENGTH =256
MULTIPLIER_BYTES_LENGTH =256
PRODUCT_BYTES_LENGTH =512

.align 64

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
	.lcomm multiplicant, MULTIPLICANT_BYTES_LENGTH
	.lcomm multiplier, MULTIPLIER_BYTES_LENGTH
	.lcomm product, PRODUCT_BYTES_LENGTH
	.lcomm partial_product, PRODUCT_BYTES_LENGTH
.text

.global _start
_start:

#Reading 512 bytes from standard input
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
	clc
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

		# mul ecx with eax
		movl multiplier(,%edi,4), %eax
		mul %ecx
		
		movl %edi,%ebx
		addl %esi,%ebx
		#if first value add without carry
		cmpl $0,%edi
		jne add_with_carry
			#adding mul result to buffor
			addl %eax, partial_product(,%ebx,4)
			incl %edi
			incl %ebx
			addl %edx, partial_product(,%ebx,4)
		jmp multiplier_loop

		add_with_carry:	
			#add with carry, if second value don't pop from stack
			cmpl $1,%edi
			jne carry_popf
				clc
				adcl %eax, partial_product(,%ebx,4)
				incl %edi
				incl %ebx
				adcl %edx, partial_product(,%ebx,4)
				#pushfl
		jmp multiplier_loop
			#add with carry, pop from stack
			carry_popf:
				popfl
				adcl %eax, partial_product(,%ebx,4)
				incl %edi
				incl %ebx
				adcl %edx, partial_product(,%ebx,4)
				pushfl
		jmp multiplier_loop

	next_multiplicant:
	#checking if in last adding carry didn't apear
	popfl
	jnc no_carry
		incl %ebx
		incl partial_product(,%ebx,4)	
	no_carry:

	incl %esi

	movl $0, %edi
	
	clc
	#after getting partial result add it to final result to get correct flags
	add_partial_to_product:
		cmpl $(PRODUCT_BYTES_LENGTH/4),%edi
		jge check_last_carry
			movl partial_product(,%edi,4), %ebx

			cmpl $0,%edi
			#if first adding, add without carry
			jne add_carry
						
			addl %ebx,product(,%edi,4)
			movl $0, partial_product(,%edi,4)		
			incl %edi;
		jmp add_partial_to_product
			#if not first adding add with carry
			add_carry:
			
			adcl %ebx,product(,%edi,4)
			movl $0, partial_product(,%edi,4)		
			incl %edi;
		jmp add_partial_to_product
		#checking if in last adding carry didn't apear
		check_last_carry:		
			jnc multiplicant_loop
			incl %edi
			incl product(,%edi,4)	
			jmp multiplicant_loop

write:
	#send result to std out
	write $product, $PRODUCT_BYTES_LENGTH
	
	movl $0, %edi
	
clear_memory:
	#clearing memory
	cmpl $(PRODUCT_BYTES_LENGTH/4),%edi
	jge read
		movl $0, product(,%edi,4)		
		incl %edi
	jmp clear_memory

ex:

exit $0

