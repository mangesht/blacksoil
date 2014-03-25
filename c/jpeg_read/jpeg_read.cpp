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
#include<unistd.h>
#define get_uint16(p) (uint16((*((p)+0) << 8 )+ *((p)+1)))
#define SOI 0xFFD8
#define EOI 0xFFD9
#define APP0 0xFFE0
#define APP2 0xFFE2
#define APP1 0xFFE1
#define APP12 0xFFEC
#define APP13 0xFFED
#define APP14 0xFFEE
#define QUANT 0xFFDB
#define HUFFMAN 0xFFC4
#define SOF 0xFFC0
#define SOSM 0xFFDA

typedef unsigned short int uint16; 

class JFIFSegment { 
   public : 
    int count ;
    uint16 app0_marker;
    uint16 length;
    char identifier[5];
    uint16 version ;
    unsigned char den_units;
    uint16 x_den;
    uint16 y_den;
    unsigned char tw; // Thumbnail width 
    unsigned char th; // Thumbnail height
    // 18 bytes till this point 

    int *th_data; // Uncompressed 24 bit RGB raster thumbnail data 

    // Methods 
    JFIFSegment(){
        app0_marker = 0;
        count = 0 ; 
    }
    int setFields(unsigned char *p);
    void display();
    int readThumbnailData(unsigned char *p, int tw,int th);

};

// It extracts the stream and sets header fields 
int JFIFSegment::setFields(unsigned char *p) {
    int idx=0;
    //app0_marker = get_uint16(p+idx);
    //idx+=2;
    //length = get_uint16(p+idx);
    //idx+=2;
    int i;
    count++;
    printf("Setfileds \n");
    for(i=0;i<11;i++){
       printf("%x\t",p[i]); 
    }
    strncpy(identifier,(const char *)(p+idx),5);
    idx+=5;
    version = get_uint16(p+idx);
    idx+=2;
    den_units = *(p+idx++);
    x_den = get_uint16(p+idx);
    idx+=2;
    y_den = get_uint16(p+idx);
    idx+=2;
    tw = *(p+idx++);
    th = *(p+idx++);
    return idx;
}

int JFIFSegment::readThumbnailData(unsigned char *p, int tw,int th){
    int idx=0;
    
    return 0;
    
}

void JFIFSegment::display(){
     printf("\n");
     printf(" count = %2x\t",count);
     printf(" app0_marker = %2x\t",app0_marker);
     printf(" length = %2x\t",length);
     printf("identifier = %s\t",identifier);
     printf(" version = %2x\t",version);
     printf(" den_units = %2x\t",den_units);
     printf(" x_den = %2x\t",x_den);
     printf(" y_den = %2x\t",y_den);
     printf(" tw = %2x\t",tw);
     printf(" th = %2x\t",th);
     printf("---------------\n");
    return;
}

int getInt(unsigned char *p) {
   // It gets the integer of size 4 bytes starting from p
    int fs;
    fs = ((int)p[3])<<24 | ((int)p[2]) << 16 | ((int)p[1]) << 8 | (int)p[0] ; 
    return fs;
 
}

void displayJpegHeader(unsigned char *p) {
    int i;
    printf("JPEG Header starts as : \n");
    for(i=0;i<50;i++) { 
        printf("%x\t",p[i]);
    }
    printf("\n");

}

int main() {

char *img_file;
int img_fd;
    unsigned char *buf;
    int bytes_read;
    int pros;
    int i;
    uint16 marker;
    uint16 length;
    unsigned char end_reached ; 

    JFIFSegment *jfif;
    img_file = (char *) malloc(256);
    buf = (unsigned char *) malloc(4096);
    //jfif = new JFIFSegment;
    jfif = (JFIFSegment *) malloc(sizeof(JFIFSegment));
    strcpy(img_file,"/home/mangesh/blakcsoil/c/jpeg_read/sky_main.jpg");
    img_fd = open(img_file,O_RDONLY);
    if(img_fd <= 0) {
        printf("Error reading file %s \n",img_file);
        perror("image open error: ");
    }
    bytes_read = read(img_fd,buf,50);
   displayJpegHeader(buf);

    
    if((pros=lseek(img_fd,0,SEEK_SET)) < 0) {
        printf("ERROR: lseek\n");
    }
    printf("Lseek = %d \n",pros);
    end_reached = 0;
    while(!end_reached) { 
       bytes_read = read(img_fd,buf,2); 
       printf("Bytes Read = %d image handle = %x \n",bytes_read,img_fd);
       marker = get_uint16(buf);
       printf("Marker = %x \t",marker);
       if(marker == SOI) {
       }else if (marker == EOI) {
            end_reached = 1;
       }else if (marker == APP0) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
            pros= jfif->setFields(buf);
            printf("After setFields = %d \n",pros);
            jfif->display();
       }else if (marker == APP2) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
       }else if (marker == APP12 || marker == APP14) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
       }else if (marker == QUANT) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
       }else if (marker == HUFFMAN) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
       }else if (marker == SOF) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
       }else if (marker == SOSM) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
           for(i=0;i<length-2;i++){
              printf("%x\t",buf[i]);
           }
       printf("\n");

       }else{
            printf("Unknown marker reached = %x \n", marker);
            end_reached = 1;
       }
    }
            printf("After setFields = %d \n",pros);
            jfif->display();
       //displayJpegHeader(buf);

     if((pros=lseek(img_fd,0,SEEK_CUR)) < 0) {
         printf("ERROR : lseek \n");
     }
       printf("\nseeking = %d Rest of info \n",pros);
       bytes_read = read(img_fd,buf,24);
       for(i=0;i<24;i++){
           printf("%x\t",buf[i]);
       }
       printf("\n");
                end_reached = 0 ;
       while(!end_reached) {
          bytes_read = read(img_fd,buf,1);
          if(buf[0] == 0xFF) { 
            bytes_read = read(img_fd,buf,1);
            printf("Marker = %x %x\n",0xFF,buf[0]);
            if(buf[0] == 0xD9) { 
                end_reached = 1 ;
            }
          }
       }
     if((pros=lseek(img_fd,0,SEEK_CUR)) < 0) {
         printf("ERROR : lseek \n");
     }
       printf("\nseeking = %d Rest of info \n",pros);

return 1;
}
