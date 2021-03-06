#include<stdio.h>

void GetRegisterWriteTime();
void GetMemoryWriteTime();
void GetReadFunctionTime();
void GetWriteFunctionTime();

unsigned long int GetTime();

unsigned long int BeforeOperationTime;
unsigned long int AfterOperationTime;

const int operationsCount =10;

int main()
{
	char c_var;
	int scanf_res;

	printf("Register Write mesured time: \n");
	for(int i =0; i < operationsCount; i++)
	{
		GetRegisterWriteTime();
		printf("Operation took %li time.\n",AfterOperationTime-BeforeOperationTime);
	}
	printf("Memory Write mesured time: \n");
	for(int i =0; i < operationsCount; i++)
	{
		GetMemoryWriteTime();
		printf("Operation took %li time.\n",AfterOperationTime-BeforeOperationTime);
	}
	printf("Read Function mesured time: \n");

	for(int i =0; i < operationsCount; i++)
	{
		GetReadFunctionTime();
		printf("Operation took %li time.\n",AfterOperationTime-BeforeOperationTime);
	}
	printf("Write function mesured time: \n");

	for(int i =0; i < operationsCount; i++)
	{
		GetWriteFunctionTime();
		printf("Operation took %li time.\n",AfterOperationTime-BeforeOperationTime);
	}

	printf("Printf (empty format string) function mesured time: \n");
	for(int i =0; i < operationsCount; i++)
	{
		BeforeOperationTime = GetTime();
		printf("");
		AfterOperationTime = GetTime();
		printf("Operation took %li time.\n",AfterOperationTime-BeforeOperationTime);
	}
	printf("Scanf function mesured time: \n");
	for(int i =0; i < operationsCount; i++)
	{
		BeforeOperationTime = GetTime();
		scanf_res = scanf("%c",&c_var);
		AfterOperationTime = GetTime();
		printf("Operation took %li time.\n",AfterOperationTime-BeforeOperationTime);
	}
	printf("Printf (format string without new line) function mesured time: \n");
	for(int i =0; i < operationsCount; i++)
	{
		BeforeOperationTime = GetTime();
		printf("Hello world");
		AfterOperationTime = GetTime();
		printf("Operation took %li time.\n",AfterOperationTime-BeforeOperationTime);
	}
	printf("Printf (format string with new line) function mesured time: \n");
	for(int i =0; i < operationsCount; i++)
	{
		BeforeOperationTime = GetTime();
		printf("Heloo world\n");
		AfterOperationTime = GetTime();
		printf("Operation took %li time.\n",AfterOperationTime-BeforeOperationTime);
	}

	return 0;
}
