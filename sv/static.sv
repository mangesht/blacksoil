class aClass ;
  static int c = 25;
  int a = 50;
endclass 

program first();
initial begin
        aClass b;
        $display("Static c = %d normal a = %d \n",b.c,b.c);
end
endprogram
