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
#define GETRED(c) (c>>16&0xFF)
#define GETGREEN(c) (c>>8&0xFF)
#define GETBLUE(c) (c&0xFF)


// Global variables 

unsigned char **imgY;
unsigned char **imgCb;
unsigned char **imgCr;

struct DIBHeader{
    int headerSize;
    int width;
    int height;
    short int colorPlanes; // Color planes must be 1 
    short int bitPerPixel; // Number of bits per pixel
    int compr;
    int imageSize;
    int hres; // Horizontal resolution 
    int vres; // VEriticle resolution 
    int numColors; // Number of colors in pallatte
    int numImpColors; // Number of imporant colors

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
    void printInfo(){
        printf("DIB : headerSize = %d width = %d height = %d compr = %d \n",dibH->headerSize,dibH->width,dibH->height,dibH->compr);
    }
    Image * copy() {
        int y;
        Image * dest;
        dest = new Image ;
        //printf("Debug: dest Pointing to %x \n",&dest);
        printf("Debug: Starting Bmp header copy\n");
        // Copy Bitmap header
        dest->bmpH-> fileSize = bmpH-> fileSize;
        dest->bmpH-> pixelStartOffset = bmpH-> pixelStartOffset;
        // Copy dibH 
        printf("Debug: Starting dib header copy\n");
        dest->dibH-> headerSize = dibH-> headerSize ;
        dest->dibH-> width = dibH-> width;
        dest->dibH-> height = dibH-> height;
        dest->dibH-> compr = dibH-> compr;
        dest->dibH-> imageSize = dibH-> imageSize;
        //
        printf("Debug: Starting img header copy\n");
        dest->imgHeader = (unsigned char *) malloc(bmpH->pixelStartOffset);
        memcpy(dest->imgHeader,imgHeader,bmpH->pixelStartOffset); 
        // Allocate memory for bitmap first then copy the values 
        // Here the sequence of operations matters a lot , as the following function uses some the fields 
        // copied earlier 
        printf("Debug: Starting allocating dest bitmap\n");
        dest->allocateBitmap();
        printf("Debug: Starting bitmap copy\n");
        for(y=0;y<dibH->height;y++) {
            memcpy(dest->bitmap[y], bitmap[y],dibH->width);
        }
        return dest;
    }

    int allocateBitmap() {
        int y;
        bitmap = (int ** ) malloc(sizeof(int *)*dibH->height);
        for(y=0;y<dibH->height;y++) {
            bitmap[y] = (int *) malloc(sizeof(int)*dibH->width);
        }
        return 0;
    } 
};
void allocateByte(unsigned char **p, int x,int y) {
    int j;
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
short int getShortInt(unsigned char *p) {
   // It gets the integer of size 4 bytes starting from p
    short int fs;
    fs =  ((short int)p[1]) << 8 | (short int)p[0] ; 
    return fs;
 
}

void displayHeader(unsigned char *p,Image *imgInfo){
    // The function extracts information from p and updates imgHeader
    int i;
    int offset;
    printf("%c %c \n",*p,*(p+1));
    printf("File size = %d \n",getInt(p+2));
    printf("Reserved = %x %x %x %x \n",*(p+6),*(p+7),*(p+8),*(p+9));
    offset = getInt(p+10);
    printf("Pixel starts at %d \n",offset); 
    imgInfo->bmpH->pixelStartOffset = offset;
    // DIB header starts here
    imgInfo->dibH->headerSize = getInt(p+14); 
    imgInfo->dibH->width = getInt(p+18); 
    imgInfo->dibH->height = getInt(p+22);
    imgInfo->dibH->colorPlanes = getShortInt(p+26);
    imgInfo->dibH->bitPerPixel = getShortInt(p+28);
    imgInfo->dibH->compr = getInt(p+30); 
    imgInfo->dibH->imageSize = getInt(p+34); 
    imgInfo->dibH->hres = getInt(p+38); 
    imgInfo->dibH->vres = getInt(p+42); 
    imgInfo->dibH->numColors = getInt(p+46); 
    imgInfo->dibH->numImpColors = getInt(p+50); 
    printf("DIB : headerSize = %d width = %d height = %d compr = %d \n",imgInfo->dibH->headerSize,imgInfo->dibH->width,imgInfo->dibH->height,imgInfo->dibH->compr);
    printf("ImageSize = %d , something at 26 = %x \n",imgInfo->dibH->imageSize,getInt(p+26));
    printf("  hres = %x  vres = %x  numColors = %x  numImpColors = %x \n",imgInfo->dibH->hres ,imgInfo->dibH->vres ,imgInfo->dibH->numColors ,imgInfo->dibH->numImpColors);
    // rest of the info
    for(i=38;i<54;i++) {
        printf("p[%d] = %x \t",i,p[i]);
    }
    printf("\n");
    // Allocate imgHeader with offset size and copy the header in it
    imgInfo->imgHeader = (unsigned char *) malloc(offset);
    memcpy(imgInfo->imgHeader,p,offset); 
}

void readColorInfo(int img_fh,Image *imgInfo) {
    //int pixelCount;
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
    //pixelCount = imgInfo->dibH->width * imgInfo->dibH->height; 
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
                //printf("RL %d ",y);
            }
        }
        // Update end of while loop conditions 
        remByteCount -= bytesRead;
    }
    
}

void setInt(unsigned char *p,int x) {
    p[0] =  x & 0xFF;
    p[1] = (x >> 8) & 0xFF;
    p[2] = (x >> 16) & 0xFF;
    p[3] = (x >> 24) & 0xFF;
}

void saveBitmapToFile(int **bitmap,int width , int height,char * fileName) {
    unsigned char *ih; // Image header 
    int fileSize ; 
    int imgsize ; 
    int i;
    int dst_fh;
    int x,y;
    unsigned char *buf;
    int col;
    buf = (unsigned char *) malloc(3);

    ih = (unsigned char *) malloc(54);
    ih[0] = 'B';
    ih[1] = 'M';
    imgsize = width * height * 3 ; 
    fileSize = imgsize + 54 ; 
    // Filesize 
    ih[2] = fileSize & 0xFF;
    ih[3] = (fileSize >> 8) & 0xFF;
    ih[4] = (fileSize >> 16) & 0xFF;
    ih[5] = (fileSize >> 24) & 0xFF;
    // Reserved 
    setInt(ih+6,0); 
    // offset fixed to 54
    setInt(ih+10,54);
    // Header Size  40 
    setInt(ih+14,40) ;
    // Width 
    setInt(ih+18,width); 
    // Height 
    setInt(ih+22,height); 
    // Something missing at 26 
    setInt(ih+26,0x180001);
    // Compr 0 
    setInt(ih+30,0);
    // image size 
    setInt(ih+34,imgsize);
    for(i=38;i<54;i++) {
        ih[i] = 0 ; 
    }

    dst_fh = open(fileName,O_TRUNC|O_CREAT|O_RDWR);
    if(dst_fh == 0) {
        perror("image save error: ");
    }
    write(dst_fh,ih,54);
    printf("\n Writing \n");
    for(y=0;y<height;y++){
        for(x=0;x<width;x++){
            col = COLOR(x,y);
            buf[0] = col >> 16 & 0xFF ; 
            buf[1] = col >> 8 & 0xFF ; 
            buf[2] = col & 0xFF ; 
            write(dst_fh,buf,3);
            if (y== 1 && x < 5 ) printf("(%d,%d) %x %x %x \t",x,y,buf[0],buf[1],buf[2]);
        }
    } 
    close(dst_fh);
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
#define MULTSIZE 12 
void convertToGray(Image *img){
    int x,y;
    int col;
    // Integer conversion from floating point 
    // Original equation is 
    // Y = 0.299 * R + 0.587 G + 0.114 B 
    // Cb = -0.14713 * R - 0.28886 G + 0.436 B 
    // Cr = 0.615 R - 0.51499 G - 0.10001 B 
    // Lets define coefficients yr , yg , yb , etc 
    int yr,yg,yb;
    int cbr,cbg,cbb;
    int crr,crg,crb;
    int tcol;
    // Luminance component integral multipliers 
    yr = 0.299 * (1<<MULTSIZE) ;
    yg = 0.587 * (1<<MULTSIZE) ;
    yb = 0.114 * (1<<MULTSIZE) ;
   
    // Integral multipliers for Cb 
    cbr = 0.1473 * (1<<MULTSIZE) ;
    cbg = 0.28886 * (1<<MULTSIZE) ;
    cbb = 0.436 * (1<<MULTSIZE) ;
    
    // Integral multipliers for Cb 
    crr = 0.615 * (1<<MULTSIZE) ;
    crg = 0.51499 * (1<<MULTSIZE) ;
    crb = 0.10001 * (1<<MULTSIZE) ;

    for (y=0;y<img->dibH->height;y++){
        for(x=0;x<img->dibH->width;x++) {
            //printf("x , y = (%d,%d)\n",x,y);
            col = img->COLOR(x,y);
            tcol = yr * GETRED(col) + yg * GETGREEN(col) + yb * GETBLUE(col);
            tcol =  tcol >> MULTSIZE ; 
            tcol = tcol < 0 ? 0 : tcol;
            tcol = tcol >255 ? 255 : tcol;
            imgY[y][x] = tcol;
            //printf("Debug: yDone\n");
            // Cb component 
            imgCb[y][x] = -1*cbr * GETRED(col) - cbg * GETGREEN(col) + cbb * GETBLUE(col);
            tcol =  tcol >> MULTSIZE ; 
            tcol = tcol < 0 ? 0 : tcol;
            tcol = tcol >255 ? 255 : tcol;
            imgCb[y][x] = tcol;
            //printf("Debug: CbDone\n");
            // Cr component 
            imgCr[y][x] = crr * GETRED(col) - crg * GETGREEN(col) - crb * GETBLUE(col);
            tcol =  tcol >> MULTSIZE ; 
            tcol = tcol < 0 ? 0 : tcol;
            tcol = tcol >255 ? 255 : tcol;
            imgCr[y][x] = tcol;
            //printf("Debug: CrDone\n");
            
        }
    }

}
