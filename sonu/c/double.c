#include<stdio.h>
void main()
{
    int i,j,n,k;
    printf("\n Enetr the no of rows");
    scanf("%d",&n);
        {
            for(i=1;i<=n;i++) // for rows
                {
                    for(j=1;j>=n-i;j++)// spacing
                     {
                        printf(" ");
                            for(k=1;k<=(i*2)-1;k++)
                                 {
                                        printf("*");
                                   }
                                        printf("\n");
                        }
                   }
                         
            } return ;
}
