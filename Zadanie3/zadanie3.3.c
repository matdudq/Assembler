#include<stdio.h>

unsigned long long int GetTime();

int main()
{
	unsigned long long int timeTest1,timeTest2;

	for(int i =0; i < 100; i++){
		timeTest1 = GetTime();
		printf("Clock Update \n");
		timeTest2 = GetTime();
		printf("%llu\n",timeTest2-timeTest1);
	}

	return 0;

}
