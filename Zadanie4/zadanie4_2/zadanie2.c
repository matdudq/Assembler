#include <stdio.h>
#include <stdbool.h>

void RiseDivideByZeroFlag();
void RiseStackOverflow();

unsigned short int GetStatusRegister();

void PrintBinary(unsigned short int c)
{
 unsigned short int i1 = (1 << (sizeof(c)*8-1));
 for(; i1; i1 >>= 1)
      printf("%d",(c&i1)!=0);
}

int main(){

	RiseDivideByZeroFlag();
	printf("Binary look of Status Register after rising precision flag\n");
	PrintBinary(GetStatusRegister());

	printf("\n");


	RiseStackOverflow();
	printf("Binary look of Status Register after rising stack overflow flag\n");

	PrintBinary(GetStatusRegister());

	
	return 0;

}
