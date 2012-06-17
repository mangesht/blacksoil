
class aClass ;
	rand int a ; 
	rand int b ; 
	rand int c ; 
	rand int d ; 
	rand int e ; 
	rand int f ; 

    task incr(int i); 
            int j = 5;
            i++;
            $display("In Class A i = %d ",i);
    endtask
endclass
extends myClass(aClass);
    before task incr(int i); 
        i++;
            $display("In Class A i = %d ",i);
            $display("In Class A j = %d ",j);
    endtask

endextends 

program first();
int a ;
initial begin
aClass b;

a = 5;
b = new();
b.randomize();
b.incr(a);
end 
endprogram

