#include <stdio.h>
#include<string.h>
#include<stdlib.h>

void main(){
char *p;

int m,i;
char temp;
p = (char *) malloc(256);
 
printf("Enter string ");
scanf("%s",p);
printf("\n Echoed valued = %s with size = %d \n",p,strlen(p));
m=strlen(p);
for(i=0;i<(m)/2;i++){
     temp=*(p+i);
    *(p+i)=*(p+m-1-i);
    *(p+m-1-i)=temp;

    
}
printf("\n Reverse string is %s\n",p);
return ;
}
