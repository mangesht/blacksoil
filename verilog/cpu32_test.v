// Copyright (c) 2008-2010 Illinois Institute of Technology
//               All rights reserved.
// Author:       Jia Wang, jwang@ece.iit,edu

module stimulus;
   
   reg power, clk, stop;
   reg [15:0] cycles;

   
   wire [7:0] pc, next_pc;
   wire [31:0] mem_s;   
   wire [15:0] code;
   wire        write_en, imm_en, branch_en;
   reg [31:0] a ,b;
   wire [31:0]sum ; 
   reg cin;
   wire cout;
  
   
//   cpu32 mycpu(power, clk, pc, mem_s, code, write_en, imm_en, branch_en, next_pc);
   adder32 adder_inst (.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout)) ;

   // program_rom myprogram(pc, code);
   
   initial begin
      clk = 1'b0;
      forever #25 clk = ~clk;
   end
   
   initial begin
      power = 1'b0;
      #26 power = 1'b1;
   end
   
   initial begin
      stop = 1'b0;
      cycles = 16'b0;      
      a = 0 ;
      b = 15;
      cin = 0;
   end
   
   initial begin
      $shm_open("shm.db", 1);
      $shm_probe("AS");
           #7400; 
           $display("FALSE TRUE = %h \n",1===1'bx);
           $shm_close();
           $finish;
   end
   
   always @(negedge clk) begin
      cycles <= cycles+1;
      a <= a + 'h1FFF_FFFF ; 
      b <= b + 'h1FFF_FFFF ; 
      $display("a = %d b = %d sum = %d cout = %d ",a,b,sum,cout);
      if((a+b) !== sum)
              $display("ERROR: SUM DOES NOT MATCH Expected = %d Got = %d\n",(a+b),sum);
      else
              $display("    SUM MATCHES\n");
   end
   
endmodule // stimulus


// ROM: we store the program here
module program_rom(pc, code);

  output [15:0] code;
  input [7:0] pc;

  reg [15:0] rom[255:0];
  
  initial
  begin
    $readmemh("code.hex", rom);
  end
  
  assign code = rom[pc];

endmodule // program_rom
