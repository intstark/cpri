

`timescale 1ps/1ps

module cpri_top
(
    input                           gty_refclk2p        ,
    input                           gty_refclk2n        ,
    input                           gty_refclk3p        ,
    input                           gty_refclk3n        ,
    input          [   3: 0]        QSFP2_RXP           ,
    input          [   3: 0]        QSFP2_RXN           ,
    output         [   3: 0]        QSFP2_TXP           ,
    output         [   3: 0]        QSFP2_TXN           ,
    input          [   3: 0]        QSFP3_RXP           ,
    input          [   3: 0]        QSFP3_RXN           ,
    output         [   3: 0]        QSFP3_TXP           ,
    output         [   3: 0]        QSFP3_TXN           ,
   
    input                           FPGA_QSFP2_MODPRSL  ,
    input                           FPGA_QSFP2_INT_L    ,
    output                          FPGA_QSFP2_LPMODE   ,
    output                          FPGA_QSFP2_RESET_L  ,
    output                          FPGA_QSFP2_MODSEL   ,

    input                           FPGA_QSFP3_MODPRSL  ,
    input                           FPGA_QSFP3_INT_L    ,
    output                          FPGA_QSFP3_LPMODE   ,
    output                          FPGA_QSFP3_RESET_L  ,
    output                          FPGA_QSFP3_MODSEL   ,

    input                           i_ref_10ms_head     ,
    input  wire    [   9: 0]        i_ref_frame_num     ,
    output                          o_ref_clk_368p64    ,
    input  wire                     i_clk_122_88_mhz_n  ,
    input  wire                     i_clk_122_88_mhz_p  ,
    input  wire                     i_clk_100mhz_n      ,
    input  wire                     i_clk_100mhz_p      ,
    input  wire                     FPGA_SYSCLK33       ,
    input  wire                     i_fpga_sysclk50m    ,
    input  wire                     i_ext_rst            //reset pin

);
 

logic                      qpll0clk_out    ;
logic                      qpll0refclk_out ;
logic                      qpll1clk_out    ;
logic                      qpll1refclk_out ;
logic                      qpll0lock_out   ;
logic                      qpll1lock_out   ;
   

 
//clk               
logic              sys_clk_300                    ;
logic              sys_rst_300                    ;
logic              sys_clk_25                    ;
logic              sys_rst_25                    ;
logic              sys_clk_100                    ;
logic              sys_rst_100                    ;
logic              sys_clk_491_52                 ;
logic              sys_rst_491_52                 ;
logic              sys_clk_368_64                 ;
logic              sys_rst_368_64                 ;
logic              sys_clk_245_76                 ;
logic              sys_rst_245_76                 ;
logic              sys_clk_122_88                 ;
logic              sys_rst_122_88                 ;
logic              sys_clk_61_44                  ;
logic              sys_rst_61_44                  ;
logic              fpga_clk_100mhz                ;
logic              fpga_rst_100mhz                ;
logic              fpga_clk_250mhz                ;
logic              fpga_rst_250mhz                ;
logic              fpga_clk_400mhz                ;
logic              fpga_rst_400mhz                ;
logic              o_frame10ms_head               ;
logic              o_frame80ms_head               ;

logic  [7:0]       cpri_clkout;
logic  [7:0]       iq_tx_enable;
logic  [7:0][63:0] iq_tx;
logic  [7:0][63:0] iq_rx;
logic  [7:0]       bffw;
logic  [7:0]       nodebfn_rx_strobe;
logic  [7:0][11:0] nodebfn_rx_nr;
logic  [7:0]       nodebfn_tx_strobe;
logic  [7:0][11:0] nodebfn_tx_nr;
logic  [7:0]       stat_alarm;
logic  [7:0][3:0]  stat_code;
logic  [7:0][14:0] stat_speed;
logic  [7:0]       mii_txdv;
logic  [7:0][3:0]  mii_txd;
logic  [7:0][3:0]  mii_rx_ready;
logic  [7:0]       mii_rxen;
logic  [7:0][3:0]  mii_rxd;
logic  [7:0]       eth_rx_avail;
logic  [7:0]       eth_rx_ready;
logic  [7:0]       nodebfn_valid;
logic  [7:0]       nodebfn_valid_eth;

logic [7:0]           s_axi_aclk   ;
logic [7:0]           s_axi_aresetn;
logic [7:0][11 : 0]   s_axi_awaddr ;
logic [7:0]           s_axi_awvalid;
logic [7:0]           s_axi_awready;
logic [7:0][31 : 0]   s_axi_wdata  ;
logic [7:0]           s_axi_wvalid ;
logic [7:0]           s_axi_wready ;
logic [7:0][1 : 0]    s_axi_bresp  ;
logic [7:0]           s_axi_bvalid ;
logic [7:0]           s_axi_bready ;
logic [7:0][11 : 0]   s_axi_araddr ;
logic [7:0]           s_axi_arvalid;
logic [7:0]           s_axi_arready;
logic [7:0][31 : 0]   s_axi_rdata  ;
logic [7:0][1 : 0]    s_axi_rresp  ;
logic [7:0]           s_axi_rvalid ;
logic [7:0]           s_axi_rready ;

logic  [31 : 0] m_axi_awaddr ;
logic  [2 : 0]  m_axi_awprot ;
logic           m_axi_awvalid;
logic           m_axi_awready;
logic  [31 : 0] m_axi_wdata  ;
logic  [3 : 0]  m_axi_wstrb  ;
logic           m_axi_wvalid ;
logic           m_axi_wready ;
logic [1 : 0]   m_axi_bresp  ;
logic           m_axi_bvalid ;
logic           m_axi_bready ;
logic  [31 : 0] m_axi_araddr ;
logic  [2 : 0]  m_axi_arprot ;
logic           m_axi_arvalid;
logic           m_axi_arready;
logic [31 : 0]  m_axi_rdata  ;
logic [1 : 0]   m_axi_rresp  ;
logic           m_axi_rvalid ;
logic           m_axi_rready ;

logic [7:0]           iq_rx_word_err;
logic [7:0][31 : 0]   iq_rx_frame_count  ;
logic [7:0][31 : 0]   iq_rx_error_count  ;
logic [7:0][11: 0]    iq_rx_nodebfn_rx_nr_store  ;
logic [31:0]    source;

wire           [  31: 0]        BRAM_PORTA_addr     ;
wire                            BRAM_PORTA_en       ;
wire                            BRAM_PORTA_rst      ;
wire           [  31: 0]        BRAM_PORTA_din      ;
wire           [   3: 0]        BRAM_PORTA_we       ;
wire           [  31: 0]        GPIO_tri_io         ;





assign FPGA_QSFP2_LPMODE  = 1'b0;
assign FPGA_QSFP2_RESET_L = 1'b1;
assign FPGA_QSFP2_MODSEL  = 1'b0;

assign FPGA_QSFP3_LPMODE  = 1'b0;
assign FPGA_QSFP3_RESET_L = 1'b1;
assign FPGA_QSFP3_MODSEL  = 1'b0;


//---------------------------------------------------------------------------//
//--clk mmcm
//--These two clocks have different sources  
assign o_ref_clk_368p64 = cpri_clkout [0] ;

vio_1 vio_top (
    .clk                                (i_fpga_sysclk50m   ),// input wire clk 
    .probe_out0                         (source             ) // output wire [31 : 0] probe_out0
);
     
clk_gen  u_clk_gen
      (
    .i_ext_rst                          (source[0]          ),
    .i_fpga_sysclk50m                   (i_fpga_sysclk50m   ),
    .i_clk_122_88_mhz_p                 (i_clk_122_88_mhz_p ),
    .i_clk_122_88_mhz_n                 (i_clk_122_88_mhz_n ),
    .i_clk_100mhz_n                     (i_clk_100mhz_n     ),
    .i_clk_100mhz_p                     (i_clk_100mhz_p     ),
    .o_clk_ext_25mhz                    (fpga_clk_25mhz     ),
    .o_rst_ext_25mhz                    (fpga_rst_25mhz     ),
    .o_clk_ext_100mhz                   (fpga_clk_100mhz    ),
    .o_rst_ext_100mhz                   (fpga_rst_100mhz    ),
    .o_clk_ext_400mhz                   (fpga_clk_400mhz    ),
    .o_rst_ext_400mhz                   (fpga_rst_400mhz    ),
         
    .o_clk_491_52                       (sys_clk_491_52     ),
    .o_rst_491_52                       (sys_rst_491_52     ),
    .o_clk_368_64                       (sys_clk_368_64     ),
    .o_rst_368_64                       (sys_rst_368_64     ),
    .o_clk_245_76                       (sys_clk_245_76     ),
    .o_rst_245_76                       (sys_rst_245_76     ),
    .o_clk_122_88                       (sys_clk_122_88     ),
    .o_rst_122_88                       (sys_rst_122_88     ),
    .o_clk_61_44                        (sys_clk_61_44      ),
    .o_rst_61_44                        (sys_rst_61_44      ) 
);


cprigrp_4ch #(
    .NUM_CHANNELS                       (4                  ) 
) u_cpri_ch_3_0(
    .i_clk_100mhz                       (fpga_clk_100mhz    ),
    .i_rst_100mhz                       (fpga_rst_100mhz    ),
    .i_freerun_clk                      (i_fpga_sysclk50m   ),
    .i_ext_rst                          (fpga_rst_100mhz    ),
    .i_clk_25Mhz                        (fpga_clk_25mhz     ),
    .i_rst_25Mhz                        (fpga_rst_25mhz     ),
    .i_hires_clk                        (fpga_clk_400mhz    ),
    .i_fabric_pll_lock                  (~fpga_rst_400mhz   ),
   
    .GTY_REFCLK_P                       (gty_refclk2p       ),
    .GTY_REFCLK_N                       (gty_refclk2n       ),
    .QSFP_RXP                           (QSFP2_RXP          ),
    .QSFP_RXN                           (QSFP2_RXN          ),
    .QSFP_TXP                           (QSFP2_TXP          ),
    .QSFP_TXN                           (QSFP2_TXN          ),
   
    .o_bffw                             (bffw[3:0]          ),
    .o_nodebfn_rx_strobe                (nodebfn_rx_strobe[3:0]),
    .o_nodebfn_rx_nr                    (nodebfn_rx_nr[3:0] ),
    .i_nodebfn_tx_strobe                ({4{nodebfn_tx_strobe[0]}}),
    .i_nodebfn_tx_nr                    ({4{nodebfn_tx_nr[0]    }}),
    .i_iq_tx_data                       ({4{iq_tx[0]}}      ),
    .o_iq_rx_data                       (iq_rx[3:0]         ),
    .o_iq_tx_enable                     (iq_tx_enable[3:0]  ),
							   
    .i_mii_txdv                         (mii_txdv[3:0]      ),
    .i_mii_txd                          (mii_txd[3:0]       ),
    .i_mii_rx_ready                     (eth_rx_ready[3:0]  ),
    .o_mii_rxen                         (mii_rxen[3:0]      ),
    .o_mii_rxd                          (mii_rxd[3:0]       ),
    .o_mii_avil                         (eth_rx_avail[3:0]  ),
 							  
    .o_stat_alarm                       (stat_alarm[3:0]    ),
    .o_stat_code                        (stat_code[3:0]     ),
    .o_stat_speed                       (stat_speed[3:0]    ),
							   
    .o_recclk_ok                        (                   ),
    .o_clk_ok_out                       (                   ),
    .o_recclk                           (                   ),
    .o_clk_out                          (cpri_clkout[3:0]   ),
    .o_rxrecclkout                      (                   ),
    .o_txusrclk_out                     (                   ),

    .s_axi_aclk                         (fpga_clk_100mhz    ),// input wire s_axi_aclk
    .s_axi_aresetn                      (~fpga_rst_100mhz   ),// input wire s_axi_aresetn
    .s_axi_awaddr                       (s_axi_awaddr  [3:0]),// input wire [11 : 0] s_axi_awaddr
    .s_axi_awvalid                      (s_axi_awvalid [3:0]),// input wire s_axi_awvalid
    .s_axi_awready                      (s_axi_awready [3:0]),// output wire s_axi_awready
    .s_axi_wdata                        (s_axi_wdata   [3:0]),// input wire [31 : 0] s_axi_wdata
    .s_axi_wvalid                       (s_axi_wvalid  [3:0]),// input wire s_axi_wvalid
    .s_axi_wready                       (s_axi_wready  [3:0]),// output wire s_axi_wready
    .s_axi_bresp                        (s_axi_bresp   [3:0]),// output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid                       (s_axi_bvalid  [3:0]),// output wire s_axi_bvalid
    .s_axi_bready                       (s_axi_bready  [3:0]),// input wire s_axi_bready
    .s_axi_araddr                       (s_axi_araddr  [3:0]),// input wire [11 : 0] s_axi_araddr
    .s_axi_arvalid                      (s_axi_arvalid [3:0]),// input wire s_axi_arvalid
    .s_axi_arready                      (s_axi_arready [3:0]),// output wire s_axi_arready
    .s_axi_rdata                        (s_axi_rdata   [3:0]),// output wire [31 : 0] s_axi_rdata
    .s_axi_rresp                        (s_axi_rresp   [3:0]),// output wire [1 : 0] s_axi_rresp
    .s_axi_rvalid                       (s_axi_rvalid  [3:0]),// output wire s_axi_rvalid
    .s_axi_rready                       (s_axi_rready  [3:0]),// input wire s_axi_rready
   
    .reset_request_in                   ({4{source[4]}}     ),
   //ila
    .i_iq_rx_word_err                   (iq_rx_word_err           [3:0]),
    .i_iq_rx_frame_count                (iq_rx_frame_count        [3:0]),
    .i_iq_rx_error_count                (iq_rx_error_count        [3:0]),
    .i_iq_rx_nodebfn_rx_nr_store        (iq_rx_nodebfn_rx_nr_store[3:0]) 
   
   
);


cprigrp_4ch #(
    .NUM_CHANNELS                       (4                  ) 
) u_cpri_ch_7_4(
    .i_clk_100mhz                       (fpga_clk_100mhz    ),
    .i_freerun_clk                      (i_fpga_sysclk50m   ),
    .i_ext_rst                          (fpga_rst_100mhz    ),
    .i_clk_25Mhz                        (fpga_clk_25mhz     ),
    .i_rst_25Mhz                        (fpga_rst_25mhz     ),
    .i_hires_clk                        (fpga_clk_400mhz    ),
    .i_fabric_pll_lock                  (~fpga_rst_400mhz   ),
   
    .GTY_REFCLK_P                       (gty_refclk3p       ),
    .GTY_REFCLK_N                       (gty_refclk3n       ),
    .QSFP_RXP                           (QSFP3_RXP          ),
    .QSFP_RXN                           (QSFP3_RXN          ),
    .QSFP_TXP                           (QSFP3_TXP          ),
    .QSFP_TXN                           (QSFP3_TXN          ),
    .o_bffw                             (bffw[7:4]          ),
  
    .o_nodebfn_rx_strobe                (nodebfn_rx_strobe[7:4]),
    .o_nodebfn_rx_nr                    (nodebfn_rx_nr[7:4] ),
    .i_nodebfn_tx_strobe                ({4{nodebfn_tx_strobe[4]}}),
    .i_nodebfn_tx_nr                    ({4{nodebfn_tx_nr[4]    }}),
    .i_iq_tx_data                       ({4{iq_tx[4]}}      ),
    .o_iq_rx_data                       (iq_rx[7:4]         ),
    .o_iq_tx_enable                     (iq_tx_enable[7:4]  ),
							   
    .i_mii_txdv                         (mii_txdv[7:4]      ),
    .i_mii_txd                          (mii_txd[7:4]       ),
    .i_mii_rx_ready                     (eth_rx_ready[7:4]  ),
    .o_mii_rxen                         (mii_rxen[7:4]      ),
    .o_mii_rxd                          (mii_rxd[7:4]       ),
    .o_mii_avil                         (eth_rx_avail[7:4]  ),
 							  
    .o_stat_alarm                       (stat_alarm[7:4]    ),
    .o_stat_code                        (stat_code[7:4]     ),
    .o_stat_speed                       (stat_speed[7:4]    ),
							   
    .o_recclk_ok                        (                   ),
    .o_clk_ok_out                       (                   ),
    .o_recclk                           (                   ),
    .o_clk_out                          (cpri_clkout[7:4]   ),
    .o_rxrecclkout                      (                   ),
    .o_txusrclk_out                     (                   ),
   
    .s_axi_aclk                         (fpga_clk_100mhz    ),// input wire s_axi_aclk
    .s_axi_aresetn                      (~fpga_rst_100mhz   ),// input wire s_axi_aresetn
    .s_axi_awaddr                       (s_axi_awaddr  [7:4]),// input wire [11 : 0] s_axi_awaddr
    .s_axi_awvalid                      (s_axi_awvalid [7:4]),// input wire s_axi_awvalid
    .s_axi_awready                      (s_axi_awready [7:4]),// output wire s_axi_awready
    .s_axi_wdata                        (s_axi_wdata   [7:4]),// input wire [31 : 0] s_axi_wdata
    .s_axi_wvalid                       (s_axi_wvalid  [7:4]),// input wire s_axi_wvalid
    .s_axi_wready                       (s_axi_wready  [7:4]),// output wire s_axi_wready
    .s_axi_bresp                        (s_axi_bresp   [7:4]),// output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid                       (s_axi_bvalid  [7:4]),// output wire s_axi_bvalid
    .s_axi_bready                       (s_axi_bready  [7:4]),// input wire s_axi_bready
    .s_axi_araddr                       (s_axi_araddr  [7:4]),// input wire [11 : 0] s_axi_araddr
    .s_axi_arvalid                      (s_axi_arvalid [7:4]),// input wire s_axi_arvalid
    .s_axi_arready                      (s_axi_arready [7:4]),// output wire s_axi_arready
    .s_axi_rdata                        (s_axi_rdata   [7:4]),// output wire [31 : 0] s_axi_rdata
    .s_axi_rresp                        (s_axi_rresp   [7:4]),// output wire [1 : 0] s_axi_rresp
    .s_axi_rvalid                       (s_axi_rvalid  [7:4]),// output wire s_axi_rvalid
    .s_axi_rready                       (s_axi_rready  [7:4]),// input wire s_axi_rready
      //ila
    .reset_request_in                   ({4{source[4]}}     ),
    .i_iq_rx_word_err                   (iq_rx_word_err           [7:4]),
    .i_iq_rx_frame_count                (iq_rx_frame_count        [7:4]),
    .i_iq_rx_error_count                (iq_rx_error_count        [7:4]),
    .i_iq_rx_nodebfn_rx_nr_store        (iq_rx_nodebfn_rx_nr_store[7:4]) 
   
);
/*
iq_tx_gen u_iq_tx_gen0
(
  .clk                    (cpri_clkout[0]),
  .iq_tx_enable           (iq_tx_enable[0]),
  .speed                  (15'b100_0000_0000_0000),
  .iq_tx                  (iq_tx[0]),
  .nodebfn_tx_strobe      (nodebfn_tx_strobe[0]),
  .nodebfn_tx_nr          (nodebfn_tx_nr[0])
);
*/
(* dont_touch = "ture" *) iq_gen_tbu u1_iq_gen_tbu(
    .clk                                (cpri_clkout[0]     ),//input	  wire				                 
    .rst                                (1'b0               ),// input	  wire				               
    .i_enable                           (iq_tx_enable[0]    ),//input   wire                  
    .i_ref_10ms_head                    (i_ref_10ms_head    ),//input	  wire				                 
    .i_ref_frame_num                    (i_ref_frame_num    ),//input	  wire		[10:0]         
    .speed                              (15'b100_0000_0000_0000),// input   wire    [15:0]           
                                                             
    .o_iq_tx                            (iq_tx[0]           ),//output  reg     [63:0]        
    .o_nodebfn_tx_strobe                (nodebfn_tx_strobe[0]),// output  reg                   
    .o_nodebfn_tx_nr                    (nodebfn_tx_nr[0][9:0]) //output  reg     [9:0]        

);

genvar i;
generate for (i=0;i<4;i=i+1) begin:IQ_ETH_GEN
 (* dont_touch = "ture" *) iq_rx_chk u_iq_rx_chk0
    (
    .clk                                (cpri_clkout[0]     ),
    .enable                             (nodebfn_valid[i]   ),
    .speed                              (15'b100_0000_0000_0000),
    .basic_frame_first_word             (bffw[i]            ),
    .iq_rx                              (iq_rx[i]           ),
    .nodebfn_rx_strobe                  (nodebfn_rx_strobe[i]),
    .nodebfn_rx_nr                      (nodebfn_rx_nr[i]   ),
    .frame_count                        (iq_rx_frame_count        [i]),
    .error_count                        (iq_rx_error_count        [i]),
    .nodebfn_rx_nr_store                (iq_rx_nodebfn_rx_nr_store[i]),
    .word_err                           (iq_rx_word_err           [i]) 
    );

gnrl_dff_synchronizer   gnrl_nodebfn_valid(
    .i_clk                              (fpga_clk_25mhz     ),
    .i_bit                              (nodebfn_valid[i]   ),
    .o_bit                              (nodebfn_valid_eth[i]) 
);

mii_stim  u_eth_mii_test
(
    .eth_clk                            (fpga_clk_25mhz     ),
    .tx_eth_enable                      (mii_txdv[i]        ),
    .tx_eth_data                        (mii_txd[i]         ),
    .tx_eth_err                         (                   ),
    .tx_eth_overflow                    (1'b0               ),
    .tx_eth_half                        (1'b0               ),
    .rx_eth_data_valid                  (mii_rxen[i]        ),
    .rx_eth_data                        (mii_rxd[i]         ),
    .rx_eth_err                         (                   ),
    .tx_start                           (nodebfn_valid_eth[i]),
    .rx_start                           (nodebfn_valid_eth[i]),
    .tx_count                           (                   ),
    .rx_count                           (                   ),
    .err_count                          (                   ),
    .eth_rx_error                       (                   ),
    .eth_rx_avail                       (eth_rx_avail[i]    ),
    .eth_rx_ready                       (eth_rx_ready[i]    ),
    .rx_fifo_almost_full                (                   ),
    .rx_fifo_full                       (                   ) 
);

  always @ (posedge cpri_clkout[0])
  begin
    if (stat_code[i] != 4'b1111)
        nodebfn_valid[i] <= 1'b0;
    else if((nodebfn_tx_nr[0] == 12'h29B) && (nodebfn_rx_nr[i] == 12'h29B ))
        nodebfn_valid[i] <= 1'b1;
  end

end
endgenerate

/*
iq_tx_gen               u_iq_tx_gen1
(
  .clk                    (cpri_clkout[4]),
  .iq_tx_enable           (iq_tx_enable[4]),
  .speed                  (15'b100_0000_0000_0000),
  .iq_tx                  (iq_tx[4]),
  .nodebfn_tx_strobe      (nodebfn_tx_strobe[4]),
  .nodebfn_tx_nr          (nodebfn_tx_nr[4])
);
*/

(* dont_touch = "ture" *)iq_gen_tbu u2_iq_gen_tbu(
    .clk                                (cpri_clkout[4]     ),//input	  wire				                 
    .rst                                (1'b0               ),// input	  wire				               
    .i_enable                           (iq_tx_enable[4]    ),//input   wire                  
    .i_ref_10ms_head                    (i_ref_10ms_head    ),//input	  wire				                 
    .i_ref_frame_num                    (i_ref_frame_num    ),//input	  wire		[10:0]         
    .speed                              (15'b100_0000_0000_0000),// input   wire    [15:0]           
                                                             
    .o_iq_tx                            (iq_tx[4]           ),//output  reg     [63:0]        
    .o_nodebfn_tx_strobe                (nodebfn_tx_strobe[4]),// output  reg                   
    .o_nodebfn_tx_nr                    (nodebfn_tx_nr[4][9:0]) //output  reg     [9:0]        

);
    
genvar f;
generate for (f=4;f<8;f=f+1) begin:IQ_ETH_GEN2
 (* dont_touch = "ture" *) iq_rx_chk u_iq_rx_chk0
    (
    .clk                                (cpri_clkout[4]     ),
    .enable                             (nodebfn_valid[f]   ),
    .speed                              (15'b100_0000_0000_0000),
    .basic_frame_first_word             (bffw[f]            ),
    .iq_rx                              (iq_rx[f]           ),
    .nodebfn_rx_strobe                  (nodebfn_rx_strobe[f]),
    .nodebfn_rx_nr                      (nodebfn_rx_nr[f]   ),
    .frame_count                        (iq_rx_frame_count        [f]),
    .error_count                        (iq_rx_error_count        [f]),
    .nodebfn_rx_nr_store                (iq_rx_nodebfn_rx_nr_store[f]),
    .word_err                           (iq_rx_word_err           [f]) 
    );

gnrl_dff_synchronizer   gnrl_nodebfn_valid(
    .i_clk                              (fpga_clk_25mhz     ),
    .i_bit                              (nodebfn_valid[f]   ),
    .o_bit                              (nodebfn_valid_eth[f]) 
);

mii_stim  u_eth_mii_test
(
    .eth_clk                            (fpga_clk_25mhz     ),
    .tx_eth_enable                      (mii_txdv[f]        ),
    .tx_eth_data                        (mii_txd[f]         ),
    .tx_eth_err                         (                   ),
    .tx_eth_overflow                    (1'b0               ),
    .tx_eth_half                        (1'b0               ),
    .rx_eth_data_valid                  (mii_rxen[f]        ),
    .rx_eth_data                        (mii_rxd[f]         ),
    .rx_eth_err                         (                   ),
    .tx_start                           (nodebfn_valid_eth[f]),
    .rx_start                           (nodebfn_valid_eth[f]),
    .tx_count                           (                   ),
    .rx_count                           (                   ),
    .err_count                          (                   ),
    .eth_rx_error                       (                   ),
    .eth_rx_avail                       (eth_rx_avail[f]    ),
    .eth_rx_ready                       (eth_rx_ready[f]    ),
    .rx_fifo_almost_full                (                   ),
    .rx_fifo_full                       (                   ) 
);

  always @ (posedge cpri_clkout[4])
  begin
    if (stat_code[f] != 4'b1111)
        nodebfn_valid[f] <= 1'b0;
    else if((nodebfn_tx_nr[4] == 12'h29B) && (nodebfn_rx_nr[f] == 12'h29B ))
        nodebfn_valid[f] <= 1'b1;
  end

end
endgenerate

param_rec_mem   param_rec_mem(
    .i_clk                              (fpga_clk_100mhz    ),
    .i_stat_code                        (stat_code[3:0]     ),

    .o_mem_addr                         (BRAM_PORTA_addr    ),
    .o_mem_din                          (BRAM_PORTA_din     ),
    .i_mem_dout                         (BRAM_PORTA_dout    ),
    .o_mem_en                           (BRAM_PORTA_en      ),
    .o_mem_rst                          (BRAM_PORTA_rst     ),
    .o_mem_we                           (BRAM_PORTA_we      ),
    .o_gpio                             (GPIO_tri_io        ) 
);


design_mb_wrapper u_design_mb_wrapper
   (
    .Clk                                (fpga_clk_100mhz    ),
    .reset_rtl_0                        (fpga_rst_100mhz    ),
    .BRAM_PORTA_addr                    (BRAM_PORTA_addr    ),
    .BRAM_PORTA_clk                     (fpga_clk_100mhz    ),
    .BRAM_PORTA_din                     (BRAM_PORTA_din     ),
    .BRAM_PORTA_dout                    (BRAM_PORTA_dout    ),
    .BRAM_PORTA_en                      (BRAM_PORTA_en      ),
    .BRAM_PORTA_rst                     (BRAM_PORTA_rst     ),
    .BRAM_PORTA_we                      (BRAM_PORTA_we      ),
    .gpio_io_i_0                        (GPIO_tri_io        ),
    .M00_AXI_araddr                     (s_axi_araddr [0]   ),
    .M00_AXI_arprot                     (                   ),
    .M00_AXI_arready                    (s_axi_arready[0]   ),
    .M00_AXI_arvalid                    (s_axi_arvalid[0]   ),
    .M00_AXI_awaddr                     (s_axi_awaddr [0]   ),
    .M00_AXI_awprot                     (                   ),
    .M00_AXI_awready                    (s_axi_awready[0]   ),
    .M00_AXI_awvalid                    (s_axi_awvalid[0]   ),
    .M00_AXI_bready                     (s_axi_bready [0]   ),
    .M00_AXI_bresp                      (s_axi_bresp  [0]   ),
    .M00_AXI_bvalid                     (s_axi_bvalid [0]   ),
    .M00_AXI_rdata                      (s_axi_rdata  [0]   ),
    .M00_AXI_rready                     (s_axi_rready [0]   ),
    .M00_AXI_rresp                      (s_axi_rresp  [0]   ),
    .M00_AXI_rvalid                     (s_axi_rvalid [0]   ),
    .M00_AXI_wdata                      (s_axi_wdata  [0]   ),
    .M00_AXI_wready                     (s_axi_wready [0]   ),
    .M00_AXI_wstrb                      (                   ),
    .M00_AXI_wvalid                     (s_axi_wvalid [0]   ),
    .M01_AXI_araddr                     (s_axi_araddr [1]   ),
    .M01_AXI_arprot                     (                   ),
    .M01_AXI_arready                    (s_axi_arready[1]   ),
    .M01_AXI_arvalid                    (s_axi_arvalid[1]   ),
    .M01_AXI_awaddr                     (s_axi_awaddr [1]   ),
    .M01_AXI_awprot                     (                   ),
    .M01_AXI_awready                    (s_axi_awready[1]   ),
    .M01_AXI_awvalid                    (s_axi_awvalid[1]   ),
    .M01_AXI_bready                     (s_axi_bready [1]   ),
    .M01_AXI_bresp                      (s_axi_bresp  [1]   ),
    .M01_AXI_bvalid                     (s_axi_bvalid [1]   ),
    .M01_AXI_rdata                      (s_axi_rdata  [1]   ),
    .M01_AXI_rready                     (s_axi_rready [1]   ),
    .M01_AXI_rresp                      (s_axi_rresp  [1]   ),
    .M01_AXI_rvalid                     (s_axi_rvalid [1]   ),
    .M01_AXI_wdata                      (s_axi_wdata  [1]   ),
    .M01_AXI_wready                     (s_axi_wready [1]   ),
    .M01_AXI_wstrb                      (                   ),
    .M01_AXI_wvalid                     (s_axi_wvalid [1]   ),
    .M02_AXI_araddr                     (s_axi_araddr [2]   ),
    .M02_AXI_arprot                     (                   ),
    .M02_AXI_arready                    (s_axi_arready[2]   ),
    .M02_AXI_arvalid                    (s_axi_arvalid[2]   ),
    .M02_AXI_awaddr                     (s_axi_awaddr [2]   ),
    .M02_AXI_awprot                     (                   ),
    .M02_AXI_awready                    (s_axi_awready[2]   ),
    .M02_AXI_awvalid                    (s_axi_awvalid[2]   ),
    .M02_AXI_bready                     (s_axi_bready [2]   ),
    .M02_AXI_bresp                      (s_axi_bresp  [2]   ),
    .M02_AXI_bvalid                     (s_axi_bvalid [2]   ),
    .M02_AXI_rdata                      (s_axi_rdata  [2]   ),
    .M02_AXI_rready                     (s_axi_rready [2]   ),
    .M02_AXI_rresp                      (s_axi_rresp  [2]   ),
    .M02_AXI_rvalid                     (s_axi_rvalid [2]   ),
    .M02_AXI_wdata                      (s_axi_wdata  [2]   ),
    .M02_AXI_wready                     (s_axi_wready [2]   ),
    .M02_AXI_wstrb                      (                   ),
    .M02_AXI_wvalid                     (s_axi_wvalid [2]   ),
    .M03_AXI_araddr                     (s_axi_araddr [3]   ),
    .M03_AXI_arprot                     (                   ),
    .M03_AXI_arready                    (s_axi_arready[3]   ),
    .M03_AXI_arvalid                    (s_axi_arvalid[3]   ),
    .M03_AXI_awaddr                     (s_axi_awaddr [3]   ),
    .M03_AXI_awprot                     (                   ),
    .M03_AXI_awready                    (s_axi_awready[3]   ),
    .M03_AXI_awvalid                    (s_axi_awvalid[3]   ),
    .M03_AXI_bready                     (s_axi_bready [3]   ),
    .M03_AXI_bresp                      (s_axi_bresp  [3]   ),
    .M03_AXI_bvalid                     (s_axi_bvalid [3]   ),
    .M03_AXI_rdata                      (s_axi_rdata  [3]   ),
    .M03_AXI_rready                     (s_axi_rready [3]   ),
    .M03_AXI_rresp                      (s_axi_rresp  [3]   ),
    .M03_AXI_rvalid                     (s_axi_rvalid [3]   ),
    .M03_AXI_wdata                      (s_axi_wdata  [3]   ),
    .M03_AXI_wready                     (s_axi_wready [3]   ),
    .M03_AXI_wstrb                      (                   ),
    .M03_AXI_wvalid                     (s_axi_wvalid [3]   ),
    .M04_AXI_araddr                     (s_axi_araddr [4]   ),
    .M04_AXI_arprot                     (                   ),
    .M04_AXI_arready                    (s_axi_arready[4]   ),
    .M04_AXI_arvalid                    (s_axi_arvalid[4]   ),
    .M04_AXI_awaddr                     (s_axi_awaddr [4]   ),
    .M04_AXI_awprot                     (                   ),
    .M04_AXI_awready                    (s_axi_awready[4]   ),
    .M04_AXI_awvalid                    (s_axi_awvalid[4]   ),
    .M04_AXI_bready                     (s_axi_bready [4]   ),
    .M04_AXI_bresp                      (s_axi_bresp  [4]   ),
    .M04_AXI_bvalid                     (s_axi_bvalid [4]   ),
    .M04_AXI_rdata                      (s_axi_rdata  [4]   ),
    .M04_AXI_rready                     (s_axi_rready [4]   ),
    .M04_AXI_rresp                      (s_axi_rresp  [4]   ),
    .M04_AXI_rvalid                     (s_axi_rvalid [4]   ),
    .M04_AXI_wdata                      (s_axi_wdata  [4]   ),
    .M04_AXI_wready                     (s_axi_wready [4]   ),
    .M04_AXI_wstrb                      (                   ),
    .M04_AXI_wvalid                     (s_axi_wvalid [4]   ),
    .M05_AXI_araddr                     (s_axi_araddr [5]   ),
    .M05_AXI_arprot                     (                   ),
    .M05_AXI_arready                    (s_axi_arready[5]   ),
    .M05_AXI_arvalid                    (s_axi_arvalid[5]   ),
    .M05_AXI_awaddr                     (s_axi_awaddr [5]   ),
    .M05_AXI_awprot                     (                   ),
    .M05_AXI_awready                    (s_axi_awready[5]   ),
    .M05_AXI_awvalid                    (s_axi_awvalid[5]   ),
    .M05_AXI_bready                     (s_axi_bready [5]   ),
    .M05_AXI_bresp                      (s_axi_bresp  [5]   ),
    .M05_AXI_bvalid                     (s_axi_bvalid [5]   ),
    .M05_AXI_rdata                      (s_axi_rdata  [5]   ),
    .M05_AXI_rready                     (s_axi_rready [5]   ),
    .M05_AXI_rresp                      (s_axi_rresp  [5]   ),
    .M05_AXI_rvalid                     (s_axi_rvalid [5]   ),
    .M05_AXI_wdata                      (s_axi_wdata  [5]   ),
    .M05_AXI_wready                     (s_axi_wready [5]   ),
    .M05_AXI_wstrb                      (                   ),
    .M05_AXI_wvalid                     (s_axi_wvalid [5]   ),
    .M06_AXI_araddr                     (s_axi_araddr [6]   ),
    .M06_AXI_arprot                     (                   ),
    .M06_AXI_arready                    (s_axi_arready[6]   ),
    .M06_AXI_arvalid                    (s_axi_arvalid[6]   ),
    .M06_AXI_awaddr                     (s_axi_awaddr [6]   ),
    .M06_AXI_awprot                     (                   ),
    .M06_AXI_awready                    (s_axi_awready[6]   ),
    .M06_AXI_awvalid                    (s_axi_awvalid[6]   ),
    .M06_AXI_bready                     (s_axi_bready [6]   ),
    .M06_AXI_bresp                      (s_axi_bresp  [6]   ),
    .M06_AXI_bvalid                     (s_axi_bvalid [6]   ),
    .M06_AXI_rdata                      (s_axi_rdata  [6]   ),
    .M06_AXI_rready                     (s_axi_rready [6]   ),
    .M06_AXI_rresp                      (s_axi_rresp  [6]   ),
    .M06_AXI_rvalid                     (s_axi_rvalid [6]   ),
    .M06_AXI_wdata                      (s_axi_wdata  [6]   ),
    .M06_AXI_wready                     (s_axi_wready [6]   ),
    .M06_AXI_wstrb                      (                   ),
    .M06_AXI_wvalid                     (s_axi_wvalid [6]   ),
    .M07_AXI_araddr                     (s_axi_araddr [7]   ),
    .M07_AXI_arprot                     (                   ),
    .M07_AXI_arready                    (s_axi_arready[7]   ),
    .M07_AXI_arvalid                    (s_axi_arvalid[7]   ),
    .M07_AXI_awaddr                     (s_axi_awaddr [7]   ),
    .M07_AXI_awprot                     (                   ),
    .M07_AXI_awready                    (s_axi_awready[7]   ),
    .M07_AXI_awvalid                    (s_axi_awvalid[7]   ),
    .M07_AXI_bready                     (s_axi_bready [7]   ),
    .M07_AXI_bresp                      (s_axi_bresp  [7]   ),
    .M07_AXI_bvalid                     (s_axi_bvalid [7]   ),
    .M07_AXI_rdata                      (s_axi_rdata  [7]   ),
    .M07_AXI_rready                     (s_axi_rready [7]   ),
    .M07_AXI_rresp                      (s_axi_rresp  [7]   ),
    .M07_AXI_rvalid                     (s_axi_rvalid [7]   ),
    .M07_AXI_wdata                      (s_axi_wdata  [7]   ),
    .M07_AXI_wready                     (s_axi_wready [7]   ),
    .M07_AXI_wstrb                      (                   ),
    .M07_AXI_wvalid                     (s_axi_wvalid [7]   ) 
);

//****************************debug********************************//
reg            [   7: 0]        nodebfn_rx_strobe_d=8'd0;
wire           [   7: 0]        nodebfn_rx_strobe_p  ;
reg            [   7: 0]        nodebfn_rx_nr_0_d   ;
wire           [   7: 0]        nodebfn_rx_nr_0_edg  ;
logic [7:0] [31:0] count_strobe_nr ;
logic [7:0] [31:0] count_strobe_nr_reg ;

generate for (i=0;i<8;i=i+1) begin:ila_rx_chk
 always@(posedge cpri_clkout[i])  begin
     nodebfn_rx_strobe_d[i] <= nodebfn_rx_strobe[i] ;
     nodebfn_rx_nr_0_d  [i] <= nodebfn_rx_nr [i][0];
 end

assign nodebfn_rx_strobe_p[i]= ~nodebfn_rx_strobe_d[i] & nodebfn_rx_strobe[i];
assign nodebfn_rx_nr_0_edg [i]= nodebfn_rx_nr_0_d[i] ^ nodebfn_rx_nr [i][0]; 

 always@(posedge cpri_clkout[i])begin
     if (nodebfn_rx_strobe_p[i])
         count_strobe_nr[i]<=32'd0 ;
     else if (nodebfn_rx_nr_0_edg[i])
        count_strobe_nr_reg[i] <= count_strobe_nr[i] ;
     else
         count_strobe_nr[i]<=count_strobe_nr[i]+32'd1 ;
end

ila_rx_chk u_ila_rx_chk(
  .clk                                (cpri_clkout[i]     ),//1
  .probe0                             (iq_rx_word_err[i]  ),// 1           
  .probe1                             (iq_rx_frame_count[i][7:0]),//8   
  .probe2                             (iq_rx_error_count[i][7:0]),// 8
  .probe3                             (iq_rx_nodebfn_rx_nr_store[i]),// 12
  .probe4                             (nodebfn_rx_nr[i]   ),//12
  .probe5                             (nodebfn_rx_strobe[i]),//1
  .probe6                             (iq_rx[i]           ),//64
  .probe7                             (nodebfn_rx_strobe_p[i]),//1
  .probe8                             (nodebfn_rx_nr_0_edg[i]),//1
  .probe9                             (count_strobe_nr_reg[i]),//32    
  .probe10                            (count_strobe_nr[i] ) //32
 );

end
endgenerate










  
endmodule

