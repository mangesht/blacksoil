#include<stdio.h>
void main()
{
int i,j,n,s;
printf("\n Enter number of rows");
scanf("%d",&n);
s=n;
for(i=1;i<=n; i++)
{
for(j=1;j<=i;j++)
{
printf("");
s--;
for(j=1; j<=(2*i)-1;j++)
printf("*");
}
printf("\n");
}
return ;
}


