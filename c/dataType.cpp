#include <stdio.h>

int  main(){
int ar[10];
bool a ;
typedef unsigned char byte;
typedef unsigned long long dword;
int k;
 int un_i;
byte b;
byte seq[4];
dword dw = 2 ; 
b = 25 ;
un_i = 0x80000001;
printf("Unsigned int i = %u \n",un_i);

seq[0] = 2 ; 
seq[1] = 3 ; 
seq[2] = 4 ; 
seq[3] = 5 ; 

printf("Hello Word ! %x  b = %d \n",a,b);
dw = seq[0] ; 
dw |= seq[1] << 8*1 ;  
dw |= seq[2] << 8*2 ;  
dw |= seq[3] << 8*3 ;  
printf("Dword unsigned long long = %x \n",dw);
dw = 0 ; 
for(k=0,dw=0;k<4 ;dw |= seq[k] <<(8*k) ,k++){
//        printf("dw = %x k = %d \n",dw , k);
}

printf("Dword unsigned long long = %x \n",dw);
return 1;
}
