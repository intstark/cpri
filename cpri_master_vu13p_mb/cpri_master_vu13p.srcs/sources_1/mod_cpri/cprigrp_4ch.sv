`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 08:16:59 PM
// Design Name: 
// Module Name: cprigrp_b130
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


module cprigrp_4ch#(
    parameter NUM_CHANNELS = 4 
) (
   input   wire                             i_ext_rst       ,   //reset pin
   input   wire                             i_fabric_pll_lock ,
   input   wire                             i_rst_25Mhz     ,
   input   wire                             i_rst_100mhz    , 
      							                
   input   wire                             i_clk_25Mhz     ,
   input   wire                             i_clk_100mhz    ,
   input   wire                             i_hires_clk     ,
   input   wire                             i_freerun_clk   ,
   
   
   input                                    GTY_REFCLK_P       , 
   input                                    GTY_REFCLK_N       , 
   input   [NUM_CHANNELS-1:0]               QSFP_RXP           , 
   input   [NUM_CHANNELS-1:0]               QSFP_RXN           , 
   output  [NUM_CHANNELS-1:0]               QSFP_TXP           , 
   output  [NUM_CHANNELS-1:0]               QSFP_TXN           , 
   
   output  [NUM_CHANNELS-1:0]               o_bffw           ,
   output  [NUM_CHANNELS-1:0]               o_nodebfn_rx_strobe,
   output  [NUM_CHANNELS-1:0][11:0]         o_nodebfn_rx_nr,
   
   input   [NUM_CHANNELS-1:0]               i_nodebfn_tx_strobe,
   input   [NUM_CHANNELS-1:0][11:0]         i_nodebfn_tx_nr,
   input   [NUM_CHANNELS-1:0][63:0]         i_iq_tx_data, 
   output  [NUM_CHANNELS-1:0][63:0]         o_iq_rx_data,   
   output   [NUM_CHANNELS-1:0]              o_iq_tx_enable, 

   input   [NUM_CHANNELS-1:0]               i_mii_txdv,
   input   [NUM_CHANNELS-1:0][3:0]          i_mii_txd,  
   input   [NUM_CHANNELS-1:0]               i_mii_rx_ready,
   output  [NUM_CHANNELS-1:0]               o_mii_rxen,
   output  [NUM_CHANNELS-1:0][3:0]          o_mii_rxd,
   output  [NUM_CHANNELS-1:0]               o_mii_avil,
 

   output  [NUM_CHANNELS-1:0]               o_stat_alarm,
   output  [NUM_CHANNELS-1:0][3:0]          o_stat_code,
   output  [NUM_CHANNELS-1:0][14:0]         o_stat_speed,   

   output  [NUM_CHANNELS-1:0]               o_recclk_ok,
   output  [NUM_CHANNELS-1:0]               o_clk_ok_out,
   output  [NUM_CHANNELS-1:0]               o_recclk,
   output  [NUM_CHANNELS-1:0]               o_clk_out,
   output  [NUM_CHANNELS-1:0]               o_rxrecclkout,
   output  [NUM_CHANNELS-1:0]               o_txusrclk_out,
   
   input  wire                              s_axi_aclk   ,
   input  wire                              s_axi_aresetn,
   input  wire [NUM_CHANNELS-1:0][11 : 0]   s_axi_awaddr ,
   input  wire [NUM_CHANNELS-1:0]           s_axi_awvalid,
   output wire [NUM_CHANNELS-1:0]           s_axi_awready,
   input  wire [NUM_CHANNELS-1:0][31 : 0]   s_axi_wdata  ,
   input  wire [NUM_CHANNELS-1:0]           s_axi_wvalid ,
   output wire [NUM_CHANNELS-1:0]           s_axi_wready ,
   output wire [NUM_CHANNELS-1:0][1 : 0]    s_axi_bresp  ,
   output wire [NUM_CHANNELS-1:0]           s_axi_bvalid ,
   input  wire [NUM_CHANNELS-1:0]           s_axi_bready ,
   input  wire [NUM_CHANNELS-1:0][11 : 0]   s_axi_araddr ,
   input  wire [NUM_CHANNELS-1:0]           s_axi_arvalid,
   output wire [NUM_CHANNELS-1:0]           s_axi_arready,
   output wire [NUM_CHANNELS-1:0][31 : 0]   s_axi_rdata  ,
   output wire [NUM_CHANNELS-1:0][1 : 0]    s_axi_rresp  ,
   output wire [NUM_CHANNELS-1:0]           s_axi_rvalid ,
   input  wire [NUM_CHANNELS-1:0]           s_axi_rready ,
   
   input  wire [NUM_CHANNELS-1:0]           reset_request_in ,
   //ila_0
   input  wire [NUM_CHANNELS-1:0]           i_iq_rx_word_err ,          
   input  wire [NUM_CHANNELS-1:0][31 : 0]   i_iq_rx_frame_count,        
   input  wire [NUM_CHANNELS-1:0][31 : 0]   i_iq_rx_error_count,        
   input  wire [NUM_CHANNELS-1:0][11 : 0]   i_iq_rx_nodebfn_rx_nr_store
   

    );
    
     
    logic  [NUM_CHANNELS-1:0]  txdlysreset_trigger;
    logic  [NUM_CHANNELS-1:0]  txphalign_trigger;
    //logic  [NUM_CHANNELS-1:0]  txdlyen_trigger;
    logic  [NUM_CHANNELS-1:0]  txphinit_trigger;
    logic                      qpll0clk_out    ;
    logic                      qpll0refclk_out ;
    logic                      qpll1clk_out    ;
    logic                      qpll1refclk_out ;
    logic                      qpll0lock_out   ;
    logic                      qpll1lock_out   ;
    logic  [NUM_CHANNELS-1:0]  rxoutclk;
    logic  [NUM_CHANNELS-1:0]  txoutclk;
    logic  [NUM_CHANNELS-1:0]  rxoutclk_bufg;
    logic  [NUM_CHANNELS-1:0]  txoutclk_bufg;

    logic  [NUM_CHANNELS-1:0]  txphaligndone_wire;
    logic  [NUM_CHANNELS-1:0]  txdlysresetdone_wire;
    logic  [NUM_CHANNELS-1:0]  txphinitdone_wire;
    
    logic                      phase_alignment_done_flag;
    
    logic  [NUM_CHANNELS-1:0][31:0] measure_recclk;
    logic  [NUM_CHANNELS-1:0][31:0] measure_txusrclk;
    logic  [NUM_CHANNELS-1:0]       measure_valid_recclk;
    logic  [NUM_CHANNELS-1:0]       measure_valid_txusrclk;
    logic  [NUM_CHANNELS-1:0]  gtreset_sm_done;
    logic  [NUM_CHANNELS-1:0]  txresetdone_out;
    logic  [NUM_CHANNELS-1:0]  local_los;
    logic  [NUM_CHANNELS-1:0]  local_lof;
    logic  [NUM_CHANNELS-1:0]  local_rai;
    logic  [NUM_CHANNELS-1:0]  remote_los;
    logic  [NUM_CHANNELS-1:0]  remote_lof;
    logic  [NUM_CHANNELS-1:0]  remote_rai;
    logic [31:0]  source;
    logic [31:0] probe;
    
    logic  [NUM_CHANNELS-1:0]  gt_txpmareset; 
    logic  [NUM_CHANNELS-1:0]  gt_txpcsreset;
    logic  [NUM_CHANNELS-1:0]  gt_txresetdone          ;
    logic  [NUM_CHANNELS-1:0]  gt_rxpmareset           ;
    logic  [NUM_CHANNELS-1:0]  gt_rxpcsreset           ;
    logic  [NUM_CHANNELS-1:0]  gt_rxpmaresetdone       ;
    logic  [NUM_CHANNELS-1:0]  gt_rxresetdone          ;
    logic  [NUM_CHANNELS-1:0]  gt_txphaligndone        ;
    logic  [NUM_CHANNELS-1:0]  gt_txphinitdone         ;
    logic  [NUM_CHANNELS-1:0]  gt_txdlysresetdone      ;
    logic  [NUM_CHANNELS-1:0]  gt_rxphaligndone        ;
    logic  [NUM_CHANNELS-1:0]  gt_rxdlysresetdone      ;
    logic  [NUM_CHANNELS-1:0]  gt_rxsyncdone           ;
    logic  [NUM_CHANNELS-1:0]  gt_cplllock             ;
    logic                      gt_qplllock_out         ;
    logic  [NUM_CHANNELS-1:0]  gt_qplllock             ;
    logic  [NUM_CHANNELS-1:0][15:0] gt_phy_status      ;
    
    logic                       txdlyen_1;
    logic                       txdlyen_2;
    logic                       txdlyen_3;
    logic  [2:0]                txdlyen_trigger;
    
    logic  [NUM_CHANNELS-1:1]   ce_sync;
    logic  [NUM_CHANNELS-1:1]   clr_sync;
    logic  [NUM_CHANNELS-1:1]   userclk_rx_reset;
    
    wire                       tx_pole_vio_sel ;
    wire                       core_is_master ;

    IBUFDS_GTE4 #(
       .REFCLK_EN_TX_PATH(1'b0),   // Refer to Transceiver User Guide.
       .REFCLK_HROW_CK_SEL(2'b00), // Refer to Transceiver User Guide.
       .REFCLK_ICNTL_RX(2'b00)     // Refer to Transceiver User Guide.
    )
    IBUFDS_GTE4_inst (
       .O(gty_refclk),         // 1-bit output: Refer to Transceiver User Guide.
       .ODIV2(), // 1-bit output: Refer to Transceiver User Guide.
       .CEB(1'b0),     // 1-bit input: Refer to Transceiver User Guide.
       .I(GTY_REFCLK_P),         // 1-bit input: Refer to Transceiver User Guide.
       .IB(GTY_REFCLK_N)        // 1-bit input: Refer to Transceiver User Guide.
    );
    
    assign gt_txpmareset = 4'b0;
    assign gt_txpcsreset = 4'b0;
    assign gt_rxpmareset = 4'b0;
    assign gt_rxpcsreset = 4'b0;    
    
    cpri24gwshared  ch0_cpri
    (
      
	  // DRP Access
      .gt_drpdaddr              ('b0 ),// in  std_logic_vector(9 downto 0);
      .gt_drpdi                 ('b0 ),// in  std_logic_vector(15 downto 0);
      .gt_drpen                 ('b0 ),// in  std_logic;
      .gt_drpwe                 ('b0 ),// in  std_logic;
      .gt_drpdo                 ( ),// out std_logic_vector(15 downto 0);
      .gt_drprdy                ( ),// out std_logic;
      // TX Reset and Initialization
      .gt_txpmareset            (gt_txpmareset[0] ),// in  std_logic;
      .gt_txpcsreset            (gt_txpcsreset[0] ),// in  std_logic;
      .gt_txresetdone           (gt_txresetdone[0] ),// out std_logic;
      // RX Reset and Initialization
      .gt_rxpmareset            (gt_rxpmareset[0] ),// in  std_logic;
      .gt_rxpcsreset            (gt_rxpcsreset[0] ),// in  std_logic;
      .gt_rxpmaresetdone        (gt_rxpmaresetdone[0] ),// out std_logic;
      .gt_rxresetdone           (gt_rxresetdone[0] ),// out std_logic;
      // Clocking
      .gt_txphaligndone         (gt_txphaligndone   [0] ),// out std_logic;
      .gt_txphinitdone          (gt_txphinitdone    [0] ),// out std_logic;
      .gt_txdlysresetdone       (gt_txdlysresetdone [0] ),// out std_logic;
      .gt_rxphaligndone         (gt_rxphaligndone   [0] ),// out std_logic;
      .gt_rxdlysresetdone       (gt_rxdlysresetdone [0] ),// out std_logic;
      .gt_rxsyncdone            (gt_rxsyncdone      [0] ),// out std_logic;
      .gt_cplllock              (gt_cplllock        [0] ),// out std_logic;
      .gt_qplllock              (gt_qplllock_out        ),// out std_logic;
      // Signal Integrity and Functionality
      .gt_rxrate                (3'b0 ),// in  std_logic_vector(2 downto 0);
      .gt_eyescantrigger        (1'b0 ),// in  std_logic;
      .gt_eyescanreset          (1'b0 ),// in  std_logic;
      .gt_eyescandataerror      (),// out std_logic;
      .gt_rxpolarity            (1'b0 ),// in  std_logic;
      .gt_txpolarity            (tx_pole_vio_sel ),// in  std_logic;   //!!!!!!!!! set 1 to fix VU13P HW bug!!!
      .gt_rxdfelpmreset         (1'b0 ),// in  std_logic;
      .gt_rxlpmen               (1'b0 ),// in  std_logic;
      .gt_txprecursor           (5'b00000 ),// in  std_logic_vector(4 downto 0);
      .gt_txpostcursor          (5'b00000 ),// in  std_logic_vector(4 downto 0);
      .gt_txdiffctrl            (5'b01100 ),// in  std_logic_vector(4 downto 0);
      .gt_txprbsforceerr        (1'b0 ),// in  std_logic;
      .gt_txprbssel             (4'b0 ),// in  std_logic_vector(3 downto 0);
      .gt_rxprbssel             (4'b0  ),// in  std_logic_vector(3 downto 0);
      .gt_rxprbserr             ( ),// out std_logic;
      .gt_rxprbscntreset        (1'b0 ),// in  std_logic;
      .gt_rxcdrhold             (4'b0  ),// in  std_logic;
      .gt_dmonitorout           ( ),// out std_logic_vector(15 downto 0);
      .gt_rxheader              ( ),// out std_logic_vector(1 downto 0);
      .gt_rxheadervalid         ( ),// out std_logic;
      .gt_rxdisperr             ( ),// out std_logic_vector(7 downto 0);
      .gt_rxnotintable          ( ),// out std_logic_vector(7 downto 0);
      .gt_rxcommadet            ( ),// out std_logic;
      .gt_pcsrsvdin             (16'h0 ),// in  std_logic_vector(15 downto 0);
      //----------------- END OF DEBUG PORTS -----------------

      //-- Transceiver monitor interface
      // reset signal
      .reset                      (i_ext_rst),  //!!!this signal will reset QPLL and cpri_core itself!!!!!
      // I/Q interface           
      .iq_tx_enable               (o_iq_tx_enable[0]),
      .basic_frame_first_word     (o_bffw[0]),
      .iq_tx                      (i_iq_tx_data[0]),
      .iq_rx                      (o_iq_rx_data[0]),
      // GT Common Ports       
      .qpll0clk_out               (qpll0clk_out    ),
      .qpll0refclk_out            (qpll0refclk_out ),
      .qpll1clk_out               (qpll1clk_out    ),
      .qpll1refclk_out            (qpll1refclk_out ),
      .qpll0lock_out              (qpll0lock_out   ),
      .qpll1lock_out              (qpll1lock_out   ),
	  
       // Vendor Specific Data   
      .vendor_tx_data             ('b0),
      .vendor_tx_xs               (),
      .vendor_tx_ns               (),
      .vendor_rx_data             (),
      .vendor_rx_xs               (),
      .vendor_rx_ns               (),
      .vs_negotiation_complete    (1'b1), 
      
      // Synchronization       
      .nodebfn_tx_strobe          (i_nodebfn_tx_strobe[0]),
      .nodebfn_tx_nr              (i_nodebfn_tx_nr[0]),
      .nodebfn_rx_strobe          (o_nodebfn_rx_strobe[0]),
      .nodebfn_rx_nr              (o_nodebfn_rx_nr[0]),

      // Ethernet interface      
      .eth_txd                    (i_mii_txd[0]),
      .eth_tx_er                  (1'b0),
      .eth_tx_en                  (i_mii_txdv[0]),
      .eth_col                    (),
      .eth_crs                    (),
      .eth_rxd                    (o_mii_rxd[0]),
      .eth_rx_er                  (),
      .eth_rx_dv                  (o_mii_rxen[0]),
      .eth_rx_avail               (o_mii_avil[0]),
      .eth_rx_ready               (i_mii_rx_ready[0]),
      .rx_fifo_almost_full        (),
      .rx_fifo_full               (),
      .eth_ref_clk                (i_clk_25Mhz),
      
      // HDLC interface        
      .hdlc_rx_data               (),
      .hdlc_tx_data               ('b0),
      .hdlc_rx_data_valid         (),
      .hdlc_tx_enable             (),
      
      // Status interface      
      .stat_alarm                 (o_stat_alarm[0]),
      .stat_code                  (o_stat_code[0]),
      .stat_speed                 (o_stat_speed[0]),
      .reset_request_in           (reset_request_in[0]),//(1'b0),
      .sdi_request_in             (1'b0),
      .reset_acknowledge_out      (),
      .sdi_request_out            (),
      .local_los                  (local_los [0]),
      .local_lof                  (local_lof [0]),
      .local_rai                  (local_rai [0]),
      .remote_los                 (remote_los[0]),
      .remote_lof                 (remote_lof[0]),
      .remote_rai                 (remote_rai[0]),
      .fifo_transit_time          (),
      .coarse_timer_value         (),
      .barrel_shift_value         (),
      .tx_gb_latency_value        (),
      .rx_gb_latency_value        (),
      .stat_rx_delay_value        (),
      .hyperframe_number          (),
      
      // AXI-Lite Interface      
      .s_axi_aclk                 (s_axi_aclk),
      .s_axi_aresetn              (s_axi_aresetn),
      .s_axi_awaddr               (s_axi_awaddr [0]),
      .s_axi_awvalid              (s_axi_awvalid[0]),
      .s_axi_awready              (s_axi_awready[0]),
      .s_axi_wdata                (s_axi_wdata  [0]),
      .s_axi_wvalid               (s_axi_wvalid [0]),
      .s_axi_wready               (s_axi_wready [0]),
      .s_axi_bresp                (s_axi_bresp  [0]),
      .s_axi_bvalid               (s_axi_bvalid [0]),
      .s_axi_bready               (s_axi_bready [0]),
      .s_axi_araddr               (s_axi_araddr [0]),
      .s_axi_arvalid              (s_axi_arvalid[0]),
      .s_axi_arready              (s_axi_arready[0]),
      .s_axi_rdata                (s_axi_rdata  [0]),
      .s_axi_rresp                (s_axi_rresp  [0]),
      .s_axi_rvalid               (s_axi_rvalid [0]),
      .s_axi_rready               (s_axi_rready [0]),
      .l1_timer_expired           (1'b0),
      
      // Transceiver signals 	  
      .txp                        (QSFP_TXP[0]),
      .txn                        (QSFP_TXN[0]),
      .rxp                        (QSFP_RXP[0]),
      .rxn                        (QSFP_RXN[0]),
      .lossoflight                (1'b0),
      .txinhibit                  (),
      
      // Clocks                 
      .refclk                     (gty_refclk),
      .core_is_master             (core_is_master),
	  .gtwiz_reset_clk_freerun_in (i_freerun_clk),  // input wire gtwiz_reset_clk_freerun_in
      .hires_clk                  (i_hires_clk),
      .hires_clk_ok               (i_fabric_pll_lock),
      .qpll_select                (1'b1),
      .recclk_ok                  (o_recclk_ok   [0] ),
      .recclk                     (o_recclk      [0] ),
      .clk_ok_out                 (o_clk_ok_out  [0] ),
      .clk_out                    (o_clk_out     [0] ),
      .rxrecclkout                (o_rxrecclkout [0] ),
      .txusrclk_out               (o_txusrclk_out[0] ),
	  
      // Tx Phase Alignment     
      .txphaligndone_in           (txphaligndone_wire  [3:1]),
      .txdlysresetdone_in         (txdlysresetdone_wire[3:1]),
      .txphinitdone_in            (txphinitdone_wire  [3:1]),
      .txphinit_out               (txphinit_trigger[3:1]),
      .phase_alignment_done_out   (phase_alignment_done_flag),
      .txdlysreset_out            (txdlysreset_trigger[3:1]),
      .txphalign_out              (txphalign_trigger  [3:1]),
      .txdlyen_out                (txdlyen_trigger ) 
    ); 
    
    assign txdlyen_ch1 =  txdlyen_trigger[0];
    assign txdlyen_ch2 =  txdlyen_trigger[1];
    assign txdlyen_ch3 =  txdlyen_trigger[2];
 
    cpri_0  ch1_cpri
     (
	  // DRP Access
      .gt_drpdaddr              ('b0 ),// in  std_logic_vector(9 downto 0);
      .gt_drpdi                 ('b0 ),// in  std_logic_vector(15 downto 0);
      .gt_drpen                 ('b0 ),// in  std_logic;
      .gt_drpwe                 ('b0 ),// in  std_logic;
      .gt_drpdo                 ( ),// out std_logic_vector(15 downto 0);
      .gt_drprdy                ( ),// out std_logic;
      // TX Reset and Initialization
      .gt_txpmareset            (gt_txpmareset[1] ),// in  std_logic;
      .gt_txpcsreset            (gt_txpcsreset[1] ),// in  std_logic;
      .gt_txresetdone           (gt_txresetdone[1] ),// out std_logic;
      // RX Reset and Initialization
      .gt_rxpmareset            (gt_rxpmareset[1] ),// in  std_logic;
      .gt_rxpcsreset            (gt_rxpcsreset[1] ),// in  std_logic;
      .gt_rxpmaresetdone        (gt_rxpmaresetdone[1] ),// out std_logic;
      .gt_rxresetdone           (gt_rxresetdone[1] ),// out std_logic;
      // Clocking
      .gt_txphaligndone         (gt_txphaligndone   [1] ),// out std_logic;
      .gt_txphinitdone          (gt_txphinitdone    [1] ),// out std_logic;
      .gt_txdlysresetdone       (gt_txdlysresetdone [1] ),// out std_logic;
      .gt_rxphaligndone         (gt_rxphaligndone   [1] ),// out std_logic;
      .gt_rxdlysresetdone       (gt_rxdlysresetdone [1] ),// out std_logic;
      .gt_rxsyncdone            (gt_rxsyncdone      [1] ),// out std_logic;
      .gt_cplllock              (gt_cplllock        [1] ),// out std_logic;
      // Signal Integrity and Functionality
      .gt_rxrate                (3'b0 ),// in  std_logic_vector(2 downto 0);
      .gt_eyescantrigger        (1'b0 ),// in  std_logic;
      .gt_eyescanreset          (1'b0 ),// in  std_logic;
      .gt_eyescandataerror      (),// out std_logic;
      .gt_rxpolarity            (1'b0 ),// in  std_logic;
      .gt_txpolarity            (tx_pole_vio_sel ),// in  std_logic;
      .gt_rxdfelpmreset         (1'b0 ),// in  std_logic;
      .gt_rxlpmen               (1'b0 ),// in  std_logic;
      .gt_txprecursor           (5'b00000 ),// in  std_logic_vector(4 downto 0);
      .gt_txpostcursor          (5'b00000 ),// in  std_logic_vector(4 downto 0);
      .gt_txdiffctrl            (5'b01100 ),// in  std_logic_vector(4 downto 0);
      .gt_txprbsforceerr        (1'b0 ),// in  std_logic;
      .gt_txprbssel             (4'b0 ),// in  std_logic_vector(3 downto 0);
      .gt_rxprbssel             (4'b0  ),// in  std_logic_vector(3 downto 0);
      .gt_rxprbserr             ( ),// out std_logic;
      .gt_rxprbscntreset        (1'b0 ),// in  std_logic;
      .gt_rxcdrhold             (4'b0  ),// in  std_logic;
      .gt_dmonitorout           ( ),// out std_logic_vector(15 downto 0);
      .gt_rxheader              ( ),// out std_logic_vector(1 downto 0);
      .gt_rxheadervalid         ( ),// out std_logic;
      .gt_rxdisperr             ( ),// out std_logic_vector(7 downto 0);
      .gt_rxnotintable          ( ),// out std_logic_vector(7 downto 0);
      .gt_rxcommadet            ( ),// out std_logic;
      .gt_pcsrsvdin             (16'h0 ),// in  std_logic_vector(15 downto 0);
      //
      
      .reset                    (i_ext_rst),
      // I/Q interface           
      .iq_tx_enable               (o_iq_tx_enable[1]),
      .basic_frame_first_word     (o_bffw[1]),
      .iq_tx                      (i_iq_tx_data[1]),
      .iq_rx                      (o_iq_rx_data[1]),
      
      // GT Common Ports       
      .qpll0clk_in                (qpll0clk_out),
      .qpll0refclk_in             (qpll0refclk_out),
      .qpll1clk_in                (qpll1clk_out),
      .qpll1refclk_in             (qpll1refclk_out),
      .qpll0lock_in               (qpll0lock_out),
      .qpll0_pd                   (),
      .qpll1lock_in               (qpll1lock_out),
      .qpll1_pd                   (),
      .recclk_in                  (rxoutclk_bufg[1]),  //input
      .txusrclk                   (o_txusrclk_out[0]), // input wire txusrclk
      .gtreset_sm_done            (gtreset_sm_done[1]),
      .userclk_tx_reset           (),
      .userclk_rx_reset           (userclk_rx_reset[1]),
      .rxoutclk                   (rxoutclk[1]),   //output
	  
      // Vendor Specific Data   
      .vendor_tx_data             ('b0),
      .vendor_tx_xs               (),
      .vendor_tx_ns               (),
      .vendor_rx_data             (),
      .vendor_rx_xs               (),
      .vendor_rx_ns               (),
      .vs_negotiation_complete    (1'b1), 
      
      // Synchronization       
      .nodebfn_tx_strobe          (i_nodebfn_tx_strobe[1]),
      .nodebfn_tx_nr              (i_nodebfn_tx_nr[1]),
      .nodebfn_rx_strobe          (o_nodebfn_rx_strobe[1]),
      .nodebfn_rx_nr              (o_nodebfn_rx_nr[1]),

      // Ethernet interface      
      .eth_txd                    (i_mii_txd[1]),
      .eth_tx_er                  (1'b0),
      .eth_tx_en                  (i_mii_txdv[1]),
      .eth_col                    (),
      .eth_crs                    (),
      .eth_rxd                    (o_mii_rxd[1]),
      .eth_rx_er                  (),
      .eth_rx_dv                  (o_mii_rxen[1]),
      .eth_rx_avail               (o_mii_avil[1]),
      .eth_rx_ready               (i_mii_rx_ready[1]),
      .rx_fifo_almost_full        (),
      .rx_fifo_full               (),
      .eth_ref_clk                (i_clk_25Mhz),
      // HDLC interface        
      .hdlc_rx_data               (),
      .hdlc_tx_data               ('b0),
      .hdlc_rx_data_valid         (),
      .hdlc_tx_enable             (),
      
      // Status interface      
      .stat_alarm                 (o_stat_alarm[1]),
      .stat_code                  (o_stat_code[1]),
      .stat_speed                 (o_stat_speed[1]),
      .reset_request_in           (reset_request_in[1]),//('b0),
      .sdi_request_in             ('b0),
      .reset_acknowledge_out      (),
      .sdi_request_out            (),
      .local_los                  (local_los [1]),
      .local_lof                  (local_lof [1]),
      .local_rai                  (local_rai [1]),
      .remote_los                 (remote_los[1]),
      .remote_lof                 (remote_lof[1]),
      .remote_rai                 (remote_rai[1]),
      .fifo_transit_time          (),
      .coarse_timer_value         (),
      .barrel_shift_value         (),
      .tx_gb_latency_value        (),
      .rx_gb_latency_value        (),
      .stat_rx_delay_value        (),
      .hyperframe_number          (),
      
      // AXI-Lite Interface      
      .s_axi_aclk                 (s_axi_aclk),
      .s_axi_aresetn              (s_axi_aresetn),
      .s_axi_awaddr               (s_axi_awaddr [1]),
      .s_axi_awvalid              (s_axi_awvalid[1]),
      .s_axi_awready              (s_axi_awready[1]),
      .s_axi_wdata                (s_axi_wdata  [1]),
      .s_axi_wvalid               (s_axi_wvalid [1]),
      .s_axi_wready               (s_axi_wready [1]),
      .s_axi_bresp                (s_axi_bresp  [1]),
      .s_axi_bvalid               (s_axi_bvalid [1]),
      .s_axi_bready               (s_axi_bready [1]),
      .s_axi_araddr               (s_axi_araddr [1]),
      .s_axi_arvalid              (s_axi_arvalid[1]),
      .s_axi_arready              (s_axi_arready[1]),
      .s_axi_rdata                (s_axi_rdata  [1]),
      .s_axi_rresp                (s_axi_rresp  [1]),
      .s_axi_rvalid               (s_axi_rvalid [1]),
      .s_axi_rready               (s_axi_rready [1]),
	  .l1_timer_expired           (1'b0),
	  
      // Transceiver signals   
      .txp                        (QSFP_TXP[1]),
      .txn                        (QSFP_TXN[1]),
      .rxp                        (QSFP_RXP[1]),
      .rxn                        (QSFP_RXN[1]),
      .lossoflight                (1'b0),
      .txinhibit                  (),
      // Clocks                 
      .refclk                     (gty_refclk),
	  .aux_clk_out                (),                                // output wire aux_clk_out. keep open (page 209 of pg056)      

      .gtwiz_reset_clk_freerun_in (i_freerun_clk),
      .hires_clk                  (i_hires_clk  ),
      .hires_clk_ok               (i_fabric_pll_lock),
      .qpll_select                (1'b1),
      .core_is_master             (core_is_master),     
      .recclk_ok                  (o_recclk_ok   [1] ),
      .txoutclk                   ( ),                                      // output wire txoutclk
      .mmcm_rst                   ( ),                                      // output wire mmcm_rst
      .txresetdone_out            (txresetdone_out[1]),                        // output wire txresetdone_out
	  .clk_in                     (o_clk_out[0]),                                          // input wire clk_in
	  .clk_ok_in                  (o_clk_ok_out  [0] ),                                    // input wire clk_ok_in      
	  .rxrecclkout                (o_rxrecclkout [1]),                                // output wire rxrecclkout  
	  .txdlyen_in                 (txdlyen_ch1),                                  // input wire txdlyen_in	  
	  .txphinit_in                (txphinit_trigger[1]),                                // input wire txphinit_in
	  .phase_alignment_done_in    (phase_alignment_done_flag),        // input wire phase_alignment_done_in
	  .txdlysreset_in             (txdlysreset_trigger[1]),                          // input wire txdlysreset_in
	  .txphalign_in               (txphalign_trigger[1]),                              // input wire txphalign_in	
	  	  
	  .txphaligndone_out          (txphaligndone_wire[1]),                    // output wire txphaligndone_out
	  .txdlysresetdone_out        (txdlysresetdone_wire[1]),                // output wire txdlysresetdone_out
	  .txphinitdone_out           (txphinitdone_wire[1]),                      // output wire txphinitdone_out
      .txsyncdone_out             ()

   );   

   BUFG_GT u_bufg_rx_clk_ch1
     (
       .I       (rxoutclk[1]), //=> txoutclk_in,
       .CE      (ce_sync[1]), //=> '1',
       .CEMASK  (0), //=> '0',
       .CLR     (clr_sync[1]), //=> userclk_tx_reset,
       .CLRMASK (0), //=> '0',
       .DIV     (3'b000), //=> bufg_div2,
       .O       (rxoutclk_bufg[1]) //=> txusrclk2);
     );
   BUFG_GT_SYNC u_bufgsync_rx_clk_ch1 (
      .CESYNC(ce_sync[1]),   // 1-bit output: Synchronized CE
      .CLRSYNC(clr_sync[1]), // 1-bit output: Synchronized CLR
      .CE(1'b1),           // 1-bit input: Asynchronous enable
      .CLK(rxoutclk[1]),         // 1-bit input: Clock
      .CLR(userclk_rx_reset[1])          // 1-bit input: Asynchronous clear
   );
  
  cpri_0  ch2_cpri
     (
	  // DRP Access
      .gt_drpdaddr              ('b0 ),// in  std_logic_vector(9 downto 0);
      .gt_drpdi                 ('b0 ),// in  std_logic_vector(15 downto 0);
      .gt_drpen                 ('b0 ),// in  std_logic;
      .gt_drpwe                 ('b0 ),// in  std_logic;
      .gt_drpdo                 ( ),// out std_logic_vector(15 downto 0);
      .gt_drprdy                ( ),// out std_logic;
      // TX Reset and Initialization
      .gt_txpmareset            (gt_txpmareset[2] ),// in  std_logic;
      .gt_txpcsreset            (gt_txpcsreset[2] ),// in  std_logic;
      .gt_txresetdone           (gt_txresetdone[2] ),// out std_logic;
      // RX Reset and Initialization
      .gt_rxpmareset            (gt_rxpmareset[2] ),// in  std_logic;
      .gt_rxpcsreset            (gt_rxpcsreset[2] ),// in  std_logic;
      .gt_rxpmaresetdone        (gt_rxpmaresetdone[2] ),// out std_logic;
      .gt_rxresetdone           (gt_rxresetdone[2] ),// out std_logic;
      // Clocking
      .gt_txphaligndone         (gt_txphaligndone   [2] ),// out std_logic;
      .gt_txphinitdone          (gt_txphinitdone    [2] ),// out std_logic;
      .gt_txdlysresetdone       (gt_txdlysresetdone [2] ),// out std_logic;
      .gt_rxphaligndone         (gt_rxphaligndone   [2] ),// out std_logic;
      .gt_rxdlysresetdone       (gt_rxdlysresetdone [2] ),// out std_logic;
      .gt_rxsyncdone            (gt_rxsyncdone      [2] ),// out std_logic;
      .gt_cplllock              (gt_cplllock        [2] ),// out std_logic;
      // Signal Integrity and Functionality
      .gt_rxrate                (3'b0 ),// in  std_logic_vector(2 downto 0);
      .gt_eyescantrigger        (1'b0 ),// in  std_logic;
      .gt_eyescanreset          (1'b0 ),// in  std_logic;
      .gt_eyescandataerror      (),// out std_logic;
      .gt_rxpolarity            (1'b0 ),// in  std_logic;
      .gt_txpolarity            (tx_pole_vio_sel ),// in  std_logic;
      .gt_rxdfelpmreset         (1'b0 ),// in  std_logic;
      .gt_rxlpmen               (1'b0 ),// in  std_logic;
      .gt_txprecursor           (5'b00000 ),// in  std_logic_vector(4 downto 0);
      .gt_txpostcursor          (5'b00000 ),// in  std_logic_vector(4 downto 0);
      .gt_txdiffctrl            (5'b01100 ),// in  std_logic_vector(4 downto 0);
      .gt_txprbsforceerr        (1'b0 ),// in  std_logic;
      .gt_txprbssel             (4'b0 ),// in  std_logic_vector(3 downto 0);
      .gt_rxprbssel             (4'b0  ),// in  std_logic_vector(3 downto 0);
      .gt_rxprbserr             ( ),// out std_logic;
      .gt_rxprbscntreset        (1'b0 ),// in  std_logic;
      .gt_rxcdrhold             (4'b0  ),// in  std_logic;
      .gt_dmonitorout           ( ),// out std_logic_vector(15 downto 0);
      .gt_rxheader              ( ),// out std_logic_vector(1 downto 0);
      .gt_rxheadervalid         ( ),// out std_logic;
      .gt_rxdisperr             ( ),// out std_logic_vector(7 downto 0);
      .gt_rxnotintable          ( ),// out std_logic_vector(7 downto 0);
      .gt_rxcommadet            ( ),// out std_logic;
      .gt_pcsrsvdin             (16'h0 ),// in  std_logic_vector(15 downto 0);
      //
      
      .reset                    (i_ext_rst),
      // I/Q interface           
      .iq_tx_enable               (o_iq_tx_enable[2]),
      .basic_frame_first_word     (o_bffw[2]),
      .iq_tx                      (i_iq_tx_data[2]),
      .iq_rx                      (o_iq_rx_data[2]),
      
      // GT Common Ports       
      .qpll0clk_in                (qpll0clk_out),
      .qpll0refclk_in             (qpll0refclk_out),
      .qpll1clk_in                (qpll1clk_out),
      .qpll1refclk_in             (qpll1refclk_out),
      .qpll0lock_in               (qpll0lock_out),
      .qpll0_pd                   (),
      .qpll1lock_in               (qpll1lock_out),
      .qpll1_pd                   (),
      .recclk_in                  (rxoutclk_bufg[2]),  //input
      .txusrclk                   (o_txusrclk_out[0]), // input wire txusrclk
      .gtreset_sm_done            (gtreset_sm_done[2]),
      .userclk_tx_reset           (),
      .userclk_rx_reset           (userclk_rx_reset[2]),
      .rxoutclk                   (rxoutclk[2]),   //output
	  
      // Vendor Specific Data   
      .vendor_tx_data             ('b0),
      .vendor_tx_xs               (),
      .vendor_tx_ns               (),
      .vendor_rx_data             (),
      .vendor_rx_xs               (),
      .vendor_rx_ns               (),
      .vs_negotiation_complete    (1'b1), 
      
      // Synchronization       
      .nodebfn_tx_strobe          (i_nodebfn_tx_strobe[2]),
      .nodebfn_tx_nr              (i_nodebfn_tx_nr[2]),
      .nodebfn_rx_strobe          (o_nodebfn_rx_strobe[2]),
      .nodebfn_rx_nr              (o_nodebfn_rx_nr[2]),

      // Ethernet interface      
      .eth_txd                    (i_mii_txd[2]),
      .eth_tx_er                  (1'b0),
      .eth_tx_en                  (i_mii_txdv[2]),
      .eth_col                    (),
      .eth_crs                    (),
      .eth_rxd                    (o_mii_rxd[2]),
      .eth_rx_er                  (),
      .eth_rx_dv                  (o_mii_rxen[2]),
      .eth_rx_avail               (o_mii_avil[2]),
      .eth_rx_ready               (i_mii_rx_ready[2]),
      .rx_fifo_almost_full        (),
      .rx_fifo_full               (),
      .eth_ref_clk                (i_clk_25Mhz),
      // HDLC interface        
      .hdlc_rx_data               (),
      .hdlc_tx_data               ('b0),
      .hdlc_rx_data_valid         (),
      .hdlc_tx_enable             (),
      
      // Status interface      
      .stat_alarm                 (o_stat_alarm[2]),
      .stat_code                  (o_stat_code[2]),
      .stat_speed                 (o_stat_speed[2]),
      .reset_request_in           (reset_request_in[2]),//('b0),
      .sdi_request_in             ('b0),
      .reset_acknowledge_out      (),
      .sdi_request_out            (),
      .local_los                  (local_los [2]),
      .local_lof                  (local_lof [2]),
      .local_rai                  (local_rai [2]),
      .remote_los                 (remote_los[2]),
      .remote_lof                 (remote_lof[2]),
      .remote_rai                 (remote_rai[2]),
      .fifo_transit_time          (),
      .coarse_timer_value         (),
      .barrel_shift_value         (),
      .tx_gb_latency_value        (),
      .rx_gb_latency_value        (),
      .stat_rx_delay_value        (),
      .hyperframe_number          (),
      
      // AXI-Lite Interface      
      .s_axi_aclk                 (s_axi_aclk),
      .s_axi_aresetn              (s_axi_aresetn),
      .s_axi_awaddr               (s_axi_awaddr [2]),
      .s_axi_awvalid              (s_axi_awvalid[2]),
      .s_axi_awready              (s_axi_awready[2]),
      .s_axi_wdata                (s_axi_wdata  [2]),
      .s_axi_wvalid               (s_axi_wvalid [2]),
      .s_axi_wready               (s_axi_wready [2]),
      .s_axi_bresp                (s_axi_bresp  [2]),
      .s_axi_bvalid               (s_axi_bvalid [2]),
      .s_axi_bready               (s_axi_bready [2]),
      .s_axi_araddr               (s_axi_araddr [2]),
      .s_axi_arvalid              (s_axi_arvalid[2]),
      .s_axi_arready              (s_axi_arready[2]),
      .s_axi_rdata                (s_axi_rdata  [2]),
      .s_axi_rresp                (s_axi_rresp  [2]),
      .s_axi_rvalid               (s_axi_rvalid [2]),
      .s_axi_rready               (s_axi_rready [2]),
	  .l1_timer_expired           (1'b0),
	  
      // Transceiver signals   
      .txp                        (QSFP_TXP[2]),
      .txn                        (QSFP_TXN[2]),
      .rxp                        (QSFP_RXP[2]),
      .rxn                        (QSFP_RXN[2]),
      .lossoflight                (1'b0),
      .txinhibit                  (),
      // Clocks                 
      .refclk                     (gty_refclk),
	  .aux_clk_out                (),                                // output wire aux_clk_out. keep open (page 209 of pg056)      

      .gtwiz_reset_clk_freerun_in (i_freerun_clk),
      .hires_clk                  (i_hires_clk  ),
      .hires_clk_ok               (i_fabric_pll_lock),
      .qpll_select                (1'b1),
      .core_is_master             (core_is_master),     
      .recclk_ok                  (o_recclk_ok   [2] ),
      .txoutclk                   ( ),                                      // output wire txoutclk
      .mmcm_rst                   ( ),                                      // output wire mmcm_rst
      .txresetdone_out            (txresetdone_out[2]),                        // output wire txresetdone_out
	  .clk_in                     (o_clk_out[0]),                                          // input wire clk_in
	  .clk_ok_in                  (o_clk_ok_out  [0] ),                                    // input wire clk_ok_in      
	  .rxrecclkout                (o_rxrecclkout [2]),                                // output wire rxrecclkout  
	  .txdlyen_in                 (txdlyen_ch2),                                  // input wire txdlyen_in	  
	  .txphinit_in                (txphinit_trigger[2]),                                // input wire txphinit_in
	  .phase_alignment_done_in    (phase_alignment_done_flag),        // input wire phase_alignment_done_in
	  .txdlysreset_in             (txdlysreset_trigger[2]),                          // input wire txdlysreset_in
	  .txphalign_in               (txphalign_trigger[2]),                              // input wire txphalign_in	
	  	  
	  .txphaligndone_out          (txphaligndone_wire[2]),                    // output wire txphaligndone_out
	  .txdlysresetdone_out        (txdlysresetdone_wire[2]),                // output wire txdlysresetdone_out
	  .txphinitdone_out           (txphinitdone_wire[2]),                      // output wire txphinitdone_out
      .txsyncdone_out             ()

   );   

   BUFG_GT u_bufg_rx_clk_ch2
     (
       .I       (rxoutclk[2]), //=> txoutclk_in,
       .CE      (ce_sync[2]), //=> '1',
       .CEMASK  (0), //=> '0',
       .CLR     (clr_sync[2]), //=> userclk_tx_reset,
       .CLRMASK (0), //=> '0',
       .DIV     (3'b000), //=> bufg_div2,
       .O       (rxoutclk_bufg[2]) //=> txusrclk2);
     );
   BUFG_GT_SYNC u_bufgsync_rx_clk_ch2 (
      .CESYNC(ce_sync[2]),   // 1-bit output: Synchronized CE
      .CLRSYNC(clr_sync[2]), // 1-bit output: Synchronized CLR
      .CE(1'b1),           // 1-bit input: Asynchronous enable
      .CLK(rxoutclk[2]),         // 1-bit input: Clock
      .CLR(userclk_rx_reset[2])          // 1-bit input: Asynchronous clear
   );

  cpri_0  ch3_cpri
     (
	  // DRP Access
      .gt_drpdaddr              ('b0 ),// in  std_logic_vector(9 downto 0);
      .gt_drpdi                 ('b0 ),// in  std_logic_vector(15 downto 0);
      .gt_drpen                 ('b0 ),// in  std_logic;
      .gt_drpwe                 ('b0 ),// in  std_logic;
      .gt_drpdo                 ( ),// out std_logic_vector(15 downto 0);
      .gt_drprdy                ( ),// out std_logic;
      // TX Reset and Initialization
      .gt_txpmareset            (gt_txpmareset[3] ),// in  std_logic;
      .gt_txpcsreset            (gt_txpcsreset[3] ),// in  std_logic;
      .gt_txresetdone           (gt_txresetdone[3] ),// out std_logic;
      // RX Reset and Initialization
      .gt_rxpmareset            (gt_rxpmareset[3] ),// in  std_logic;
      .gt_rxpcsreset            (gt_rxpcsreset[3] ),// in  std_logic;
      .gt_rxpmaresetdone        (gt_rxpmaresetdone[3] ),// out std_logic;
      .gt_rxresetdone           (gt_rxresetdone[3] ),// out std_logic;
      // Clocking
      .gt_txphaligndone         (gt_txphaligndone   [3] ),// out std_logic;
      .gt_txphinitdone          (gt_txphinitdone    [3] ),// out std_logic;
      .gt_txdlysresetdone       (gt_txdlysresetdone [3] ),// out std_logic;
      .gt_rxphaligndone         (gt_rxphaligndone   [3] ),// out std_logic;
      .gt_rxdlysresetdone       (gt_rxdlysresetdone [3] ),// out std_logic;
      .gt_rxsyncdone            (gt_rxsyncdone      [3] ),// out std_logic;
      .gt_cplllock              (gt_cplllock        [3] ),// out std_logic;
      // Signal Integrity and Functionality
      .gt_rxrate                (3'b0 ),// in  std_logic_vector(2 downto 0);
      .gt_eyescantrigger        (1'b0 ),// in  std_logic;
      .gt_eyescanreset          (1'b0 ),// in  std_logic;
      .gt_eyescandataerror      (),// out std_logic;
      .gt_rxpolarity            (1'b0 ),// in  std_logic;
      .gt_txpolarity            (tx_pole_vio_sel ),// in  std_logic;
      .gt_rxdfelpmreset         (1'b0 ),// in  std_logic;
      .gt_rxlpmen               (1'b0 ),// in  std_logic;
      .gt_txprecursor           (5'b00000 ),// in  std_logic_vector(4 downto 0);
      .gt_txpostcursor          (5'b00000 ),// in  std_logic_vector(4 downto 0);
      .gt_txdiffctrl            (5'b01100 ),// in  std_logic_vector(4 downto 0);
      .gt_txprbsforceerr        (1'b0 ),// in  std_logic;
      .gt_txprbssel             (4'b0 ),// in  std_logic_vector(3 downto 0);
      .gt_rxprbssel             (4'b0  ),// in  std_logic_vector(3 downto 0);
      .gt_rxprbserr             ( ),// out std_logic;
      .gt_rxprbscntreset        (1'b0 ),// in  std_logic;
      .gt_rxcdrhold             (4'b0  ),// in  std_logic;
      .gt_dmonitorout           ( ),// out std_logic_vector(15 downto 0);
      .gt_rxheader              ( ),// out std_logic_vector(1 downto 0);
      .gt_rxheadervalid         ( ),// out std_logic;
      .gt_rxdisperr             ( ),// out std_logic_vector(7 downto 0);
      .gt_rxnotintable          ( ),// out std_logic_vector(7 downto 0);
      .gt_rxcommadet            ( ),// out std_logic;
      .gt_pcsrsvdin             (16'h0 ),// in  std_logic_vector(15 downto 0);
      //
      
      .reset                    (i_ext_rst),
      // I/Q interface           
      .iq_tx_enable               (o_iq_tx_enable[3]),
      .basic_frame_first_word     (o_bffw[3]),
      .iq_tx                      (i_iq_tx_data[3]),
      .iq_rx                      (o_iq_rx_data[3]),
      
      // GT Common Ports       
      .qpll0clk_in                (qpll0clk_out),
      .qpll0refclk_in             (qpll0refclk_out),
      .qpll1clk_in                (qpll1clk_out),
      .qpll1refclk_in             (qpll1refclk_out),
      .qpll0lock_in               (qpll0lock_out),
      .qpll0_pd                   (),
      .qpll1lock_in               (qpll1lock_out),
      .qpll1_pd                   (),
      .recclk_in                  (rxoutclk_bufg[3]),  //input
      .txusrclk                   (o_txusrclk_out[0]), // input wire txusrclk
      .gtreset_sm_done            (gtreset_sm_done[3]),
      .userclk_tx_reset           (),
      .userclk_rx_reset           (userclk_rx_reset[3]),
      .rxoutclk                   (rxoutclk[3]),   //output
	  
      // Vendor Specific Data   
      .vendor_tx_data             ('b0),
      .vendor_tx_xs               (),
      .vendor_tx_ns               (),
      .vendor_rx_data             (),
      .vendor_rx_xs               (),
      .vendor_rx_ns               (),
      .vs_negotiation_complete    (1'b1), 
      
      // Synchronization       
      .nodebfn_tx_strobe          (i_nodebfn_tx_strobe[3]),
      .nodebfn_tx_nr              (i_nodebfn_tx_nr[3]),
      .nodebfn_rx_strobe          (o_nodebfn_rx_strobe[3]),
      .nodebfn_rx_nr              (o_nodebfn_rx_nr[3]),

      // Ethernet interface      
      .eth_txd                    (i_mii_txd[3]),
      .eth_tx_er                  (1'b0),
      .eth_tx_en                  (i_mii_txdv[3]),
      .eth_col                    (),
      .eth_crs                    (),
      .eth_rxd                    (o_mii_rxd[3]),
      .eth_rx_er                  (),
      .eth_rx_dv                  (o_mii_rxen[3]),
      .eth_rx_avail               (o_mii_avil[3]),
      .eth_rx_ready               (i_mii_rx_ready[3]),
      .rx_fifo_almost_full        (),
      .rx_fifo_full               (),
      .eth_ref_clk                (i_clk_25Mhz),
      // HDLC interface        
      .hdlc_rx_data               (),
      .hdlc_tx_data               ('b0),
      .hdlc_rx_data_valid         (),
      .hdlc_tx_enable             (),
      
      // Status interface      
      .stat_alarm                 (o_stat_alarm[3]),
      .stat_code                  (o_stat_code[3]),
      .stat_speed                 (o_stat_speed[3]),
      .reset_request_in           (reset_request_in[3]),//('b0),
      .sdi_request_in             ('b0),
      .reset_acknowledge_out      (),
      .sdi_request_out            (),
      .local_los                  (local_los [3]),
      .local_lof                  (local_lof [3]),
      .local_rai                  (local_rai [3]),
      .remote_los                 (remote_los[3]),
      .remote_lof                 (remote_lof[3]),
      .remote_rai                 (remote_rai[3]),
      .fifo_transit_time          (),
      .coarse_timer_value         (),
      .barrel_shift_value         (),
      .tx_gb_latency_value        (),
      .rx_gb_latency_value        (),
      .stat_rx_delay_value        (),
      .hyperframe_number          (),
      
      // AXI-Lite Interface      
      .s_axi_aclk                 (s_axi_aclk),
      .s_axi_aresetn              (s_axi_aresetn),
      .s_axi_awaddr               (s_axi_awaddr [3]),
      .s_axi_awvalid              (s_axi_awvalid[3]),
      .s_axi_awready              (s_axi_awready[3]),
      .s_axi_wdata                (s_axi_wdata  [3]),
      .s_axi_wvalid               (s_axi_wvalid [3]),
      .s_axi_wready               (s_axi_wready [3]),
      .s_axi_bresp                (s_axi_bresp  [3]),
      .s_axi_bvalid               (s_axi_bvalid [3]),
      .s_axi_bready               (s_axi_bready [3]),
      .s_axi_araddr               (s_axi_araddr [3]),
      .s_axi_arvalid              (s_axi_arvalid[3]),
      .s_axi_arready              (s_axi_arready[3]),
      .s_axi_rdata                (s_axi_rdata  [3]),
      .s_axi_rresp                (s_axi_rresp  [3]),
      .s_axi_rvalid               (s_axi_rvalid [3]),
      .s_axi_rready               (s_axi_rready [3]),
	  .l1_timer_expired           (1'b0),
	  
      // Transceiver signals   
      .txp                        (QSFP_TXP[3]),
      .txn                        (QSFP_TXN[3]),
      .rxp                        (QSFP_RXP[3]),
      .rxn                        (QSFP_RXN[3]),
      .lossoflight                (1'b0),
      .txinhibit                  (),
      // Clocks                 
      .refclk                     (gty_refclk),
	  .aux_clk_out                (),                                // output wire aux_clk_out. keep open (page 209 of pg056)      

      .gtwiz_reset_clk_freerun_in (i_freerun_clk),
      .hires_clk                  (i_hires_clk  ),
      .hires_clk_ok               (i_fabric_pll_lock),
      .qpll_select                (1'b1),
      .core_is_master             (core_is_master),     
      .recclk_ok                  (o_recclk_ok   [3] ),
      .txoutclk                   ( ),                                      // output wire txoutclk
      .mmcm_rst                   ( ),                                      // output wire mmcm_rst
      .txresetdone_out            (txresetdone_out[3]),                        // output wire txresetdone_out
	  .clk_in                     (o_clk_out[0]),                                          // input wire clk_in
	  .clk_ok_in                  (o_clk_ok_out  [0] ),                                    // input wire clk_ok_in      
	  .rxrecclkout                (o_rxrecclkout [3]),                                // output wire rxrecclkout  
	  .txdlyen_in                 (txdlyen_ch3),                                  // input wire txdlyen_in	  
	  .txphinit_in                (txphinit_trigger[3]),                                // input wire txphinit_in
	  .phase_alignment_done_in    (phase_alignment_done_flag),        // input wire phase_alignment_done_in
	  .txdlysreset_in             (txdlysreset_trigger[3]),                          // input wire txdlysreset_in
	  .txphalign_in               (txphalign_trigger[3]),                              // input wire txphalign_in	
	  	  
	  .txphaligndone_out          (txphaligndone_wire[3]),                    // output wire txphaligndone_out
	  .txdlysresetdone_out        (txdlysresetdone_wire[3]),                // output wire txdlysresetdone_out
	  .txphinitdone_out           (txphinitdone_wire[3]),                      // output wire txphinitdone_out
      .txsyncdone_out             ()

   );   

   BUFG_GT u_bufg_rx_clk_ch3
     (
       .I       (rxoutclk[3]), //=> txoutclk_in,
       .CE      (ce_sync[3]), //=> '1',
       .CEMASK  (0), //=> '0',
       .CLR     (clr_sync[3]), //=> userclk_tx_reset,
       .CLRMASK (0), //=> '0',
       .DIV     (3'b000), //=> bufg_div2,
       .O       (rxoutclk_bufg[3]) //=> txusrclk2);
     );
   BUFG_GT_SYNC u_bufgsync_rx_clk_ch3 (
      .CESYNC(ce_sync[3]),   // 1-bit output: Synchronized CE
      .CLRSYNC(clr_sync[3]), // 1-bit output: Synchronized CLR
      .CE(1'b1),           // 1-bit input: Asynchronous enable
      .CLK(rxoutclk[3]),         // 1-bit input: Clock
      .CLR(userclk_rx_reset[3])          // 1-bit input: Asynchronous clear
   );






ila_cpri_stat   ila_cpri_stat
(
	.clk       (o_clk_out[0]),         // input wire clk
	
	.probe0    (i_iq_tx_data),         // input wire [63:0]  probe0 
	.probe1    (o_iq_rx_data),         // input wire [63:0]  probe1 
	.probe2    (i_nodebfn_tx_strobe),  // input wire [0:0]   probe2 
	.probe3    (i_nodebfn_tx_nr    ),  // input wire [11:0]  probe3 
	.probe4    (o_nodebfn_rx_strobe),  // input wire [0:0]   probe4
	.probe5    (o_nodebfn_rx_nr    ),  // input wire [11:0]  probe5
	.probe6    (o_iq_tx_enable     )    // input wire [3:0]   probe6     
);

tx_pole_vio u_tx_pole_vio 
(
  .clk(i_clk_100mhz),                // input wire clk
  .probe_out0(tx_pole_vio_sel)  ,
  .probe_out1(core_is_master)  
);
 
ila_cpri_mii   ila_cpri_mii
(
	.clk       (i_clk_100mhz   ),      // input wire clk
	
	.probe0    (o_stat_alarm   ),      // input wire [0:0]  probe0  
	.probe1    (o_stat_code    ),      // input wire [3:0]  probe1 
	.probe2    (o_stat_speed   ),      // input wire [14:0]  probe2 
	.probe3    (i_mii_txd      ),      // input wire [3:0]  probe7
	.probe4    (o_mii_rxd      ),      // input wire [3:0]  probe7
	.probe5    (i_mii_txdv     ),      // input wire [0:0]  probe7
	.probe6    (o_mii_rxen     ),      // input wire [0:0]  probe7
	.probe7    (i_mii_rx_ready ),      // input wire [0:0]  probe7 
	.probe8    (o_mii_avil     ),      // input wire [0:0]  probe7 
	.probe9    (txdlysreset_trigger[3:1]),
	.probe10   (txphalign_trigger  [3:1]),
	.probe11   (txdlyen_trigger ),  
	.probe12   (txdlysresetdone_wire )  
);






endmodule
