#include <stdio.h>
#include <stdlib.h>

class G1 {
        public : 
        int a ; 
};

int  main(){
       G1 gInst; 
//       gInst = new G1 ;
       printf("Address of gInst = %x \n",&gInst);
       printf("Value of A before = %d \n",gInst.a);

return 0;
}
