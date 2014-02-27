#include<stdio.h>

void main(){

int a[7];
int i;
int num_interations;
int temp;
int count;
int swap_done;

printf("The random array is : ");
for(i=0;i<7;i++) { 
    a[i] = random() % 50 ;
    printf("%d ",a[i]);
}
printf("\n");

// Start sorting
count = 0 ; 
for(num_interations=0;num_interations < 7 ; num_interations++) { 
    swap_done = 0 ; 
    for(i=0;i<6-num_interations;i++) {
        count++;
        if (a[i] > a[i+1]){ 
            // Swap the elements 
            temp = a[i]; 
            a[i] = a[i+1];
            a[i+1] = temp; 
            swap_done = 1; 
        } 
    }

    
   printf("The sorted array is at iteration num = %d : ",num_interations);
   for(i=0;i<7;i++) { 
       printf("%d ",a[i]);
   }
   printf("\n");
   
   if(swap_done == 0) { 
        break;
   }

}

printf("The sorted array is : ");
for(i=0;i<7;i++) { 
    printf("%d ",a[i]);
}
printf("\n");


printf("Total number of comparisons = %d \n",count);

}
