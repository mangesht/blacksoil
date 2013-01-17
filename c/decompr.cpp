#include <stdio.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdlib.h>
#include<string.h>

int idx;
int bitp;
unsigned int mask[16];
unsigned char *buf;

int getbits(int n);
void set_mask() { 
    int i;
    for(i=0;i<16;i++){
        mask[i] = 1 << i;
    }
}

int main(int argc,char *argv[]){

    int ret;
    int fd;
    int i;
    char path[256] = "/home/mangesh/tryzip/r_man.txt.gz";
    buf = (unsigned char *) malloc(2024);

    if(argc > 1 ) {
        strcpy(path,argv[1]);
    }
    printf("FileName = %s \n",path);
    fd = open(path,O_RDONLY);
    set_mask();
    if(fd < 0) {
        printf("File opening failed for %s \n",path);
        perror("");
    }else{
        printf("File %s opened in RDOnly Mode fd = %d\n",path,fd);
    }
    ret = read(fd,buf,1024);
    printf("Read %d bytes \n",ret);

    for(i=0;i<ret;i++){
        printf("%x ",(int)buf[i]);
    }
    printf("\n");
    printf("Os = %x \n",buf[9]);
    printf("Filename =");
    for(i=10;buf[i]!=0;i++){
        printf("%x %c",buf[i],(char)buf[i]);
    }
    i++;
    printf("\n i = %d buf[i] = %x ",i,buf[i]);
    idx = i ;
    bitp = 0 ; 
    int bfinal = getbits(1);
    printf("bfinal = %d \t",bfinal);
    int btype = getbits(2);
    printf("btype = %d \n",btype);
    int r;
    for(;idx<ret;){
        r = getbits(8);
        //printf("r = %x r-48 = %x = %c \n",r,r-48,(char)(r-48));
        break;
    }
    free(buf);   
    return 0;
}

int getbits(int n){
    int i;
    int res=0;
    for(i=0;i<n;i++){
        res = res <<1;
        res |= (buf[idx] & mask[bitp])>>bitp;
        if(bitp == 7) { bitp = 0 ; idx++ ; } 
        else {
            bitp++;
        }
    }
    return res ;    
}

