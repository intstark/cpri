//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/28 15:54:23
// Design Name: 
// Module Name: design_top
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
`timescale 1ns / 1ps




module design_top(
    output  [3:0]   sfp_txp   ,
    output  [3:0]   sfp_txn   ,
    input   [3:0]   sfp_rxp   ,
    input   [3:0]   sfp_rxn   ,
    input           refclk0_p ,
    input           refclk0_n ,
    input           refclk1_p ,
    input           refclk1_n ,
    input   [1:0]   i_sysclk_p,
    input   [1:0]   i_sysclk_n,

    output          o_recclk_p,
    output          o_recclk_n,

    input   [3:0]   sfp_tx_disable  ,

    output  [7:0]   led_8bits_tri_o ,
    inout           io_zynq_iic_scl ,
    inout           io_zynq_iic_sda

);


//-------------------------------------------------------------------------------
// PARAMETER
//-------------------------------------------------------------------------------
parameter TOTAL_LANE = 4;


//-------------------------------------------------------------------------------
// WIRE & REGISTER
//-------------------------------------------------------------------------------
logic           core_master ;
logic           ext_reset   ;
logic           recclk_out  ;
logic           sysclk_100m ;
logic           rec_clk     ;

logic           hires_clk   ;
logic           ext_clk_ok  ;
logic           eth_ref_clk ;
logic           axi_clk     ;
logic           pll0_locked ;
logic           pll1_locked ;
logic           cpri_clk_130;
logic           qpll_lock   ;


logic   [TOTAL_LANE-1:0]        stat_alarm  ;
logic   [TOTAL_LANE-1:0][3:0]   stat_code   ;
logic   [TOTAL_LANE-1:0][14:0]  stat_speed  ;
logic   [TOTAL_LANE-1:0]        local_los   ;
logic   [TOTAL_LANE-1:0]        local_lof   ;

logic   [TOTAL_LANE-1:0]        iq_tx_en    ;
logic   [TOTAL_LANE-1:0]        iq_bffwd    ;
logic   [TOTAL_LANE-1:0]        nodebfn_tx_strobe ;
logic   [TOTAL_LANE-1:0][11:0]  nodebfn_tx_nr;
logic   [TOTAL_LANE-1:0]        nodebfn_rx_strobe ;
logic   [TOTAL_LANE-1:0][11:0]  nodebfn_rx_nr;
logic   [TOTAL_LANE-1:0][63:0]  iq_tx;
logic   [TOTAL_LANE-1:0][63:0]  iq_rx;
logic   [TOTAL_LANE-1:0]        eth_rxen    ;
logic   [TOTAL_LANE-1:0][3:0]   eth_rxd     ;
logic   [TOTAL_LANE-1:0]        eth_txen    ;
logic   [TOTAL_LANE-1:0][3:0]   eth_txd     ;
logic   [TOTAL_LANE-1:0]        eth_rx_avail;
logic   [TOTAL_LANE-1:0]        eth_rx_ready;

logic   [TOTAL_LANE-1:0][31:0]  rx_frame_cnt;
logic   [TOTAL_LANE-1:0][31:0]  rx_error_cnt;
 


//-------------------------------------------------------------------------------
// assign
//-------------------------------------------------------------------------------

assign sfp_tx_disable = 4'h0;





//-------------------------------------------------------------------------------
// clock
//-------------------------------------------------------------------------------
IBUFDS      IBUFDS_inst (
    .O      (freerun_clk  ),   // 1-bit output: Buffer outputBUFG    BUFG_SYSGC(
    .I      (i_sysclk_p[1]),   // 1-bit input: Diff_p buffer input (connect directly to top-level port)    .I  (),
    .IB     (i_sysclk_n[1])    // 1-bit input: Diff_n buffer input (connect directly to top-level port)    .O  ()
);


clk_wiz_0       clk_wiz_0
(
    .clk_in1    (freerun_clk),
    .reset      (1'b0),         // input reset
    .clk_out1   (axi_clk),      // output clk_out1 100m
    .clk_out2   (eth_ref_clk),  // output clk_out1 25m
    .clk_out3   (hires_clk),    // output clk_out1 300m
    .locked     (pll0_locked)   // output locked
);


OBUFDS      OBUFDS_100m (
    .I      (rec_clk   ),    // 1-bit output: Buffer outputBUFG    BUFG_SYSGC(
    .O      (o_recclk_p),           // 1-bit input: Diff_p buffer input (connect directly to top-level port)    .I  (),
    .OB     (o_recclk_n)            // 1-bit input: Diff_n buffer input (connect directly to top-level port)    .O  ()
);

//-------------------------------------------------------------------------------
// IQ SIM
//-------------------------------------------------------------------------------
iq_eth_test # (
    .LANE                   (4)
)iq_eth_test_0(
    .i_clk                  (cpri_clk_130),
    .i_stat_speed           (stat_speed[0]),
    .i_stat_code            (stat_code[3:0]),
    .i_tx_en                (iq_tx_en [3:0]),
    .o_iq_tx                (iq_tx    [3:0]),
    .o_nodebfn_tx_strobe    (nodebfn_tx_strobe[3:0]),
    .o_nodebfn_tx_nr        (nodebfn_tx_nr    [3:0]),

    .i_bffw                 (iq_bffwd[3:0]),
    .i_iq_rx                (iq_rx   [3:0]),
    .i_nodebfn_rx_strobe    (nodebfn_rx_strobe[3:0]),
    .i_nodebfn_rx_nr        (nodebfn_rx_nr    [3:0]),
    .o_rx_frame_count       (rx_frame_cnt[3:0]),
    .o_rx_error_count       (rx_error_cnt[3:0]),
    .o_nodebfn_rx_nr_strobe (),
    .o_rx_word_err          (),

    .i_eth_clk              (eth_ref_clk      ),
    .i_eth_rxen             (eth_rxen    [3:0]),
    .i_eth_rxd              (eth_rxd     [3:0]),
    .o_eth_txen             (eth_txen    [3:0]),
    .o_eth_txd              (eth_txd     [3:0]),
    .i_eth_rx_avail         (eth_rx_avail[3:0]),
    .o_eth_rx_ready         (eth_rx_ready[3:0]) 
);


//-------------------------------------------------------------------------------
// connect the design under test to the signals in the testbench.
//-------------------------------------------------------------------------------
cpri_quad_top                   cpri_quad_0
(
    // Clock
    .gtwiz_reset_clk_freerun_in  (freerun_clk),
    .refclk_p                    (refclk1_p),
    .refclk_n                    (refclk1_n),
    .hires_clk                   (hires_clk),
    .hires_clk_ok                (pll0_locked),
    .eth_ref_clk                 (eth_ref_clk),

    // reset
    .reset                       (ext_reset),

    .qpll_select                 (1'b1),
    .core_is_master              (1'b0),
    .enable_test_start           (1'b1),

    .o_stat_alarm                (stat_alarm[3:0]),
    .o_stat_code                 (stat_code [3:0]),
    .o_stat_speed                (stat_speed[3:0]),
    .mu_law_encoding             (),

    .o_local_los                 (local_los[3:0]),
    .o_local_lof                 (local_lof[3:0]),
    // AXI
    .s_axi_aclk                  (axi_clk       ),
    .s_axi_aresetn               (pll0_locked   ),
    .s_axi_awaddr                (),
    .s_axi_awvalid               (),
    .s_axi_awready               (),
    .s_axi_wdata                 (),
    .s_axi_wvalid                (),
    .s_axi_wready                (),
    .s_axi_bresp                 (),
    .s_axi_bvalid                (),
    .s_axi_bready                (),
    .s_axi_araddr                (),
    .s_axi_arvalid               (),
    .s_axi_arready               (),
    .s_axi_rdata                 (),
    .s_axi_rresp                 (),
    .s_axi_rvalid                (),
    .s_axi_rready                (),

    // I/O interface
    .o_iq_tx_enable              (iq_tx_en[3:0]),
    .o_bffwd                     (iq_bffwd[3:0]),
    .i_iq_tx                     (iq_tx   [3:0]),
    .o_iq_rx                     (iq_rx   [3:0]),
    
    .i_nodebfn_tx_strobe         (nodebfn_tx_strobe[3:0]),
    .i_nodebfn_tx_nr             (nodebfn_tx_nr    [3:0]),
    .o_nodebfn_rx_strobe         (nodebfn_rx_strobe[3:0]),
    .o_nodebfn_rx_nr             (nodebfn_rx_nr    [3:0]), 

    // eth interface
    .i_eth_txd                   (eth_txd     [3:0]),
    .i_eth_tx_en                 (eth_txen    [3:0]),
    .o_eth_rxd                   (eth_rxd     [3:0]),
    .o_eth_rx_dv                 (eth_rxen    [3:0]),
    .o_eth_rx_avail              (eth_rx_avail[3:0]),
    .i_eth_rx_ready              (eth_rx_ready[3:0]),

    // SERDES
    .o_txp                       (sfp_txp[3:0]),
    .o_txn                       (sfp_txn[3:0]),
    .i_rxp                       (sfp_rxp[3:0]),
    .i_rxn                       (sfp_rxn[3:0]),

    .o_cpri_clk                  (cpri_clk_130),
    .o_rec_clk                   (rec_clk),
    .o_qpll_lock                 (qpll_lock   )

);




//-----------------------------------------------------------------------------
// VIO 
//-----------------------------------------------------------------------------
vio_reset       vio_reset 
(
  .clk          (axi_clk    ),  // input wire clk
  .probe_out0   (ext_reset  )  // output wire [0 : 0] probe_out0
);

//-----------------------------------------------------------------------------
// ZYNQ
//-----------------------------------------------------------------------------
zynq_mpsoc_wrapper              zynq_mpsoc_wrapper 
(
    .led_8bits_tri_o            (led_8bits_tri_o),
    .iic1_pl_scl_io             (io_zynq_iic_scl),
    .iic1_pl_sda_io             (io_zynq_iic_sda)
);


//-----------------------------------------------------------------------------
// DEBUG
//-----------------------------------------------------------------------------
gnrl_dff_synchronizer   cdc_qpll_lock(
    .i_clk              (axi_clk),
    .i_bit              (qpll_lock),
    .o_bit              (qpll_lock_ila)
);

ila_status      ila_status (
    .clk        (axi_clk),              // input wire clk
    
    .probe0     (pll0_locked ),         // input wire [0:0]   probe0
    .probe1     (stat_alarm  ),         // input wire [0:0]   probe1  
    .probe2     (stat_code   ),         // input wire [3:0]   probe2
    .probe3     (stat_speed  ),         // input wire [14:0]  probe3
    .probe4     (eth_txd     ),         // input wire [3:0]   probe4
    .probe5     (eth_txen    ),         // input wire [0:0]   probe5
    .probe6     (eth_rxd     ),         // input wire [3:0]   probe6
    .probe7     (eth_rxen    ),         // input wire [0:0]   probe7 
    .probe8     (eth_rx_avail),         // input wire [0:0]   probe8 
    .probe9     (eth_rx_ready),         // input wire [0:0]   probe9 
    .probe10    (eth_rx_ready),         // input wire [0:0]   probe10
    .probe11    (qpll_lock_ila),
    .probe12    (local_los   ),         // input wire [3:0]   probe10
    .probe13    (local_lof   )
);

    
endmodule
