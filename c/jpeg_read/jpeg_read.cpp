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
#define get_uint32(p) (((uint32)*((p)+1)) << 24 )
//| (((uint32)*((p)+1)) << 16 ) | (((uint32)*((p)+2)) << 8 ) | ((uint32)(*(p)+3))
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
typedef unsigned  int uint32; 



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
    unsigned char precision_0;
    unsigned char quantTblIdx_0;
    unsigned char quantVal_0[64];
    unsigned char precision_1;
    unsigned char quantTblIdx_1;
    unsigned char quantVal_1[64];
    QuantTblMarker() {
        int i;
        precision_0 = 0 ;
        precision_1 = 0 ;
        quantTblIdx_0 = 0xff;
        quantTblIdx_1 = 0xff;
        for(i=0;i<64;i++) {
            quantVal_0[i] = 0;
            quantVal_1[i] = 0;
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
#define HFTDEPTH 1024
#define HFMAXCODELEN 16

struct HuffmanCode{
      unsigned short code;
      unsigned char value;
      unsigned char codeLen;
};
class HuffmanTable{
public:
    struct HuffmanCode hfc[128];
    unsigned char codePtr;
    HuffmanTable(){
        codePtr = 0 ; 
    }
   void pushCode(unsigned short nc,unsigned char cl,unsigned char val){
        hfc[codePtr].code = nc ;
        hfc[codePtr].codeLen = cl ;
        hfc[codePtr].value = val ;
        codePtr++;
   } 
   int setCode(unsigned char *count,unsigned char *values){
        int i,j,k;
        int vidx=0;
        struct HuffmanCode **ha;//[HFTDEPTH];
        struct HuffmanCode **ha_p;//[HFTDEPTH];
        struct HuffmanCode **ha_trans;//HFTDEPTH];
        int ha_len = 0 ; 
        int ha_p_len = 0 ; 
        int allotted;
        unsigned short nc;
        ha = (struct HuffmanCode **) malloc(HFTDEPTH*sizeof(struct HuffmanCode *));
        for(i=0;i<HFTDEPTH;i++){
            ha[i] = (struct HuffmanCode *) malloc(sizeof(struct HuffmanCode));
        } 
        
        ha_p = (struct HuffmanCode **) malloc(HFTDEPTH*sizeof(struct HuffmanCode *));
        for(i=0;i<HFTDEPTH;i++){
            ha_p[i] = (struct HuffmanCode *) malloc(sizeof(struct HuffmanCode));
        } 
        // Initialize ha and ha_p 
        for(i=0;i<HFTDEPTH;i++){
            ha[i]->code = 0 ; 
            ha[i]->codeLen = 0 ; 
            ha_p[i]->code = 0 ; 
            ha_p[i]->codeLen = 0 ; 
        }
 
        ha_p_len = 1 ; 
        for(i=1;i<HFMAXCODELEN;i++) {
            allotted = 0 ;
            ha_len = 0;
            for(j=0;j<ha_p_len;j++) {
                nc = ha_p[j]->code << 1 ;
                if(allotted < count[i]){
                    pushCode(nc,i,values[vidx++]);
                    allotted++;
                }else{
                    ha[ha_len]->code = nc;
                    ha[ha_len]->codeLen = i;
                    ha_len++;
                }
                nc = nc | 0x1 ;
                if(allotted < count[i]){
                    pushCode(nc,i,values[vidx++]);
                    allotted++;
                }else{
                    ha[ha_len]->code = nc;
                    ha[ha_len]->codeLen = i;
                    ha_len++;
                }

            } 

            // Copy the contents of ha to ha_p  
           ha_trans = ha_p;
           ha_p = ha;
           ha = ha_trans; 
           ha_p_len = ha_len;
        }
   }
    void display(){
        int i;
        printf("\nCode\tCodeLen\tValue\n");
        for(i=0;i<codePtr;i++){
            printf("%x\t %d\t %x \n",hfc[i].code,(int)hfc[i].codeLen,(int)hfc[i].value);            

        }
    }
         
};
#define HUFFMAN_LOOKUP_WIDTH 16
#define HUFFMAN_LOOKUP_DEPTH (1<<16)
struct LookupTable{
    unsigned char num; // Number of codes contained in this struct 
    unsigned char remNum; // Number of unused bits in this set of WIDTH
    unsigned char val[HUFFMAN_LOOKUP_WIDTH/2];
    unsigned char codeLen[HUFFMAN_LOOKUP_WIDTH/2];
};
class HuffmanLookup{
    public :
    struct LookupTable lkpt[HUFFMAN_LOOKUP_DEPTH];
    void display(){
        int i;
        int j;
        for(i=0;i<64;i++){
            printf("Lookup info for Idx = %04x  Valid code = %d num of unused bits = %d \n",i,lkpt[i].num,lkpt[i].remNum);
            for(j=0;j<lkpt[i].num;j++){
                printf("\t\t value = %x \n",lkpt[i].val[j]);
            }
        }
    }
    void setLookUpTable(HuffmanTable *ht){
        unsigned int idx;
        unsigned int tidx; // Temporary shadow of idx 
        unsigned int v;
        unsigned int cl; // CodeLens 
        unsigned short code;
        unsigned char codeFound;
        unsigned char remNum;
        unsigned short ctv; // Code Table values
        for(idx=0;idx<HUFFMAN_LOOKUP_DEPTH;idx++){
        //for(idx=0;idx<64;idx++){
            lkpt[idx].num=0;
            lkpt[idx].remNum=0;
            tidx =  idx;
            remNum = HUFFMAN_LOOKUP_WIDTH ;
            do{
               codeFound = 0 ;
               for(cl=2;cl<=remNum;cl++){
                     code = tidx>>(16-cl); // 16 because size of tidx is 16 
                     // Match this code against CodeTable values
                     for(ctv=0;ctv<ht->codePtr;ctv++){
                           if(ht->hfc[ctv].codeLen == cl) {
                               // CodeLen matches , now go for code match 
                               if(ht->hfc[ctv].code == code) {
                                   // This is matching code
                                   lkpt[idx].val[lkpt[idx].num] = ht->hfc[ctv].value;
                                   lkpt[idx].codeLen[lkpt[idx].num] = cl;
                                   lkpt[idx].num++;
                                   // Remove this bits from rest of code
                                   tidx = tidx << cl;
                                   codeFound = 1; 
                                   remNum -= cl;
                                   break; 
                               }
                           }
                   }
                   if(codeFound == 1) {
                       break;
                   } 
               }
            }while(codeFound == 1);
            lkpt[idx].remNum = remNum;
        }
        
    }
     
};
class HuffmanMarker {
public:
    unsigned char tbl_class; // DC = 0 and AC = 1 
    unsigned char identifier; // Luma = 0 , Chroma = 1  
    // The values in 4 rows are indexed by 
    // identifier * 2 + tbl_class 
    unsigned char codesOfLen[4][17];
    unsigned char values[4][96];
   
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

class SOSMarker {
public :
    unsigned char nComponent;
    // Following two fields are per component 
    unsigned char cid[3];
    unsigned char tbl[3];
    unsigned char ident[3];
    unsigned char misc[12];
    unsigned char spectSelect[2] ; // Spectral selection 
    unsigned char sAprox; // Successive approximation 
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
    idx=0;
    precision_0 = p[0] >> 4 ;
    quantTblIdx_0 = p[0] & 0xf;
    idx++;
    // Mangesh TODO You may need to enter these values in zig-zag format 
    for(i=0;i<64;i++,idx++){
        quantVal_0[i] = p[idx];
        printf("idx=%d ",idx);
        printf("%d ",p[idx]);
    }
    precision_1 = p[idx] >> 4 ;
    quantTblIdx_1 = p[idx] & 0xf;
    idx++;
    for(i=0;i<64;i++,idx++){
        quantVal_1[i] = p[idx];
    }
    return idx; 
}

void QuantTblMarker::display(){
    int i;
    printf("Quantization Table marker \n");
    printf("Precision = %x Quantization Table index = %x \n",precision_0,quantTblIdx_0);
    printf("Quantization table \n");
    for(i=0;i<64;i++) {
        printf("%x\t",quantVal_0[i]);
        if(i%8==7) printf("\n");
    }
    printf("Precision = %x Quantization Table index = %x \n",precision_1,quantTblIdx_1);
    printf("Quantization table \n");
    for(i=0;i<64;i++) {
        printf("%x\t",quantVal_1[i]);
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
    int k;
    printf("\n");
    for(k=0;k<20;k++){
        printf("%x",*(p+k));
    }
    
    printf("\n");
    for(k=0;k<4;k++) { 
        tbl_class = *(p+idx) >> 4 ; 
        identifier = *(p+idx) & 0xf;
        idx++;
        for(i=0;i<16;i++){
            codesOfLen[identifier*2+tbl_class][i+1] = p[idx];
            printf("CodeofLen(%d) = %d at idx = %d\n",i+1,codesOfLen[identifier*2+tbl_class][i+1],idx);
            idx++;
        }
        cnt = 0;
        for(i=1;i<=16;i++){
            for(j=0;j<codesOfLen[identifier*2+tbl_class][i];j++){
                values[identifier*2+tbl_class][cnt++] = p[idx++];
            }
        }
        valuesCount = cnt;
        display();
   }

}
void HuffmanMarker::display(){
    int idx;
    int i;
    int j;
    int k ; 
    printf("HuffmanMarker \n");
    for(k=0;k<3;k++) { 
            printf("table class = %x  ",k%2);
            printf("identifier  = %x  ",k/2);
            printf("Codes of Length \n");
            i = 0 ; 
            
            for(idx=1;idx<=16;idx++){
                printf("\nC[%d] = %x\t",idx,codesOfLen[k][idx]); ;
                for(j=0;j< codesOfLen[k][idx];j++){
                    printf(" %X",values[k][i]);
                    i++;
                }
                
            }
         printf("\n"); 
    }
    /*
    printf("\n Values ...Count = %x \n",valuesCount);
    for(i=0;i<valuesCount;i++){
        printf("%x\t",values[identifier*2+tbl_class][i]);
    }
    */
    
}
int setFields(unsigned char *p){

}
void APP12Marker::display(){
    printf("APP12 Marker \n");
    printf("%s\n",info);
}


int SOSMarker::setFields(unsigned char *p){
   int i;
   int idx;
   idx  = 0;
   nComponent = p[idx++];
   for(i=0;i<nComponent;i++){
       cid[i] = p[idx++];
       tbl[i] = p[idx] >> 4 ;
       ident[i] = p[idx] & 0xf; 
       idx++;
   }
   spectSelect[0] = p[idx++];
   spectSelect[1] = p[idx++];
   sAprox = p[idx++];
   return idx;
}

void SOSMarker::display(){
   int i;
   printf("\n-------------------Start of Scan Marker \n");
   for(i=0;i<nComponent;i++){
        printf("Component %d cid = %d table = %d Identifier = %d \n",i,cid[i],tbl[i],ident[i]);
    }
    printf("Spectral selection %d to %d \n",spectSelect[0],spectSelect[1]);
    printf("Successive Approximation = %d \n",sAprox);
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

void decode(unsigned char *p, HuffmanLookup *huff[4]) {
    int i;
    unsigned short rx;
    unsigned int rxp;
    unsigned char val;
    unsigned char remNum;
    unsigned char len;
    unsigned char rxResidue;
    unsigned short ab; // additional bits 
    int dcVal;
    printf("String for decoding\n");
    for(i=0;i<64;i++){
        printf("%02x ",p[i]);
    }
    printf("\n");
    rxResidue =32 ; 
    rxp = get_uint16(p);
    p+=4;
    rx = rxp;
    printf("rx = %x rxp = %x \n");
    if (rx == 0xFF00) {
        // Remove the stuffed 0s
        rx = rx | p[0]; 
        p++;
    }
    if(huff[0]->lkpt[rx].num <= 0) {
        printf("ERROR: Invalid code\n");
    }else{
        val = huff[0]->lkpt[rx].val[0];
        len = huff[0]->lkpt[rx].codeLen[0];
        printf("Val = %d len = %d \n",val,len);
        rx = rx << len; // Move out searched bit
        rxp = rxp << len;
        rxResidue -= len;
        while(rxResidue <= 24) {
            rxp = rxp | (((unsigned int)p[0])<<(32-rxResidue-8));
            p++;
            rxResidue += 8 ;
        }
        // Get in bits from p to fillrx
        // Get val bits from stream, it represent additional bits 
        ab = rxp >> (32-val); 
        rxp = rxp << val;
        rxResidue -= val;
        while(rxResidue <= 24) {
            rxp = rxp | (((unsigned int)p[0])<<(32-rxResidue-8));
            p++;
            rxResidue += 8 ;
        }

        // You have val and additional bits find out present dc value
       if(ab < (1<<(val-1))) { 
           dcVal = ab  - (1<<val) +1 ;
       }else{
            dcVal = ab;
       }
       printf("DCVAl = %d ab = %d\n",dcVal,ab); 

    }
}

int main(int argc,char **argv) {

char *img_file;
int img_fd;
    unsigned char *buf;
    int bytes_read;
    int pros;
    int i;
    uint16 marker;
    uint16 length;
    unsigned char end_reached ; 
    int  agcCount = 1;
    char *argP;

    JFIFSegment *jfif;
    QuantTblMarker *quantTbl;
    HuffmanMarker *huffmanMarker;
    SOFMarker *sofMarker;
    SOSMarker *sosMarker;
    HuffmanTable *hft[4];
    HuffmanLookup *hfl[4];
    img_file = (char *) malloc(256);
    
    buf = (unsigned char *) malloc(4096);
    //jfif = new JFIFSegment;
    jfif = (JFIFSegment *) malloc(sizeof(JFIFSegment));
    strcpy(img_file,"/home/mangesh/blakcsoil/c/jpeg_read/sky_main.jpg");
    argP= (char *) malloc(256);
    if(argc > 0) {
         for(i=0;i<argc;i++){
            printf("Inputs = %s\n",argv[i]);
        }
        while(agcCount < argc) { 
            strcpy(argP,argv[agcCount]);
            if(strstr(argP,"-f")!=NULL){
                if(argc>agcCount+1) {
                    strcpy(img_file,argv[agcCount+1]);
                    agcCount++;
                }
            }
            if(strstr(argP,"-h")!=NULL){
                printf("Display Help\n");
                return 0;
            }
            agcCount++;
        } 
    }
    img_fd = open(img_file,O_RDONLY);
    if(img_fd <= 0) {
        printf("Error reading file %s \n",img_file);
        perror("image open error: ");
        return 1;
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
            int hidx;
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
            huffmanMarker = (HuffmanMarker *) malloc(sizeof(HuffmanMarker));
            huffmanMarker->setFields(buf);
            huffmanMarker->display();
            // Make the Huffman table
            //hidx = huffmanMarker->identifier * 2 + huffmanMarker->tbl_class ;
            for(hidx=0;hidx <4;hidx++){
                hft[hidx] = (HuffmanTable *) malloc(sizeof(HuffmanTable));
                hft[hidx]->setCode(huffmanMarker->codesOfLen[hidx],huffmanMarker->values[hidx]);
                printf("Huffman Table number = %d \n",hidx);
                hft[hidx]->display();
                //

                hfl[hidx] = (HuffmanLookup *) malloc(sizeof(HuffmanLookup));
                hfl[hidx]->setLookUpTable(hft[0]);
            }

       }else if (marker == SOF) {
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
            sofMarker = (SOFMarker *) malloc(sizeof(SOFMarker));
            sofMarker->setFields(buf);
            sofMarker->display();
       }else if (marker == SOSM) {
            printf("\nSOSM Start of Scan Marker needs info \n");
            bytes_read = read(img_fd,buf,2);
            length = get_uint16(buf);
            printf("length = %x \n",length);
            bytes_read = read(img_fd,buf,length-2);
            sosMarker = (SOSMarker *) malloc(sizeof(SOSMarker));
            sosMarker->setFields(buf);
            sosMarker->display();
           for(i=0;i<length-2;i++){
              printf("%x\t",buf[i]);
           }
            // At this point, start reading actual data
            printf("\n");
            bytes_read = read(img_fd,buf,64);
            decode(buf,hfl); 

       }else{
            printf("Unknown marker reached = %x at offset = %d (%x)\n", marker,(int)lseek(img_fd,0,SEEK_CUR),(int)lseek(img_fd,0,SEEK_CUR));
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
            printf("Bytes = %x\t",buf[0]);
            bytes_read = read(img_fd,buf,2);
            printf("%x %x at %d \n",buf[0],buf[1],(int)lseek(img_fd,0,SEEK_CUR));
          }
       }
     if((pros=lseek(img_fd,0,SEEK_CUR)) < 0) {
         printf("ERROR : lseek \n");
     }
       printf("\nseeking = %d Rest of info \n",pros);

    /*
     printf("Huffman table \n");
     hft = (HuffmanTable *) malloc(sizeof(HuffmanTable));
     hft->setCode(huffmanMarker->codesOfLen[1],huffmanMarker->values[1]);
     hft->display();
     hfl = (HuffmanLookup *) malloc(sizeof(HuffmanLookup));
     hfl->setLookUpTable(hft[0]);
     hfl->display();
    */

return 1;
}
