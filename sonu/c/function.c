#include<stdio.h>
void display(int a);
void main()
{
    int r;
    int i;
    r=random() % 1000;
    for(i=0;i<r;i++){
        display(i);
    }
    return;
}
void display(int a)
{
    
    if(a==0)
    printf("\n%d st time",a);
    else if(a==1)
    printf("\n%d nd time",a);
    else if(a==2)
    printf("\n%d rd time",a);
    else
    printf("\n %d th time",a);
    return ;
}

