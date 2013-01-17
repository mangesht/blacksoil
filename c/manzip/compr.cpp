#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<errno.h>
#include<ctype.h>


#define	GZIP_MAGIC     "\037\213" /* Magic header for gzip files, 1F 8B */

/* Compression methods (see algorithm.doc) */
#define STORED      0
#define COMPRESSED  1
#define PACKED      2
#define LZHED       3
/* methods 4 to 7 reserved */
#define DEFLATED    8
#define MAX_METHODS 9

// Define Compression flags as per RFC 1952 

#define FTEXT   0x01
#define FHCRC   0x02
#define FEXTRA  0x04
#define FNAME   0x08
#define FCOMMENT 0x10

// For XFL
#define SLOW 2
#define FAST 4 

// OS CODE for Unix 
#define OS_CODE 0x03
#define OUTBUFSIZ 1024
#ifndef WSIZE
#  define WSIZE 0x8000     /* window size--must be a power of two, and */
#endif                     /*  at least 32K for zip's deflate method */

#define HASH_BITS 15
#define HASH_SIZE (unsigned)(1<<HASH_BITS)
#define HASH_MASK (HASH_SIZE-1)

#define LLMASK63_48 (((long long)1<<48)-1)
#define LLMASK47_32 (((long long)0xffff0000<<32) + (long long)0xffffffff)
#define LLMASK31_16 (((long long)0xffffffff<<32) + (long long)0x0000ffff)
#define LLMASK15_0  (((long long)0xffffffff<<32) + (long long)0xffff0000)
#ifndef PATH_SEP
#  define PATH_SEP '/'
#endif


typedef unsigned char uch;
typedef unsigned short ush;

unsigned short int outcnt = 0; 
unsigned char *outbuf;
unsigned char *inbuf;
unsigned short int incnt = 0;
ush win_rem_cnt = 0 ; 
ush wcnt = 0 ; 
long long *hash_loc;
unsigned int *hash_map;
unsigned int hash_loc_free_locn = 0;

char ifname[256] = "/home/mangesh/tryzip/r_man.txt";

#define put_byte(c) {outbuf[outcnt++]=(uch)(c); if (outcnt==OUTBUFSIZ)\
   flush_outbuf();}

#define put_char(c) put_byte((c) & 0x7F)
#define tolow(c)  (isupper (c) ? tolower (c) : (c))  /* force to lower case */
#define casemap(c) tolow(c) /* Force file names to lower case */

#include "util.cpp"
void allocate_mem();
void get_outpath(char *path, char *opath);
char * gzip_base_name (char* fname);

char *strlwr(char *s);
int zip(int in,int out);
void flush_outbuf();
void deflate();
unsigned int find_insert_hash(ush pos);
int fill_window();
unsigned short int get_match_info(ush wcnt,ush tloc);


    unsigned char *buf;
    int ifd; // input file handle 
    int ofd; // output file handle 
    int level = 6; 

int main(int argc,char *argv[]){

    int ret;
    int i;
    char ofname[256] ="";
    buf = (unsigned char *) malloc(2024);
    allocate_mem();
    printf("\n");
    if(argc > 1 ) {
        strcpy(ifname,argv[1]);
    }
    printf("FileName = %s \n",ifname);
    ifd = open(ifname,O_RDONLY);

    if(ifd <= 0) {
        perror("inpfileopenfailed ");
    } 
    get_outpath(ifname,ofname);
    //ofname = "/home/mangesh/tryzip/r_man.gz";
    printf("destination file = %s----\n",ofname);
    //ofd = open("/home/mangesh/tryzip/r_man.gz",O_WRONLY | O_CREAT , 0444);
    ofd = open(ofname,O_WRONLY | O_CREAT | O_TRUNC , 0644);
    if(ofd <= 0) {
        perror("outfileopenfailed ");

    } 
    printf("input file handle = %d output file handle = %d \n",ifd,ofd);
    zip(ifd,ofd); 

    flush_outbuf();
    close(ifd);
    close(ofd);

}


int zip(int in,int out){
    uch flags = 0;
    uch extra_flags = 0 ;
    unsigned long stamp;
    put_byte(GZIP_MAGIC[0]); /* magic header */
    put_byte(GZIP_MAGIC[1]);
    put_byte(DEFLATED);      /* compression method */
    flags |= FNAME ;
    put_byte(flags);
    stamp = 0 ; 
    put_byte(stamp & 0xFF);
    put_byte((stamp>>8 )& 0xFF);
    put_byte((stamp>>16)& 0xFF);
    put_byte((stamp>>24)& 0xFF);
    
    // XFL 
    if (level == 1) {
       extra_flags |= FAST;
    } else if (level == 9) {
       extra_flags |= SLOW;
    }
    put_byte(extra_flags);
    put_byte(OS_CODE); 

	char *p = gzip_base_name (ifname); /* Don't save the directory part. */
	do {
	    put_char(*p);
	} while (*p++);
    
    deflate();

    return 0; 
}

void deflate(){
    unsigned int srch_loc;
    ush num_locs;
    long long hash_loc_entry;
    int i;
    ush tloc;
    ush match_len;
    ush longest_match = 0 ;
    ush distance = 0 ;
    
    fill_window();
    while(win_rem_cnt > 0) {
        srch_loc = find_insert_hash(wcnt);
        num_locs = (srch_loc >> 16 ) & 0xF;
        srch_loc = srch_loc & 0xFFFF;
        printf("Search location = %d \n",srch_loc);
        longest_match = 0 ;
        distance = 0 ;
        while(srch_loc != 0) { 
            hash_loc_entry = hash_loc[srch_loc];
            srch_loc = (hash_loc_entry >> 48) & 0xFFFF;
            printf("New search location = %d \n",srch_loc);
            for(i=num_locs;i>0;i--){
                 tloc = (hash_loc_entry >> ((i-1)*16)) & 0xFFFF;
                 match_len = get_match_info(wcnt,tloc);
                 if(longest_match < match_len) {
                     longest_match = match_len;
                     distance = wcnt - tloc ; 
                 }
            }
            num_locs = 3;
        } 
        printf("The longest match for this round = %d and distance = %d \n",longest_match,distance);
        wcnt++;
        win_rem_cnt--;
    }

}
// return the index to the location where matching strings can be found 
// also returns number of valid entries at that location
unsigned int find_insert_hash(ush pos){
    unsigned int head_loc;
    ush chain_len;
    uch mod_chain_len;
    long long hash_loc_entry;
    ush hash_idx = ((inbuf[pos+0] << 10) ^ (inbuf[pos+1]<<5) ^ inbuf[pos+2]) & HASH_MASK;
    printf("Finding hash for position = %d . Hash value = %x for %c  \n",pos,hash_idx,inbuf[pos]);
    head_loc = hash_map[hash_idx];
    chain_len = (head_loc >> 16) & 0xFFFF;
    head_loc = head_loc & 0xFFFF;
    hash_loc_entry = hash_loc[head_loc];
    printf("chain len = %d \t ",chain_len);
    mod_chain_len = chain_len % 3 ;
    if(mod_chain_len % 3 == 0 ){
        // get next free location
        ush free_loc = hash_loc_free_locn++; 
        hash_loc_entry = (pos & 0xFFFF); // update at 0th position 
        printf("link = %ld ",hash_loc_entry>>48);
        hash_loc_entry = (hash_loc_entry & LLMASK63_48 ) | (long long)head_loc << 48 ;
        printf("2_link = %ld ",hash_loc_entry>>48);
        hash_loc[free_loc] = hash_loc_entry;
        hash_map[hash_idx] = free_loc;
        printf("Using new free location = %d link = %d ",free_loc,hash_loc_entry >> 48);
    }else{
        // There are already entries there 
        hash_loc_entry = hash_loc_entry; 
        if(mod_chain_len == 1) { 
            hash_loc_entry = (hash_loc_entry & LLMASK31_16) | (long long)pos << 16;
        }else{
            hash_loc_entry = (hash_loc_entry & LLMASK47_32) | (long long)pos << 32;
        }
        hash_loc[head_loc] = hash_loc_entry;
        printf("Using free location = %d link = %d ",head_loc,hash_loc_entry>> 48);
    }
    
    chain_len++;
    hash_map[hash_idx] = (hash_map[hash_idx] & 0xFFFF) | ((unsigned int)chain_len<<16);
    head_loc = (head_loc & 0xFFFF) | ((unsigned int) mod_chain_len << 16);
    printf("\n");
    return head_loc;
}

// Find the longest match starting at location tloc
// Returns matching length 
unsigned short int get_match_info(ush wcnt,ush tloc){
    unsigned char *base;
    unsigned char *srch_area;
    ush ml=0;
    base = inbuf+wcnt;
    srch_area = inbuf+tloc;
    printf("called get_match_info \n");
    printf("starting comparision of %c and %c \n",*base,*srch_area);
    while(*base == *srch_area) { 
        ml++;
        base++;
        srch_area++;
    }
    return ml;
}
void get_outpath(char *path, char *opath)
{
    char *dest;
    char *tmp;
    printf("getpath input= %s \n",path);
    dest = opath;
    strcpy(dest,path);
    tmp= strrchr(dest,'.');
    tmp++;
    *tmp = 'g'; 
    tmp++;
    *tmp = 'z'; 
    tmp++;
    *tmp = '\0';
    printf("destination = %s \n",dest);
    opath = dest;
    return;
}

void allocate_mem(){
    outbuf = (unsigned char *) malloc(sizeof(unsigned char) * OUTBUFSIZ );
    inbuf = (unsigned char *) malloc(sizeof(unsigned char) * WSIZE);
    hash_map = (unsigned int *) malloc(sizeof(unsigned int) * HASH_SIZE);
    hash_loc = (long long *) malloc(sizeof(long long) * (WSIZE +2) / 3) ;
}

// Fills in the inbuf with data from file 
// returns the size of the window 
int fill_window(){
    unsigned char *tbuf;
    int r_byte = WSIZE - win_rem_cnt;
    int rd_byte ; 
    int i;
    tbuf = (uch *) malloc(r_byte);
    rd_byte = read(ifd,tbuf,r_byte);
    if (rd_byte <= 0 ) { 
        return -1;
    }else{
        printf("fill window assigning \n");
        for(i=0;i<rd_byte;i++){
            printf(" %c",(int)*tbuf);
            inbuf[(wcnt+i) & 0x7FFF] = *tbuf++;
        }
        //wend =( wcnt+i) & 0x7FFF;
        printf("\n");
        win_rem_cnt += rd_byte;
    }
    //free(tbuf); 
    return (rd_byte != r_byte); 
}
void flush_outbuf(){
    ush w_c;
    w_c = write(ofd,outbuf,outcnt);
    if(w_c != outcnt) { 
        perror("flushError: ");
    }
    outcnt = 0 ; 
}


/* ========================================================================
 * Return the base name of a file (remove any directory prefix and
 * any version suffix). For systems with file names that are not
 * case sensitive, force the base name to lower case.
 */
char * gzip_base_name (char* fname)
{
    char *p;

    if ((p = strrchr(fname, PATH_SEP))  != NULL) fname = p+1;
#ifdef PATH_SEP2
    if ((p = strrchr(fname, PATH_SEP2)) != NULL) fname = p+1;
#endif
#ifdef PATH_SEP3
    if ((p = strrchr(fname, PATH_SEP3)) != NULL) fname = p+1;
#endif
#ifdef SUFFIX_SEP
    if ((p = strrchr(fname, SUFFIX_SEP)) != NULL) *p = '\0';
#endif
    if (casemap('A') == 'a') strlwr(fname);
    return fname;
}

char *strlwr(char *s)
{
    char *t;
    for (t = s; *t; t++)
      *t = tolow ((unsigned char) *t);
    return s;
}

