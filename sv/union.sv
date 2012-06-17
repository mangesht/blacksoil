
program first();
int a ;
bit [15:0] vec;
bit [95:0] bigVec;
bit init;
union packed {
        int a ; 
        byte[3:0] b; 
        bit[31:0] c ; 
} my_data;

initial begin
//my_data un;

my_data.a = 'h35;

$display("A = %x b = %x  = %x \n",my_data.a,my_data.b[0],my_data.c);
end 

endprogram

