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
int index ;
bit [15:0] vec;
bit [95:0] bigVec;
bit init;
initial begin
aClass b;



for(index = 0; index < 64 ; index++) begin 
        if(index[5:4] == 2'b00) begin
                $display("Index = %x \n",index);
        end 
end 

end 

endprogram

