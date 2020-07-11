.global RiseDivideByZeroFlag
.global RiseStackOverflow

.section .data
randomValue:
 .float 997

.section .text

RiseDivideByZeroFlag: 

	FINIT

	FLDZ

	FIDIVR randomValue

ret

RiseStackOverflow:

	FINIT
	
	FLD1
	FLD1
	FLD1
	FLD1
	FLD1
	FLD1
	FLD1
	FLD1
	FLD1
	FLD1
ret
