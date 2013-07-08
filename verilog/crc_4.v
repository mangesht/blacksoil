module crc_4(reset,clk,inp,rem); 
    input reset;
    input clk;
    input [3:0] inp;
    output[2:0] rem;
    reg [2:0] rem;
    reg [31:0]f ;
    //reg [3:0] g = 'b1001;
    localparam g = 4'b1001;
    reg ans;
   // reg [3:0] inp;
    reg [6:0] d ;
    wire [3:0] q;
    wire [6:0]ds_1;
    wire [6:0]ds_2;
    wire [6:0]ds_3;
    wire [6:0]ds_4;
    reg [7:0] quotient;
//    reg clk;
//    reg reset;
    reg[7:0] cnt;
always @(posedge clk) begin 
        if(reset == 1'b1) begin 
            d = 0;
            cnt = 0;
        end else begin 
            cnt = cnt + 1 ;
            f = f << 4;
            quotient = quotient << 4;
            quotient[3:0] = q[3:0];
            d[6:4] = ds_4[2:0];
            d[3:0] = inp;
            rem = ds_4[2:0];
            //$display("Cnt = %d Quotient = %0b remainder ds_4 =%0b ",cnt,quotient,ds_4);
        end 
    end 
//    always_comb begin : division
assign        q[3] = d[6];
assign        ds_1[5] = d[5]^g[2]&q[3];
assign        ds_1[4] = d[4]^g[1]&q[3];
assign        ds_1[3] = d[3]^g[0]&q[3];
assign        ds_1[2] = d[2];
        //---stage 2 
assign        q[2] = ds_1[5];
assign        ds_2[4] = ds_1[4]^g[2]&q[2];
assign        ds_2[3] = ds_1[3]^g[1]&q[2];
assign        ds_2[2] = ds_1[2]^g[0]&q[2];
assign        ds_2[1] = d[1];
        // -- stage 3 
assign        q[1] = ds_2[4];
assign        ds_3[3] = ds_2[3] ^ g[2] & q[1];
assign        ds_3[2] = ds_2[2] ^ g[1] & q[1];
assign        ds_3[1] = ds_2[1] ^ g[0] & q[1];
assign        ds_3[0] = d[0];
        //-- stage 4 
assign        q[0] = ds_3[3];
assign        ds_4[2] = ds_3[2] ^ g[2] & q[0];
assign        ds_4[1] = ds_3[1] ^ g[1] & q[0];
assign        ds_4[0] = ds_3[0] ^ g[0] & q[0];
//    end 
endmodule 

