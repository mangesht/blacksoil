#include<stdio.h>
void main(){
struct student // structer declaration
 {
  char name;
  int roll_no;
  int marks;
  }student s[10];

int i;
 for(i=21;i<=31;i++) {  // storing student data in structer
   printf("\nEnter student data");
   scanf("%s %d %d",&s[i].name, &s[i].roll_no, &s[i].marks);
}
for(i=21;i<=31;i++){ // accassing the data
    printf("\n name of student is %c \n roll_no %d \n marks %d",s[i].name, s[i].roll_no, s[i].marks);
}
return ;
}

