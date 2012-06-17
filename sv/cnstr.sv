
class aClass ;
	rand int a ; 
	rand int b ; 
	rand int c ; 
	rand int d ; 
	rand int e ; 
	rand int f ; 
   constraint aCnstr {  
     b > 50 ;  
     c > 40 ;  
     d > 30 ;  
     e > 20 ;  
     f > 0 ;  
     a > 10 ; 
     a < 100; 
     a == b + c ; 
     a == d + e ; 
   }
endclass 
program first();
int a ;
int cr;
initial begin
aClass b;

a = 5;
b = new();
b.randomize();
b.randomize() with {f inside{[0:4],32,34,871} ;};
$display("Mangesh local a = %d Class a = %d",a,b.a );
$display(" a = %d b = %d c = %d d = %d e = %d f = %d " ,b.a,b.b,b.c,b.d , b.e , b.f );
end 
endprogram

