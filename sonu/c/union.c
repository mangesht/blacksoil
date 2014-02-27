#include<stdio.h>
void main()
{
union re
{
int i;
char ch[2];
};
union re e;// e is union variable
e.i= 200;
printf("%d\n",e.i);
printf("e.ch[0]=%d\n",e.ch[0]);
printf("e.ch[1]=%d\n",e.ch[1]);
}
