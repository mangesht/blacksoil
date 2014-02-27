#include<stdio.h>
#include <stdlib.h>

typedef long long int64 ;
#define PNL printf("\n")
int64  fib(int64 n) {
        if(n< 2) { 
        return 1;
        } 
    return (fib(n-1)+fib(n-2));
}

int main(int argc,int argv[])
{
    int64 n ;
    int i;
    //printf("Argc = %d \n",argc);
    for(i=0;i<argc;i++) { 
        printf("%s\t",(char *)argv[i]);
    }
    PNL;
    //scanf("%d",&n);
    n = atoi((char *)argv[1]);
    printf("Fibb(%lld) = %lld \n",n,fib(n)); 
}
