typedef struct { 
    int in ; 
    int out; 
}userInfoS;

class aClass ;
	rand int a ; 
   constraint aCnstr {  
     a > 10 ; 
   }
endclass 

function getDataVal( userInfoS s);
        $display( "Val Input = %d \n",s.out);
        s.out = 25; 
endfunction 
function getDataRef(ref userInfoS s);
        $display( "Ref Input = %d \n",s.out);
        s.out = 20; 
endfunction 

function classTest(aClass a);
        $display("Input to classTest= %d \n",a.a);
        a.a= 50 ; 
endfunction

program first();
int a ;
initial begin
aClass b;
userInfoS uInfoInst;
uInfoInst.in=10;
uInfoInst.out=11;
getDataRef(uInfoInst);
$display("Struct Output by Ref = %d \n",uInfoInst.out);
getDataVal(uInfoInst);
$display("Struct Output by Val = %d \n",uInfoInst.out);
b=new();
$display("Output = %d \n",uInfoInst.out);
classTest(b);
$display("Output of class pass by value  = %d \n",b.a);

end 
endprogram

