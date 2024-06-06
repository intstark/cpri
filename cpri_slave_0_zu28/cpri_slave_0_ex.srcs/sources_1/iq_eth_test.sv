//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/28 15:54:23
// Design Name: 
// Module Name: iq_gen_chk
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




module iq_eth_test # (LANE = 8)
(
    input                       i_clk                   ,
    input   [14:0]              i_stat_speed            ,
    input   [LANE-1:0][3:0]     i_stat_code             ,
    input   [LANE-1:0]          i_tx_en                 ,
    output  [LANE-1:0][63:0]    o_iq_tx                 ,
    output  [LANE-1:0]          o_nodebfn_tx_strobe     ,
    output  [LANE-1:0][11:0]    o_nodebfn_tx_nr         ,

    input   [LANE-1:0]          i_bffw                  ,
    input   [LANE-1:0][63:0]    i_iq_rx                 ,
    input   [LANE-1:0]          i_nodebfn_rx_strobe     ,
    input   [LANE-1:0][11:0]    i_nodebfn_rx_nr         ,
    output  [LANE-1:0][31:0]    o_rx_frame_count        ,
    output  [LANE-1:0][31:0]    o_rx_error_count        ,
    output  [LANE-1:0][11:0]    o_nodebfn_rx_nr_strobe  ,
    output  [LANE-1:0]          o_rx_word_err           ,

    input                       i_eth_clk               ,
    input   [LANE-1:0]          i_eth_rxen              ,
    input   [LANE-1:0][3:0]     i_eth_rxd               ,
    output  [LANE-1:0]          o_eth_txen              ,
    output  [LANE-1:0][3:0]     o_eth_txd               ,
    input   [LANE-1:0]          i_eth_rx_avail          ,
    output  [LANE-1:0]          o_eth_rx_ready         
    
);

//-------------------------------------------------------------------------------
// WIRE & REGISTER
//-------------------------------------------------------------------------------
localparam SYNC_NR_ID = 12'h29B;

//-------------------------------------------------------------------------------
// WIRE & REGISTER
//-------------------------------------------------------------------------------

genvar i;

logic   [LANE-1:0]  nodebfn_valid;

logic   [LANE-1:0]  nodebfn_valid_eth;

//-------------------------------------------------------------------------------
// BODY
//-------------------------------------------------------------------------------
generate for (i=0 ; i<LANE ; i++ ) 
begin : iq_test_patten
    
    //------------------------------------------------------
    // RX_CHK_EN
    //------------------------------------------------------
    always_ff @ (posedge i_clk)begin
    if (i_stat_code[i] != 4'b1111)
        nodebfn_valid[i] <= 1'b0;
    else if((o_nodebfn_tx_nr[i] == SYNC_NR_ID) && (i_nodebfn_rx_nr[i] == SYNC_NR_ID))
        nodebfn_valid[i] <= 1'b1;
    end


    //------------------------------------------------------
    // IQ_TX_GEN
    //------------------------------------------------------
    iq_tx_gen                   u_iq_tx_gen
    (
        .clk                    (i_clk      ),
        .iq_tx_enable           (i_tx_en[i] ),
        .speed                  (i_stat_speed),
        .iq_tx                  (o_iq_tx[i]),
        .nodebfn_tx_strobe      (o_nodebfn_tx_strobe[i]),
        .nodebfn_tx_nr          (o_nodebfn_tx_nr[i])
    );


    //------------------------------------------------------
    // IQ_RX_CHK
    //------------------------------------------------------
    iq_rx_chk                   u_iq_rx_chk
    (
        .clk                    (i_clk),
        .enable                 (nodebfn_valid[i]),
        .speed                  (i_stat_speed),
        .basic_frame_first_word (i_bffw[i]),
        .iq_rx                  (i_iq_rx[i]),
        .nodebfn_rx_strobe      (i_nodebfn_rx_strobe[i]),
        .nodebfn_rx_nr          (i_nodebfn_rx_nr[i]),
        .frame_count            (o_rx_frame_count      [i]),
        .error_count            (o_rx_error_count      [i]),
        .nodebfn_rx_nr_store    (o_nodebfn_rx_nr_strobe[i]),
        .word_err               (o_rx_word_err         [i])
    );

    //------------------------------------------------------
    // MII TEST
    //------------------------------------------------------
    gnrl_dff_synchronizer   gnrl_nodebfn_valid(
        .i_clk              (i_eth_clk),
        .i_bit              (nodebfn_valid[i]),
        .o_bit              (nodebfn_valid_eth[i])
    );

    mii_stim                u_eth_mii_test
    (
       .eth_clk              (i_eth_clk),
       .tx_eth_enable        (o_eth_txen[i]),
       .tx_eth_data          (o_eth_txd [i]),
       .tx_eth_err           (),
       .tx_eth_overflow      (1'b0),
       .tx_eth_half          (1'b0),
       .rx_eth_data_valid    (i_eth_rxen[i]),
       .rx_eth_data          (i_eth_rxd [i]),
       .rx_eth_err           (),
       .tx_start             (nodebfn_valid_eth[i]),
       .rx_start             (nodebfn_valid_eth[i]),
       .tx_count             (),
       .rx_count             (),
       .err_count            (),
       .eth_rx_error         (),
       .eth_rx_avail         (i_eth_rx_avail[i]),
       .eth_rx_ready         (o_eth_rx_ready[i]),
       .rx_fifo_almost_full  (),
       .rx_fifo_full         ()
    );


end
endgenerate






endmodule




