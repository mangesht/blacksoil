
typedef enum {Ah,Eth,Sia} PktEncapTypes;
class aClass ;
	rand int a ; 
    rand PktEncapTypes pkt;
    rand int hdrCfg[PktEncapTypes];
   constraint aCnstr {  
     a > 10 ; 
   }
endclass 

program first();
int a ;
initial begin
aClass b;

a = 5;
b = new();
b.randomize();
$display("Mangesh local a = %d Class a = %d size = ",a,b.a );
    foreach(b.hdrCfg[i])begin
            $display("Hdr = %d , %d ",b.hdrCfg[i],b.hdrCfg[i]);
    end
//$display("PktEncapTypes = %d ",PktEncapTypes);
end 
endprogram

