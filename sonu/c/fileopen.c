#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void main()
{
FILE *fp;
char *fname;
char str[] = "sonu Thorat";
char *idata ;
int id;

idata = (char *) malloc(256);
fname = "/home/mangesh/blacksoil/sonu/fp_sonu.txt";
fp=fopen(fname,"w");// file open

if(fp!= NULL){ 
    printf("%s fopen successful \n",fname);
}
else { 
    printf("%s fopen failed \n",fname);
}
id = 0x12345678 ; 

fwrite(str ,1 ,sizeof(str) ,fp );// write operation: 1byte of each element
sprintf(idata,"%x",id);
printf("Str = %s id = %x idata = %s sizeof(idata) = %d \n",str,id,idata,strlen(idata));
fwrite(idata, 1, strlen(idata) ,fp);
fclose(fp);// close file

return ;
}
