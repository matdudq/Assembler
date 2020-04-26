SYSEXIT =1
SYSREAD =3
SYSWRITE =4
STDIN =0
STDOUT = 1
EXIT_SUCCESS = 0

.global GetRegisterWriteTime
.type GetRegisterWriteTime, @function

.global GetMemoryWriteTime
.type GetMemoryWriteTime, @function

.global GetReadFunctionTime
.type GetReadFunctionTime, @function

.global GetWriteFunctionTime
.type GetWriteFunctionTime, @function

.global GetTime
.type GetTime, @function

.section .data 
	.lcomm test 4
	test_msg: .ascii "Hello world"
	test_msg_len = .-test_msg	

.macro GetTimer
	xor %eax, %eax
	cpuid 
	rdtsc
.endm

.macro write
	movl $SYSWRITE, %eax
	movl $STDOUT, %ebx
	movl $test_msg, %ecx
	movl $test_msg_len, %edx
	int $0x80
.endm

.macro read 
	movl $SYSREAD, %eax
	movl $STDIN, %ebx
	movl $test, %ecx
	movl $1, %edx
	int $0x80
.endm
.section .text

GetTime:
	push %ebx

	xor %edx, %edx
	xor %eax, %eax
	cpuid 
	rdtsc

	pop %ebx
ret 
GetRegisterWriteTime:
	push %ebx

	GetTimer
	movl %eax, BeforeOperationTime

	movl $1, %eax
	
	GetTimer
	movl %eax, AfterOperationTime

	pop %ebx
	ret
 
GetMemoryWriteTime:
	push %ebx

	GetTimer
	movl %eax, BeforeOperationTime

	movl $0, %ecx

	movl $1, test(,%ecx,4)
	
	GetTimer
	movl %eax, AfterOperationTime

	pop %ebx
	ret 

GetReadFunctionTime:
	push %ebx

	GetTimer
	movl %eax, BeforeOperationTime

	read
	
	GetTimer
	movl %eax, AfterOperationTime

	pop %ebx
	ret 

GetWriteFunctionTime:
	push %ebx

	GetTimer
	movl %eax, BeforeOperationTime

	write
	
	GetTimer
	movl %eax, AfterOperationTime

	pop %ebx
	ret 
