#include<stdio.h>
void main()
{
int marks;

printf("\n Enter the marks of student",marks);
scanf("%d",&marks);
   if(marks>100 || marks<0){
        printf("\n Error:Plaese enter valid marks!");
}
else{
        if(marks>90 && marks<=100)
            printf("\n student got distinction !");  
        else{
             if(marks>75 && marks <=90)
                printf("\n student got first class ");
             else{
                    if(marks>65 && marks <=75)
                            printf("\n student got second class");
                     else{
                            if(marks>50 && marks <=65)
                                    printf("\n student got third class");
                            else 
                                    printf("\n student not Qualified");

                         }
                }
            }
    }
return ;
}


