#include <stdio.h>


short int get_hash(char *c) {
    unsigned short int h;
    h = 0 ;
    // incomplete h = ((c[0] & 0x18)<< 10) | ((c[0] & 0x7) ^ ((c[1] & 0xE)>>5))
    short int c0;
    short int c1;
    short int c2;
    c0 = ((unsigned char)c[0] ) << 10;
    c1 = ((unsigned char)c[1]) << 5;
    c2 = (unsigned char)c[2];
    h = (c0 ^ c1 ^ c2)& 0x7fff;
    return h;
}
short int update_hash(short int h,unsigned char c) {
    return ( ((h << 5) ^ c ) & 0x7fff);
}
int main(){
    char *p;
    short int hd;
    short int hu;
    int i=0;
    p = "mangesh";
    hd = get_hash(p);
    for(i=0;i<3;i++){
        hu = update_hash(hu,p[i]);
    }
    printf("direct hash = %x updated hash = %x \n",hd,hu);
    return 0;
}
