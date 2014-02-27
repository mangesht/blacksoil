#include<stdio.h>
void main()
{ int j,i;

  int a[]={7,6,5,4,3,2,1};
    for(i=0;i<7;i++)
        {   
            for(j=i+1;j<7;j++)
                if(a[i]>a[j])
                   { int temp;
                        temp=a[i];
                         a[i]=a[j];
                         a[j]=temp;
                     }
            }
 printf("\n sorted arrar using bubble sort is:");
        for(i=0;i<7;i++)
            {
                printf("\n %d",a[i]);
             }
return ;
}
