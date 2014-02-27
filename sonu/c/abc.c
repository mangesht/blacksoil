#include<stdio.h>
struct ABC {
    char a;
    char b; 
    char c;
    char d;
};
void main()
{
    struct ABC a;
    unsigned int k;
    a.a=1;
    a.b=2;
    a.c=3;
    a.d=4;
    //k=(unsigned int) a;
    printf("%x\n",a);
    return ;
}
