#include <stdio.h>
#include <stdlib.h>

typedef struct {
        int i ; 
        void setI();
}myStruct;
void myStruct::setI(){
        i= 10 ; 
}
void print(int& m) {
        printf("Inside my print = %d \n",m);
}

int  main(){
       myStruct a;
       int k;
      printf("I = %d Default value of k = %d \n",a.i,k); 
      a.setI();
      printf("I = %d \n",a.i); 
      print(a.i);
return 0;
}

