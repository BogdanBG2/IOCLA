#include <stdio.h>
#include <stdlib.h>

/*
 Pentru algoritmii de mai jos scrieți cod în C fără a folosi:

    apeluri de funcţii (exceptând scanf() şi printf())
    else
    for
    while
    do {} while;
    construcțiile if care conțin return
    if-uri imbricate

If-urile trebuie sa contina cel mult un goto.
Adică va trebui să folosiți if și multe instrucțiuni goto.

Implementați maximul dintr-un vector folosind cod C și constrângerile de mai sus.

*/
int main()
{
    int a[4] = {2, 6, 4, 1};
    printf("a = [ ");
    int j;
    for(j = 0; j < 4; j++)
	printf("%d ", a[j]);
    printf("] Vectorul dat\n");
    int max = a[0];
    int i = 1;

    loop:
		if(max < a[i])
		    max = a[i];
		if(++i < 4) goto loop;

    printf("Maximul este %d\n", max);

    return 0;
}
