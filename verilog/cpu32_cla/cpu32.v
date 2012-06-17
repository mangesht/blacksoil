// Copyright (c) 2008-2010 Illinois Institute of Technology
//               All rights reserved.
// Author:       Jia Wang, jwang@ece.iit,edu

// Basic circuit elements

`timescale 1ps/1ps 

module decoder2to4(in, out, en);
   
   output [3:0] out;
   input [1:0]     in;
   input     en;
   
   wire [1:0]     nn;
   
   not(nn[0], in[0]);
   not(nn[1], in[1]);
   
   and(out[0], nn[1], nn[0], en);
   and(out[1], nn[1], in[0], en);
   and(out[2], in[1], nn[0], en);
   and(out[3], in[1], in[0], en);

endmodule // decoder2to4


module decoder3to8(in, out, en);
   
   output [7:0] out;
   input [2:0]     in;
   input     en;
   
   wire     nn2, en0, en1;
   
   not(nn2, in[2]);
   and(en0, nn2, en);
   and(en1, in[2], en);
   
   decoder2to4 d0(in[1:0], out[3:0], en0);
   decoder2to4 d1(in[1:0], out[7:4], en1);
   
endmodule // decoder3to8


module decoder4to16(in, out, en);

   output [15:0] out;
   input [3:0]      in;
   input      en;
   
   wire      nn3, en0, en1;
   
   not(nn3, in[3]);
   and(en0, nn3, en);
   and(en1, in[3], en);
   
   decoder3to8 d0(in[2:0], out[7:0], en0);
   decoder3to8 d1(in[2:0], out[15:8], en1);
   
endmodule // decoder4to16


module tris(in, sel, out);
   
   output out;
   input  in, sel;
   tri       out;
   
   bufif1 b1(out, in, sel);
   
endmodule // tris


module tris_8(in, sel, out);
   
   output [7:0] out;
   input [7:0]     in;
   input     sel;
   
   tris t0(in[0], sel, out[0]);
   tris t1(in[1], sel, out[1]);
   tris t2(in[2], sel, out[2]);
   tris t3(in[3], sel, out[3]);
   tris t4(in[4], sel, out[4]);
   tris t5(in[5], sel, out[5]);
   tris t6(in[6], sel, out[6]);
   tris t7(in[7], sel, out[7]);
   
endmodule // tris_8

module tris_32(in, sel, out);
    output [31:0] out;
    input [31:0] in;
    input sel;
    tris_8 word0(in[7:0] , sel , out[7:0]);
    tris_8 word1(in[15:8] , sel , out[15:8]);
    tris_8 word2(in[23:16] , sel , out[23:16]);
    tris_8 word3(in[31:24] , sel , out[31:24]);
endmodule // tris_32

module dff(d, clk, q);
   
   output q;
   input  d, clk;
   reg       q;
   
   always @(posedge clk)
     q <= d;
   
endmodule // dff


module dff_8(d, clk, q);
   
   output [7:0] q;
   input [7:0]     d;
   input     clk;    
   
   dff d0(d[0], clk, q[0]);
   dff d1(d[1], clk, q[1]);
   dff d2(d[2], clk, q[2]);
   dff d3(d[3], clk, q[3]);
   dff d4(d[4], clk, q[4]);
   dff d5(d[5], clk, q[5]);
   dff d6(d[6], clk, q[6]);
   dff d7(d[7], clk, q[7]);
   
endmodule // dff_8

module dff_32(d,clk,q);
   output [31:0] q;
   input [31:0] d;
   input     clk;    

    dff_8 word0(d[7:0],clk,q[7:0]);
    dff_8 word1(d[15:8],clk,q[15:8]);
    dff_8 word2(d[23:16],clk,q[23:16]);
    dff_8 word3(d[31:24],clk,q[31:24]);


endmodule //dff_32


module mux2to1(in0, in1, sel, out);
   
   output out;
   input  in0, in1, sel;
   
   wire   nsel, n0, n1;
   
   not(nsel, sel);
   
   and(n0, nsel, in0);
   and(n1, sel, in1);
   
   or(out, n0, n1);
   
endmodule // mux2to1

module mux2to1_spcl(in0, in1, sel, out);
   
   output out;
   input  in0, in1, sel;
   
   wire   nsel, n0, n1,nseln;
   
   not(nsel, sel);
   not(nseln ,nsel);
   and(n0, nsel, in0);
   and(n1, nseln, in1);
   
   or(out, n0, n1);
   
endmodule // mux2to1


module mux2to1_8(in0, in1, sel, out);

   output [7:0] out;
   input [7:0]     in0, in1;
   input     sel;

   mux2to1 m0(in0[0], in1[0], sel, out[0]);
   mux2to1 m1(in0[1], in1[1], sel, out[1]);
   mux2to1 m2(in0[2], in1[2], sel, out[2]);
   mux2to1 m3(in0[3], in1[3], sel, out[3]);
   mux2to1 m4(in0[4], in1[4], sel, out[4]);
   mux2to1 m5(in0[5], in1[5], sel, out[5]);
   mux2to1 m6(in0[6], in1[6], sel, out[6]);
   mux2to1 m7(in0[7], in1[7], sel, out[7]);
   
endmodule // mux2to1_8

module mux2to1_32(in0,in1,sel,out);
    output [31:0] out;
    input [31:0] in0,in1;
    input sel;
    mux2to1_8 word0(in0[7:0] , in1[7:0] , sel , out[7:0]);
    mux2to1_8 word1(in0[15:8] ,in1[15:8],  sel , out[15:8]);
    mux2to1_8 word2(in0[23:16] , in1[23:16], sel , out[23:16]);
    mux2to1_8 word3(in0[31:24] , in1[31:24],sel , out[31:24]);
endmodule // mux2to1_32



module memory_8(port_a, sel_a, port_b, sel_b, port_s, write_en, clk);
   
   output [7:0] port_a, port_b;
   input     sel_a, sel_b, write_en, clk;
   input [7:0]     port_s;
   
   wire [7:0]     dout, mux_out;
   
   mux2to1_8 m0(dout, port_s, write_en, mux_out);
   
   dff_8 d(mux_out, clk, dout);
   
   tris_8 ta(dout, sel_a, port_a);
   tris_8 tb(dout, sel_b, port_b);
   
endmodule // memory_8


module memory16_8(port_a, addr_a, port_b, addr_b, port_s, addr_s, write_en, clk);
   
   output [7:0] port_a, port_b;
   input [3:0]     addr_a, addr_b, addr_s;
   input     write_en, clk;
   input [7:0]     port_s;
   
   wire [15:0]     sel_a, sel_b, sel_s;
   
   //Decoding address line
   decoder4to16 da(addr_a, sel_a, 1'b1);
   decoder4to16 db(addr_b, sel_b, 1'b1);
   decoder4to16 ds(addr_s, sel_s, write_en);

   memory_8 m0(port_a, sel_a[0], port_b, sel_b[0], port_s, sel_s[0], clk);
   memory_8 m1(port_a, sel_a[1], port_b, sel_b[1], port_s, sel_s[1], clk);
   memory_8 m2(port_a, sel_a[2], port_b, sel_b[2], port_s, sel_s[2], clk);
   memory_8 m3(port_a, sel_a[3], port_b, sel_b[3], port_s, sel_s[3], clk);
   memory_8 m4(port_a, sel_a[4], port_b, sel_b[4], port_s, sel_s[4], clk);
   memory_8 m5(port_a, sel_a[5], port_b, sel_b[5], port_s, sel_s[5], clk);
   memory_8 m6(port_a, sel_a[6], port_b, sel_b[6], port_s, sel_s[6], clk);
   memory_8 m7(port_a, sel_a[7], port_b, sel_b[7], port_s, sel_s[7], clk);
   memory_8 m8(port_a, sel_a[8], port_b, sel_b[8], port_s, sel_s[8], clk);
   memory_8 m9(port_a, sel_a[9], port_b, sel_b[9], port_s, sel_s[9], clk);
   memory_8 m10(port_a, sel_a[10], port_b, sel_b[10], port_s, sel_s[10], clk);
   memory_8 m11(port_a, sel_a[11], port_b, sel_b[11], port_s, sel_s[11], clk);
   memory_8 m12(port_a, sel_a[12], port_b, sel_b[12], port_s, sel_s[12], clk);
   memory_8 m13(port_a, sel_a[13], port_b, sel_b[13], port_s, sel_s[13], clk);
   memory_8 m14(port_a, sel_a[14], port_b, sel_b[14], port_s, sel_s[14], clk);
   memory_8 m15(port_a, sel_a[15], port_b, sel_b[15], port_s, sel_s[15], clk);
   
endmodule // memory16_8

 
module memory16_32(port_a, addr_a, port_b, addr_b, port_s, addr_s, write_en, clk);
    output [31:0] port_a , port_b;
    input [3:0] addr_a,addr_b,addr_s;
    input write_en,clk;
    input [31:0] port_s;
    
    memory16_8 word0(port_a[7:0],addr_a,port_b[7:0],addr_b,port_s[7:0],addr_s,write_en,clk);
    memory16_8 word1(port_a[15:8],addr_a,port_b[15:8],addr_b,port_s[15:8],addr_s,write_en,clk);
    memory16_8 word2(port_a[23:16],addr_a,port_b[23:16],addr_b,port_s[23:16],addr_s,write_en,clk);
    memory16_8 word3(port_a[31:24],addr_a,port_b[31:24],addr_b,port_s[31:24],addr_s,write_en,clk);
endmodule // memory16_32

// Logic module in ALU

module and_8(s, a, b);
   
   output [7:0] s;
   input [7:0]     a,b;
   
   and myand[7:0](s, a, b);
   
endmodule // and_8

module and_32(s, a, b);
   output [31:0] s;
   input [31:0]     a,b;

   and_8 word_0(s[7:0] , a [7:0] , b[7:0] );
   and_8 word_1(s[15:8] , a [15:8] , b[15:8] );
   and_8 word_2(s[23:16] , a [23:16] , b[23:16] );
   and_8 word_3(s[31:24] , a [31:24] , b[31:24] );

endmodule //and_32

module inv_32_op(out, a , b );
    output[31:0] out;
    input[31:0] a;
    input b;

    xor x0(out[0],a[0],b);
    xor x1(out[1],a[1],b);
    xor x2(out[2],a[2],b);
    xor x3(out[3],a[3],b);
    xor x4(out[4],a[4],b);
    xor x5(out[5],a[5],b);
    xor x6(out[6],a[6],b);
    xor x7(out[7],a[7],b);
    xor x8(out[8],a[8],b);
    xor x9(out[9],a[9],b);
    xor x10(out[10],a[10],b);
    xor x11(out[11],a[11],b);
    xor x12(out[12],a[12],b);
    xor x13(out[13],a[13],b);
    xor x14(out[14],a[14],b);
    xor x15(out[15],a[15],b);
    xor x16(out[16],a[16],b);
    xor x17(out[17],a[17],b);
    xor x18(out[18],a[18],b);
    xor x19(out[19],a[19],b);
    xor x20(out[20],a[20],b);
    xor x21(out[21],a[21],b);
    xor x22(out[22],a[22],b);
    xor x23(out[23],a[23],b);
    xor x24(out[24],a[24],b);
    xor x25(out[25],a[25],b);
    xor x26(out[26],a[26],b);
    xor x27(out[27],a[27],b);
    xor x28(out[28],a[28],b);
    xor x29(out[29],a[29],b);
    xor x30(out[30],a[30],b);
    xor x31(out[31],a[31],b);
endmodule // xor_32


module xnor_8(s, a, b);
   
   output [7:0] s;
   input [7:0]     a,b;
   
   xnor myxnor[7:0](s, a, b);
   
endmodule // xnor_8

module xnor_32(s,a,b);
   output [31:0] s ; 
   input [31:0] a , b ; 
   xnor_8 word_0(s[7:0] , a [7:0] , b[7:0] );
   xnor_8 word_1(s[15:8] , a [15:8] , b[15:8] );
   xnor_8 word_2(s[23:16] , a [23:16] , b[23:16] );
   xnor_8 word_3(s[31:24] , a [31:24] , b[31:24] );
endmodule //xnor_32 

// Adder in ALU

module adder(s, co, a, b, ci);

   output s, co;
   input  a, b, ci;
   
   wire   o0, o1, o2;
   
   xor(s, a, b, ci);
   
   or(o0, a, b);
   or(o1, b, ci);
   or(o2, ci, a);
   and(co, o0, o1, o2);
   
endmodule // adder


module adder_8(s, co, of, a, b, ci);
   
   output [7:0] s;
   output     co, of;
   input [7:0]     a, b;
   input     ci;
   
   wire     c1, c2, c3, c4, c5, c6, c7;
   
   adder a0(s[0], c1, a[0], b[0], ci);
   adder a1(s[1], c2, a[1], b[1], c1);
   adder a2(s[2], c3, a[2], b[2], c2);
   adder a3(s[3], c4, a[3], b[3], c3);
   adder a4(s[4], c5, a[4], b[4], c4);
   adder a5(s[5], c6, a[5], b[5], c5);
   adder a6(s[6], c7, a[6], b[6], c6);
   adder a7(s[7], co, a[7], b[7], c7);
   
   xor(of, co, c7);
   
endmodule // adder_8


module addsub_8(s, co, of, a, b, sub);

   output [7:0] s;
   output     co, of;
   input [7:0]     a, b;
   input      sub;
   
   wire [7:0]     xb;
   
   xor x0(xb[0], b[0], sub);
   xor x1(xb[1], b[1], sub);
   xor x2(xb[2], b[2], sub);
   xor x3(xb[3], b[3], sub);
   xor x4(xb[4], b[4], sub);
   xor x5(xb[5], b[5], sub);
   xor x6(xb[6], b[6], sub);
   xor x7(xb[7], b[7], sub);
   
   adder_8 myadder(s, co, of, a, xb, sub);
   
endmodule // addsub_8


module addsub_32(s, co, of, a, b, sub);
   output [31:0] s;
   output  co, of;
   input [31:0] a, b;
   input sub;
   wire co_0,co_1,co_2;
   wire of_0,of_1,of_2;
   wire [31:0] xb;

   inv_32_op x0(xb,b,sub);
   adder_8 myadder_0(s[7:0], co_0, of_0, a[7:0], xb[7:0], sub);
   adder_8 myadder_1(s[15:8], co_1, of_1, a[15:8], xb[15:8], co_0);
   adder_8 myadder_2(s[23:16], co_2, of_2, a[23:16], xb[23:16], co_1);
   adder_8 myadder_3(s[31:24], co, of, a[31:24], xb[31:24], co_2);
endmodule // addsub_32

module addsub_cla32(s,co,of,a,b,sub);
   output [31:0] s;
   output  co, of;
   input [31:0] a, b;
   input sub;
   wire [31:0] xb;

   inv_32_op x0(xb,b,sub);
   adder_cla32 myadder_32(.a(a),.b(xb),.cin(sub),.sum(s),.cout(co));
endmodule
// for PC

module inc_8(s, a);
   
   output [7:0] s;
   wire co;
   input [7:0]     a;
   
   wire  c1, c2, c3, c4, c5, c6, c7;
   
   adder a0(s[0], c1, a[0], 1'b0, 1'b1);
   adder a1(s[1], c2, a[1], 1'b0, c1);
   adder a2(s[2], c3, a[2], 1'b0, c2);
   adder a3(s[3], c4, a[3], 1'b0, c3);
   adder a4(s[4], c5, a[4], 1'b0, c4);
   adder a5(s[5], c6, a[5], 1'b0, c5);
   adder a6(s[6], c7, a[6], 1'b0, c6);
   adder a7(s[7], co, a[7], 1'b0, c7);
   
endmodule // inc_8

// Shifter in ALU

module shift_left_logic_8(s, a, b);
   
   output [7:0] s;
   input [7:0]     a, b;
   
   assign s = a << b[2:0];
   
endmodule // shift_left_logic_8

module shift_left_logic_32(s ,a ,b ) ;
    output [31:0] s;
    input [31:0] a ,b ;
    assign s = a << b[4:0];
endmodule // shift_left_logic_32


module shift_right_logic_8(s, a, b);
   
   output [7:0] s;
   input [7:0]     a, b;
   
   assign s = a >> b[2:0];
   
endmodule // shift_right_logic_8

module shift_right_logic_32(s,a,b);
    output [31:0] s ;
    input [31:0] a ,b ;
    
    assign s = a >> b[4:0];
endmodule


// ALU

module alu_32(s,a,b,op,carry);
    output [31:0] s ;
    output carry;
    input [31:0] a , b ; 
    input [2:0] op;
    
    wire [31:0] ssl ,ssr,saddsub,sand , sxnor;
    wire co,of;

    shift_left_logic_32 my_sll (ssl,a,b);
    shift_right_logic_32 my_srl (ssr,a,b);
    addsub_cla32 my_add_sub(saddsub, co, of,a,b,op[0]);
    and_32 my_and(sand , a , b);
    xnor_32 my_xnor(sxnor,a,b);

   wire [31:0]     s00, s01, s10, s11, s0, s1;
   
   mux2to1_32 mux00(ssl, ssr, op[0], s00);
   assign s01 = saddsub;
   mux2to1_32 mux10(sand, sxnor, op[0], s10);
   assign s11 = 32'bx;

   mux2to1_32 mux0(s00, s01, op[1], s0);
   mux2to1_32 mux1(s10, s11, op[1], s1);

   mux2to1_32 muxs(s0, s1, op[2], s);

   assign carry = co; 


endmodule // alu_32


// PC: program conuter

module PC(pc, power, clk, branch_pc, branch_en, stop_en, next_pc);

   output [7:0] pc, next_pc;
   input     power, clk, branch_en, stop_en;
   input [7:0]     branch_pc;
   
   wire [7:0]     inc_pc, init_pc, temp_pc0, temp_pc1;
   wire     ci;
   
   dff_8 d(next_pc, clk, pc);

   inc_8 myinc(inc_pc, pc);
   
   assign init_pc = 8'b0;

   mux2to1_8 mux0(inc_pc, branch_pc, branch_en, temp_pc0);
   mux2to1_8 mux1(temp_pc0, pc, stop_en, temp_pc1);
   mux2to1_8 mux2(init_pc, temp_pc1, power, next_pc);

endmodule // PC


// Control: instruction decoder

module control(code, write_en, addr_s, addr_a, addr_b, alu_op,
           jz_en, jnz_en,jnc_en,jc_en , branch_pc, imm_en, imm, stop_en,arith_instr);

   output [3:0] addr_s, addr_a, addr_b;
   output     write_en, jz_en, jnz_en,jnc_en ,jc_en, imm_en, stop_en,arith_instr;
   output [7:0] branch_pc, imm;
   output [2:0] alu_op;
   input [15:0] code;
   
   wire     n15, n14, n13, n12;
   
   // ADD/SUB/SLL1/SLR1/AND/XNOR
   //   code: "0 alu_op[2:0] regs rega regb"
   //   signals: write_en
   
   // LOADI
   //   code: "1010 regs imm[7:0]"
   //   signals: write_en, imm_en
   //
   //   JNC 
   //   code : "1011 pc[7:4] xxxx pc[3:0] " 
   //   signals jnc_en

   // JZ
   //   code: "1000 pc[7:4] rega pc[3:0]"
   //   signals: jz_en

   // JNZ
   //   code: "1001 pc[7:4] rega pc[3:0]"
   //   signals: jnz_en

   // STOP
   //   code: "1111 xxxx xxxx xxxx"
   //   signals: stop_en
   
   assign alu_op = {code[14], code[13], code[12]};
   assign addr_s = {code[11], code[10], code[9], code[8]};
   assign addr_a = {code[7], code[6], code[5], code[4]};
   assign addr_b = {code[3], code[2], code[1], code[0]};
   assign imm = {code[7], code[6], code[5], code[4],
         code[3], code[2], code[1], code[0]};
   assign branch_pc = {code[11], code[10], code[9], code[8],
               code[3], code[2], code[1], code[0]};
   
   not(n15, code[15]);
   not(n14, code[14]);
   not(n13, code[13]);
   not(n12, code[12]);

   and(stop_en, code[15], code[14], code[13], code[12]);

   and(imm_en, code[15], n14, code[13], n12);
   
   or(write_en, imm_en, n15);

   and(jz_en, code[15], n14, n13, n12);

   and(jnz_en, code[15], n14, n13, code[12]);
   and(jnc_en , code[15],n14,code[13],code[12]);
   and(jc_en,code[15],code[14],n13,n12);
   and(arith_instr , n15,n14,code[13]);

endmodule // control


// CPU

module cpu32(power, clk, pc, mem_s, code, write_en, imm_en, branch_en, next_pc,arithInstr,carryOut);
   
   output [7:0] pc,  next_pc;
   output       write_en, imm_en, branch_en;
   output [31:0] mem_s;
   output arithInstr,carryOut;

   input [15:0] code;
   input     power, clk;

   wire     a_nz, a_z, bz, bnz, bnc,stop_en, jz_en, jnz_en,jnc_en,jc_en,bc;
   wire [7:0]     imm, branch_pc;
   wire [31:0]    a ,b , alu_s;
   wire [3:0]     addr_a, addr_b, addr_s;
   wire [2:0]     alu_op;
   wire co,carry,carry_n,carry_lat,carry_lat_c;
   wire arith_instr,arith_instr_d;
   wire carry_latch_sel,nclk;
   
   
   assign arithInstr = arith_instr;
   assign carryOut = co;
   PC mypc(pc, power, clk, branch_pc, branch_en, stop_en, next_pc);
   
   control myctl(code, write_en, addr_s, addr_a, addr_b, alu_op,
         jz_en, jnz_en,jnc_en,jc_en, branch_pc, imm_en, imm, stop_en,arith_instr);
   
   alu_32 myalu(alu_s, a, b, alu_op ,co);
   
   memory16_32 myram(a, addr_a, b, addr_b, mem_s, addr_s, write_en, clk);
  
   dff co_d(carry_lat_c,clk,carry_lat);
   dff  arith_d(arith_instr,clk,arith_instr_d);
   //not nclk_inst (nclk,clk);
   //and carry_sel_and(carry_latch_sel,nclk,arith_instr);
   mux2to1 carry_lat_mux (carry_lat,co,arith_instr ,carry_lat_c);

   // Branch logic
   or(a_nz, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25], a[26], a[27], a[28], a[29], a[30], a[31]);
   not(a_z, a_nz);
   not (carry_n,carry_lat);
   and(bz, a_z, jz_en);
   and(bnz, a_nz, jnz_en);
   and(bnc,carry_n,jnc_en);
   and(bc,carry_lat,jc_en);
   or(branch_en, bz, bnz,bnc,bc);

   // Choose output
   mux2to1_32 alu_out(alu_s, {24'b0,imm}, imm_en, mem_s);
   
endmodule // cpu
