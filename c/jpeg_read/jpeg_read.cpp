#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<errno.h>
#include<string.h>
#include<math.h> 
#include<sys/stat.h>
#include<sys/types.h>
#include<sys/wait.h>
#include<signal.h>
#include<fcntl.h>
#include<unistd.h>
#include "imagePros.h"

#define get_uint16(p) (uint16((*((p)+0) << 8 )+ *((p)+1)))
#define get_uint32(p) (((uint32)*((p)+0)) << 24 ) | (((uint32)*((p)+1)) << 16 ) | (((uint32)*((p)+2)) << 8 ) | ((uint32)*((p)+3))
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
int zigZagToLinear[64]; 
int LinearToZigZag[64] = { 
        0 ,  1,  5,  6, 14, 15, 27, 28,
        2 ,  4,  7, 13, 16, 26, 29, 42,
        3 ,  8, 12, 17, 25, 30, 41, 43,
        9 , 11, 18, 24, 31, 40, 44, 53,
        10, 19, 23, 32, 39, 45, 52, 54,
        20, 22, 33, 38, 46, 51, 55, 60,
        21, 34, 37, 47, 50, 56, 59, 61,
        35, 36, 48, 49, 57, 58, 62, 63
};


void setUpZigZagToLinear(){
    int i;
    for(i=0;i<64;i++){ 
        zigZagToLinear[LinearToZigZag[i]] = i ; 
    }
}
void display_8_8(short int  *p){
    int i,j;
    printf("\n");
    for(i=0;i<8;i++){
        for(j=0;j<8;j++){
            printf("%4d ",p[i*8+j]);
        }
        printf("\n");
    }
    
}

void display_8_8_2d(short int clear_8_8[8][8]) {
    int i,j;
    printf("\n");
    for(i=0;i<8;i++){
        for(j=0;j<8;j++){
            printf("%4x ",clear_8_8[i][j]);
        }
        printf("\n");
    }
}
void display_8_8_2di(int clear_8_8[8][8]) {
    int i,j;
    printf("\n");
    for(i=0;i<8;i++){
        for(j=0;j<8;j++){
            printf("%4x ",clear_8_8[i][j]);
        }
        printf("\n");
    }
}


//-------------------IDCT 
float C(int u){
    if(u==0) return(1.0f/sqrtf(2));
    else return 1.0f;
}

int calcIDCTxy(int x, int y, const short int block[8][8])
{
	const float PI = 3.14f;
    float sum=0;
    for( int u=0; u<8; u++)
    {
         for(int v=0; v<8; v++)
         {
             sum += ( C(u) * C(v) ) * block[u][v] * cosf( ((2*x+1) * u * PI) / 16)  * cosf( ((2*y+1) * v * PI) / 16);
         }
    }         
    return (int) ((1.0/4.0) * sum);
}

void PerformIDCT(short int outBlock[8][8], const short int inBlock[8][8])
{
	for(int y=0; y<8; y++)
	{
		for(int x=0; x<8; x++)
		{
			outBlock[x][y]  =  calcIDCTxy( x, y, inBlock);
		}
	}
}
//----------------------------------
// Color Space conversion 

unsigned int YCbCrToRGB(short int Y,short int Cb , short int Cr) { 
   // The equations are 
   /*
        R = 298 * Y / 256  + 408 * Cr / 256 - 223 
        G = 298 * Y / 256  - 100 * Cb / 256 - 208 * Cr / 256 + 135
        B = 298 * Y / 256  + 516 * Cb / 256 - 277
   */
    short int R,G,B;
    int res = 0 ; 
        /*
        R = (298.0 *(float)Y / 256.0 + 408.0*(float)Cr / 256.0- 223.0);
        G = (298.0 *(float)Y / 256.0 - 100.0*(float)Cb / 256.0- 208.0* (float)Cr / 256.0 + 135.0) ; 
        B = (298.0 *(float)Y / 256.0 + 516.0*(float)Cb / 256.0- 277.0); 
        */
        R = Y + 1.402 * (Cr-128);
        G = Y - 0.34414* (Cb-128) - 0.71414 * ( Cr-128);
        B = Y + 1.772 * ( Cb - 128); 
        
        if(R <0) {
            printf(" r = %d %d %d %d ",R,Y,Cb,Cr);
            res = 1; 
        }
        if(G <0) {
            printf(" g = %d %d %d %d ",G,Y,Cb,Cr);
            res = 1; 
        }
        if(B <0) {
            printf(" b = %d %d %d %d ",B,Y,Cb,Cr);
            res = 1; 
        }
        R = R < 0 ? 0 : R > 255 ? 255 : R ;
        G = G < 0 ? 0 : G > 255 ? 255 : G ;
        B = B < 0 ? 0 : B > 255 ? 255 : B ;
        //G = G < 0 ? 0 : G & 0xFF;
        //B = B < 0 ? 0 : B & 0xFF;
        //res = (R << 16) | (G<<8) | B ; 
        res = (res << 24 )| ((int)B << 16) | ((int)G<<8) | (int)R ; 
        //res = res & 0xFF00FF;

    return res;
}



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
    unsigned char quantVal[2][64];
    unsigned char precision_1;
    unsigned char quantTblIdx_1;
    QuantTblMarker() {
        int i;
        precision_0 = 0 ;
        precision_1 = 0 ;
        quantTblIdx_0 = 0xff;
        quantTblIdx_1 = 0xff;
        for(i=0;i<64;i++) {
            quantVal[0][i] = 0;
            quantVal[1][i] = 0;
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
        int i,j;
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
        return 1;
    }
    void display(){
        int i;
        printf("\nCode\tCodeLen\tValue\n");
        for(i=0;i<codePtr;i++){
            printf("%x\t %d\t %x \n",hfc[i].code,(int)hfc[i].codeLen,(int)hfc[i].value);            
            
        }
    }
    
};
#define HUFFMAN_LOOKUP_WIDTH 14
#define HUFFMAN_LOOKUP_DEPTH (1<< HUFFMAN_LOOKUP_WIDTH)
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
        unsigned int cl; // CodeLens 
        unsigned short code;
        unsigned char codeFound;
        unsigned char remNum;
        unsigned short ctv; // Code Table values
        int maxCtv = 0;
        for(idx=0;idx<HUFFMAN_LOOKUP_DEPTH;idx++)
        //for(idx=0;idx<64;idx++)
        {
            //printf("idx = %d ",idx);
            //printf("idx = %d \n",idx);
            lkpt[idx].num=0;
            lkpt[idx].remNum=0;
            tidx =  idx;
            remNum = HUFFMAN_LOOKUP_WIDTH ;
            do{
                codeFound = 0 ;
                //printf("%d ",idx);
                for(cl=1;cl<=remNum &&  lkpt[idx].num  < 3 ;cl++){
                    
                    code = tidx>>(HUFFMAN_LOOKUP_WIDTH -cl); // 16 because size of tidx is 16 
                    // Match this code against CodeTable values
                    for(ctv=0;ctv<ht->codePtr;ctv++){
                        if(ctv > maxCtv) { 
                            maxCtv = ctv; 
                            printf("Max Reached value  = %d \n",maxCtv);
                        }
                        if(ht->hfc[ctv].codeLen == cl) {
                            // CodeLen matches , now go for code match 
                            if(ht->hfc[ctv].code == code) {
                                // This is matching code
                                if(cl==1) {
                                    //printf("Code match for cl == 1 %d idx = %x ctvIdx= %d lkpt_valid num = %d code = %x \n",cl,idx,ctv,lkpt[idx].num,code);
                                }
                                //printf("Lookup Idx num = %d \n",lkpt[idx].num);
                                lkpt[idx].val[lkpt[idx].num] = ht->hfc[ctv].value;
                                lkpt[idx].codeLen[lkpt[idx].num] = cl;
                                // Remove this bits from rest of code
                                //if(cl==1) {printf("%d ",lkpt[idx].num); continue;}
                                if(cl ==1){
                                    lkpt[idx].num++;
                                    tidx = (tidx << 1) & ((1<<HUFFMAN_LOOKUP_WIDTH)-1);
                                    codeFound = 1; 
                                    remNum --;
                                }else { 
                                    lkpt[idx].num++;
                                    tidx = ( tidx << cl) & ((1<<HUFFMAN_LOOKUP_WIDTH)-1);
                                    codeFound = 1; 
                                    remNum -= cl;
                                }
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
    unsigned char identifier; // Y Luma = 0 , Chroma = 1  
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
    
    return idx;
    
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
        quantVal[0][i] = p[idx];
        printf("idx=%d ",idx);
        printf("%d ",p[idx]);
    }
    precision_1 = p[idx] >> 4 ;
    quantTblIdx_1 = p[idx] & 0xf;
    idx++;
    for(i=0;i<64;i++,idx++){
        quantVal[1][i] = p[idx];
    }
    return idx; 
}

void QuantTblMarker::display(){
    int i;
    printf("Quantization Table marker \n");
    printf("Precision = %x Quantization Table index = %x \n",precision_0,quantTblIdx_0);
    printf("Quantization table \n");
    for(i=0;i<64;i++) {
        printf("%x\t",quantVal[0][i]);
        if(i%8==7) printf("\n");
    }
    printf("Precision = %x Quantization Table index = %x \n",precision_1,quantTblIdx_1);
    printf("Quantization table \n");
    for(i=0;i<64;i++) {
        printf("%x\t",quantVal[1][i]);
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
        printf("Huffman::setFields idx = %d \n");
    }
    return idx;    
}
void HuffmanMarker::display(){
    int idx;
    int i;
    int j;
    int k ; 
    printf("HuffmanMarker \n");
    for(k=0;k<4;k++) { 
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
/*
int setFields(unsigned char *p){
    return 1; 
}
*/
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
/*
int getInt(unsigned char *p) {
    // It gets the integer of size 4 bytes starting from p
    int fs;
    fs = ((int)p[3])<<24 | ((int)p[2]) << 16 | ((int)p[1]) << 8 | (int)p[0] ; 
    return fs;
    
}
*/

void displayJpegHeader(unsigned char *p) {
    int i;
    printf("JPEG Header starts as : \n");
    for(i=0;i<50;i++) { 
        printf("%x\t",p[i]);
    }
    printf("\n");
    
}

#define SHOWP printf("P = %x %x %x %x \n",p[0],p[1],p[2],p[3])
/*
                    //rxp = (rxp & 0xff00ffff ) | (((unsigned int )p[0]) << 16);  
#define STUFFCHECK(a) printf("%d ",a); \
                    if ((rxp>>16) == 0xFF00) { \
                    printf("Stuffing found : rxp = %x residual = %d \n",rxp,rxResidue); \
                    rxp = (rxp & 0xff000000 ) | ((rxp & 0xFFFF) << 8 );\
                    printf("Removed Stuffing : rxp = %x \n",rxp); \
                    rxResidue -= 8; \
                    br++; \
                } else if(rxp>>24 == 0xFF) { \
                    t = (rxp >> 16) & 0xFF ;  \
                    printf("Marker encountered = 0xFF%x \n",t); \
                }else if(rxp>>16 == EOI) { \
                    t = (rxp >> 16) & 0xFF ; \
                    printf("Marker encountered = 0xFF%x \n",t); \
                    printf("End of Segmentn in AC component cc = %d \n",cc); \
                    endReached = 1;  \
                    break; \
                } 
*/

#define STUFFCHECK(a)  if(dcd_dbg) printf("%d ",a); \
                    if (((p[0]<<8) |p[1]) == 0xFF00) { \
                    if(dcd_dbg) printf("Stuffing found : p_0_1 = %x  %x \n",p[0],p[1]); \
                    p[1] = p[0] ; \
                    p++; \
                    if(dcd_dbg) printf("After Stuffing found : p_0_1 = %x  %x \n",p[0],p[1]); \
                    br++; \
                }else if(((p[0]<<8) |p[1]) == EOI) { \
                    t = (rxp >> 16) & 0xFF ; \
                    printf("Marker encountered = 0xFF%x \n",t); \
                    printf("End of Segmentn in AC component cc = %d \n",cc); \
                    endReached = 1;  \
                } 


int decode(unsigned char *p, HuffmanLookup *huff[4], SOSMarker *sosMarker,QuantTblMarker *quantTbl,SOFMarker *sofMarker) {
    
    int i,j;
    unsigned short rx;
    unsigned int rxp;
    unsigned char val;
    unsigned char len;
    unsigned char rxResidue;
    unsigned short ab; // additional bits 
    unsigned char cc; // Color components
    unsigned char qtblIdx; 
    int dcVal;
    short int *mcu;
    short int mcuCount;
    unsigned char mcuIdx;
    short int tmcux; //  Total number of MCU in x direction 
    short int tmcuy; // in y direction 
    short int cmcux; //  Current of MCU in x direction 
    short int cmcuy; // in y direction 
    int t ; // Very temporary var 
    unsigned char endReached = 0 ; 
    int br; // Bytes read 
    short int dct_8_8[8][8];
    short int clear_8_8[3][8][8];
    int rgb_8_8[8][8];
    int dcd_dbg; 
    short int p_dc[3];
    int **bitmap; 


    // Initializations 
    bitmap = (int ** ) malloc(sofMarker->Y*sizeof(int *));
    for(i=0;i<sofMarker->Y;i++) {
        bitmap[i] = (int *) malloc(sofMarker->X*sizeof(int));
    }
    br = 0 ; 
    dcd_dbg = 0 ; 
    setUpZigZagToLinear();
    for(i=0;i<3;i++){ 
        p_dc[i] = 0;
    }
    printf("String for decoding\n");
    for(i=0;i<64;i++){
        //printf("%02x ",p[i]);
        printf("%3d",zigZagToLinear[i]);
        if(i%8==7) printf("\n");
    }
    printf("\n");
    rxResidue =32 ; 
    
// ------------------------------------------------------
    rxp = get_uint32(p);
    printf("Values as %x %x %x %x \n",(((uint32)*((p)+0)) << 24 ) , (((uint32)*((p)+1)) << 16 ) , (((uint32)*((p)+2)) << 8 ) ,*(p+3) );
    p+=4;
    br+=4;
    // Find out number of MCUs 
    tmcux = ceil(sofMarker->X / 8.0 ); 
    tmcuy = ceil(sofMarker->Y/ 8.0 ); 
    cmcux = 0 ; 
    cmcuy = 0 ; 
    mcu = (short int  *) malloc(64* sizeof(short int));
    printf("Total tmcux = %d tmcuy = %d \n",tmcux,tmcuy);
    mcuCount = 0 ; 
    while(endReached == 0){ 
        if(cmcux == 17 && cmcuy == 5) { 
            dcd_dbg = 1; 
        }
        if(cmcux == 19 && cmcuy == 5) { 
            dcd_dbg = 0; 
        }
        //printf("Getting mcu (%d,%d)\n",cmcux,cmcuy);
        for(cc=0;cc<3 ;cc++) { 
            if(dcd_dbg) printf("CC Loop = %d sleeping \n",cc);
            if(dcd_dbg) SHOWP;
            //sleep(1);
            // Start for DC component
            // Do allocation for mcu 
            //mcu = NULL;
            //mcu = (short int  *) realloc(mcu,sizeof(short int));
            mcuIdx = 0 ; 
            // Find quantizations Table index 
            //qtblIdx = 0 ; 
            for(i=0;i<3;i++){
                if(sosMarker->cid[(cc+i)%3] == cc+1) {
                    qtblIdx = sosMarker->tbl[(cc+i)%3];
                    break;
                }
            }
            if(dcd_dbg) printf("Quantization table index used = %d \n",qtblIdx);  
            /*
            if ((rxp>>16) == 0xFF00) {
                // Remove the stuffed 0s
                rxp = (rxp & 0xff00ffff ) | (((unsigned int )p[0]) << 16); 
                p++;
                br+=1;
            }else if(rxp>>16 == EOI) {
                // End of segment 
                printf("End of Segment in DC component ERROR \n");
                endReached = 1; 
                break;
            }
            */ 
            rx = rxp >>  (32 - HUFFMAN_LOOKUP_WIDTH);
            if(dcd_dbg) printf("rx = %x rxp = %x \n",rx,rxp);
            if(huff[qtblIdx*2+0]->lkpt[rx].num <= 0) {
                printf("ERROR: Invalid code\n");
            }else{
                if(dcd_dbg) printf("Here \n");
                val = huff[qtblIdx*2+0]->lkpt[rx].val[0];
                len = huff[qtblIdx*2+0]->lkpt[rx].codeLen[0];
                if(dcd_dbg) printf("0 rxp = %x Val = %d len = %d \n",rxp,val,len);
                rx = (rx << len) & ((1<<HUFFMAN_LOOKUP_WIDTH)-1); // Move out searched bit
                rxp = rxp << len;
                rxResidue -= len;
                while(rxResidue <= 24) {
                    STUFFCHECK(1)
                    rxp = rxp | (((unsigned int)p[0])<<(32-rxResidue-8));
                    p++;
                    br+=1;
                    rxResidue += 8 ;
                }
                if(dcd_dbg) printf("rxp = %x after residual\n",rxp);
                // Get in bits from p to fillrx
                // Get val bits from stream, it represent additional bits 
                if(val == 0 ) {
                    dcVal = 0 ; 
                }else{ 
                    ab = rxp >> (32-val); 
                    rxp = rxp << val;
                    rxResidue -= val;
                    while(rxResidue <= 24) {
                        STUFFCHECK(2)
                        rxp = rxp | (((unsigned int)p[0])<<(32-rxResidue-8));
                        p++;
                        br+=1;
                        rxResidue += 8 ;
                    }
                    if(dcd_dbg) printf("rxp = %x after residual\n",rxp);
                    
                    // You have val and additional bits find out present dc value
                    if(ab < (1<<(val-1))) { 
                        dcVal = ab  - (1<<val) +1 ;
                    }else{
                        dcVal = ab;
                    }
                    dcVal = dcVal * quantTbl->quantVal[qtblIdx][mcuIdx]; 
                }
                if(dcd_dbg) printf("DCVAl = %d ab = %d quantval = %d \n",dcVal,ab,quantTbl->quantVal[qtblIdx][mcuIdx]); 
                mcu[zigZagToLinear[mcuIdx++]] = dcVal ;
                //mcu[mcuIdx++] = dcVal ;
            }
            // End of Y DC  decoding 
            // -----------------------------------------------------------------------------------------
            // Start looking at Y AC components
            int decodedCount = 0 ; 
            int numZeros ;
            while(decodedCount <63) { 
                if(dcd_dbg) SHOWP;
                /*
                if ((rxp>>16) == 0xFF00) {
                    // Remove the stuffed 0s
                    rxp = (rxp & 0xff00ffff ) | (((unsigned int )p[0]) << 16); 
                    p++;
                    br++;
                } else if(rxp>>24 == 0xFF) { 
                    t = (rxp >> 16) & 0xFF ; 
                    printf("Marker encountered = 0xFF%x \n",t);
                    //endReached = 1; 
                    //break;
                }else if(rxp>>16 == EOI) {
                    t = (rxp >> 16) & 0xFF ; 
                    printf("Marker encountered = 0xFF%x \n",t);
                    printf("End of Segmentn in AC component cc = %d \n",cc);
                    // End of segment 
                    endReached = 1; 
                    break;
                }
                */
                rx = rxp >> (32 - HUFFMAN_LOOKUP_WIDTH);
                if(dcd_dbg) printf("rx = %04x rxp = %08x \n",rx,rxp);
                
                if(huff[qtblIdx*2+1]->lkpt[rx].num <= 0) {
                    if(dcd_dbg) printf("ERROR: Invalid code\n");
                }else{
                    val = huff[qtblIdx*2+1]->lkpt[rx].val[0];
                    len = huff[qtblIdx*2+1]->lkpt[rx].codeLen[0];
                    if(dcd_dbg) printf("1 rxp = %x Val = %d len = %d \n",rxp,val,len);
                    rx = (rx << len) & ((1<<HUFFMAN_LOOKUP_WIDTH)-1); // Move out searched bit
                    rxp = rxp << len;
                    rxResidue -= len;
                    while(rxResidue <= 24) {
                        STUFFCHECK(3)
                        rxp = rxp | (((unsigned int)p[0])<<(32-rxResidue-8));
                        p++;
                        br++;
                        rxResidue += 8 ;
                        if(dcd_dbg) printf("Residual shifting done \n");
                    }
                        if(dcd_dbg) printf("rxp = %x after residual \n",rxp);
                    // Get in bits from p to fillrx
                    // Get val bits from stream, it represent additional bits 
                    if(val == 0) { 
                        // This means end of block
                        for(;mcuIdx<64;) {
                            //mcu[mcuIdx++] = 0;
                            mcu[zigZagToLinear[mcuIdx++]] = 0 ;
                        }
                        if(dcd_dbg) printf("End of Block\n");
                        decodedCount = 63;
                    } else{
                        numZeros= val >> 4 ;
                        if(dcd_dbg) printf("ZRL [ %d ] \n",numZeros);
                        for(i=0;i<numZeros;i++){
                            //mcu[mcuIdx++] = 0;
                            mcu[zigZagToLinear[mcuIdx++]] = 0 ;
                            if(dcd_dbg) printf("ACVal = %d \n",0);
                        }
                        val = val & 0xF;
                        if(val != 0 ) { 
                        ab = rxp >> (32-val); 
                        rxp = rxp << val;
                        rxResidue -= val;
                        if(dcd_dbg) printf("rxp = %x after shifting by %d \n",rxp,val);
                        while(rxResidue <= 24) {
                            STUFFCHECK(4)
                            rxp = rxp | (((unsigned int)p[0])<<(32-rxResidue-8));
                            p++;
                            br++;
                            rxResidue += 8 ;
                            if(dcd_dbg) printf("Residual shifting done 2 \n");
                        }
                        if(dcd_dbg) printf("rxp = %x after residual\n",rxp);
                        // You have val and additional bits find out present dc value
                        if(ab < (1<<(val-1))) { 
                            dcVal = ab  - (1<<val) +1 ;
                        }else{
                            dcVal = ab;
                        }
                        dcVal = dcVal * quantTbl->quantVal[qtblIdx][mcuIdx]; 
                        } else { 
                            dcVal = 0 ; 
                        }
                        if(dcd_dbg) printf("abVal = %d ACVal = %d quantVal = %d \n",ab,dcVal,quantTbl->quantVal[qtblIdx][mcuIdx]);
                        mcu[zigZagToLinear[mcuIdx++]] = dcVal ;
                        //mcu[mcuIdx++] = dcVal ;
                        decodedCount++;
                    }
                }
            }
            //dcd_dbg = 1; 
            if(dcd_dbg) printf("Getting mcu (%d,%d)\n",cmcux,cmcuy);
            if(dcd_dbg) printf(" MCU #%d MCU for component = %d \n",mcuCount,cc);
            if(dcd_dbg) display_8_8(mcu);
            //dcd_dbg = 0; 
            // The current dc is differentail value 
            if(dcd_dbg) printf("p_dc = 0x%x = 0d%d \n",p_dc[cc],p_dc[cc]);
            mcu[0] = mcu[0] + p_dc[cc]; 
            p_dc[cc] = mcu[0]; 
            // Convert 1-D into 2 array as required for IDCT 
            for(i=0;i<64;i++){
                dct_8_8[(int)floor(i/8)][i%8] = mcu[i];
            }
            if(dcd_dbg) printf("DCT values ");
            if(dcd_dbg)  display_8_8_2d(dct_8_8);
            PerformIDCT(clear_8_8[cc],dct_8_8);
            if(dcd_dbg) printf("Cleared Image  values ");
            // Perform addition of 128 to all the values
            for(i=0;i<8;i++){ 
                for(j=0;j<8;j++){ 
                    clear_8_8[cc][i][j] += 128;
                }
            }
            if(dcd_dbg) display_8_8_2d(clear_8_8[cc]);
        }
        for(i=0;i<8;i++){ 
            for(j=0;j<8;j++){ 
                // Color space conversion to RGB 
                rgb_8_8[i][j] = YCbCrToRGB(clear_8_8[0][i][j],clear_8_8[1][i][j],clear_8_8[2][i][j]);
                if(rgb_8_8[i][j] >> 24 != 0 ) { 
                    printf("Error X = %d Y = %d i = %d j = %d \n",cmcux,cmcuy,i,j);
                }
                rgb_8_8[i][j] = rgb_8_8[i][j] & 0x00FFFFFF;   
            }
        }
        if(dcd_dbg) printf("RGB Composition = \n");
        if(dcd_dbg) display_8_8_2di(rgb_8_8);
        // Rellocate this pixel information to bitmap
        for(i=0;i<8;i++) {
            for(j=0;j<8;j++) {
                // here 
                if(cmcux*8+j<sofMarker->X && (cmcuy)*8+i < sofMarker->Y){
                    //COLOR(cmcux*8+j,cmcuy*8+i) =rgb_8_8[i][j] ; 
                    bitmap[sofMarker->Y-1-(cmcuy)*8-i][cmcux*8+j] = rgb_8_8[i][j] ;
                }else{
                    if(dcd_dbg) printf("Skipping for %d %d %d ",cmcuy,i,j);
                }
            }
        }
        //return 0;
        cmcux++; 
        if(cmcux == tmcux ) { 
            cmcux = 0 ; 
            cmcuy++;
        }
        mcuCount++;
    }
    printf("Saving the file \n");
    saveBitmapToFile(bitmap,sofMarker->X,sofMarker->Y,"rupesh.bmp");
    return br; 
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
    
    buf = (unsigned char *) malloc(64000);
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
                printf("Start setLookUpTable for idx = %d \n",hidx);
                hfl[hidx]->setLookUpTable(hft[hidx]);
                printf("over  setLookUpTable for idx = %d \n",hidx);
            }
            printf("Progrma over \n");
            
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
            bytes_read = read(img_fd,buf,64000);
            printf("Bytes read = %d \n",bytes_read);
            decode(buf,hfl,sosMarker,quantTbl,sofMarker); 
           

            if((pros=lseek(img_fd,0,SEEK_CUR)) < 0) {
                printf("ERROR : lseek \n");
            }
            printf("\nseeking = %d Rest of info \n",pros);
            bytes_read = read(img_fd,buf,24);
            for(i=0;i<24;i++){
                printf("%x\t",buf[i]);
            }
        }else{
            printf("Unknown marker reached = %x at offset = %d (%x)\n", marker,(int)lseek(img_fd,0,SEEK_CUR),(int)lseek(img_fd,0,SEEK_CUR));
            end_reached = 1;
        }
    }
    printf("After setFields = %d \n",pros);
    jfif->display();
    //displayJpegHeader(buf);
    
    /*
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
    */
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
    
    return bytes_read; 
}
