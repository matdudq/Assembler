.global GetStatusRegister
.global GetControlWord
.global SetControlWord

.section .bss
 .lcomm buffer, 2
.text




GetStatusRegister:

	push %ebp
	mov %esp, %ebp 
	push %ebx

	FSTSW %ax 
	
	pop %ebx
	pop %ebp

ret

GetControlWord:

	push %ebp
	mov %esp, %ebp
	push %ebx
	
	FSTCW buffer
	mov buffer, %eax
	
	pop %ebx
	pop %ebp

ret

SetControlWord:

	push %ebp 
	mov %esp, %ebp
	push %ebx

	movl 8(%ebp), %eax
	
	movw  %ax, buffer
	FLDCW buffer
	
	pop %ebx	
	pop %ebp
	
ret 

