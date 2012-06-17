#include <stdio.h>
#include <stdlib.h>

int  main(){
        int *p;
        int i;
        p = (int *) malloc( 10*sizeof(int));
        *p =100;
        p[1] = 200; 
        *(p+2) = 300;
        printf("Mangesh Address of p = %d Value at p = %d \n",p,*p);
        printf("p of 1 = %d p2 = %d \n",p[1],p[2]);
        for(i=0;i<10;i++){
                p[i] = 100*i;
                printf("Address = %d Value = %d \n",(p+i),*(p+i));
        }
        
return 0;
}
