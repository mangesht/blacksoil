#include<stdio.h>
void swap(int, int);
int main()
{
int num[]={7,6,5,4,3,2,1};
int  i=0;

 while(i<=7)                        
{     if(num[i]> num[i+1])
        {   
            swap(num,num+i);
            num[i]++;
        }
    
      i++;
}
 printf("%d \t",num[i]);
 return 0;
}

void swap(int a, int b)
{
    int temp;
    temp=a;
    a=b;
    b=temp;
   }
