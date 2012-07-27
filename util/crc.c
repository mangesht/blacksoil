

/*
  Code from: 
  Reversing CRC ? Theory and Practice. 
  Martin Stigge, 
  Henryk Pl?tz, 
  Wolf M?ller, 
  Jens-Peter Redlich. 
  Public Report, Systems Architecture Group, HU Berlin, 2006.
  http://stigge.org/martin/pub/SAR-PR-2006-05.pdf
*/  

#include<stdio.h> 

#define CRCPOLY 0xEDB88320
#define CRCINV 0x5B358FD3 // inverse poly of (x^N) mod CRCPOLY
#define INITXOR 0xFFFFFFFF
#define FINALXOR 0xFFFFFFFF
typedef unsigned int uint32;
typedef unsigned char uint8;


/**
 * Creates the CRC table with 256 32-bit entries. CAUTION: Assumes that 
 * enough space for the resulting table has already been allocated.
 */
void make_crc_table(uint32 *table) {
    uint32 c;
    int n, k;
        
    for (n = 0; n < 256; n++) {
        c = n;
        for (k = 0; k < 8; k++) {
            if ((c & 1) != 0) {
                c = CRCPOLY ^ (c >> 1);
            } else {
                c = c >> 1;
            }
        }
        table[n] = c;
    }
}

/**
 * Creates the reverse CRC table with 256 32-bit entries. CAUTION: Assumes 
 * that enough space for the resulting table has already been allocated.
 */
void make_crc_revtable(uint32 *table) {
    uint32 c;
    int n, k;
        
    for (n = 0; n < 256; n++) {
        c = n << 3*8;
        for (k = 0; k < 8; k++) {
            if ((c & 0x80000000) != 0) {
                c = ((c ^ CRCPOLY) << 1) | 1;
            } else {
                c <<= 1;
            }
        }
        table[n] = c;
    }
}

/**
 * Computes the CRC32 of the buffer of the given length using the
 * (slow) bit-oriented approach
 */
int crc32_bitoriented(unsigned char *buffer, int length) {
    int i, j;
    uint32 crcreg = INITXOR;
    
    for (j = 0; j < length; ++j) {
        unsigned char b = buffer[j];
        for (i = 0; i < 8; ++i) {
            if ((crcreg ^ b) & 1) {
                crcreg = (crcreg >> 1) ^ CRCPOLY;
            } else {
                crcreg >>= 1;
            }
            b >>= 1;
        }
    }

    return crcreg ^ FINALXOR;
}

/**
 * Computes the CRC32 of the buffer of the given length 
 * using the supplied crc_table
 */
int crc32_tabledriven(unsigned char *buffer, 
                      int length, 
                      uint32 *crc_table) 
{
    int i;
    uint32 crcreg = INITXOR;
        
    for (i = 0; i < length; ++i) {
        crcreg = (crcreg >> 8) ^ crc_table[((crcreg ^ buffer[i]) & 0xFF)];
    }
    
    return crcreg ^ FINALXOR;
}

/**
 * Changes the last 4 bytes of the given buffer so that it afterwards will
 * compute to the "magic sequence" (usually 0x2144DF1C for CRC32)
 */
void fix_crc_magic(unsigned char *buffer, int length, uint32 *crc_table) 
{
    int i;

    // calculate CRC32 except for the last 4 bytes
    uint32 crcreg = crc32_tabledriven(buffer, length-4, crc_table);

    // inject crcreg as content - nothing easier than that!
    for (i = 0; i < 4; ++i)
        buffer[length - 4 + i] = (crcreg >> i*8) & 0xFF;
}

/**
 * Changes the last 4 bytes of the given buffer so that it afterwards will
 * compute to the given tcrcreg using the given crc_table
 *
 * This function uses the method of the multiplication with (x^N)^-1.
 */
void fix_crc_end(unsigned char *buffer, 
                 int length, 
                 uint32 tcrcreg, 
                 uint32 *crc_table) 
{
    int i;
    tcrcreg ^= FINALXOR;

    // calculate crc except for the last 4 bytes; this is essentially crc32()
    uint32 crcreg = INITXOR;
    for (i = 0; i < length - 4; ++i) {
        crcreg = (crcreg >> 8) ^ crc_table[((crcreg ^ buffer[i]) & 0xFF)];
    }

    // calculate new content bits
    // new_content = tcrcreg * CRCINV mod CRCPOLY
    uint32 new_content = 0;
    for (i = 0; i < 32; ++i) {
        // reduce modulo CRCPOLY
        if (new_content & 1) {
             new_content = (new_content >> 1) ^ CRCPOLY;
        } else {
             new_content >>=  1;
        }
        // add CRCINV if corresponding bit of operand is set
        if (tcrcreg & 1) {
            new_content ^= CRCINV;
        }
        tcrcreg >>= 1;
    }
    // finally add old crc
    new_content ^= crcreg;
    
    // inject new content
    for (i = 0; i < 4; ++i)
        buffer[length - 4 + i] = (new_content >> i*8) & 0xFF;
}

/**
 * Changes the 4 bytes of the given buffer at position fix_pos so that 
 * it afterwards will compute to the given tcrcreg using the given crc_table.
 * A reversed crc table (crc_revtable) must be provided.
 */
void fix_crc_pos(unsigned char *buffer, 
                 int length, 
                 uint32 tcrcreg, 
                 int fix_pos, 
                 uint32 *crc_table, 
                 uint32 *crc_revtable) 
{
    int i;
    // make sure fix_pos is within 0..(length-1)
    fix_pos = ((fix_pos%length)+length)%length;

    // calculate crc register at position fix_pos; this is essentially crc32()
    uint32 crcreg = INITXOR;
    for (i = 0; i < fix_pos; ++i) {
        crcreg = (crcreg >> 8) ^ crc_table[((crcreg ^ buffer[i]) & 0xFF)];
    }

    // inject crcreg as content
    for (i = 0; i < 4; ++i)
        buffer[fix_pos + i] = (crcreg >> i*8) & 0xFF;

    // calculate crc backwards to fix_pos, beginning at the end
    tcrcreg ^= FINALXOR;
    for (i = length - 1; i >= fix_pos; --i) {
        tcrcreg = (tcrcreg << 8) ^ crc_revtable[tcrcreg >> 3*8] ^ buffer[i];
    }

    // inject new content
    for (i = 0; i < 4; ++i)
        buffer[fix_pos + i] = (tcrcreg >> i*8) & 0xFF;
        
}


void hex_dump(char *p_binary, int size)
{
    unsigned char *p_byte = (unsigned char *) (p_binary);
    unsigned char *p_bin_end = (unsigned char *)
        ( (unsigned char *)(p_binary) + (size) );
    char c1, c2;
    int byte_cnt = 0;

    for(; p_byte < p_bin_end; p_byte++)
    {
        c1 = "0123456789ABCDEF"[(*p_byte & 0xF0) >> 4 ];
        c2 = "0123456789ABCDEF"[(*(p_byte)) & 0x0F ];

        if (byte_cnt == 0) {
            printf("%04X: ", byte_cnt);
        }
        if ( (byte_cnt % 8) == 0 ) {
            printf("\n%04X: ", byte_cnt);
        }
        byte_cnt++;
        printf("%c%c ", c1, c2);
    }
    printf("\n");
}


crc2enet_byte_order(uint32 crc32, uint8 enet_crc32[])
{
    enet_crc32[3] = (crc32 & 0xFF000000) >> 24;
    enet_crc32[2] = (crc32 & 0x00FF0000) >> 16;
    enet_crc32[1] = (crc32 & 0x0000FF00) >> 8;
    enet_crc32[0] = (crc32 & 0x000000FF);
    
}


#define BUF_LEN(array) \
( sizeof( array )/sizeof( array[0] ) ) 

int main() {
    
    uint32 crc_table[256*8];
    uint32 crc_revtable[256*8];
    uint32 crc32;
    uint8 enet_crc32[4];


    //Example packet. The CRC at the end is a correct one
    //packet from: http://jaoswald.wordpress.com/chaosnet-information/
//    unsigned char example_packet[] = {
//        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x08, 0x00, 0x07, 0x5c, 0x2e, 0xe4, 0x08, 0x06, 0x00, 0x01,
//        0x08, 0x04, 0x06, 0x02, 0x00, 0x01, 0x08, 0x00, 0x07, 0x5c, 0x2e, 0xe4, 0x03, 0x64, 0x00, 0x00,
//        0x00, 0x00, 0x00, 0x00, 0x02, 0x64, 0x00, 0x3a, 0xf3, 0x5c, 0x4f, 0x12, 0x01, 0x10, 0x00, 0x01,
//        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x41, 0x42, 0x41, 0x08, 0x00 , 0x5a, 0xe2, 0x41, 0xf9 /* last 4 octets are CRC */
//    };
 unsigned char example_packet[] = { 
 0x06, 0x4d, 0xd9, 0x68, 0xfe, 0xb9, 0xc7, 0x9a, 0xe7, 0xb9, 0xa6, 0x89, 0x03, 0xf9, 0xa2, 0xc8, 0xd6, 0x45, 0x3b, 0x8e, 0x70, 0x99, 0xa2, 0x20, 0xf7, 0x04, 0xaf, 0x58, 0xe3, 0xdd, 0xa1, 0xe8, 0x66, 0xdd, 0xd5, 0xb5, 0xc1, 0x47, 0x39, 0x52, 0xfb, 0x13, 0xe2, 0xb5, 0x8a, 0x52, 0x7a, 0x4a, 0x91, 0x26, 0x32, 0x7c, 0xf8, 0xb0, 0x02, 0x70, 0x55, 0x25, 0xd1, 0x51, 0x67, 0xa6, 0xff, 0xeb, 0x79, 0x14, 0x16, 0x27, 0xef, 0x48, 0xc4, 0x50, 0x0e, 0xa5, 0x78, 0x6b, 0x80, 0xba, 0xdc, 0x46, 0xc2, 0x70, 0xc7, 0x8d, 0x27, 0xc0, 0xb9, 0x3e, 0x7c, 0x6d, 0xe8, 0xf9, 0xab, 0xb7, 0xb1, 0x3f, 0x2e, 0x45, 0xd6, 0xa9, 0x50, 0xb9, 0x5e, 0x07, 0x01, 0x22, 0x9c, 0x34, 0xb1, 0x76, 0xce, 0xa8, 0x67, 0x27, 0xf8, 0x25, 0x34, 0xac, 0xf8, 0x39, 0x0e, 0x35, 0x65, 0x29, 0xcf, 0xbe, 0x9c, 0xaf, 0x84, 0xcb, 0x09, 0x62, 0xa0, 0x1c, 0x84, 0x75, 0x5a, 0xc0, 0x01, 0xc0, 0xde, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0xc0, 0x01, 0xc0, 0xde, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x01,0x02,0x03,0x04};

    unsigned char ping[] = {
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x03,
        0xff, 0x1f, 0x08, 0x49, 0x08, 0x00, 0x45, 0x00,
        0x00, 0x1e, 0xce, 0xc2, 0x00, 0x00, 0x40, 0x01,
        0x27, 0x04, 0xc0, 0xa8, 0x01, 0xc9, 0xc0, 0xa8,
        0x01, 0xff, 0x08, 0x00, 0xf7, 0xf2, 0x00, 0x08,
        0x00, 0x05, 0x00, 0x00, 0x12, 0x34, 0x56, 0x78,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0xd5,
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x03,
        0xff, 0x1f, 0x08, 0x49, 0x08, 0x00, 0x45, 0x00,
        0x00, 0x1e, 0xce, 0xc2, 0x00, 0x00, 0x40, 0x01,
        0x27, 0x04, 0xc0, 0xa8, 0x01, 0xc9, 0xc0, 0xa8,
        0x01, 0xff, 0x08, 0x00, 0xf7, 0xf2, 0x00, 0x08,
        0x00, 0x05, 0x00, 0x00 
    };

    /* The same packet as above, but the 4 bytes starting from offset 0x30 are patched 
       so that the CRC in Ethernet transmission order is 0x12, 0x34, 0x56, 0x78 */
    unsigned char ping_fixed[] = {
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x03,
        0xff, 0x1f, 0x08, 0x49, 0x08, 0x00, 0x45, 0x00,
        0x00, 0x1e, 0xce, 0xc2, 0x00, 0x00, 0x40, 0x01,
        0x27, 0x04, 0xc0, 0xa8, 0x01, 0xc9, 0xc0, 0xa8,
        0x01, 0xff, 0x08, 0x00, 0xf7, 0xf2, 0x00, 0x08,
        0x00, 0x05, 0x00, 0x00, 0x12, 0x34, 0x56, 0x78,
        0xB7, 0xA9, 0xEB, 0x3C, 0x00, 0x00, 0x00, 0x00,
        0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0xd5,
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x03,
        0xff, 0x1f, 0x08, 0x49, 0x08, 0x00, 0x45, 0x00,
        0x00, 0x1e, 0xce, 0xc2, 0x00, 0x00, 0x40, 0x01,
        0x27, 0x04, 0xc0, 0xa8, 0x01, 0xc9, 0xc0, 0xa8,
        0x01, 0xff, 0x08, 0x00, 0xf7, 0xf2, 0x00, 0x08,
        0x00, 0x05, 0x00, 0x00 /* , 0x12, 0x34, 0x56, 0x78 */
    };


    make_crc_table(crc_table);
    make_crc_revtable(crc_revtable);

    /* Calculate CRC32 of the example packet - without the last 4 bytes which are the Ethernet CRC */
    crc32 = crc32_tabledriven(example_packet, BUF_LEN(example_packet) - 4, crc_table);
    printf("crc of example_packet: %08X\n", crc32);
    crc2enet_byte_order(crc32, enet_crc32);
    printf("crc of example_packet (Ethernet transmission order): %02X %02X %02X %02X\n", enet_crc32[0], enet_crc32[1], enet_crc32[2], enet_crc32[3]);
    
    printf("crc of ping packet: %08X\n", crc32_tabledriven(ping, BUF_LEN(ping), crc_table) );

    /* Patch the packet ping so that its CRC is 0x78563412 (or, in Ethernet transmission order: 0x12 0x34 0x56 0x78 */
    /* 4 bytes of the ping packet are patched starting from offset 0x30 */
    fix_crc_pos(ping, BUF_LEN(ping), 0x78563412, 0x30, crc_table, crc_revtable);
    crc32 = crc32_tabledriven(ping, BUF_LEN(ping), crc_table);
    printf("crc of ping packet after fix_crc_pos: %08X\n", crc32);
    crc2enet_byte_order(crc32, enet_crc32);
    printf("crc of ping packet after fix_crc_pos in Ethernet trasmission order: %02X %02X %02X %02X\n", enet_crc32[0], enet_crc32[1], enet_crc32[2], enet_crc32[3]);
    //hex_dump(ping, BUF_LEN(ping));           
}


