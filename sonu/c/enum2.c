#include<stdio.h>
void main()
{
int i;
enum signal
{
red=0,
yellow=1,
green=2,
};
enum signal;
for(i=red;i<=green;i++){
  printf("\nsignal is: %d",i);
    if (i==red){
        printf("\n STOP!!");
}
    if(i==green){
        printf("\nGO\n");
}
   }
return ;
}
