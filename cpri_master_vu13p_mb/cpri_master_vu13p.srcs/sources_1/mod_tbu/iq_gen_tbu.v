`timescale 1 ns / 1 ps
//----------------------------------------------------------------------------- 
//Copyright @2022 ,  zhongguancunchuangxinyuan. All rights reserved.
//Author(s)       :  zhangyunliang 
//Email           :  zhangyunliang@zgc-xnet.con
//Creation Date   :  2022-10-20
//File name       :  nr_tbu.v
//-----------------------------------------------------------------------------
//Detailed Description :                                                     
//
//
//
//-----------------------------------------------------------------------------
module iq_gen_tbu #(
   parameter  SIM_TEST           = 0, 
   parameter  CLK_SET            = 2 // 1=122.88, 2=245.76, 4=491.52
)
(

	  input	  wire				      clk               ,  
	  input	  wire				      rst               ,
	  input   wire                   i_enable          ,	                                        									                                        									
	  input	  wire				      i_ref_10ms_head   ,  	
	  input	  wire		[9:0]     i_ref_frame_num   ,
	  input   wire    [15:0]    speed             ,

    output  reg     [63:0]    o_iq_tx           ,         
    output  reg               o_nodebfn_tx_strobe ,
    output  reg     [9:0]    o_nodebfn_tx_nr     
//---------------------------------------------------------------------------//

); 

  //constant bfc_max           : unsigned(15 downto 0) := 16'h95FF; -- basic frame count 256x150=38400

  //signal bfn_i               : unsigned(15 downto 0) := x"9400";  -- CHANGE ARBITRARY START UP BFN No.
  //signal nodebfn_tx_nr_i     : unsigned(11 downto 0) := x"29A";   -- CHANGE ARBITRARY START UP NODEBFN No.

localparam     bfc_max = 16'h95FF   ;               //basic frame count 256x150=38400        
localparam     iq_tx_max_cnt = 16'h180 -4 ;//- byte_width;
	reg [3:0 ]   byte_width =4 ;
	reg [15:0]   iq_tx_cnt = 'd0;
  reg [15:0]   bfn_i = 16'd0;
  reg [9:0]   nodebfn_tx_nr_i ;
  reg          nodebfn_tx_strobe_i = 0 ;
  wire [63:0]  iq_tx_i  ;
  reg          ref_10ms_hd_d1 , ref_10ms_hd_d2 ;
  wire         ref_10ms_hd_p ;
  reg [15:0]   speed_r = 16'd0 ;
  reg [15:0] nodebfn_tx_strobe_cnt ;
  //test
 // reg  i_enable = 0 ;
  
always@(posedge clk)
begin
      if (speed != speed_r) begin
        iq_tx_cnt <= 'h0; 
        bfn_i <= 'h0;
      end
      
      else if (i_enable == 1'b1) 
        iq_tx_cnt <= {12'h000 ,byte_width};
        
      else if (iq_tx_cnt == iq_tx_max_cnt) begin
        iq_tx_cnt <= 'h0;
        if (bfn_i == bfc_max) begin
           bfn_i <= 'h0;      
        end
        else
          bfn_i <= bfn_i + 1;
    
      end   
          
      else
        iq_tx_cnt <= iq_tx_cnt + 4;
// Register outputs
      o_iq_tx <= iq_tx_i;
      speed_r <= speed ;   
end

always@(posedge clk) begin
    ref_10ms_hd_d1 <= i_ref_10ms_head ;
    ref_10ms_hd_d2 <= ref_10ms_hd_d1  ;   
end

assign ref_10ms_hd_p = ~ref_10ms_hd_d2 && ref_10ms_hd_d1 ;


assign  iq_tx_i = {iq_tx_cnt+16'd3 , iq_tx_cnt+16'd2 ,iq_tx_cnt+16'd1, iq_tx_cnt};


always@(posedge clk)
begin
  if (rst) begin
    nodebfn_tx_strobe_i <= 'b0 ;  
  end
  else if(ref_10ms_hd_p)begin
    nodebfn_tx_strobe_i <= 1;
    nodebfn_tx_strobe_cnt <= 16'h0 ;
  end
  else if (nodebfn_tx_strobe_cnt == iq_tx_max_cnt )begin
    nodebfn_tx_strobe_cnt <= 16'h0 ;
    nodebfn_tx_strobe_i <= 0;
  end
  else 
    nodebfn_tx_strobe_cnt <= nodebfn_tx_strobe_cnt + 16'h4 ;
   
  o_nodebfn_tx_strobe <= nodebfn_tx_strobe_i ;
end

always@(posedge clk)begin
  if (rst) 
    o_nodebfn_tx_nr     <= 'h0 ;
  else if(o_nodebfn_tx_strobe && i_enable )//(ref_10ms_hd_p)
    o_nodebfn_tx_nr <= i_ref_frame_num ;//nodebfn_tx_nr_i + 11'h1 ; 
    
  //o_nodebfn_tx_nr     <=  nodebfn_tx_nr_i  ;
end


//test
/*
always@(posedge clk)
begin
  if (nodebfn_tx_strobe_cnt == iq_tx_max_cnt  )
    i_enable <= 1 ;
  else 
    i_enable <= 0 ;    
end 
*/
endmodule