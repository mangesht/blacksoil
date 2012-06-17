
class aClass ;
	rand int a ; 
   constraint aCnstr {  
     a > 10 ; 
   }
endclass 
program first();
int a ;
bit[1024:0] pktData;
initial begin
aClass b;

a = 5;
b = new();
b.randomize();
pktData = 'h1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
$display("Mangesh local a = %d Class a = %d \npktData=%x",a,b.a,pktData );
end 
endprogram

