#include<stdio.h>
#include<stdlib.h>
void main() {
int i;
int j;
int **p;

p=(int**)malloc (4*sizeof(int*));
for(i=0;i<4;i++) {
    p[i]=(int*)malloc (3*sizeof(int*));
for(j=0;j<3;j++){
   // p[j]= random () % 1000;
   scanf("%d",&p[i][j]);
   }
}

for(i=0;i<4;i++) {
    printf("\n");
for(j=0;j<3;j++){
    
    printf("%d\n",p[i][j]);
   }
}
return ;
}

