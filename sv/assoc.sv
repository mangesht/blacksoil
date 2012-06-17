
typedef enum {Ah,Eth,Sia,GARP} PktEncapTypes;
class aClass ;

	rand int a ; 
    rand int map[PktEncapTypes];
   constraint aCnstr {  
     a > 10 ; 
   }

endclass 
program first();
int a ;
initial begin
aClass b;
PktEncapTypes cur;
PktEncapTypes newAssoc[string];
a = 5;
b = new();
b.randomize();
$display("Mangesh local a = %d Class a = %d",a,b.a );
b.map[Ah+1] =  8; 
b.map[Eth] = 9; 
b.map[Sia] = 7; 

b.map.first(cur);
do
    begin
         $display("%s  = %d ",cur.name,cur);
         newAssoc[cur.name] = b.map[cur];
    end
    while(b.map.next(cur));

    foreach(newAssoc[i])begin
            $display("%d index = %s ",newAssoc[i],i);
    end

end
endprogram

