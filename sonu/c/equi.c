#include<stdio.h>
void main()
{
        int i,j,n,k;
        printf("\n Enter number of rows");
        scanf("%d",&n);
        for(i=1;i<=n; i++) { // Number for rows 
//                for(j=n;j>=i;j--) { 
                printf("i=%d",i);
                 for(j=1;j<=8-i;j++) { 
                    printf(" ");   // For spaces before printing * 
                 }
                 for(k=1; k<=(2*i)-1;k++) { 
                      printf("*");
                 }
                 printf("\n");
        }

        return ;
}


