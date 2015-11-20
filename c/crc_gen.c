//-------------------------------------------------------
// Verilog mod 2 divisor 
// Mangesh Thakare (mangesh.thakare@gmail.com)
// The code generates Verilog code for module 2 division by
// specified polynomial.
// The polymonial to be specified without any omission of leading 
// or trailing zeros / ones 
// Eg. x^3 + x^2 + 1 Be represeted as i.e. D (1101)
// The input polynomial should be specific in hex 
//--------------------------------------------------------

#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
#include<string.h>

// #include<sys/stat.h>
//#include<sys/types.h>
//#include<sys/wait.h>
//#include<unistd.h>
//#include<signal.h>
#include<fcntl.h>


int out_fd;
int writef(char *p) { 
    int len = strlen(p);
    write(out_fd,p,len);
    return len;
}
void display_help() { 
    printf("crc_gen [-p polynomial ] [-w width] [-h] [outputFile]\n");
    printf("Defaults are polynomial = f width = 4 outputFile = crc.v \n"); 
    return;
}
int main(int argc,char *argv[]) {
    char *outputFileName;
    char *str;
    int WIDTH = 4;
    int POLY_ORDER = 3; 
    char *polynomial;
    int idx = 1 ; 
    int pidx = 0 ; 
    outputFileName = (char *) malloc(256);
    str = (char *) malloc(256);
    polynomial = (char *) malloc(256);
    strcpy(outputFileName , "crc.v");
    strcpy(polynomial , "f");
    if(argc > 1){
        while(idx<argc){ 
            if(strcmp(argv[idx],"-p") == 0 ) {
                // Polynomial for calculations
                strcpy(polynomial,argv[idx+1]);
                idx++;
            }else if(strcmp(argv[idx],"-w") == 0 ) {
                // Polynomial for calculations
                 WIDTH = atoi(argv[idx+1]);
                 idx++;
            }else if(strcmp(argv[idx],"-h") == 0 ) {
                 display_help();
                 return 0;
            }else {
                strcpy(outputFileName,argv[idx]);
            }

            idx++;
        }
    }
    // Finding order of the polynomial
    POLY_ORDER = 0 ;
    int tmp = strlen(polynomial);
    POLY_ORDER = tmp * 4 ;
    char *t;
    t  = (char *) malloc(2);
    t[0] = polynomial[0];
    int l ; 
    sscanf(t,"%x",&l);
    tmp = 0 ; 
    while(l>0) { 
        tmp++;
        l/=2;
    }
    POLY_ORDER = POLY_ORDER - (4-tmp) - 1 ;
    

    printf("D = %d\n",(int )l);
    printf("Polynomial = %s Poly Order = %d Width = %d \n",polynomial,POLY_ORDER,WIDTH);
    printf("Output file = %s \n",outputFileName);
    out_fd = open(outputFileName,O_TRUNC | O_RDWR | O_CREAT,S_IRUSR|S_IWUSR| S_IROTH);
    if(out_fd == -1){
         perror("error:");
         printf("No output file exiting \n");
         return -1; 
     }
   
    sprintf(str,"module crc_%d(reset,clk,inp,rem);\n",POLY_ORDER+1);
    writef(str);
    writef("input reset;\n");
    writef("input clk;\n");
    sprintf(str,"input[%d:0] inp;\n",WIDTH-1);
    writef(str);
    sprintf(str,"output [%d:0] rem;\n",POLY_ORDER);
    writef(str);
    sprintf(str,"reg [%d:0] rem;\n",POLY_ORDER);
    writef(str);
    sprintf(str,"localparam g = %d'h%s;\n",POLY_ORDER+1,polynomial);
    writef(str);
    sprintf(str,"reg [%d:0]d;\n",WIDTH + POLY_ORDER - 1);
    writef(str);
    sprintf(str,"reg [%d:0] q;\n",WIDTH-1);
    writef(str);
    for(idx=0;idx<=WIDTH;idx++){
        sprintf(str,"wire [%d:0] ds_%d;",POLY_ORDER + WIDTH -1 ,idx);
    }
    writef("always @(posedge clk) begin\n");
    writef("if reset == 1'b1) begin \n");
    writef("d=0;\n");
    writef("end else begin\n");
    sprintf(str,"d[%d:%d] = ds_%d[%d:0];\n",POLY_ORDER + WIDTH -1 , WIDTH,WIDTH,POLY_ORDER-1);
    writef(str);
    sprintf(str,"d[%d:0] = inp;\n",WIDTH-1);
    writef(str);
    sprintf(str,"rem = ds_%d[%d:0];\n",WIDTH,POLY_ORDER-1); 
    writef(str);
    writef("end\n");
    writef("end\n");
    writef("\n");
    writef("assign ds_0 = d ;\n");
    for(idx=0;idx<WIDTH;idx++) { 
        sprintf(str,"// Stage No. %d \n",idx +1);
        writef(str);
        sprintf(str,"assign q[%d] = ds_%d[%d] ;\n",WIDTH-1-idx,idx,POLY_ORDER+WIDTH-1-idx);
        writef(str);
        for(pidx=POLY_ORDER-1;pidx>=0;pidx--){
            sprintf(str,"assign ds_%d[%d] = ds_%d[%d]^g[%d]&q[%d];\n",idx+1,POLY_ORDER+WIDTH-1-idx-POLY_ORDER+pidx,idx,POLY_ORDER+WIDTH-1-idx-POLY_ORDER+pidx,pidx,WIDTH-1-idx);
            writef(str);
        }
        //printf("pid = %d \n",pidx);
        if(idx != WIDTH -1 ) { 
            //sprintf(str,"For idx = %d \n",idx);
            //writef(str);
            sprintf(str,"assign ds_%d[%d] = ds_0[%d];\n",idx+1,POLY_ORDER+WIDTH-1-idx-POLY_ORDER+pidx,POLY_ORDER+WIDTH-1-idx-POLY_ORDER+pidx);
            writef(str);
        }
    }
 
    writef("endmodule\n");
    close(out_fd);
    return 0;
}
