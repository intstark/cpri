`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/28 17:35:55
// Design Name: 
// Module Name: bbu_top
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


module bbu_top(

   input                      gty_refclk2p                 ,  
   input                      gty_refclk2n                 ,  
   input                      gty_refclk3p               ,  
   input                      gty_refclk3n               ,     
   input   [3:0]               QSFP2_RXP                  , 
   input   [3:0]               QSFP2_RXN                  , 
   output  [3:0]               QSFP2_TXP                  , 
   output  [3:0]               QSFP2_TXN                  ,   
   input   [3:0]               QSFP3_RXP                  , 
   input   [3:0]               QSFP3_RXN                  , 
   output  [3:0]               QSFP3_TXP                  , 
   output  [3:0]               QSFP3_TXN                  ,  
   
   input                       FPGA_QSFP2_MODPRSL         ,  
   input                       FPGA_QSFP2_INT_L	          ,  
   output                      FPGA_QSFP2_LPMODE	        ,  
   output                      FPGA_QSFP2_RESET_L         ,  
   output                      FPGA_QSFP2_MODSEL	        ,  

   input                       FPGA_QSFP3_MODPRSL         ,  
   input                       FPGA_QSFP3_INT_L	          ,  
   output                      FPGA_QSFP3_LPMODE	        ,  
   output                      FPGA_QSFP3_RESET_L         ,  
   output                      FPGA_QSFP3_MODSEL	        , 

//*******************tbu*************************//
/*
  input                       i_frame_10ms_hd ,
  input                       i_frame_80ms_hd ,
  input                       i_ref_clk_245p76,
 */  
   
  input    wire              i_clk_122_88_mhz_n         ,
  input    wire              i_clk_122_88_mhz_p         ,
  input    wire              i_clk_100mhz_n             ,
  input    wire              i_clk_100mhz_p             ,
  input	   wire              FPGA_SYSCLK33              ,
  input	   wire              i_fpga_sysclk50m           ,
  input	   wire              i_ext_rst                   //reset pin

    );
  
localparam FRAM10MS_CNT_MAX = 2457600 - 1;
localparam FRAM80MS_CNT_MAX = 19660800 - 1; 
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
  wire	     [10:0]	       ref_frame_num        ;
  wire	     [31:0]	       sys_max_delay        ;
  wire	  			       frame5ms_head_out    ;
  wire	  			       frame10ms_head_out   ;
  wire	  			       frame80ms_head_out   ;
  wire	  			       ref_frame_kind       ;
  wire	     [31:0]	       ext_frame_info       ;  
  wire       [9:0]        dw_frame_num          ;
  wire                    dw_frame_hd           ;
  
  assign sys_clk_245p76 = ref_clk_245p76  ;
  assign sys_rst_245p76 = ~locked_245p76 ;
//************************ test func generate 10ms hd inner logic *******************//
reg [23:0 ] fram10ms_cnt = 24'd0 ;
reg [27:0 ] fram80ms_cnt = 24'd0 ;
reg [10:0 ] self_hfn = 0 ;

assign sys_rst = sys_rst_245p76 ;
assign sys_clk = sys_clk_245p76 ;
 always@( posedge sys_clk )begin
 if (sys_rst == 1)
     fram10ms_cnt <= 24'd0 ;
 else if (fram10ms_cnt == FRAM10MS_CNT_MAX )
     fram10ms_cnt <= 24'd0 ;
 else 
     fram10ms_cnt <= fram10ms_cnt + 24'd1 ;
 end
 
 always@( posedge sys_clk )begin
 if (sys_rst == 1)
     fram80ms_cnt <= 24'd0 ;
 else if (fram80ms_cnt == FRAM80MS_CNT_MAX )
     fram80ms_cnt <= 24'd0 ;
 else 
     fram80ms_cnt <= fram80ms_cnt + 24'd1 ;
 end
 
 always@( posedge sys_clk )begin
     if(sys_rst == 1)
	      self_hfn <= 11'd0 ;
     else if (fram10ms_cnt == FRAM10MS_CNT_MAX || fram10ms_cnt == ((FRAM10MS_CNT_MAX+1)/2-1 ))
	      self_hfn <= self_hfn + 11'd1 ;
	  else
	      self_hfn <= self_hfn ; 
 end
 
 assign ref_10ms_head = (fram10ms_cnt == 0);
 assign ref_80ms_head = (fram80ms_cnt == 0);
 assign ref_frame_num = self_hfn ;
 //**********end**************************************
                                               									                                          											      			      	  		   			  			  		  	                 
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
 
 //*************************** cpri ********************************//
cpri_top u1_cpri_top
(
    .gty_refclk2p           (gty_refclk2p )      ,   // input                     
    .gty_refclk2n           (gty_refclk2n )      ,   // input                     
    .gty_refclk3p           (gty_refclk3p )    ,     // input                     
    .gty_refclk3n           (gty_refclk3n )    ,     // input                     
    .QSFP2_RXP              (QSFP2_RXP    )    ,    // input   [3:0]             
    .QSFP2_RXN              (QSFP2_RXN    )    ,    // input   [3:0]             
    .QSFP2_TXP              (QSFP2_TXP    )    ,    // output  [3:0]             
    .QSFP2_TXN              (QSFP2_TXN    )    ,    // output  [3:0]             
    .QSFP3_RXP              (QSFP3_RXP    )    ,    // input   [3:0]             
    .QSFP3_RXN              (QSFP3_RXN    )    ,    // input   [3:0]             
    .QSFP3_TXP              (QSFP3_TXP    )    ,    // output  [3:0]             
    .QSFP3_TXN              (QSFP3_TXN    )    ,    // output  [3:0]             
	
    .FPGA_QSFP2_MODPRSL     (FPGA_QSFP2_MODPRSL)    ,     //input                       
    .FPGA_QSFP2_INT_L	    (FPGA_QSFP2_INT_L	 )      ,     //input                       
    .FPGA_QSFP2_LPMODE	    (FPGA_QSFP2_LPMODE	)    ,   //output                      
    .FPGA_QSFP2_RESET_L     (FPGA_QSFP2_RESET_L)    ,     //output                      
    .FPGA_QSFP2_MODSEL	    (FPGA_QSFP2_MODSEL	)    ,   //output                      
	
    .FPGA_QSFP3_MODPRSL     (FPGA_QSFP3_MODPRSL)    ,     //input                       
    .FPGA_QSFP3_INT_L	    (FPGA_QSFP3_INT_L	 )      ,     //input                       
    .FPGA_QSFP3_LPMODE	    (FPGA_QSFP3_LPMODE	)    ,   //output                      
    .FPGA_QSFP3_RESET_L     (FPGA_QSFP3_RESET_L)    ,     //output                      
    .FPGA_QSFP3_MODSEL	    (FPGA_QSFP3_MODSEL	)    ,   //output                      

    .i_ref_10ms_head        (dw_frame_hd)    ,
    .i_ref_frame_num        (dw_frame_num)    ,
    .o_ref_clk_368p64       (ref_clk_368p64)    ,
   .i_clk_122_88_mhz_n      (i_clk_122_88_mhz_n      )   ,                  //  input    wire              
   .i_clk_122_88_mhz_p      (i_clk_122_88_mhz_p      )   ,                  //  input    wire              
   .i_clk_100mhz_n          (i_clk_100mhz_n          )   ,                  //  input    wire              
   .i_clk_100mhz_p          (i_clk_100mhz_p          )   ,                  //  input    wire              
   .FPGA_SYSCLK33           (FPGA_SYSCLK33           )   ,                  //  input		 wire            
   .i_fpga_sysclk50m        (i_fpga_sysclk50m        )   ,                  //  input	   wire              
   .i_ext_rst               (i_ext_rst               )    //reset pin       //  input	   wire     
);

//********************* gen 245p76 ***********************

clk_245p76_gen u_clk_245p76_gen
   (
    // Clock out ports
    .clk_out1(ref_clk_245p76),     // output clk_out1
    // Status and control signals
    .reset(1'b0), // input reset
    .locked(locked_245p76),       // output locked
   // Clock in ports
    .clk_in1(ref_clk_368p64)      // input clk_in1
);

endmodule
