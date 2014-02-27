#include<stdio.h>
#include<math.h>

int is_prime(int);
int main()
{
int i;
printf("Enter a number\n");
scanf("%d",&i);
printf("\n%d Is number prime= %d\n",i,is_prime(i));
}

/*
int is_prime(int i) {
int r=0,n;
for(n=2;n<=sqrt(i);r = i%n==0 ? 1 : r , n++) ;
printf("r = %d",r);
return (!r);
}

*/

int is_prime (int i) {
   int r,n;
   int k;
   r = 0 ; 
   
   for(n=2;n<=sqrt(i);n++) {
        r = 1 ; 
        k = i%n;
        if  ( k == 0) { 
            printf("%d divisible by %d \n",i,n);
            r = 0;
        }
   }
   return (r);
}


// OLD for(n=2;n<=sqrt(i);n++){
// OLD     /*
// OLD      m=i%n;
// OLD      if(m==0){
// OLD         r=1;
// OLD      } else { 
// OLD         r = r ;
// OLD      }
// OLD     */
// OLD     r = i%n==0 ? 1 : r ; 
// OLD }
// OLD /*  
// OLD if(r==1) {
// OLD     return(0);
// OLD } else { 
// OLD     return(1);
// OLD }
// OLD */
// OLD    return (!r);
// OLD }
