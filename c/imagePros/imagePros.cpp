#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<errno.h>
#include<string.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<sys/wait.h>
#include<signal.h>
#include<fcntl.h>

class Image{
    public : 
    struct DIBHeader * dibH;
    struct BMPHeader * bmpH;
    unsigned char *imgHeader;
    int ** bitmap;
    int allocateBitmap(int width,int height) {
        int x,y;
        bitmap = (int ** ) malloc(sizeof(int *)*width);
        for(x=0;x<width;x++) {
            bitmap[x] = (int *) malloc(sizeof(int)*height);
        }
    } 
};
struct DIBHeader{
    int headerSize;
    int width;
    int height;
    int compr;

}; 

struct BMPHeader{
    int fileSize;
    int pixelStartOffset;
};
int getInt(unsigned char *p) {
   // It gets the integer of size 4 bytes starting from p
    int fs;
    fs = ((int)p[3])<<24 | ((int)p[2]) << 16 | ((int)p[1]) << 8 | (int)p[0] ; 
    return fs;
 
}
void displayHeader(unsigned char *p,Image *imgInfo){
    // The function extracts information from p and updates imgHeader
    int fs;
    int i;
    int offset;
    struct DIBHeader dib;
    printf("%c %c \n",*p,*(p+1));
    printf("File size = %d \n",getInt(p+2));
    printf("Reserved = %x %x %x %x \n",*(p+6),*(p+7),*(p+8),*(p+9));
    offset = getInt(p+10);
    printf("Pixel starts at %d \n",offset); 
    // DIB header starts here
    dib.headerSize = getInt(p+14); 
    dib.width = getInt(p+18); 
    dib.height = getInt(p+22);
    dib.compr = getInt(p+0x1E); 
    printf("DIB : headerSize = %d width = %d height = %d compr = %d \n",dib.headerSize,dib.width,dib.height,dib.compr);
    // Allocate imgHeader with offset size and copy the header in it
    imgInfo->imgHeader = (unsigned char *) malloc(offset);
    memcpy(imgInfo->imgHeader,p,offset); 
}

int main(){
int img_fd;
char *img_file;
unsigned char *buf;
unsigned char *imgHeader;
int bytes_read;
Image *img;
    printf ("ImagePros started \n");
    img_file = (char *) malloc(256);
    strcpy(img_file,"/home/mangesh/blacksoil/c/imagePros/desk.bmp");
    // Mem allocation for buffer 
    buf = (unsigned char *) malloc(256);
    img_fd = open(img_file,O_RDONLY);
    if(img_fd == 0) {
        perror("image open error: ");
    }
    img = new Image ;
    bytes_read = read(img_fd,buf,256); 
    displayHeader(buf,img);
    // Close opened image
    close(img_fd);
    return 0;
}
