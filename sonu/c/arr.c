#include<stdio.h>
void main()
{
int a[10];
int i;
    for(i=0;i<10;i++)
        {
            a[i]=rand()%1000;
            printf("\n %d",a[i]);
        }
}
//static memmory allocation
