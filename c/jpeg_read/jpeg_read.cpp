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

class QuantTblMarker {
public : 
    unsigned char precision;
    unsigned char quantTblIdx;
    unsigned char quantVal[64];
    QuantTblMarker() {
        int i;
        precision = 0 ;
        quantTblIdx = 0xff;
        for(i=0;i<64;i++) {
            quantVal[i] = 0;
        }
    }
    
    int setFields(unsigned char *p);
    void display();
};

class SOFMarker{
public:
    unsigned char precision;
    uint16 Y;
    uint16 X;
    unsigned char Nf;
    unsigned char CID[3]; // For maximum 3 components for color baseline JPEG images 
    unsigned char H[3];
    unsigned char V[3];
    unsigned char quantTblIdx[3];

    SOFMarker(){
        Nf=0;
    }
    int setFields(unsigned char *p);
    void display();
};

class HuffmanMarker {
public:
    unsigned char tbl_class;
    unsigned char identifier;
    unsigned char codesOfLen[17];
    unsigned char values[96];
   
    unsigned char valuesCount; 
    HuffmanMarker(){
        identifier = 0;
        valuesCount = 0;
    }
    int setFields(unsigned char *p);
    void display();
};

class APP12Marker {
public:
    unsigned char *info;
    int setFields(unsigned char *p);
    void display();
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
     printf("JFIF Segment \n");
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
int QuantTblMarker::setFields(unsigned char *p){
    int idx;
    int i;
    precision = p[0] >> 4 ;
    quantTblIdx = p[0] & 0xf;
    idx++;
    // Mangesh TODO You may need to enter these values in zig-zag format 
    for(i=0;i<64;i++,idx++){
        quantVal[i] = p[idx];
    }
    return idx; 
}

void QuantTblMarker::display(){
    int i;
    printf("Quantization Table marker \n");
    printf("Precision = %x Quantization Table index = %x \n",precision,quantTblIdx);
    printf("Quantization table \n");
    for(i=0;i<64;i++) {
        printf("%x\t",quantVal[i]);
        if(i%8==7) printf("\n");
    }
    
}

int SOFMarker::setFields(unsigned char *p){
    int idx=0;
    int i;
    precision = *(p+idx++);
    Y = get_uint16(p+idx);
    idx+=2;
    X = get_uint16(p+idx);
    idx+=2;
    Nf = *(p+idx++);
    for(i=0;i<Nf;i++){
        CID[i] = *(p+idx++);
        H[i] = *(p+idx) >> 4;
        V[i] = *(p+idx) &  0xf;
        idx++;
        quantTblIdx[i] = *(p+idx++);
    }

    return idx;
}

void SOFMarker::display(){
    int i;
    printf("SOFMarker : ");
    printf("Y =  %x \t",Y);
    printf("X =  %x \t",X);
    printf("Nf  %x \t",Nf);
    for(i=0;i<Nf;i++){
        printf("\nCID  %x \t",CID[i]);
        printf("H  %x \t",H[i]);
        printf("V  %x \t",V[i]);
        printf("Qunatization Table num  %x \t",quantTblIdx[i]);
    }
    printf("\n");
}
int HuffmanMarker::setFields(unsigned char *p){
    int idx =0;
    int i;
    int j;
    int cnt;
    tbl_class = *(p+idx) >> 4 ; 
    identifier = *(p+idx) & 0xf;
    for(idx=1;idx<=16;idx++){
        codesOfLen[idx] = p[idx];
    }
    cnt = 0;
    for(i=1;i<=16;i++){
        for(j=0;j<codesOfLen[i];j++){
            values[cnt++] = p[idx++];
        }
    }
    valuesCount = cnt;

}
void HuffmanMarker::display(){
    int idx;
    int i;
    int j;
    printf("HuffmanMarker \n");
    printf("table class = %x \t ",tbl_class);
    printf("identifier  = %x \t ",identifier);
    printf("Codes of Length \n");
    for(idx=1;idx<=16;idx++){
        printf("C[%x] = %x\t",idx,codesOfLen[idx]); ;
    }
    printf("\n Values ...Count = %x \n",valuesCount);
    for(i=0;i<valuesCount;i++){
        printf("%x\t",values[i]);
    }
    
    printf("\n"); 
    
}
int setFields(unsigned char *p){

}
void APP12Marker::display(){
    printf("APP12 Marker \n");
    printf("%s\n",info);
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
    QuantTblMarker *quantTbl;
    HuffmanMarker *huffmanMarker;
    SOFMarker *sofMarker;
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
       //printf("Bytes Read = %d image handle = %x \n",bytes_read,img_fd);
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
       }else if ( marker == APP14) {
            printf("APP12 or APP14  Marker needs info \n");
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
       }else if (marker == APP12) {
            printf("App12 Old Camera info \n");
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
            printf("info = %s \n",buf);
       }else if (marker == QUANT) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
            //quantTbl = new QuantTblMarker;
            quantTbl = (QuantTblMarker *) malloc(sizeof(QuantTblMarker));
            quantTbl->setFields(buf);
            quantTbl->display();
       }else if (marker == HUFFMAN) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
            huffmanMarker = (HuffmanMarker *) malloc(sizeof(HuffmanMarker));
            huffmanMarker->setFields(buf);
            huffmanMarker->display();
       }else if (marker == SOF) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
            sofMarker = (SOFMarker *) malloc(sizeof(SOFMarker));
            sofMarker->setFields(buf);
            sofMarker->display();
       }else if (marker == SOSM) {
            printf("SOSM Marker needs info \n");
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
            printf("Marker = %x %x\t",0xFF,buf[0]);
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
