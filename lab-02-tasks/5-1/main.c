#include <stdio.h>
#include <stdlib.h>

int main()
{
    int a[5] = {6, 4, 2, 1, 0};
    
    int i, j, sem = 1, aux;
    printf("v = [");
	i = 0;
initial_print:
	printf("%d ", a[i]);
	if(++i < 5) goto initial_print;

    
	printf("]\n");
loop_sem:
    sem = 0;
       
	i = 0;
loop_i:

    j = i + 1;
loop_j:
		if(a[i] > a[j])
		{
			aux = a[i];
			a[i] = a[j];
			a[j] = aux;
			sem = 1;
		}
    	if(++j < 5) goto loop_j;

	if(++i < 4) goto loop_i;
	if(sem) goto loop_sem;

    i = 0;
loop_print:
        printf("%d ", a[i]);
        if(++i < 5) goto loop_print;

    printf("\n");
    return 0;
}
