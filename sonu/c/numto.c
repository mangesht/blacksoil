#include<stdio.h>
void main()
{
int i,j,n,m;
int k=0;
printf("enter the no of rows");
scanf("%d",&n);
    for(i=1;i<=n;i++)
        {   
            for(j=1;j<=i;j++)
               {  
                 m=j+k;
                  printf("%d",m);
                  printf(" ");
                  k++;
              
                 }
              printf("\n");
        }
return ;
}                    
