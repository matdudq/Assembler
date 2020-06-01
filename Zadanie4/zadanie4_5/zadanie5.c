#include <stdio.h>

void UpdateHardConnectionsTime();
void UpdateLowConnectionsTime();

unsigned long int timer1, timer2; 

int main()
{
	UpdateLowConnectionsTime();
	printf("Time of operation with low connections: %lu\n", timer2-timer1);
	
	UpdateHardConnectionsTime();
	printf("Time of operation with hard connections: %lu\n", timer2-timer1);
	return 0;
}

