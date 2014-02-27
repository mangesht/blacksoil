#include<stdio.h>
int odd(int);
int main()
{
int i;
printf("\nEnter a number");
scanf("%d",&i);
printf("Is odd=%d",odd(i));

}
int odd(int i)
{
int m;
m=i%2;
if(m==0){
    return(0);
          }
else
return (1);
}
