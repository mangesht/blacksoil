#include "imagePros.h"

int main(){
int img_fd;
char *img_file;
char *dest_img;
unsigned char *buf;
unsigned char *imgHeader;
int bytes_read;
Image *img;
Image *gsImg;
// Temporary variables
int tCol;
int x,y;
int i,j;
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
    
    // Convert the file to gray scale and Cb Cr 
    //allocateByte(imgY,img->dibH->width,img->dibH->height);
    imgY = (unsigned char **) malloc(sizeof(unsigned char *)*img->dibH->height);
    for(j=0;j<img->dibH->height;j++) {
       imgY[j] = (unsigned char *) malloc(sizeof(unsigned char)*img->dibH->width);
    }

//    allocateByte(imgCb,img->dibH->width,img->dibH->height);
    imgCb = (unsigned char **) malloc(sizeof(unsigned char *)*img->dibH->height);
    for(j=0;j<img->dibH->height;j++) {
       imgCb[j] = (unsigned char *) malloc(sizeof(unsigned char)*img->dibH->width);
    }
    // allocateByte(imgCr,img->dibH->width,img->dibH->height);
    imgCr = (unsigned char **) malloc(sizeof(unsigned char *)*img->dibH->height);
    for(j=0;j<img->dibH->height;j++) {
       imgCr[j] = (unsigned char *) malloc(sizeof(unsigned char)*img->dibH->width);
    }


    printf("Debug: Image file closed\n");
    convertToGray(img);
    printf("Debug: Gray scale conversion done\n");
    gsImg = new Image;
    //printf("Debug: gsImage Pointing to %x \n",gsImg);

    gsImg = img->copy();
    gsImg->printInfo();
    printf("Debug: Image copy done\n");
    // Now assign bitmap of gsImg with Y component computed above
    for(y=0;y<gsImg->dibH->height;y++){
        for(x=0;x<gsImg->dibH->width;x++) {
            tCol = imgY[y][x] & 0xFF;
            tCol = tCol << 16 | tCol << 8 | tCol ; 
                gsImg->bitmap[y][x] = tCol; 
        }
    }
    printf("Debug: Copying Y to GsImg done \n"); 
    //saveImageToFile(gsImg,dest_img);
    saveBitmapToFile(gsImg->bitmap,gsImg->dibH->width,gsImg->dibH->height,dest_img);
    printf("Debug: File saving done \n");
    return 0;
}
