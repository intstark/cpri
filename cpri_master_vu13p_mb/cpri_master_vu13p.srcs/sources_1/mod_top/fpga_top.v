`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/29 14:24:44
// Design Name: 
// Module Name: fpga_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fpga_top(
   input                       gty_refclk0p              ,  
   input                       gty_refclk0n              ,  
   input                       gty_refclk1p              ,  
   input                       gty_refclk1n              ,     
   input   [3:0]               SFP_RXP                   , 
   input   [3:0]               SFP_RXN                   , 
   output  [3:0]               SFP_TXP                   , 
   output  [3:0]               SFP_TXN                   ,   
   //output  [3:0]             SFP_TX_disable_n	         ,  

   input    wire               i_clk_100m_n         ,
   input    wire               i_clk_100m_p         ,
   input    wire               i_clk_125m_n         ,
   input    wire               i_clk_125m_p         ,
   input    wire               i_clk_SI570_n        ,
   input    wire               i_clk_SI570_p        , //PIN_J19, SI570 output,default 300M
   
   output   wire               o_cpri_re_recclk_p   ,   
   output   wire               o_cpri_re_recclk_n      
    );
//var declare
//**************************    PLL       ************************//
 wire  ref_clk_245p76 ;
 wire  ref_clk_368p64 ;
 wire  rst_245p76  ;
 wire  locked_245p76   ;
 //*************************    TBU       ************************//
  wire				       sys_clk_245p76       ;
  wire				       sys_rst_245p76       ;
  wire        [1:0]        nr_scs_cfg           ;
  wire				       ref_10ms_head        ;
  wire				       ref_80ms_head        ;
  wire	     [11:0]	       ref_frame_num        ;
  wire	     [31:0]	       sys_max_delay        ;
  wire	  			       frame5ms_head_out    ;
  wire	  			       frame10ms_head_out   ;
  wire	  			       frame80ms_head_out   ;
  wire	  			       ref_frame_kind       ;
  wire	     [31:0]	       ext_frame_info       ;  
  wire       [9:0]        dw_frame_num          ;
  wire                    dw_frame_hd           ;
  //*******************cpri buff***********************//
  wire      [63:0]        iq_rx_ch0             ;
  wire      [63:0]        iq_rx_ch1             ;
  wire      [63:0]        iq_rx_ch2             ;
  wire      [63:0]        iq_rx_ch3             ;
  wire      [255:0]       iq_rx                 ;
  wire      [255:0]      iq_rx_delay ;
wire        [15:0]       delay_value ;
  
  
  assign sys_clk_245p76 = ref_clk_245p76  ;
  assign sys_rst_245p76 = ~locked_245p76 ;
  assign iq_rx_ch0      = iq_rx[63+64*0:64*0] ;
  assign iq_rx_ch1      = iq_rx[63+64*1:64*1] ;
  assign iq_rx_ch2      = iq_rx[63+64*2:64*2] ;
  assign iq_rx_ch3      = iq_rx[63+64*3:64*3] ;
//******************* TBU *****************// 
sys_tbu #(
//   SIM_TEST:  for sim,it=1;for prj,it=0.
//   CLK_SET:   1=122.88, 2=245.76, 4=491.52
	  .SIM_TEST                               (1'd0                   ),
	  .CLK_SET                                (3'd2                   )
) u_sys_tbu
      (
    .clk                                    (sys_clk_245p76         ),//sys_clk_491_52
    .rst                                    (sys_rst_245p76         ),//sys_rst_491_52
    .nr_scs_cfg                             (2'd2                   ),//120k=0,60k=1,30k=2,15k=3.
    .i_ref_10ms_head                        (ref_10ms_head          ),//o_frame10ms_head      
    .i_ref_80ms_head                        (ref_80ms_head          ),//o_frame80ms_head      
    .i_ref_frame_num                        (ref_frame_num          ),
    .i_sys_max_delay                        (32'b0                  ),
    .i_10ms_ul_dl_gap                       (32'b0                  ), 
    .o_frame5ms_head                        (frame5ms_head_out      ),
    .o_frame10ms_head                       (frame10ms_head_out     ),
    .o_frame80ms_head                       (frame80ms_head_out     ),
    .o_ref_frame_kind                       (ref_frame_kind         ),
    .o_ext_frame_info                       (ext_frame_info         ),
//---------------------------------------------------------------------------//
//--uplink info 	    
    .i_ul_0_frame_pos			                    (32'h10                 ),
//    .o_ul_0_half_frame_num     		          (m_ul_0_half_frame_num  ),
//    .o_ul_0_frame_num          	            (m_ul_0_frame_num       ),
//    .o_ul_0_slot_num           	            (m_ul_0_slot_num        ),
//    .o_ul_0_symb_num           		          (m_ul_0_symb_num        ),
//    .o_ul_0_half_frame_head    		          (m_ul_0_half_frame_head ),
//    .o_ul_0_frame_head         		          (m_ul_0_frame_head      ),
//    .o_ul_0_slot_head          		          (m_ul_0_slot_head       ),
//    .o_ul_0_symb_head          		          (m_ul_0_symb_head       ),
//    .o_ul_0_10us_or_5us_num    		          (m_ul_0_10us_or_5us_num ),
//    .o_ul_0_10us_or_5us_vld    		          (m_ul_0_10us_or_5us_vld ),

    .i_ul_1_frame_pos			                    (32'h10                 ),
//    .o_ul_1_half_frame_num     		          (m_ul_1_half_frame_num  ),
//    .o_ul_1_frame_num          	            (m_ul_1_frame_num       ),
//    .o_ul_1_slot_num           	            (m_ul_1_slot_num        ),
//    .o_ul_1_symb_num           		          (m_ul_1_symb_num        ),
//    .o_ul_1_half_frame_head    		          (m_ul_1_half_frame_head ),
//    .o_ul_1_frame_head         		          (m_ul_1_frame_head      ),
//    .o_ul_1_slot_head          		          (m_ul_1_slot_head       ),
//    .o_ul_1_symb_head          		          (m_ul_1_symb_head       ),
//    .o_ul_1_10us_or_5us_num    		          (m_ul_1_10us_or_5us_num ),
//    .o_ul_1_10us_or_5us_vld    		          (m_ul_1_10us_or_5us_vld ),   
//---------------------------------------------------------------------------//
//--downlink info  
    .i_dl_0_frame_pos                         (32'h10                 ),
    .o_dl_0_half_frame_num     		          (m_dl_0_half_frame_num  ),
    .o_dl_0_frame_num                         (dw_frame_num           ),
    .o_dl_0_slot_num                          (m_dl_0_slot_num        ),//
    .o_dl_0_symb_num           		          (m_dl_0_symb_num        ),
    .o_dl_0_half_frame_head    		          (m_dl_0_half_frame_head ),
    .o_dl_0_frame_head         		          (dw_frame_hd            ),
    .o_dl_0_slot_head          		          (m_dl_0_slot_head       ),
    .o_dl_0_symb_head          		          (m_dl_0_symb_head       ),
    .o_dl_0_10us_or_5us_num    		          (m_dl_0_10us_or_5us_num ),
    .o_dl_0_10us_or_5us_vld    		          (m_dl_0_10us_or_5us_vld ), 
//---------------------------------------------------------------------------//
//--report to x86                                                               
    .i_prt_frame_pos                        (32'd3  	              ), 
    .o_rpt_half_frame_num                   (m_rpt_half_frame_num   ),
    .o_rpt_frame_num                        (m_rpt_frame_num        ),
    .o_rpt_slot_num                         (m_rpt_slot_num         ),
    .o_rpt_symb_num                         (m_rpt_symb_num         ),
    .o_rpt_half_frame_head                  (m_rpt_half_frame_head  ),
    .o_rpt_frame_head                       (m_rpt_frame_head       ),
    .o_rpt_slot_head                        (m_rpt_slot_head        ),
    .o_rpt_symb_head                        (m_rpt_symb_head        ),
    .o_rpt_10us_or_5us_num                  (m_rpt_10us_or_5us_num  ),
    .o_rpt_10us_or_5us_vld                  (m_rpt_10us_or_5us_vld  ) 
);
 
    //******************* CPRI ****************//
    re_top u1_re_top
    (
      .gty_refclk0p            (gty_refclk0p      )  ,  
      .gty_refclk0n            (gty_refclk0n      )  ,  
      .gty_refclk1p            (gty_refclk1p      )  ,  
      .gty_refclk1n            (gty_refclk1n      )  ,     
      .SFP_RXP                 (SFP_RXP           )  , 
      .SFP_RXN                 (SFP_RXN           )  , 
      .SFP_TXP                 (SFP_TXP           )  , 
      .SFP_TXN                 (SFP_TXN          )  ,   

      .i_clk_100m_n            (i_clk_100m_n      )  ,
      .i_clk_100m_p            (i_clk_100m_p      )  ,
      .i_clk_125m_n            (i_clk_125m_n      )  ,
      .i_clk_125m_p            (i_clk_125m_p      )  ,
      .i_clk_SI570_n           (i_clk_SI570_n     )  ,
      .i_clk_SI570_p           (i_clk_SI570_p     )  , //PIN_J19, SI570 output,default 300M
      
      .o_iq_rx                 (iq_rx) ,
      .i_iq_tx                 () ,
      //.i_ref_10ms_head         (dw_frame_hd       )  ,   //input                      
      //.i_ref_frame_num         (dw_frame_num      )  ,   //input  wire [9:0]         
      .o_ref_clk_368p64        (ref_clk_368p64    )  ,   //output                     
      .o_nodebfn_rx_strobe     (ref_10ms_head     )  ,   //output                      
      .o_nodebfn_rx_nr         (ref_frame_num     )  ,   //output  wire [11:0]    
         
      .o_cpri_re_recclk_p      (o_cpri_re_recclk_p)  ,   
      .o_cpri_re_recclk_n      (o_cpri_re_recclk_n)
  
    );
    
vio_cpri_10km_buf u_vio_cpri_10km_buf (
  .clk(ref_clk_368p64),                // input wire clk
  .probe_in0(iq_rx[63:0]),    // input wire [63 : 0] probe_in0
  .probe_in1(iq_rx_delay[63:0]),    // input wire [63 : 0] probe_in1
  .probe_out0(delay_value)  // output wire [15 : 0] probe_out0
);
//********************** iq_buf ****************************//
(* dont_touch = "ture" *)cpri_10km_buff u2_cpri_10km_buff
(
  .clk            (ref_clk_368p64),
  .rst            (1'b0),
  .i_iq_data      (iq_rx),
  .i_delay_value  (delay_value),
  .o_iq_data_10km (iq_rx_delay) 
 );
 

//********************* gen 245p76 ***********************
clk_245p76_gen u3_clk_245p76_gen
   (
    // Clock out ports
    .clk_out1(ref_clk_245p76),     // output clk_out1
    // Status and control signals
    .reset(rst_245p76), // input reset
    .locked(locked_245p76),       // output locked
   // Clock in ports
    .clk_in1(ref_clk_368p64)      // input clk_in1
);

//
    

 
endmodule
