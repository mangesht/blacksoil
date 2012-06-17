#include <stdio.h>
#include <stdlib.h>

class Base { 
        public : 
        int i ; 
};

int main(){

        Base a;
        Base* ptr;
        //a = new;
        a.i = 5;
        printf("Ptr.i = %x \n",ptr);
        printf("Base addi = %x  \n",&a);
        printf("Base.i = %d \n",a.i);
        ptr =&a ;
        printf("Ptr.i = %d \n",ptr->i);
        printf("Adress ptr = %x \n",ptr);
        printf("Base addi = %x  \n",&a);
        a.i = 6 ;
        ptr = new Base (a);
        printf("Ptr.i = %d \n",ptr->i);
        printf("Adress ptr = %x \n",ptr);
        return 1;
}
