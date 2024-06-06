//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/28 15:54:23
// Design Name: 
// Module Name: cpri_quad_top
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




module cpri_quad_top # (LANE = 4)
(
    // Clock
    input                   gtwiz_reset_clk_freerun_in,
    input                   refclk_p                ,
    input                   refclk_n                ,
    input                   hires_clk               ,
    input                   hires_clk_ok            ,
    input                   eth_ref_clk             ,

    // reset
    input                   reset                   ,

    input                   qpll_select             ,
    input                   core_is_master          ,
    input                   enable_test_start       ,

    output [LANE-1:0]       o_stat_alarm            ,
    output [LANE-1:0][3:0]  o_stat_code             ,
    output [LANE-1:0][14:0] o_stat_speed            ,
    input                   mu_law_encoding         ,

    output [LANE-1:0]       o_local_los             ,
    output [LANE-1:0]       o_local_lof             ,

    // AXI
    input                   s_axi_aclk              ,
    input                   s_axi_aresetn           ,
    input  [LANE-1:0][11:0] s_axi_awaddr            ,
    input  [LANE-1:0]       s_axi_awvalid           ,
    output [LANE-1:0]       s_axi_awready           ,
    input  [LANE-1:0][31:0] s_axi_wdata             ,
    input  [LANE-1:0]       s_axi_wvalid            ,
    output [LANE-1:0]       s_axi_wready            ,
    output [LANE-1:0][1:0]  s_axi_bresp             ,
    output [LANE-1:0]       s_axi_bvalid            ,
    input  [LANE-1:0]       s_axi_bready            ,
    input  [LANE-1:0][11:0] s_axi_araddr            ,
    input  [LANE-1:0]       s_axi_arvalid           ,
    output [LANE-1:0]       s_axi_arready           ,
    output [LANE-1:0][31:0] s_axi_rdata             ,
    output [LANE-1:0][1:0]  s_axi_rresp             ,
    output [LANE-1:0]       s_axi_rvalid            ,
    input  [LANE-1:0]       s_axi_rready            ,

    // I/O interface
    output [LANE-1:0]       o_iq_tx_enable          ,
    output [LANE-1:0]       o_bffwd                 ,
    input  [LANE-1:0][63:0] i_iq_tx                 ,
    output [LANE-1:0][63:0] o_iq_rx                 ,
    
    input  [LANE-1:0]       i_nodebfn_tx_strobe     ,
    input  [LANE-1:0][11:0] i_nodebfn_tx_nr         ,
    output [LANE-1:0]       o_nodebfn_rx_strobe     ,
    output [LANE-1:0][11:0] o_nodebfn_rx_nr         , 

    // eth interface
    input  [LANE-1:0][3:0]  i_eth_txd               ,
    input  [LANE-1:0]       i_eth_tx_en             ,
    output [LANE-1:0][3:0]  o_eth_rxd               ,
    output [LANE-1:0]       o_eth_rx_dv             ,
    output [LANE-1:0]       o_eth_rx_avail          ,
    input  [LANE-1:0]       i_eth_rx_ready          ,

    // SERDES
    output [LANE-1:0]       o_txp                   ,
    output [LANE-1:0]       o_txn                   ,
    input  [LANE-1:0]       i_rxp                   ,
    input  [LANE-1:0]       i_rxn                   ,

    output                  o_cpri_clk              ,              
    output                  o_rec_clk               ,              
    output                  o_qpll_lock              


);


//--------------------------------------------------------------------
// PARAMETER
//--------------------------------------------------------------------






//--------------------------------------------------------------------
// WIRE & REGISTER
//--------------------------------------------------------------------
logic [3:0]     txphaligndone_vec   ;
logic [3:0]     txdlysresetdone_vec ;
logic [3:0]     txphinit_vec        ;
logic [3:0]     txdlysreset_vec     ;
logic [3:0]     txphalign_vec       ;
logic [3:0]     txphinitdone_vec    ;
logic [3:0]     userclk_tx_reset    ;
logic [3:0]     userclk_rx_reset    ;
logic [3:0]     txdlyen_vec         ;
logic           phase_alignment_done_out;
logic [3:0]     gtreset_sm_done     ;
logic [3:0]     txresetdone_out     ;

logic [3:0]     rxrecclkout_vec     ;
logic [3:0]     recclk_ok_vec       ;

// common
logic           common_qpll0clk     ;
logic           common_qpll0refclk  ;
logic           common_qpll1clk     ;
logic           common_qpll1refclk  ;
logic           common_qpll0lock    ;
logic           common_qpll1lock    ;

// status
logic [3:0]     local_los           ;
logic [3:0]     local_lof           ;
logic [3:0]     local_rai           ;
logic [3:0]     remote_los          ;
logic [3:0]     remote_lof          ;
logic [3:0]     remote_rai          ;
logic [3:0][7:0]hyperframe_nr       ;

logic           recclk_out          ;
logic           clk_out             ;    
logic           clk_ok_out          ;
logic           txusrclk_out        ;

logic           refclk              ;


//--------------------------------------------------------------------
// Clock
//--------------------------------------------------------------------
IBUFDS_GTE4 #(
    .REFCLK_EN_TX_PATH  (1'b0), // Refer to Transceiver User Guide.
    .REFCLK_HROW_CK_SEL (2'b00),// Refer to Transceiver User Guide.
    .REFCLK_ICNTL_RX    (2'b00) // Refer to Transceiver User Guide.
)
IBUFDS_GTE4_0 (
    .O      (refclk),           // 1-bit output: Refer to Transceiver User Guide.
    .ODIV2  (),                 // 1-bit output: Refer to Transceiver User Guide.
    .CEB    (1'b0),             // 1-bit input: Refer to Transceiver User Guide.
    .I      (refclk_p),         // 1-bit input: Refer to Transceiver User Guide.
    .IB     (refclk_n)          // 1-bit input: Refer to Transceiver User Guide.
);


//--------------------------------------------------------------------
// CH0
//--------------------------------------------------------------------
cpri_slave_0_support               cpri_ch0
(
    .reset                          ( reset),

    // I/Q interface
    .iq_tx_enable                   ( o_iq_tx_enable[0] ),
    .basic_frame_first_word         ( o_bffwd[0]        ),
    .iq_tx                          ( i_iq_tx[0]        ),
    .iq_rx                          ( o_iq_rx[0]        ),

    // GT Common Ports
    .qpll0clk_out                   ( common_qpll0clk   ),
    .qpll0refclk_out                ( common_qpll0refclk),
    .qpll1clk_out                   ( common_qpll1clk   ),
    .qpll1refclk_out                ( common_qpll1refclk),
    .qpll0lock_out                  ( common_qpll0lock  ),
    .qpll1lock_out                  ( common_qpll1lock  ),
    
    // Vendor interface
    .vendor_tx_data                 ( 'd0),
    .vendor_tx_xs                   ( ),
    .vendor_tx_ns                   ( ),
    .vendor_rx_data                 ( ),
    .vendor_rx_xs                   ( ),
    .vendor_rx_ns                   ( ),
    .vs_negotiation_complete        ( 1'b1),

    // Synchronization
    .nodebfn_tx_strobe              ( i_nodebfn_tx_strobe[0]),
    .nodebfn_tx_nr                  ( i_nodebfn_tx_nr[0]    ),
    .nodebfn_rx_strobe              ( o_nodebfn_rx_strobe[0]),
    .nodebfn_rx_nr                  ( o_nodebfn_rx_nr[0]    ),

    // Ethernet interface
    .eth_txd                        ( i_eth_txd[0]      ),
    .eth_tx_er                      ( 1'b0 ),
    .eth_tx_en                      ( i_eth_tx_en[0]    ),
    .eth_col                        ( ),
    .eth_crs                        ( ),
    .eth_rxd                        ( o_eth_rxd[0]      ),
    .eth_rx_er                      ( ),
    .eth_rx_dv                      ( o_eth_rx_dv[0]    ),
    .eth_rx_avail                   ( o_eth_rx_avail[0] ),
    .eth_rx_ready                   ( i_eth_rx_ready[0] ),
    .rx_fifo_almost_full            ( ),
    .rx_fifo_full                   ( ),
    .eth_ref_clk                    ( eth_ref_clk       ),

    // HDLC interface
    .hdlc_rx_data                   ( ),
    .hdlc_tx_data                   ( 'd0 ),
    .hdlc_rx_data_valid             ( ),
    .hdlc_tx_enable                 ( ),

    // Status interface
    .stat_alarm                     ( o_stat_alarm[0]),
    .stat_code                      ( o_stat_code [0]),
    .stat_speed                     ( o_stat_speed[0]),
    .reset_acknowledge_in           ( 1'b0),
    .sdi_request_in                 ( 1'b0),
    .reset_request_out              ( ),
    .sdi_request_out                ( ),
    .local_los                      ( local_los [0]),
    .local_lof                      ( local_lof [0]),
    .local_rai                      ( local_rai [0]),
    .remote_los                     ( remote_los[0]),
    .remote_lof                     ( remote_lof[0]),
    .remote_rai                     ( remote_rai[0]),
    .fifo_transit_time              ( ),
    .coarse_timer_value             ( ),
    .barrel_shift_value             ( ),
    .tx_gb_latency_value            ( ),
    .rx_gb_latency_value            ( ),
    .stat_rx_delay_value            ( ),
    .hyperframe_number              ( hyperframe_nr[0]),

    // AXI management interface
    .s_axi_aclk                     ( s_axi_aclk        ),
    .s_axi_aresetn                  ( s_axi_aresetn     ),
    .s_axi_awaddr                   ( s_axi_awaddr [0]  ),
    .s_axi_awvalid                  ( s_axi_awvalid[0]  ),
    .s_axi_awready                  ( s_axi_awready[0]  ),
    .s_axi_wdata                    ( s_axi_wdata  [0]  ),
    .s_axi_wvalid                   ( s_axi_wvalid [0]  ),
    .s_axi_wready                   ( s_axi_wready [0]  ),
    .s_axi_bresp                    ( s_axi_bresp  [0]  ),
    .s_axi_bvalid                   ( s_axi_bvalid [0]  ),
    .s_axi_bready                   ( s_axi_bready [0]  ),
    .s_axi_araddr                   ( s_axi_araddr [0]  ),
    .s_axi_arvalid                  ( s_axi_arvalid[0]  ),
    .s_axi_arready                  ( s_axi_arready[0]  ),
    .s_axi_rdata                    ( s_axi_rdata  [0]  ),
    .s_axi_rresp                    ( s_axi_rresp  [0]  ),
    .s_axi_rvalid                   ( s_axi_rvalid [0]  ),
    .s_axi_rready                   ( s_axi_rready [0]  ),
    .l1_timer_expired               ( 1'b0              ),

    // SFP interface
    .txp                            ( o_txp[0]  ),
    .txn                            ( o_txn[0]  ),
    .rxp                            ( i_rxp[0]  ),
    .rxn                            ( i_rxn[0]  ),
    .lossoflight                    ( 1'b0      ),
    .txinhibit                      (           ),

    // Clocks
    //.core_is_master                 ( core_is_master),
    .refclk                         ( refclk),
    .gtwiz_reset_clk_freerun_in     ( gtwiz_reset_clk_freerun_in),
    .hires_clk                      ( hires_clk),
    .hires_clk_ok                   ( hires_clk_ok),
    .qpll_select                    ( qpll_select ),
    .recclk_ok                      ( recclk_ok_vec[0]),
    .recclk                         ( recclk_out),
    .clk_out                        ( clk_out),
    .clk_ok_out                     ( clk_ok_out),
    .rxrecclkout                    ( rxrecclkout_vec[0]),
    .txusrclk_out                   ( txusrclk_out),

    // Tx Phase alignment
    .txphaligndone_in               ( txphaligndone_vec  [3:1]  ),
    .txdlysresetdone_in             ( txdlysresetdone_vec[3:1]  ),
    .txphinitdone_in                ( txphinitdone_vec   [3:1]  ),
    .txphinit_out                   ( txphinit_vec       [3:1]  ),
    .phase_alignment_done_out       ( phase_alignment_done_out  ),
    .txdlysreset_out                ( txdlysreset_vec    [3:1]  ),
    .txphalign_out                  ( txphalign_vec      [3:1]  ),
    .txdlyen_out                    ( txdlyen_vec        [3:1]  )
);



//--------------------------------------------------------------------
// CH1
//--------------------------------------------------------------------
logic   [LANE-1:0]  ce_sync;
logic   [LANE-1:0]  clr_sync;
logic   [LANE-1:0]  rxoutclk_out;
logic   [LANE-1:0]  rxoutclk_bufg;

BUFG_GT         u_bufg_rx_clk_ch1
(
    .I          (rxoutclk_out[1]), //=> txoutclk_in,
    .CE         (ce_sync[1]), //=> '1',
    .CEMASK     (0), //=> '0',
    .CLR        (clr_sync[1]), //=> userclk_tx_reset,
    .CLRMASK    (0), //=> '0',
    .DIV        (3'b000), //=> bufg_div2,
    .O          (rxoutclk_bufg[1]) //=> txusrclk2);
);
BUFG_GT_SYNC    u_bufgsync_rx_clk_ch1 (
    .CESYNC     (ce_sync[1]),           // 1-bit output: Synchronized CE
    .CLRSYNC    (clr_sync[1]),          // 1-bit output: Synchronized CLR
    .CE         (1'b1),                 // 1-bit input: Asynchronous enable
    .CLK        (rxoutclk_out[1]),      // 1-bit input: Clock
    .CLR        (userclk_rx_reset[1])   // 1-bit input: Asynchronous clear
);

cpri_slave_0                       cpri_ch1 
(
    .reset                          ( reset),

    // I/Q interface
    .iq_tx_enable                   ( o_iq_tx_enable[1] ),
    .basic_frame_first_word         ( o_bffwd[1]        ),
    .iq_tx                          ( i_iq_tx[1]        ),
    .iq_rx                          ( o_iq_rx[1]        ),

    // GT Common Ports
    .qpll0clk_in                    ( common_qpll0clk),
    .qpll0refclk_in                 ( common_qpll0refclk),
    .qpll0lock_in                   ( common_qpll0lock),
    .qpll0_pd                       ( ),
    .qpll1clk_in                    ( common_qpll1clk),
    .qpll1refclk_in                 ( common_qpll1refclk),
    .qpll1lock_in                   ( common_qpll1lock),
    .qpll1_pd                       ( ),

    // Vendor Specific Data
    .vendor_tx_data                 ( 'd0),
    .vendor_tx_xs                   ( ),
    .vendor_tx_ns                   ( ),
    .vendor_rx_data                 ( ),
    .vendor_rx_xs                   ( ),
    .vendor_rx_ns                   ( ),
    .vs_negotiation_complete        ( 1'b1),

    // Synchronization
    .nodebfn_tx_strobe              ( i_nodebfn_tx_strobe[1]),
    .nodebfn_tx_nr                  ( i_nodebfn_tx_nr[1]    ),
    .nodebfn_rx_strobe              ( o_nodebfn_rx_strobe[1]),
    .nodebfn_rx_nr                  ( o_nodebfn_rx_nr[1]    ),

    // Ethernet interface
    .eth_txd                        ( i_eth_txd[1]      ),
    .eth_tx_er                      ( 1'b0 ),
    .eth_tx_en                      ( i_eth_tx_en[1]    ),
    .eth_col                        ( ),
    .eth_crs                        ( ),
    .eth_rxd                        ( o_eth_rxd[1]      ),
    .eth_rx_er                      ( ),
    .eth_rx_dv                      ( o_eth_rx_dv[1]    ),
    .eth_rx_avail                   ( o_eth_rx_avail[1] ),
    .eth_rx_ready                   ( i_eth_rx_ready[1] ),
    .rx_fifo_almost_full            ( ),
    .rx_fifo_full                   ( ),
    .eth_ref_clk                    ( eth_ref_clk       ),

    // HDLC interface
    .hdlc_rx_data                   ( ),
    .hdlc_tx_data                   ( 'd0 ),
    .hdlc_rx_data_valid             ( ),
    .hdlc_tx_enable                 ( ),

    // Status interface
    .stat_alarm                     ( o_stat_alarm[1]),
    .stat_code                      ( o_stat_code [1]),
    .stat_speed                     ( o_stat_speed[1]),
    .reset_acknowledge_in           ( 1'b0),
    .sdi_request_in                 ( 1'b0),
    .reset_request_out              ( ),
    .sdi_request_out                ( ),
    .local_los                      ( local_los [1]),
    .local_lof                      ( local_lof [1]),
    .local_rai                      ( local_rai [1]),
    .remote_los                     ( remote_los[1]),
    .remote_lof                     ( remote_lof[1]),
    .remote_rai                     ( remote_rai[1]),
    .fifo_transit_time              ( ),
    .coarse_timer_value             ( ),
    .barrel_shift_value             ( ),
    .tx_gb_latency_value            ( ),
    .rx_gb_latency_value            ( ),
    .stat_rx_delay_value            ( ),
    .hyperframe_number              ( hyperframe_nr[1]),

    // AXI management interface
    .s_axi_aclk                     ( s_axi_aclk        ),
    .s_axi_aresetn                  ( s_axi_aresetn     ),
    .s_axi_awaddr                   ( s_axi_awaddr [1]  ),
    .s_axi_awvalid                  ( s_axi_awvalid[1]  ),
    .s_axi_awready                  ( s_axi_awready[1]  ),
    .s_axi_wdata                    ( s_axi_wdata  [1]  ),
    .s_axi_wvalid                   ( s_axi_wvalid [1]  ),
    .s_axi_wready                   ( s_axi_wready [1]  ),
    .s_axi_bresp                    ( s_axi_bresp  [1]  ),
    .s_axi_bvalid                   ( s_axi_bvalid [1]  ),
    .s_axi_bready                   ( s_axi_bready [1]  ),
    .s_axi_araddr                   ( s_axi_araddr [1]  ),
    .s_axi_arvalid                  ( s_axi_arvalid[1]  ),
    .s_axi_arready                  ( s_axi_arready[1]  ),
    .s_axi_rdata                    ( s_axi_rdata  [1]  ),
    .s_axi_rresp                    ( s_axi_rresp  [1]  ),
    .s_axi_rvalid                   ( s_axi_rvalid [1]  ),
    .s_axi_rready                   ( s_axi_rready [1]  ),
    .l1_timer_expired               ( 1'b0              ),

    // SFP interface
    .txp                            ( o_txp[1]  ),
    .txn                            ( o_txn[1]  ),
    .rxp                            ( i_rxp[1]  ),
    .rxn                            ( i_rxn[1]  ),
    .lossoflight                    ( 1'b0      ),
    .txinhibit                      (           ),

    // Clocks
    //.core_is_master                 ( core_is_master),
    .refclk                         ( refclk),
    .gtwiz_reset_clk_freerun_in     ( gtwiz_reset_clk_freerun_in),
    .hires_clk                      ( hires_clk),
    .hires_clk_ok                   ( hires_clk_ok),
    .qpll_select                    ( qpll_select ),
    .recclk_in                      ( rxoutclk_bufg[1]),
    .recclk_ok                      ( recclk_ok_vec[1]),
    .clk_in                         ( clk_out),
    .clk_ok_in                      ( clk_ok_out),
    .rxrecclkout                    ( rxrecclkout_vec[1]),
    .txusrclk                       ( txusrclk_out),

    .gtreset_sm_done                ( gtreset_sm_done[1]),
    .userclk_tx_reset               ( ),
    .userclk_rx_reset               ( userclk_rx_reset[1]),
    .aux_clk_out                    ( ),
    .txoutclk                       ( ),
    .mmcm_rst                       ( ),
    .rxoutclk                       ( rxoutclk_out[1]),
    .txresetdone_out                ( txresetdone_out[1]),

    .txphaligndone_out              ( txphaligndone_vec  [1]    ),
    .txdlysresetdone_out            ( txdlysresetdone_vec[1]    ),
    .txphinitdone_out               ( txphinitdone_vec   [1]    ),
    .txphinit_in                    ( txphinit_vec       [1]    ),
    .phase_alignment_done_in        ( phase_alignment_done_out  ),
    .txdlysreset_in                 ( txdlysreset_vec    [1]    ),
    .txphalign_in                   ( txphalign_vec      [1]    ),
    .txdlyen_in                     ( txdlyen_vec        [1]    ),
    .txsyncdone_out                 ( )
);


//--------------------------------------------------------------------
// CH2
//--------------------------------------------------------------------
BUFG_GT         u_bufg_rx_clk_ch2
(
    .I          (rxoutclk_out[2]), //=> txoutclk_in,
    .CE         (ce_sync[2]), //=> '1',
    .CEMASK     (0), //=> '0',
    .CLR        (clr_sync[2]), //=> userclk_tx_reset,
    .CLRMASK    (0), //=> '0',
    .DIV        (3'b000), //=> bufg_div2,
    .O          (rxoutclk_bufg[2]) //=> txusrclk2);
);
BUFG_GT_SYNC    u_bufgsync_rx_clk_ch2 (
    .CESYNC     (ce_sync[2]),           // 1-bit output: Synchronized CE
    .CLRSYNC    (clr_sync[2]),          // 1-bit output: Synchronized CLR
    .CE         (1'b1),                 // 1-bit input: Asynchronous enable
    .CLK        (rxoutclk_out[2]),      // 1-bit input: Clock
    .CLR        (userclk_rx_reset[2])   // 1-bit input: Asynchronous clear
);

cpri_slave_0                       cpri_ch2 
(
    .reset                          ( reset),

    // I/Q interface
    .iq_tx_enable                   ( o_iq_tx_enable[2] ),
    .basic_frame_first_word         ( o_bffwd[2]        ),
    .iq_tx                          ( i_iq_tx[2]        ),
    .iq_rx                          ( o_iq_rx[2]        ),

    // GT Common Ports
    .qpll0clk_in                    ( common_qpll0clk),
    .qpll0refclk_in                 ( common_qpll0refclk),
    .qpll0lock_in                   ( common_qpll0lock),
    .qpll0_pd                       ( ),
    .qpll1clk_in                    ( common_qpll1clk),
    .qpll1refclk_in                 ( common_qpll1refclk),
    .qpll1lock_in                   ( common_qpll1lock),
    .qpll1_pd                       ( ),

    // Vendor Specific Data
    .vendor_tx_data                 ( 'd0),
    .vendor_tx_xs                   ( ),
    .vendor_tx_ns                   ( ),
    .vendor_rx_data                 ( ),
    .vendor_rx_xs                   ( ),
    .vendor_rx_ns                   ( ),
    .vs_negotiation_complete        ( 1'b1),

    // Synchronization
    .nodebfn_tx_strobe              ( i_nodebfn_tx_strobe[2]),
    .nodebfn_tx_nr                  ( i_nodebfn_tx_nr[2]    ),
    .nodebfn_rx_strobe              ( o_nodebfn_rx_strobe[2]),
    .nodebfn_rx_nr                  ( o_nodebfn_rx_nr[2]    ),

    // Ethernet interface
    .eth_txd                        ( i_eth_txd[2]      ),
    .eth_tx_er                      ( 1'b0 ),
    .eth_tx_en                      ( i_eth_tx_en[2]    ),
    .eth_col                        ( ),
    .eth_crs                        ( ),
    .eth_rxd                        ( o_eth_rxd[2]      ),
    .eth_rx_er                      ( ),
    .eth_rx_dv                      ( o_eth_rx_dv[2]    ),
    .eth_rx_avail                   ( o_eth_rx_avail[2] ),
    .eth_rx_ready                   ( i_eth_rx_ready[2] ),
    .rx_fifo_almost_full            ( ),
    .rx_fifo_full                   ( ),
    .eth_ref_clk                    ( eth_ref_clk       ),

    // HDLC interface
    .hdlc_rx_data                   ( ),
    .hdlc_tx_data                   ( 'd0 ),
    .hdlc_rx_data_valid             ( ),
    .hdlc_tx_enable                 ( ),

    // Status interface
    .stat_alarm                     ( o_stat_alarm[2]),
    .stat_code                      ( o_stat_code [2]),
    .stat_speed                     ( o_stat_speed[2]),
    .reset_acknowledge_in           ( 1'b0),
    .sdi_request_in                 ( 1'b0),
    .reset_request_out              ( ),
    .sdi_request_out                ( ),
    .local_los                      ( local_los [2]),
    .local_lof                      ( local_lof [2]),
    .local_rai                      ( local_rai [2]),
    .remote_los                     ( remote_los[2]),
    .remote_lof                     ( remote_lof[2]),
    .remote_rai                     ( remote_rai[2]),
    .fifo_transit_time              ( ),
    .coarse_timer_value             ( ),
    .barrel_shift_value             ( ),
    .tx_gb_latency_value            ( ),
    .rx_gb_latency_value            ( ),
    .stat_rx_delay_value            ( ),
    .hyperframe_number              ( hyperframe_nr[2]),

    // AXI management interface
    .s_axi_aclk                     ( s_axi_aclk        ),
    .s_axi_aresetn                  ( s_axi_aresetn     ),
    .s_axi_awaddr                   ( s_axi_awaddr [2]  ),
    .s_axi_awvalid                  ( s_axi_awvalid[2]  ),
    .s_axi_awready                  ( s_axi_awready[2]  ),
    .s_axi_wdata                    ( s_axi_wdata  [2]  ),
    .s_axi_wvalid                   ( s_axi_wvalid [2]  ),
    .s_axi_wready                   ( s_axi_wready [2]  ),
    .s_axi_bresp                    ( s_axi_bresp  [2]  ),
    .s_axi_bvalid                   ( s_axi_bvalid [2]  ),
    .s_axi_bready                   ( s_axi_bready [2]  ),
    .s_axi_araddr                   ( s_axi_araddr [2]  ),
    .s_axi_arvalid                  ( s_axi_arvalid[2]  ),
    .s_axi_arready                  ( s_axi_arready[2]  ),
    .s_axi_rdata                    ( s_axi_rdata  [2]  ),
    .s_axi_rresp                    ( s_axi_rresp  [2]  ),
    .s_axi_rvalid                   ( s_axi_rvalid [2]  ),
    .s_axi_rready                   ( s_axi_rready [2]  ),
    .l1_timer_expired               ( 1'b0              ),

    // SFP interface
    .txp                            ( o_txp[2]  ),
    .txn                            ( o_txn[2]  ),
    .rxp                            ( i_rxp[2]  ),
    .rxn                            ( i_rxn[2]  ),
    .lossoflight                    ( 1'b0      ),
    .txinhibit                      (           ),

    // Clocks
    //.core_is_master                 ( core_is_master),
    .refclk                         ( refclk),
    .gtwiz_reset_clk_freerun_in     ( gtwiz_reset_clk_freerun_in),
    .hires_clk                      ( hires_clk),
    .hires_clk_ok                   ( hires_clk_ok),
    .qpll_select                    ( qpll_select ),
    .recclk_in                      ( rxoutclk_bufg[2]),
    .recclk_ok                      ( recclk_ok_vec[2]),
    .clk_in                         ( clk_out),
    .clk_ok_in                      ( clk_ok_out),
    .rxrecclkout                    ( rxrecclkout_vec[2]),
    .txusrclk                       ( txusrclk_out),

    .gtreset_sm_done                ( gtreset_sm_done[2]),
    .userclk_tx_reset               ( ),
    .userclk_rx_reset               ( userclk_rx_reset[2]),
    .aux_clk_out                    ( ),
    .txoutclk                       ( ),
    .mmcm_rst                       ( ),
    .rxoutclk                       ( rxoutclk_out[2]),
    .txresetdone_out                ( txresetdone_out[2]),

    .txphaligndone_out              ( txphaligndone_vec  [2]    ),
    .txdlysresetdone_out            ( txdlysresetdone_vec[2]    ),
    .txphinitdone_out               ( txphinitdone_vec   [2]    ),
    .txphinit_in                    ( txphinit_vec       [2]    ),
    .phase_alignment_done_in        ( phase_alignment_done_out  ),
    .txdlysreset_in                 ( txdlysreset_vec    [2]    ),
    .txphalign_in                   ( txphalign_vec      [2]    ),
    .txdlyen_in                     ( txdlyen_vec        [2]    ),
    .txsyncdone_out                 ( )
);


//--------------------------------------------------------------------
// CH3
//--------------------------------------------------------------------
BUFG_GT         u_bufg_rx_clk_ch3
(
    .I          (rxoutclk_out[3]), //=> txoutclk_in,
    .CE         (ce_sync[3]), //=> '1',
    .CEMASK     (0), //=> '0',
    .CLR        (clr_sync[3]), //=> userclk_tx_reset,
    .CLRMASK    (0), //=> '0',
    .DIV        (3'b000), //=> bufg_div2,
    .O          (rxoutclk_bufg[3]) //=> txusrclk2);
);
BUFG_GT_SYNC    u_bufgsync_rx_clk_ch3 (
    .CESYNC     (ce_sync[3]),           // 1-bit output: Synchronized CE
    .CLRSYNC    (clr_sync[3]),          // 1-bit output: Synchronized CLR
    .CE         (1'b1),                 // 1-bit input: Asynchronous enable
    .CLK        (rxoutclk_out[3]),      // 1-bit input: Clock
    .CLR        (userclk_rx_reset[3])   // 1-bit input: Asynchronous clear
);

cpri_slave_0                       cpri_ch3 
(
    .reset                          ( reset),

    // I/Q interface
    .iq_tx_enable                   ( o_iq_tx_enable[3] ),
    .basic_frame_first_word         ( o_bffwd[3]        ),
    .iq_tx                          ( i_iq_tx[3]        ),
    .iq_rx                          ( o_iq_rx[3]        ),

    // GT Common Ports
    .qpll0clk_in                    ( common_qpll0clk),
    .qpll0refclk_in                 ( common_qpll0refclk),
    .qpll0lock_in                   ( common_qpll0lock),
    .qpll0_pd                       ( ),
    .qpll1clk_in                    ( common_qpll1clk),
    .qpll1refclk_in                 ( common_qpll1refclk),
    .qpll1lock_in                   ( common_qpll1lock),
    .qpll1_pd                       ( ),

    // Vendor Specific Data
    .vendor_tx_data                 ( 'd0),
    .vendor_tx_xs                   ( ),
    .vendor_tx_ns                   ( ),
    .vendor_rx_data                 ( ),
    .vendor_rx_xs                   ( ),
    .vendor_rx_ns                   ( ),
    .vs_negotiation_complete        ( 1'b1),

    // Synchronization
    .nodebfn_tx_strobe              ( i_nodebfn_tx_strobe[3]),
    .nodebfn_tx_nr                  ( i_nodebfn_tx_nr[3]    ),
    .nodebfn_rx_strobe              ( o_nodebfn_rx_strobe[3]),
    .nodebfn_rx_nr                  ( o_nodebfn_rx_nr[3]    ),

    // Ethernet interface
    .eth_txd                        ( i_eth_txd[3]      ),
    .eth_tx_er                      ( 1'b0 ),
    .eth_tx_en                      ( i_eth_tx_en[3]    ),
    .eth_col                        ( ),
    .eth_crs                        ( ),
    .eth_rxd                        ( o_eth_rxd[3]      ),
    .eth_rx_er                      ( ),
    .eth_rx_dv                      ( o_eth_rx_dv[3]    ),
    .eth_rx_avail                   ( o_eth_rx_avail[3] ),
    .eth_rx_ready                   ( i_eth_rx_ready[3] ),
    .rx_fifo_almost_full            ( ),
    .rx_fifo_full                   ( ),
    .eth_ref_clk                    ( eth_ref_clk       ),

    // HDLC interface
    .hdlc_rx_data                   ( ),
    .hdlc_tx_data                   ( 'd0 ),
    .hdlc_rx_data_valid             ( ),
    .hdlc_tx_enable                 ( ),

    // Status interface
    .stat_alarm                     ( o_stat_alarm[3]),
    .stat_code                      ( o_stat_code [3]),
    .stat_speed                     ( o_stat_speed[3]),
    .reset_acknowledge_in           ( 1'b0),
    .sdi_request_in                 ( 1'b0),
    .reset_request_out              ( ),
    .sdi_request_out                ( ),
    .local_los                      ( local_los [3]),
    .local_lof                      ( local_lof [3]),
    .local_rai                      ( local_rai [3]),
    .remote_los                     ( remote_los[3]),
    .remote_lof                     ( remote_lof[3]),
    .remote_rai                     ( remote_rai[3]),
    .fifo_transit_time              ( ),
    .coarse_timer_value             ( ),
    .barrel_shift_value             ( ),
    .tx_gb_latency_value            ( ),
    .rx_gb_latency_value            ( ),
    .stat_rx_delay_value            ( ),
    .hyperframe_number              ( hyperframe_nr[3]),

    // AXI management interface
    .s_axi_aclk                     ( s_axi_aclk        ),
    .s_axi_aresetn                  ( s_axi_aresetn     ),
    .s_axi_awaddr                   ( s_axi_awaddr [3]  ),
    .s_axi_awvalid                  ( s_axi_awvalid[3]  ),
    .s_axi_awready                  ( s_axi_awready[3]  ),
    .s_axi_wdata                    ( s_axi_wdata  [3]  ),
    .s_axi_wvalid                   ( s_axi_wvalid [3]  ),
    .s_axi_wready                   ( s_axi_wready [3]  ),
    .s_axi_bresp                    ( s_axi_bresp  [3]  ),
    .s_axi_bvalid                   ( s_axi_bvalid [3]  ),
    .s_axi_bready                   ( s_axi_bready [3]  ),
    .s_axi_araddr                   ( s_axi_araddr [3]  ),
    .s_axi_arvalid                  ( s_axi_arvalid[3]  ),
    .s_axi_arready                  ( s_axi_arready[3]  ),
    .s_axi_rdata                    ( s_axi_rdata  [3]  ),
    .s_axi_rresp                    ( s_axi_rresp  [3]  ),
    .s_axi_rvalid                   ( s_axi_rvalid [3]  ),
    .s_axi_rready                   ( s_axi_rready [3]  ),
    .l1_timer_expired               ( 1'b0              ),

    // SFP interface
    .txp                            ( o_txp[3]  ),
    .txn                            ( o_txn[3]  ),
    .rxp                            ( i_rxp[3]  ),
    .rxn                            ( i_rxn[3]  ),
    .lossoflight                    ( 1'b0      ),
    .txinhibit                      (           ),

    // Clocks
    //.core_is_master                 ( core_is_master),
    .refclk                         ( refclk),
    .gtwiz_reset_clk_freerun_in     ( gtwiz_reset_clk_freerun_in),
    .hires_clk                      ( hires_clk),
    .hires_clk_ok                   ( hires_clk_ok),
    .qpll_select                    ( qpll_select ),
    .recclk_in                      ( rxoutclk_bufg[3]),
    .recclk_ok                      ( recclk_ok_vec[3]),
    .clk_in                         ( clk_out),
    .clk_ok_in                      ( clk_ok_out),
    .rxrecclkout                    ( rxrecclkout_vec[3]),
    .txusrclk                       ( txusrclk_out),

    .gtreset_sm_done                ( gtreset_sm_done[3]),
    .userclk_tx_reset               ( ),
    .userclk_rx_reset               ( userclk_rx_reset[3]),
    .aux_clk_out                    ( ),
    .txoutclk                       ( ),
    .mmcm_rst                       ( ),
    .rxoutclk                       ( rxoutclk_out[3]),
    .txresetdone_out                ( txresetdone_out[3]),

    .txphaligndone_out              ( txphaligndone_vec  [3]    ),
    .txdlysresetdone_out            ( txdlysresetdone_vec[3]    ),
    .txphinitdone_out               ( txphinitdone_vec   [3]    ),
    .txphinit_in                    ( txphinit_vec       [3]    ),
    .phase_alignment_done_in        ( phase_alignment_done_out  ),
    .txdlysreset_in                 ( txdlysreset_vec    [3]    ),
    .txphalign_in                   ( txphalign_vec      [3]    ),
    .txdlyen_in                     ( txdlyen_vec        [3]    ),
    .txsyncdone_out                 ( )
);


//-----------------------------------------------------------------------------
// RECCLK OUT
//-----------------------------------------------------------------------------
localparam REC_DIV = 11;

logic [7:0] rec_counter = 8'd0;
logic       recclk_ext  = 1'b0;
logic       recclk_pin ;

always_ff @ (posedge recclk_out) begin
    if(o_qpll_lock)
        if(rec_counter==REC_DIV)
            rec_counter <= 8'd0;    
        else
            rec_counter <= rec_counter + 8'd1;
    else
        rec_counter <= 8'd0;
end

always_ff @ (posedge recclk_out) begin
    if(rec_counter==REC_DIV)
        recclk_ext <= ~recclk_ext;
end

FDCE        recclkout_gen
(
    .D      (recclk_ext ),
    .CE     (1'b1       ),
    .C      (recclk_out ),
    .CLR    (1'b0       ),
    .Q      (recclk_pin )
);

assign o_cpri_clk = clk_out;
assign o_rec_clk  = recclk_pin;
assign o_qpll_lock = qpll_select ? common_qpll1lock : common_qpll0lock;
assign o_local_los = local_los;
assign o_local_lof = local_lof;


//-----------------------------------------------------------------------------
// DEBUG
//-----------------------------------------------------------------------------
logic recclk_ila;

always_ff @ (posedge o_cpri_clk) begin
    recclk_ila <= recclk_ext;
end


ila_cpri_iq     ila_cpri_iq (
    .clk        (o_cpri_clk),  // input wire clk
    
    .probe0     (i_nodebfn_tx_strobe),      // input wire [0:0]  probe4
    .probe1     (i_nodebfn_tx_nr    ),      // input wire [11:0]  probe5
    .probe2     (o_nodebfn_rx_strobe),      // input wire [0:0]  probe4
    .probe3     (o_nodebfn_rx_nr    ),      // input wire [11:0]  probe5
    .probe4     ({i_iq_tx[3],i_iq_tx[2],i_iq_tx[1],i_iq_tx[0]}),    // input wire [31:0]  probe6
    .probe5     ({o_iq_rx[3],o_iq_rx[2],o_iq_rx[1],o_iq_rx[0]}),    // input wire [31:0]  probe7
    .probe6     (recclk_ila) // input wire [31:0]  probe7
);

endmodule