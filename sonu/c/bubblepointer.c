#include<stdio.h>
#include<stdlib.h>

void main(){
int i,temp;
int *p;
int num_interations;
p=(int*)malloc(7*sizeof(int));
printf("\n Random array is:");// elements to be sorted
   
        for(i=0;i<7;i++){
         *(p+i)=random() % 25;
           printf("%d\t",p[i]);
        }
             
//sorting
    for(num_interations=0;num_interations < 7 ; num_interations++){
        for(i=0;i<6-num_interations;i++){
                  if(*(p+i)>*(p+i+1)){
                      temp=*(p+i);
                      *(p+i)=*(p+i+1);
                      *(p+i+1)=temp;
                   }
        }
    }
   printf("\n sorted array num is:%d\n",num_interations);

        for(i=0;i<7;i++){
           printf("%d\t",p[i]);
        }
   printf("\n");
}
                     
