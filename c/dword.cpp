#include <stdio.h>
#include <stdlib.h>

typedef unsigned long long dword;
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
      dword val;
      dword expect;
      printf("I = %d Default value of k = %d \n",a.i,k); 
      a.setI();
      printf("I = %d \n",a.i); 
      print(a.i);
      val = 0xffffffff;
      expect = 0;
      expect = expect -1 ; 
      printf("Val = %ld \n",val);
      val = 0 ; 
      printf("Val = %ld \n",val);
      val = val - 1  ; 
      printf("-1_Val = %ld \n",val);
      if(val & 0xffffffff == 0xffffffff) {
              printf("Val = FF\n");
      }else{
              printf("Val NOt = FF\n");
      }
      if(val == expect) {
              printf("Val matches\n");
      }else{
              printf("Val NO matches\n");
      }

return 0;
}

