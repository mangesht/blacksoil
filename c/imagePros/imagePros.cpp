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
#define COLOR(x,y) bitmap[y][x]

struct DIBHeader{
    int headerSize;
    int width;
    int height;
    int compr;
    int imageSize;

}; 

struct BMPHeader{
    int fileSize;
    int pixelStartOffset;
};


class Image{
    public : 
    struct DIBHeader *dibH;
    struct BMPHeader *bmpH;
    unsigned char *imgHeader;
    int ** bitmap;
    // Class Constructor 
    Image() {
        dibH = ( struct DIBHeader *) malloc(sizeof(struct DIBHeader));
        bmpH = ( struct BMPHeader *) malloc(sizeof(struct BMPHeader));
    }
    int allocateBitmap() {
        int x,y;
        bitmap = (int ** ) malloc(sizeof(int *)*dibH->height);
        for(y=0;y<dibH->height;y++) {
            bitmap[y] = (int *) malloc(sizeof(int)*dibH->width);
        }
    } 
};
void allocateByte(unsigned char **p, int x,int y) {
    int i,j;
    p = (unsigned char **) malloc(sizeof(unsigned char)*y);
    for(j=0;j<y;j++) {
        p[j] = (unsigned char *) malloc(sizeof(unsigned char)*x);
    }
}
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
    imgInfo->dibH->headerSize = getInt(p+14); 
    imgInfo->dibH->width = getInt(p+18); 
    imgInfo->dibH->height = getInt(p+22);
    imgInfo->dibH->compr = getInt(p+0x1E); 
    imgInfo->dibH->imageSize = getInt(p+0x22); 
    printf("DIB : headerSize = %d width = %d height = %d compr = %d \n",imgInfo->dibH->headerSize,imgInfo->dibH->width,imgInfo->dibH->height,imgInfo->dibH->compr);
    // Allocate imgHeader with offset size and copy the header in it
    imgInfo->imgHeader = (unsigned char *) malloc(offset);
    memcpy(imgInfo->imgHeader,p,offset); 
}

void readColorInfo(int img_fh,Image *imgInfo) {
    int pixelCount;
    int i;
    int x,y;
    int col;
    unsigned char *buf;
    int remByteCount;
    int bytesRead;
    int bytesToRead;
    // Allocate the space before reading from image 
    imgInfo->allocateBitmap();
    buf = (unsigned char *) malloc(4096);
    // Initialization of loop variables 
    pixelCount = imgInfo->dibH->width * imgInfo->dibH->height; 
    i=0;
    x = 0 ; 
    y = 0 ; 
    remByteCount = imgInfo->dibH->imageSize;
    printf("Reading \n");
    while(remByteCount>0){
        bytesToRead = remByteCount > 4095 ? 4095 : remByteCount ; 
        bytesRead = read(img_fh,buf,bytesToRead);
        for(i=0;i<bytesRead;i+=3) {
            // The format inside the integer is {8'b0,R,G,B}
            col = ((int)buf[i]) << 16 | ((int)buf[i+1]) << 8 | ((int)buf[i+2]);
            imgInfo->COLOR(x,y) =  col;
            if ( y == 1 && x < 5 ) printf("(%d,%d) %x->%x %x %x ",x,y,col,buf[i+0],buf[i+1],buf[i+2]);
            x++;
            if (x == imgInfo->dibH->width ){
                // End of line reached 
                x = 0 ; 
                y++;
                printf("RL %d ",y);
            }
        }
        // Update end of while loop conditions 
        remByteCount -= bytesRead;
    }
    
}

void saveImageToFile(Image *imgInfo,char * fileName) {
    int dst_fh;
    int x,y;
    unsigned char *buf;
    int col;
    buf = (unsigned char *) malloc(3);
    dst_fh = open(fileName,O_TRUNC|O_CREAT|O_RDWR);
    if(dst_fh == 0) {
        perror("image save error: ");
    }
    write(dst_fh,imgInfo->imgHeader,54);
    printf("\n Writing \n");
    for(y=0;y<imgInfo->dibH->height;y++){
        for(x=0;x<imgInfo->dibH->width;x++){
            col = imgInfo->COLOR(x,y);
            buf[0] = col >> 16 & 0xFF ; 
            buf[1] = col >> 8 & 0xFF ; 
            buf[2] = col & 0xFF ; 
            write(dst_fh,buf,3);
            if (y== 1 && x < 5 ) printf("(%d,%d) %x %x %x \t",x,y,buf[0],buf[1],buf[2]);
        }
    } 
    close(dst_fh);
}

int main(){
int img_fd;
char *img_file;
char *dest_img;
unsigned char *buf;
unsigned char *imgHeader;
unsigned char **imgY;
int bytes_read;
Image *img;
    printf ("ImagePros started \n");
    img_file = (char *) malloc(256);
    dest_img = (char *) malloc(256);
    strcpy(img_file,"/home/mangesh/blacksoil/c/imagePros/desk.bmp");
    strcpy(dest_img,"/home/mangesh/blacksoil/c/imagePros/dest.bmp");
    // Mem allocation for buffer 
    buf = (unsigned char *) malloc(256);
    img_fd = open(img_file,O_RDONLY);
    if(img_fd == 0) {
        perror("image open error: ");
    }
    img = new Image ;
    bytes_read = read(img_fd,buf,54); 
    displayHeader(buf,img);
    readColorInfo(img_fd,img);
    // Close opened image
    close(img_fd);
    // The reading of the file is complete
    
    saveImageToFile(img,dest_img);
    return 0;
}
