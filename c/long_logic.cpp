#include <stdio.h> 

int main(){
    long long ul;
    unsigned char uc;
    ul = (long long)0x12345678 * (long long) 0x100000000 + (long long)0xabcdefab;
    printf("before  %lx %lx \n",ul>>32,ul);
    for(int i=0;i<8;i++) { 
        uc = ul & 0xFF;
        printf("val  = %x \n",uc);
        ul = ul >> 8;
    }
    printf("One more time \n");
    ul = (long long)0x12345678 * (long long) 0x100000000 + (long long)0xabcdefab;
    printf("before  %lx %lx \n",ul>>16,ul);
    for(int i=0;i<8;i++) { 
        uc = (ul >> (i*8)) & 0xFF;
        printf("val  = %x \n",uc);
        //ul = ul >> 8;
    }

    ul = (ul & (((long long)1<<48)-1)) | ((long long)0x4172 << 48) ;
    printf("againt \n");
    for(int i=0;i<8;i++) { 
        uc = (ul >> (i*8)) & 0xFF;
        printf("val  = %x \n",uc);
        //ul = ul >> 8;
    }


    unsigned short sh;
    sh = ul >> 48 ;
    printf("anded with 4 %x \n",sh);
    printf("REALIZATION : Size of unsigned long = %d \n",sizeof(long long));
    return 0;
}
