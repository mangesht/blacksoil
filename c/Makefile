
crc_gen.o:crc_gen.c
	gcc -o crc_gen.o crc_gen.c 

eth_crc:crc_gen.o 
	./crc_gen.o -p 104c11db7 -w 32 -o crc.v 
#	./crc_gen.o -p  82608edb -w 32 -o crc.v 
