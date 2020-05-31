.global GetTime

.section .text

GetTime:
	push %ebx

	xor %edx, %edx
	xor %eax, %eax
	cpuid 
	rdtsc

	pop %ebx
ret 
