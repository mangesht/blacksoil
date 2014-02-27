#include<stdio.h>
void main()
{
unsigned int i;
printf("Enter a number\n");
scanf("%d",&i);
if((i&0x01)==1)
    {
    printf("Entered no is odd\n");
     }
else {
    printf("not odd\n");
      }
}
