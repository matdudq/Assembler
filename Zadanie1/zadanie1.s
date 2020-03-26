SYSEXIT =1
SYSREAD =3
SYSWRITE =4
STDIN =0
STDOUT = 1
EXIT_SUCCESS = 0

NUMBERS_ALPHABETH_OFFSET_ASCII = 7

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
	.lcomm msg, 1
	msg_out: .ascii "   "
	msg_out_len = .-msg_out

.text

.global _start
_start:

#One byte reading from standard input
read:
	movl $SYSREAD, %eax
	movl $STDIN, %ebx
	movl $msg, %ecx
	movl $1, %edx
	int $0x80

#We are comparing read function status, if %eax is not value 1 finish process
	movl $1, %ebx
	cmpl %eax, %ebx
	jne ex

	movl $0, %eax #setting 0 index for eax register
	movb msg(,%eax,1) , %bl # setting read byte to register bl
	movb msg(,%eax,1) , %bh # setting read byte to register bh 

	shrb $4, %bl #right shifting bl register to get left letter offset
	shlb $4, %bh #left shifting bh to leave first 4 bits in register
	shrb $4, %bh #right shifting bh to get correct rigth letter offset

	addb $'0',%bl #adding offset to our base ascii value
	addb $'0',%bh#same as up

	cmpb $'9', %bl #comparing left letter if is outside of desired region
	jle next #if it is we move it do letters
	addb $NUMBERS_ALPHABETH_OFFSET_ASCII, %bl
next:
	cmpb $'9', %bh
	jle second_next
	addb $NUMBERS_ALPHABETH_OFFSET_ASCII, %bh

second_next:

#moving our letters value to output message
	movb %bl, msg_out(,%eax,1)
	incl %eax
	movb %bh, msg_out(,%eax,1)

	#sending output message on standard output
	write $msg_out, $msg_out_len

jmp read

ex:

exit $0

