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
	movd K_3, %mm6 # move k matrix to mm4/5/6 

	pinsrw $0, 0(%eax, %ecx,1), %mm0 
	pinsrw $1, 2(%eax, %ecx,1), %mm0 #fullfill mm0 with continous words (values of first row)	
	
	pmaddubsw %mm4, %mm0 #multiply and add values vertically
	
	add %ebx, %ecx # next row
		
	pinsrw $0, 0(%eax, %ecx,1), %mm1
	pinsrw $1, 2(%eax, %ecx,1), %mm1 #fullfill mm1 with continous words (values of second row)	
	
	pmaddubsw %mm5, %mm1 #multiply and add values vertically
	
	add %ebx, %ecx # next row

	pinsrw $0, 0(%eax, %ecx,1), %mm2
	pinsrw $1, 2(%eax, %ecx,1), %mm2 #fullfill mm2 with continous words (values of third row)	
	
	pmaddubsw %mm6, %mm2 #multiply and add values vertically

	
	paddw %mm1, %mm0
	paddw %mm2, %mm0 #adding vertically result rows
	phaddw %mm0, %mm0 #adding horizontally result 
		
	pextrw $0, %mm0, %eax #move result to eax
	shr $LINEAR_NORM_ATRIBUTE_A, %eax #normalization - shifting a atribute
	add $LINEAR_NORM_ATRIBUTE_B, %eax #normalization - adding b atribute
	

	pop %edi
	pop %esi
	pop %ebx
	pop %ebp
ret
 
