
class aClass ;
	rand int a ; 
   constraint aCnstr {  
     a > 10 ; 
   }
endclass 
program first();
int a ;
initial begin
aClass b;
int crypto_start;
int pkt_len ; 
bit[15:0] segment_length;

real r;

a = 5;
b = new();
b.randomize();
r = 1.2; 
$display("Mangesh local a = %d Class a = %d real = %ld ",a,b.a,r );
pkt_len = 'hfa;
segment_length = 'h0008;
crypto_start  = pkt_len - 2 - segment_length;
$display(" crypto_start = %x pkt_len = %x segment_length = %x \n",crypto_start,pkt_len,segment_length);

end 
endprogram

