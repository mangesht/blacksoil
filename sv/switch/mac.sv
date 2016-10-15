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
        // QM to MAC interface 
        output logic mac_qm_rdy,
        input logic [11:0] qm_mac_pkt_len,
        input logic qm_mac_data_valid,
        input logic qm_mac_sop,
        input logic qm_mac_eop,
        input logic[255:0] qm_mac_data,

        // Arbiter Interface 
        input logic arb_mac_rdy , 
        output logic arb_valid , 
        output logic [11:0] mac_fe_pkt_len,
        output logic mac_fe_data_valid,
        output logic mac_fe_sop,
        output logic mac_fe_eop,
        output logic[255:0] mac_fe_data 
        

);
reg buf_0;
reg [8:0] buf_idx; 
reg [31:0] pkt_buf_0[1536];
reg [31:0] pkt_buf_1[1536];
reg [11:0] pkt_0_len;
reg [11:0] pkt_1_len;
reg pkt_0_valid; 
reg pkt_1_valid; 

//reg tx_eop;
//reg tx_valid;
wire[2:0]       bv;


reg [31:0] out_pkt_buf[1536];
reg [8:0] out_rd_ptr;
reg [8:0] out_wr_ptr;
reg out_buf_empty;

assign bv = rx_bv == 0 ? 4 : rx_bv ; 
assign arb_valid = pkt_0_valid | pkt_1_valid ; 
// Receive the packet from Phy 
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

// Send the packet FE 
reg [11:0] out_b_cnt;
always @(posedge clk)begin 
    if(reset) begin 
        mac_fe_sop = 0;
        mac_fe_eop = 0;
        mac_fe_data_valid = 0;
    end else begin 
       if(arb_mac_rdy & (pkt_0_valid | pkt_1_valid)) begin 
            mac_fe_sop = out_b_cnt == 0 ? 1 : 0 ; 
       end 
                
        if(arb_mac_rdy & pkt_0_valid) begin 
            mac_fe_pkt_len = pkt_0_len ;
            if(out_b_cnt < pkt_0_len) begin 
                mac_fe_data = { pkt_buf_0[out_b_cnt+7],pkt_buf_0[out_b_cnt+6],pkt_buf_0[out_b_cnt+5],pkt_buf_0[out_b_cnt+4],pkt_buf_0[out_b_cnt+3],pkt_buf_0[out_b_cnt+2],pkt_buf_0[out_b_cnt+1],pkt_buf_0[out_b_cnt] };
               mac_fe_data_valid = 1;  
               mac_fe_eop = (out_b_cnt+16) >= pkt_0_len  ? 1 : 0 ; 
               out_b_cnt += 16;
            end 
        end else if (arb_mac_rdy & pkt_1_valid) begin 
            mac_fe_pkt_len = pkt_1_len ;
            if(out_b_cnt < pkt_1_len) begin 
                mac_fe_data = { pkt_buf_1[out_b_cnt+7],pkt_buf_1[out_b_cnt+6],pkt_buf_1[out_b_cnt+5],pkt_buf_1[out_b_cnt+4],pkt_buf_1[out_b_cnt+3],pkt_buf_1[out_b_cnt+2],pkt_buf_1[out_b_cnt+1],pkt_buf_1[out_b_cnt] };
               mac_fe_data_valid = 1;  
               mac_fe_eop = (out_b_cnt+16) >= pkt_1_len  ? 1 : 0 ; 
               out_b_cnt += 16;
            end 
        end else begin 
           mac_fe_data_valid = 0;  
        end 
    end 
end

// Packet send of Tx MAC Interface
reg [11:0 ] out_pkt_len;
always @(posedge clk) begin 
    if(reset) begin 
            out_wr_ptr = 0 ;
    end else begin 
        if(qm_mac_data_valid & qm_mac_sop) begin 
            out_pkt_len = qm_mac_pkt_len;
        end 
        if(qm_mac_data_valid) begin 
            for(int i=0;i<8;i++) begin 
                out_pkt_buf[out_wr_ptr + i ] = qm_mac_data[i*8+:32];
            end
            out_wr_ptr+=8;
        end else begin 
            out_wr_ptr = 0;
        end 
    end 
end 

always @(posedge clk) begin 
    if(reset) begin 
        out_buf_empty = 1; 
    end else begin 
        if(qm_mac_data_valid & qm_mac_sop) begin 
            out_buf_empty = 0; 
        end else if(tx_eop & tx_valid) begin 
            out_buf_empty = 1; 
        end 
    end 
end

always @(posedge clk) begin 
    if(reset) begin 
        out_rd_ptr=0;
    end else begin 
        if(!out_buf_empty)begin
            tx_valid = 1; 
            tx_data = out_pkt_buf[out_rd_ptr];
            tx_sop = out_rd_ptr == 0 ; 
            tx_eop = (out_rd_ptr * 4 + 4) >= out_pkt_len ? 1 : 0 ; 
            out_rd_ptr++;
      end else begin 
            tx_valid = 0 ; 
            out_rd_ptr=0;
      end
    end
end

initial begin 
        $display("I am MAC ");
end 

endmodule 
