////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s             VMM Tutorial             s////
////s                                      s////
////s           gopi@testbench.in          s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////


`vmm_channel(vmm_data)

program test_channel();
  vmm_data p_put,p_get;
  vmm_data_channel p_c =  new("p_c","chan");
  int i;

  initial
     repeat(10)
         begin
             p_put = new(null);
             p_put.stream_id = i++;
             $display(" Pushed a packet in to channel with id %d",p_put.stream_id);
             p_c.put(p_put);
         end     


   initial 
      forever 
         begin
         #( $urandom()%10);
         p_c.get(p_get);
         $display(" Popped a packet from channel with id %d",p_get.stream_id);
         end 
endprogram 

