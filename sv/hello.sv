`include "myFunc.sv"

class aClass ;
	rand int a ; 
   constraint aCnstr {  
     a > 10 ; 
   }
   virtual task myDisp();
       rawTask();
   endtask 

endclass 
program first();
int a ;
bit [15:0] vec;
bit [95:0] bigVec;
bit init;
initial begin
aClass b;



a = 5;
b = new();

b.randomize();
$display("Mangesh local a = %d Class a = %d Bit init = %x ",a,b.a,init );
if(init == 1 ) begin 
        $display("Bit is not 0 \n");
end
vec = 'hff34;
$display("7:0 = %x",vec[7-:8]);
$display("7:0 = %x",vec[0+:8]);
vec = 1; 
bigVec = 12'habc << 32;
$display("Shifted 7:0 = %0x",bigVec);
getData();
b.myDisp();
end 

task getData();
begin 
         int i ;
        $display("I = %d ",i);
end 
endtask 
endprogram

