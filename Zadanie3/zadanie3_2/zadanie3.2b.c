#include<stdio.h>

extern char* m_string;
extern short m_short;

int main(){

	char mg[] = {"Hello world"};
	m_string = mg;
	m_short = 123;
	printf("%hi%s",m_short,m_string);
	
	return 0;
}
