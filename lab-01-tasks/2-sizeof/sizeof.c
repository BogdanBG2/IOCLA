#include <stdio.h>
int main()
{
    printf("char: %zu\n", sizeof(char));
    printf("short: %zu\n", sizeof(short));
    printf("int: %zu\n", sizeof(int));
    printf("unsigned int: %zu\n", sizeof(unsigned int));
    printf("long: %zu\n", sizeof(long));
    printf("long long: %zu\n", sizeof(long long));
    printf("void *: %zu\n", sizeof(void *));
	printf("unsigned char *: %zu\n", sizeof(unsigned char *));
    return 0;
}
