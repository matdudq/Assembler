SYSEXIT =1
SYSREAD =3
SYSWRITE =4
STDIN =0
STDOUT = 1
EXIT_SUCCESS = 0

SHIFT_COUNT = 4
FIRST_ASCII_NUMBER = 0x30
LAST_ASCII_NUMBER = 0x39
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
msg: .ascii "n"
msg_len = .-msg
msg_out: .ascii "  \n"
msg_out_len = .-msg_out


.text
.global _start
_start:
movl $0, %eax #ustawiamy index na 0
movb msg(,%eax,1) , %bl # wsadzamy 8 bitow liczby do rejestru bl
movb msg(,%eax,1) , %bh # wsadzamy 8 bitow liczby do rejestru bh

movb $0x30, %dl # ustawiamy dla rejestrow dl wartosci dla poczatku przedzialu
movb $0x30, %dh # ustawiamy dla rejestrow dh wartosci dla poczatku przedzialu

shrb $SHIFT_COUNT, %bl #przesuwamy w prawo bajt, zostaja nam tylko 4 bity w rejestrze bl
shlb $SHIFT_COUNT, %bh #przesuwamy w lewo bajt, zostaja nam tylko 4 bity w rejestrze bh
shrb $SHIFT_COUNT, %bh #przesuwamy w prawo bajt, zeby miec 4 bity na poczatku bh
#w bl mamy offset lewego znaku
# w bh mamy offset prawego znaku


addb %dl,%bl # dodajemy poczatek przedzialu wartosci do offsetu
addb %dh,%bh# to samo

cmpb $LAST_ASCII_NUMBER, %bl #dla bajku bl sprawdzamy czy nie wyszedl poza zakres liczb w Ascii 
#jesli wyszedl to przesuwamy na litery

jle next
addb $NUMBERS_ALPHABETH_OFFSET_ASCII, %bl
next:

cmpb $LAST_ASCII_NUMBER, %bh
jle second_next
addb $NUMBERS_ALPHABETH_OFFSET_ASCII, %bh
second_next:


movb %bl, msg_out(,%eax,1)# przenosimy wartosci znakow do wiadomosci wyjsciowej
incl %eax
movb %bh, msg_out(,%eax,1)

write $msg_out, $msg_out_len

exit $0

