#include<stdio.h>
#include<stdlib.h>
void main() {
int *a, i;
a=(int*)malloc(4*sizeof(int ));    // allocating  bytes
for(i=0;i<4;i++)
        {                            // storing elements
          printf("Enter the elements"); 
          scanf("%d",(a+i));
          
          
        }

       for(i=0;i<4;i++)
        {
          printf("\n entered elements are:%d",*(a+i));
          
         }
return ;
}
