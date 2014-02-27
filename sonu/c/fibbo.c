#include<stdio.h>
void main()
{
long long  i;
long long  m;
long long  t;
int count;
i=1;
t=1;
printf("\n %lld %lld",i,t);
for(count=0;count<46;count++){
   m = i + t ; 
   i = t ; 
   t = m ;                            
   printf("f(%d) = %lld\t",count+3,m);
}
                  
}

