#include<stdio.h>
void main()
{
    int i,j,k,n;
    printf("\n Enter no of rows");
    scanf("%d",&n);
        for(i=1;i<=n;i++) //for upper
            {
                for(j=n;j>=(n-i);j--)
                    printf(" ");
                    {
                        for(k=1;k<=(i*2)-1;k++)
                            printf("*");
                     }
                     printf(" \n ");
            }
        for(i=n;i<=1;i--)
            {
                for(j=0;j<=(n-i);j++)
                    printf(" ");
                    {
                        for(k=i;k<=1;k--)
                            printf("*");
                     }
                     printf("\n");
              }
                return ;
       }
       

