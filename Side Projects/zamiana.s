SYSEXIT =1
SYSREAD = 3
SYSWRITE = 4
STDOUT =1 
EXIT_SUCCESS = 0

.align 32

.data
msg: .ascii "eLLlo\n"
msg_len = .-msg

.macro write str,len
movl $SYSWRITE, %eax
movl $STDOUT, %ebx
movl \str, %ecx
movl \len, %edx
int $0x80
.endm

.macro exit code
movl $SYSEXIT, %eax
movl \code, %ebx
int $0x80
.endm

.text
.global _start
_start:

movl $-1, %ecx

loop_start: # Zachnij petle
cmpl $msg_len, %ecx # porownaj dlugosc stringa z aktualnym indeksem
jg ex # jesli wiekszy wyjdz
incl %ecx #zwieksz licznik
movb msg(,%ecx,1), %bl # przerzuc do rejestru ebx aktualna litere
cmpb $0x61, %bl # porownaj aktualna litere z 'a'
jl loop_start # jesli mniejsza to kontynuj petle bo litera duza
subl $0x20,msg(,%ecx,1) # w innym wypadku zmniejsz wartosc litery -> zrob ja duza
jmp loop_start #wskakuj na start
ex:

write $msg,$msg_len

exit $0
