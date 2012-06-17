
module pfa (a,b,cin,G,P,s);
input a , b, cin ; 
output G,P,s;
wire a_xor_b;

assign P = a_xor_b;
xor pi (a_xor_b,a,b);
and gi (G,a,b);
xor si (s,a_xor_b,cin);
endmodule 

module cla (cin,p0,g0,p1,g1,p2,g2,p3,g3,c0,c1,c2,c3);
input cin,p0,g0,p1,g1,p2,g2,p3,g3;
output c0,c1,c2,c3;
wire w0,w1,w2,w3 ;
// Gi:0 = Gi + Gi-1:0 . Pi = Ci

//c1 = g1 + g0 . p1 ;
//assign c0 = g0;
and a0(w0,cin,p0);
or o0(c0,g0,w0);

and a1(w1,c0,p1);
or o1 (c1,w1,g1);

and a2(w2,c1,p2);
or o2 (c2,w2,g2);

and a3(w3,c2,p3);
or o3 (c3,w3,g3);


endmodule


module adder_cla4(a,b,cin,sum,cout);
input [3:0] a;
input [3:0] b;
input cin;
output[3:0] sum;
output cout;
wire g0,p0,cout_0;
wire g1,p1,cout_1;
wire g2,p2,cout_2;
wire g3,p3,cout_3;
wire cout_4;

assign cout = cout_3;
pfa pfa_0 (.a(a[0]),.b(b[0]),.cin(cin),.G(g0),.P(p0),.s(sum[0]));
pfa pfa_1 (.a(a[1]),.b(b[1]),.cin(cout_0),.G(g1),.P(p1),.s(sum[1]));
pfa pfa_2 (.a(a[2]),.b(b[2]),.cin(cout_1),.G(g2),.P(p2),.s(sum[2]));
pfa pfa_3 (.a(a[3]),.b(b[3]),.cin(cout_2),.G(g3),.P(p3),.s(sum[3]));


cla cla_0 (.cin(cin),.p0(p0),.g0(g0),.p1(p1),.g1(g1),.p2(p2),.g2(g2),.p3(p3),.g3(g3),.c0(cout_0),.c1(cout_1),.c2(cout_2),.c3(cout_3));
endmodule

module adder_cla8(a,b,cin,sum,cout);
input [7:0] a;
input [7:0] b;
input cin;
output[7:0] sum;
output cout;

wire cout_0;
adder_cla4 add_3_0 (a[3:0],b[3:0],cin,sum[3:0],cout_0);
adder_cla4 add_7_4 (a[7:4],b[7:4],cout_0,sum[7:4],cout);
endmodule


module adder_cla32(a,b,cin,sum,cout);
input [31:0] a;
input [31:0] b;
input cin;
output[31:0] sum;
output cout;
wire cout_0,cout_1 ,cout_2;

adder_cla8 add_7_0 (a[7:0],b[7:0],cin,sum[7:0],cout_0);
adder_cla8 add_15_8 (a[15:8],b[15:8],cout_0,sum[15:8],cout_1);
adder_cla8 add_23_16 (a[23:16],b[23:16],cout_1,sum[23:16],cout_2);
adder_cla8 add_31_24 (a[31:24],b[31:24],cout_2,sum[31:24],cout);

endmodule
