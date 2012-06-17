class Festival;
        bit[2:0] diwali;
        bit[2:0] holi[8];
        int i,j;
        int k;
        covergroup fcov;
                cover_point_f : coverpoint diwali {
                        bins diwaliBins[]= {0,1,2,3,4,5};
                }
                coverpoint i {bins i[] = {[0:2]};}
                coverpoint j {bins j[] = {[0:2]};}
                // Cross 
                x1 : cross i,j;
                x2 :cross i,j{
                        bins i_zero = binsof(i) intersect {[0:1]};
                }
                holiCovArray : coverpoint holi[k];
        endgroup
        extern function new();
        extern  function void gotData();
endclass 
function Festival::new();
        diwali = 0 ; 
        fcov = new;
endfunction 

 function void Festival::gotData();
    fcov.sample();
endfunction

program main;
    bit [2:0] y;
    bit man;
    Festival fest;
    bit [2:0] values[$]= '{3,5,6,7,4};
    
//   covergroup cg;
//     cover_point_y : coverpoint y;
//     coverpoint man;
//   endgroup
    
//  cg cg_inst = new();
   
initial begin 
      fest = new();
      foreach(values[i])
      begin
        y = values[i];
        man = y;
        fest.diwali = y;
        fest.holi[y] = 2;
        fest.k = y ; 
        fest.i = y %3 ;
        fest.j = y %3 ;
        fest.gotData();
        $display("Y = %d \n",y);
//        cg_inst.sample();
      end
    end
  endprogram

