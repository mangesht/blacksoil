program first();
initial begin 
    bit[3:0] lv;
    bit[7:0] op1; 
    bit[7:0] op2; 
    bit[7:0] op3; 
    for(lv=0;lv<=8;lv++) begin 
         op1[lv] = lv[2]^lv[1]&lv[0] ; 
         op2[lv] = lv[2]^(lv[1]&lv[0]) ; 
         op3[lv] = (lv[2]^lv[1]) & lv[0] ; 
    end 
    $display("OP1 = %x OP2 = %x op3 = %x \n",op1,op2,op3);
end 
endprogram

