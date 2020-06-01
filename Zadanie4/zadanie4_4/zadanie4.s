.global UpdateValue
.global floatingPointValue

.data
floatingPointValue: .zero 80

.section .data
 threeValue: .float 3.0
 
.section .text

UpdateValue: 
	FLD1 
	FDIV threeValue
	fstpt floatingPointValue

ret
