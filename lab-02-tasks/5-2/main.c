#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    char s1[] = "Bogdan";
    printf("s1 = %s\n", s1);
    char s2[] = "dan";
    printf("s2 = %s\n", s2);
    int l1 = strlen(s1), l2 = strlen(s2);

    int i, j, sem = 0;

    i = 0;
I_LOOP:
    if(s1[i] == s2[0])
    {
        j = 1;
J_LOOP:
        if(s1[i + j] != s2[j])
            goto FINISH;

        if(++j < l2) goto J_LOOP;
        sem++;
    }
    if(++i < l1) goto I_LOOP;

    FINISH:
    printf("Este s2 subsir al lui s1?\n");
    if(sem)
        printf("Raspuns: Da\n");
    else
        printf("Raspuns: Nu\n");
    return sem;
}
