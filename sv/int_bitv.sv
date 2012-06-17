
class aClass ;
	rand int a ; 
   constraint aCnstr {  
     a > 10 ; 
   }
endclass 
program first();
int a ;
bit [15:0] data_l,user_data;
initial begin
  data_l = 22 ; 
  user_data = 14;
  a = data_l - user_data; 
  $display("Sub A = %d \n",a);
end 
endprogram

