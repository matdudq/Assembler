#include <stdio.h>

extern char floatingPointValue[10];

void SetControlWord(unsigned short int x);
unsigned short int GetControlWord();

void UpdateValue();

void PrintBinary(unsigned short int c)
{
	unsigned short int i1 = (1 << (sizeof(c)*8-1));
	for(; i1; i1 >>= 1)
	      printf("%d",(c&i1)!=0);
}

void PrintBinaryExtended(){

	int i,j;
	for(j=9;j>=0;j--)
	{
		for(i=0;i<=7;i++)
		{
			if(j==9 && i==1)
			{
				printf(" ");
			}
			else if(j==7 && i==0)
			{
				printf(" ");
			}
			else if(j==7 && i==1)
			{
				printf(" ");
			}
			if((floatingPointValue[j] >> (7-i)) & 1)
			{
				printf("1");
			}
			else
			{
				printf("0");
			}
		}
	}
	printf("\n");
}

int main(){
	
	SetControlWord(0b1111000001111111);
	UpdateValue();
	printf("To nearest rounding \nControll register: ");
	PrintBinary(GetControlWord());

	printf("\n");
	PrintBinaryExtended();
	printf("\n");


	SetControlWord(0b1111100001111111);
	UpdateValue();
	printf("To upper rounding \nControll register: ");
	PrintBinary(GetControlWord());

	printf("\n");
	PrintBinaryExtended();
	printf("\n");

	SetControlWord(0b1111010001111111);
	UpdateValue();
	printf("To lower rounding \nControll register: ");
	PrintBinary(GetControlWord());
	
	printf("\n");
	PrintBinaryExtended();
	printf("\n");

	SetControlWord(0b1111110001111111);
	UpdateValue();
	printf("To zero rounding \nControll register: ");
	PrintBinary(GetControlWord());
	
	printf("\n");
	PrintBinaryExtended();
	printf("\n");


	return 0;
}
