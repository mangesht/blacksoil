
class aClass ;
	rand int a ; 
   constraint aCnstr {  
     a > 10 ; 
   }
endclass 
program first();
int a ;
initial begin
int k[2:6];
const int i=8;
bit [31:0] bv = 2**16-1;
bv[3:0] = 1;
bv[i+:8] = 2;
bv[23:16] = 3;
bv[3:0] = 1;
bv[8+:8] = 2;
bv[23:16] = 3;
k[2] = 20;
k[3] = 30;
k[4] = 40;
a= bv[12+:4];
$display("k = %x A = %x bv = %x  \n",k[2],a,bv);
end 
endprogram

