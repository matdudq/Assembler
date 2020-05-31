.global getFilteredValue

.section .data

K_1: .byte -1, -1, 0, 0
K_2: .byte -1, 0, 1, 0
K_3: .byte 0, 1, 1, 0


#Rounded atribute to 2^n. N is our shift.
LINEAR_NORM_ATRIBUTE_A = 3;
#127,5 rounded to 128
LINEAR_NORM_ATRIBUTE_B = 128;

# Normalization comes from Linear step function in png.c file we can calculate const values for our case
# w = x/a + b where x is unnormalized value and w - normalized.


getFilteredValue:

	pushl %ebp
	mov %esp, %ebp
	
	push %ebx
	push %esi
	push %edi

	mov 8(%ebp), %eax # M array
	mov 12(%ebp), %ebx # width
	mov 16(%ebp), %ecx # actual index
	 			
	movd K_1, %mm4
	movd K_2, %mm5
	movd K_3, %mm6

	pinsrw $0, 0(%eax, %ecx,1), %mm0
	pinsrw $1, 1(%eax, %ecx,1), %mm0 	
	pmaddubsw %mm4, %mm0
	
	add %ebx, %ecx
		
	pinsrw $0, 0(%eax, %ecx,1), %mm1
	pinsrw $1, 1(%eax, %ecx,1), %mm1 	
	pmaddubsw %mm5, %mm1
	
	add %ebx, %ecx 

	pinsrw $0, 0(%eax, %ecx,1), %mm2
	pinsrw $1, 1(%eax, %ecx,1), %mm2 	
	pmaddubsw %mm6, %mm2
	
	paddw %mm1, %mm0
	paddw %mm2, %mm0
	phaddw %mm0, %mm0
		
	pextrw $0, %mm0, %eax
	shr $LINEAR_NORM_ATRIBUTE_A, %eax
	add $LINEAR_NORM_ATRIBUTE_B, %eax
	

	pop %edi
	pop %esi
	pop %ebx
	pop %ebp
ret
 
