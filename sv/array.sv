
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
int myAr[5][5];
int myArAsoc[int];

real r;

for(int i=0;i<5;i++)begin 
        myAr[i][i] = i;
        myArAsoc[i] = i;
        $display("MyAr[%d] = %d \n",i,myAr[i][i]);
        $display("myArAsoc[%d] = %d \n",i,myArAsoc[i]);
end
end 
endprogram

