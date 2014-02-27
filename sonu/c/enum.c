#include<stdio.h>
void main()
{
    int i,j,k,n;
    int d;
    printf("\n Enter no of rows");
    scanf("%d",&d);
    for(i=1;i<=n;i++)
        {
            for(j=1;j<=n-i;j++){
                printf(" ");}
                    for(k=1;k<=(i*2)-1;k++)
                        {
                            printf("*");
                         }
                 printf("\n");
           }
          return ;
}
