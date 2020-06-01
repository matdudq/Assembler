.global UpdateHardConnectionsTime
.global UpdateLowConnectionsTime

.section .text

.macro GetTimer

	xor %eax, %eax
	cpuid 
	rdtsc

.endm

UpdateLowConnectionsTime:
	
	push %ebx
	push %esi
 
	FINIT

	FLDPI
	FLDL2T
	FLDL2E
	FLDLG2
	FLD1


	GetTimer 
	movl %eax, timer1

	.rept 1000
		FADD %st(0), %st(1)
		FMUL %st(0), %st(2)
		FADD %st(0), %st(3)
		FMUL %st(0), %st(4)
	.endr
	
	GetTimer 
	movl %eax, timer2
	
	pop %esi
	pop %ebx

ret

UpdateHardConnectionsTime: 

	push %ebx
	push %esi

	FINIT
	FLDPI
	FLDl2T 
	FLDL2E
	FLDLG2
	FLD1
	
	GetTimer 
	movl %eax, timer1	
	.rept 1000
	FADD %st(1), %st(0)
	FMUL %st(2), %st(0)
	FADD %st(3), %st(0)
	FMUL %st(4), %st(0)
	.endr
	
	GetTimer
	movl %eax, timer2
	
	pop %esi
	pop %ebx

ret
