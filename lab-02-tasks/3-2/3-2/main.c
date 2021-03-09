#include <stdio.h>
#include <stdlib.h>

int main()
{
    int v[] = {2, 5, 9, 17, 21, 28, 34};
    int i;
    printf("v = [");
    for(i = 0; i < 7; i++)
	printf("%d ", v[i]);
    printf("]\n");
    int x;
    printf("x = ");
    scanf("%d", &x);

    int l = 0, r = 6;
    int m, sem = 0;
    LOOP:
    {
        m = l + (r-l)/2; // mai eficient decat (l+r)/2
        if(v[m] == x)
        {
            sem++;
            printf("%d e in v\n", x);
            goto FINISH;
        }
        if(v[m] < x)
            l = m + 1;
        if(v[m] > x)
            r = m - 1;
        if(l <= r) goto LOOP;
    }
    printf("%d nu e in v\n", x);

    FINISH:
    return 0;
}
