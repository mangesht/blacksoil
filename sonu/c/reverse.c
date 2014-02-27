#include <stdio.h>
#include<string.h>
#include<stdlib.h>

int strev(char *);

int main(){
char *p; 
int i;
p = (char *) malloc(256);
printf("Enter string ");
if(!gets(p)) return 1;
printf("\n Echoed valued = %s with size = %d \n",p,strlen(p));
i = strev(p);
for(
printf("\n Reverse string is %s \n %d\n",p,i);

return 0;
}

int strev(char *p){

int m,i;
char temp;

m=strlen(p);
for(i=0;i<m/2;i++){
    temp=*(p+i);
    *(p+i)=*(p+m-1-i);
    *(p+m-1-i)=temp;

}
return 1; //I'm always right
}
