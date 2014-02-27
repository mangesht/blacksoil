#include<stdio.h>
void main()
{
int marks;
printf("\nEnter the marks");
scanf("%d",&marks);
switch(marks)
    {
case(marks>100):
       printf("\n Error:Please enter valid marks");
       break;
case(marks>90 ):
       printf("\n student got distinction");
       break;
case(marks>75):
       printf("\n student got first class");
       break;
case(marks>65):
       printf("\n student got second class");
       break;
case(marks>50):
       printf("\n student got third class");
       break;
default: ("\n student is not Qualified");
       break;
}
return ;
}

      
