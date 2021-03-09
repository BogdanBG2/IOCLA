#include <stdio.h>

int main(void)
{
    short a = 20000;
    short b = 14000;

    short c = a + b; 
	// c = 34000

	unsigned short d = 3 * a + b; 
	// d = 74000, dar max(unsigned short) = 65535, deci d = 74000 - 65536 = 8464

    short e = a << 1; 
	// e = 40000

    // TODO - print variables c, d, e
    printf("%hu\n", c);
    printf("%hu\n", d);
    printf("%hu\n", e);
    return 0;
}
