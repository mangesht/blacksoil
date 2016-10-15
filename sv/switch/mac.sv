    module mac( 
        input logic clk, 
        input logic reset, 

        input logic rx_sop,
        input logic rx_eop,
        input logic rx_valid,
        input logic[31:0] rx_data,
        input logic[1:0] rx_bv,

        output logic tx_sop,
        output logic tx_eop,
        output logic tx_valid,
        output logic[31:0] tx_data,
        output logic[1:0] tx_bv,

        // Arbiter Interface 
        input logic arb_mac_rdy , 
        output logic arb_valid , 
        output logic [11:0] mac_fe_pkt_len,
        output logic[255:0] mac_fe_data 
        

);
reg buf_0;
reg [8:0] buf_idx; 
reg [31:0] pkt_buf_0[1536];
reg [31:0] pkt_buf_1[1536];
reg [11:0] pkt_0_len;
reg [11:0] pkt_1_len;
wire[2:0]       bv;

assign bv = rx_bv == 0 ? 4 : rx_bv ; 
always @(posedge clk) begin 
    if(reset) begin 
        buf_0 = 1; 
        buf_idx = 0 ;
        pkt_0_len = 0; 
        pkt_1_len = 0; 
    end else begin 
        if(rx_valid & rx_eop) begin 
        if(buf_0) begin 
             pkt_0_len = buf_idx * 4 + bv ;
         end else begin 
             pkt_1_len = buf_idx * 4 + bv ;
         end 
            buf_idx = 0 ;
        end else if (rx_valid) begin 
            buf_idx = buf_idx +1 ;
        end
        if(rx_valid) begin 
            if(buf_0) begin 
                pkt_buf_0[buf_idx] = rx_data;
            end else begin 
                pkt_buf_1[buf_idx] = rx_data;
            end
        end 
    end 
end


initial begin 
        $display("I am MAC ");
end 

endmodule 
