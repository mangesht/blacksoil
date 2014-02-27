#include<stdio.h>
void main(){
typedef struct student // structer declaration
 {
  char name[40];
  int roll_no;
  int marks;
  }student;
  student s[50];
 int i;
 printf("\nEnter student data: name, and marks");
 int  count=21;
  for(i=0;i<=1;i++) {  // storing student data in structer
        s[i].roll_no =count;
        scanf("%s %d",&s[i].name, &s[i].marks);
        count ++;
   }
 printf("\n Roll_no: \t Name: \t marks:");
 printf("\n");
 for(i=0;i<=1;i++){ // accessing the data
 
       printf("\n%d \t%s \t%d",s[i].roll_no, s[i].name, s[i].marks);
}
printf("sizeof student=%d\n",sizeof(student));
return ;
}
