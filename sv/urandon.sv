class uRan;
rand bit [1023:0] ran;
endclass 
program urandom_my();
int a ; 
initial begin

uRan r;
r=new ();
r.randomize();
$display("Rand = %x \n",r.ran);
//r.randomize();
//r.ran=std::r
$display("Rand = %x \n",r.ran);
a = $urandom(16);
$display("A = %d \n",a);
end 
endprogram
