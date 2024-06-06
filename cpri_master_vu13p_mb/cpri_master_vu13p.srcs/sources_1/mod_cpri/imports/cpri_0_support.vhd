-----------------------------------------------------------------------
-- Title      : Support Level Module
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : cpri_0_support.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: 
-----------------------------------------------------------------------
-- (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of AMD and is protected under U.S. and international copyright
-- and other intellectual property laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- AMD, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) AMD shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or AMD had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- AMD products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of AMD products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

library cpri_v8_11_17;
use cpri_v8_11_17.all;

entity cpri_0_support is
  port (
    -- Additional Debug Ports
    -- DRP Access
    gt_drpdaddr              : in  std_logic_vector(9 downto 0);
    gt_drpdi                 : in  std_logic_vector(15 downto 0);
    gt_drpen                 : in  std_logic;
    gt_drpwe                 : in  std_logic;
    gt_drpdo                 : out std_logic_vector(15 downto 0);
    gt_drprdy                : out std_logic;
    -- TX Reset and Initialization
    gt_txpmareset            : in  std_logic;
    gt_txpcsreset            : in  std_logic;
    gt_txresetdone           : out std_logic;
    -- RX Reset and Initialization
    gt_rxpmareset            : in  std_logic;
    gt_rxpcsreset            : in  std_logic;
    gt_rxpmaresetdone        : out std_logic;
    gt_rxresetdone           : out std_logic;
    -- Clocking
    gt_txphaligndone         : out std_logic;
    gt_txphinitdone          : out std_logic;
    gt_txdlysresetdone       : out std_logic;
    gt_rxphaligndone         : out std_logic;
    gt_rxdlysresetdone       : out std_logic;
    gt_rxsyncdone            : out std_logic;
    gt_cplllock              : out std_logic;
    gt_qplllock              : out std_logic;
    -- Signal Integrity and Functionality
    gt_rxrate                : in  std_logic_vector(2 downto 0);
    gt_eyescantrigger        : in  std_logic;
    gt_eyescanreset          : in  std_logic;
    gt_eyescandataerror      : out std_logic;
    gt_rxpolarity            : in  std_logic;
    gt_txpolarity            : in  std_logic;
    gt_rxdfelpmreset         : in  std_logic;
    gt_rxlpmen               : in  std_logic;
    gt_txprecursor           : in  std_logic_vector(4 downto 0);
    gt_txpostcursor          : in  std_logic_vector(4 downto 0);
    gt_txdiffctrl            : in  std_logic_vector(4 downto 0);
    gt_txprbsforceerr        : in  std_logic;
    gt_txprbssel             : in  std_logic_vector(3 downto 0);
    gt_rxprbssel             : in  std_logic_vector(3 downto 0);
    gt_rxprbserr             : out std_logic;
    gt_rxprbscntreset        : in  std_logic;
    gt_rxcdrhold             : in  std_logic;
    gt_dmonitorout           : out std_logic_vector(15 downto 0);
    gt_rxheader              : out std_logic_vector(1 downto 0);
    gt_rxheadervalid         : out std_logic;

    gt_rxdisperr             : out std_logic_vector(7 downto 0);
    gt_rxnotintable          : out std_logic_vector(7 downto 0);
    gt_rxcommadet            : out std_logic;
    gt_pcsrsvdin             : in  std_logic_vector(15 downto 0);
    ----------------- END OF DEBUG PORTS -----------------

    -- Transceiver monitor interface
    txdata                   : out std_logic_vector(63 downto 0);
    txcharisk                : out std_logic_vector(7 downto 0);
    txheader                 : out std_logic_vector(1 downto 0);
    txsequence               : out std_logic_vector(6 downto 0);
    rxdata                   : out std_logic_vector(63 downto 0);
    rxchariscomma            : out std_logic_vector(7 downto 0);
    rxcharisk                : out std_logic_vector(7 downto 0);
    rxdisperr                : out std_logic_vector(7 downto 0);
    rxnotintable             : out std_logic_vector(7 downto 0);
    rxdatavalid              : out std_logic;
    rxheader                 : out std_logic_vector(1 downto 0);
    rxheadervalid            : out std_logic;
    rxgearboxslip            : out std_logic;
    reset                    : in  std_logic; -- Asynchronous reset

    -- I/Q interface
    iq_tx_enable             : out std_logic;
    basic_frame_first_word   : out std_logic;
    iq_tx                    : in  std_logic_vector(63 downto 0);
    iq_rx                    : out std_logic_vector(63 downto 0);

    -- GT Common Ports
    qpll0clk_out             : out std_logic;
    qpll0refclk_out          : out std_logic;
    qpll1clk_out             : out std_logic;
    qpll1refclk_out          : out std_logic;
    qpll0lock_out            : out std_logic;
    qpll1lock_out            : out std_logic;

    -- Vendor Specific Data
    vendor_tx_data           : in  std_logic_vector(127 downto 0);
    vendor_tx_xs             : out std_logic_vector(1 downto 0);
    vendor_tx_ns             : out std_logic_vector(5 downto 0);
    vendor_rx_data           : out std_logic_vector(127 downto 0);
    vendor_rx_xs             : out std_logic_vector(1 downto 0);
    vendor_rx_ns             : out std_logic_vector(5 downto 0);
    vs_negotiation_complete  : in  std_logic;

    -- Synchronization
    nodebfn_tx_strobe        : in  std_logic;
    nodebfn_tx_nr            : in  std_logic_vector(11 downto 0);
    nodebfn_rx_strobe        : out std_logic;
    nodebfn_rx_nr            : out std_logic_vector(11 downto 0);

    -- Ethernet interface
    eth_txd                  : in  std_logic_vector(3 downto 0);
    eth_tx_er                : in  std_logic;
    eth_tx_en                : in  std_logic;
    eth_col                  : out std_logic;
    eth_crs                  : out std_logic;
    eth_rxd                  : out std_logic_vector(3 downto 0);
    eth_rx_er                : out std_logic;
    eth_rx_dv                : out std_logic;
    eth_rx_avail             : out std_logic;
    eth_rx_ready             : in  std_logic;
    rx_fifo_almost_full      : out std_logic;
    rx_fifo_full             : out std_logic;
    eth_ref_clk              : in  std_logic;

    -- HDLC interface
    hdlc_rx_data             : out std_logic;
    hdlc_tx_data             : in  std_logic;
    hdlc_rx_data_valid       : out std_logic;
    hdlc_tx_enable           : out std_logic;

    -- Status interface
    stat_alarm               : out std_logic;
    stat_code                : out std_logic_vector(3 downto 0);
    stat_speed               : out std_logic_vector(14 downto 0);
    reset_request_in         : in  std_logic;
    sdi_request_in           : in  std_logic;
    reset_acknowledge_out    : out std_logic;
    sdi_request_out          : out std_logic;
    local_los                : out std_logic;
    local_lof                : out std_logic;
    local_rai                : out std_logic;
    remote_los               : out std_logic;
    remote_lof               : out std_logic;
    remote_rai               : out std_logic;
    fifo_transit_time        : out std_logic_vector(13 downto 0);
    coarse_timer_value       : out std_logic_vector(17 downto 0);
    barrel_shift_value       : out std_logic_vector(6 downto 0);
    tx_gb_latency_value      : out std_logic_vector(15 downto 0);
    rx_gb_latency_value      : out std_logic_vector(15 downto 0);
    stat_rx_delay_value      : out std_logic_vector(6 downto 0);
    hyperframe_number        : out std_logic_vector(7 downto 0);

    -- AXI-Lite Interface
    -----------------
    s_axi_aclk               : in  std_logic;
    s_axi_aresetn            : in  std_logic;
    s_axi_awaddr             : in  std_logic_vector(11 downto 0);
    s_axi_awvalid            : in  std_logic;
    s_axi_awready            : out std_logic;
    s_axi_wdata              : in  std_logic_vector(31 downto 0);
    s_axi_wvalid             : in  std_logic;
    s_axi_wready             : out std_logic;
    s_axi_bresp              : out std_logic_vector(1 downto 0);
    s_axi_bvalid             : out std_logic;
    s_axi_bready             : in  std_logic;
    s_axi_araddr             : in  std_logic_vector(11 downto 0);
    s_axi_arvalid            : in  std_logic;
    s_axi_arready            : out std_logic;
    s_axi_rdata              : out std_logic_vector(31 downto 0);
    s_axi_rresp              : out std_logic_vector(1 downto 0);
    s_axi_rvalid             : out std_logic;
    s_axi_rready             : in  std_logic;
    l1_timer_expired         : in  std_logic;

    -- Transceiver signals
    txp                      : out std_logic;
    txn                      : out std_logic;
    rxp                      : in  std_logic;
    rxn                      : in  std_logic;
    lossoflight              : in  std_logic;
    txinhibit                : out std_logic;

    -- Clocks
    refclk                   : in  std_logic;
    gtwiz_reset_clk_freerun_in : in std_logic;
    hires_clk                : in  std_logic;
    hires_clk_ok             : in  std_logic;
    qpll_select              : in  std_logic;
    core_is_master           : in  std_logic;
    clk_out                  : out std_logic;
    clk_ok_out               : out std_logic;
    recclk                   : out std_logic;
    recclk_ok                : out std_logic;
    rxrecclkout              : out std_logic;
    txusrclk_out             : out std_logic;

    txphaligndone_in         : in  std_logic_vector(2 downto 0);
    txdlysresetdone_in       : in  std_logic_vector(2 downto 0);
    txphinitdone_in          : in  std_logic_vector(2 downto 0);
    txphinit_out             : out std_logic_vector(2 downto 0);
    phase_alignment_done_out : out std_logic;
    txdlysreset_out          : out std_logic_vector(2 downto 0);
    txphalign_out            : out std_logic_vector(2 downto 0);
    txdlyen_out              : out std_logic_vector(2 downto 0));
end cpri_0_support;


architecture rtl of cpri_0_support is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  ---------------------------------------------------------------------
  -- Component Declarations
  ---------------------------------------------------------------------
  component cpri_0_clocking is
  port (
    reset                 : in  std_logic;
    stable_clk            : in  std_logic;
    txoutclk_in           : in  std_logic;
    rxoutclk_in           : in  std_logic;
    mmcm_reset            : in  std_logic;
    txresetdone_in        : in  std_logic;
    phase_alignment_done  : in  std_logic;
    enable                : in  std_logic;
    speed_select          : in  std_logic_vector(14 downto 0);
    clk_out               : out std_logic;
    txusrclk              : out std_logic;
    clk_ok                : out std_logic;
    recclk_out            : out std_logic;
    userclk_tx_reset      : in  std_logic;
    userclk_rx_reset      : in  std_logic;
    reset_phalignment_out : out std_logic);
  end component;

  component cpri_0_resets is
  port (
    aux_clk     : in  std_logic;
    reset       : in  std_logic;
    qpll_reset  : out std_logic);
  end component;

  component cpri_0_tx_alignment
  generic (
    MASTER_LANE_ID         : integer range 0 to 31:= 0); -- Number of the lane which is considered the master in manual phase-alignment
  port (
    stable_clk             : in  std_logic;              --Stable Clock, either a stable clock from the PCB
    reset_phalignment      : in  std_logic;              --or reference-clock present at startup.
    txphaligndone_vec      : in  std_logic_vector(3 downto 0);
    txdlysresetdone_vec    : in  std_logic_vector(3 downto 0);
    txphinitdone_vec       : in  std_logic_vector(3 downto 0);
    txphinit_vec           : out std_logic_vector(3 downto 0);
    phase_alignment_done   : out std_logic := '0';       -- Manual phase-alignment performed sucessfully
    txdlysreset_vec        : out std_logic_vector(3 downto 0);
    txphalign_vec          : out std_logic_vector(3 downto 0);
    txdlyen_vec            : out std_logic_vector(3 downto 0));
  end component;

  component cpri_0_gt_gtye4_common_wrapper is
  generic (
    SIM_RESET_SPEEDUP    : string  := "false"; -- Set to "true" to speed up sim reset
    SIM_VERSION          : string  := "4.0");
  port (
    GTREFCLK0_IN          : in  std_logic;
    QPLL0RESET_IN         : in  std_logic;
    QPLL0LOCKDETCLK_IN    : in  std_logic;
    QPLL0PD_IN            : in  std_logic;
    QPLL0LOCK_OUT         : out std_logic;
    QPLL0OUTCLK_OUT       : out std_logic;
    QPLL0OUTREFCLK_OUT    : out std_logic;
    QPLL1RESET_IN         : in  std_logic;
    QPLL1LOCKDETCLK_IN    : in  std_logic;
    QPLL1PD_IN            : in  std_logic;
    QPLL1LOCK_OUT         : out std_logic;
    QPLL1OUTCLK_OUT       : out std_logic;
    QPLL1OUTREFCLK_OUT    : out std_logic;
    speed_select          : in  std_logic_vector(14 downto 0)
    );
  end component;

  component cpri_0
  port (
    -- Additional Debug Ports
    -- DRP Access
    gt_drpdaddr             : in  std_logic_vector(9 downto 0);
    gt_drpdi                : in  std_logic_vector(15 downto 0);
    gt_drpen                : in  std_logic;
    gt_drpwe                : in  std_logic;
    gt_drpdo                : out std_logic_vector(15 downto 0);
    gt_drprdy               : out std_logic;
    -- TX Reset and Initialization
    gt_txpmareset           : in  std_logic;
    gt_txpcsreset           : in  std_logic;
    gt_txresetdone          : out std_logic;
    -- RX Reset and Initialization
    gt_rxpmareset           : in  std_logic;
    gt_rxpcsreset           : in  std_logic;
    gt_rxpmaresetdone       : out std_logic;
    gt_rxresetdone          : out std_logic;
    -- Clocking
    gt_txphaligndone        : out std_logic;
    gt_txphinitdone         : out std_logic;
    gt_txdlysresetdone      : out std_logic;
    gt_rxphaligndone        : out std_logic;
    gt_rxdlysresetdone      : out std_logic;
    gt_rxsyncdone           : out std_logic;
    gt_cplllock             : out std_logic;
    -- Signal Integrity and Functionality
    gt_rxrate               : in  std_logic_vector(2 downto 0);
    gt_eyescantrigger       : in  std_logic;
    gt_eyescanreset         : in  std_logic;
    gt_eyescandataerror     : out std_logic;
    gt_rxpolarity           : in  std_logic;
    gt_txpolarity           : in  std_logic;
    gt_rxdfelpmreset        : in  std_logic;
    gt_rxlpmen              : in  std_logic;
    gt_txprecursor          : in  std_logic_vector(4 downto 0);
    gt_txpostcursor         : in  std_logic_vector(4 downto 0);
    gt_txdiffctrl           : in  std_logic_vector(4 downto 0);
    gt_txprbsforceerr       : in  std_logic;
    gt_txprbssel            : in  std_logic_vector(3 downto 0);
    gt_rxprbssel            : in  std_logic_vector(3 downto 0);
    gt_rxprbserr            : out std_logic;
    gt_rxprbscntreset       : in  std_logic;
    gt_rxcdrhold            : in  std_logic;
    gt_dmonitorout          : out std_logic_vector(15 downto 0);
    gt_rxheader             : out std_logic_vector(1 downto 0);
    gt_rxheadervalid        : out std_logic;

    gt_rxdisperr            : out std_logic_vector(7 downto 0);
    gt_rxnotintable         : out std_logic_vector(7 downto 0);
    gt_rxcommadet           : out std_logic;
    gt_pcsrsvdin            : in  std_logic_vector(15 downto 0);
    ----------------- END OF DEBUG PORTS -----------------

    -- Transceiver monitor interface
    txdata                  : out std_logic_vector(63 downto 0);
    txcharisk               : out std_logic_vector(7 downto 0);
    txheader                : out std_logic_vector(1 downto 0);
    txsequence              : out std_logic_vector(6 downto 0);
    rxdata                  : out std_logic_vector(63 downto 0);
    rxchariscomma           : out std_logic_vector(7 downto 0);
    rxcharisk               : out std_logic_vector(7 downto 0);
    rxdisperr               : out std_logic_vector(7 downto 0);
    rxnotintable            : out std_logic_vector(7 downto 0);
    rxdatavalid             : out std_logic;
    rxheader                : out std_logic_vector(1 downto 0);
    rxheadervalid           : out std_logic;
    rxgearboxslip           : out std_logic;
    reset                   : in  std_logic;

    -- I/Q interface
    iq_tx_enable            : out std_logic;
    basic_frame_first_word  : out std_logic;
    iq_tx                   : in  std_logic_vector(63 downto 0);
    iq_rx                   : out std_logic_vector(63 downto 0);

    -- GT Common Ports
    qpll0clk_in             : in  std_logic;
    qpll0refclk_in          : in  std_logic;
    qpll1clk_in             : in  std_logic;
    qpll1refclk_in          : in  std_logic;
    qpll0lock_in            : in  std_logic;
    qpll0_pd                : out std_logic;
    qpll1lock_in            : in  std_logic;
    qpll1_pd                : out std_logic;

    -- Vendor Specific Data
    vendor_tx_data          : in  std_logic_vector(127 downto 0);
    vendor_tx_xs            : out std_logic_vector(1 downto 0);
    vendor_tx_ns            : out std_logic_vector(5 downto 0);
    vendor_rx_data          : out std_logic_vector(127 downto 0);
    vendor_rx_xs            : out std_logic_vector(1 downto 0);
    vendor_rx_ns            : out std_logic_vector(5 downto 0);
    vs_negotiation_complete : in  std_logic;

    -- Synchronization
    nodebfn_tx_strobe       : in  std_logic;
    nodebfn_tx_nr           : in  std_logic_vector(11 downto 0);
    nodebfn_rx_strobe       : out std_logic;
    nodebfn_rx_nr           : out std_logic_vector(11 downto 0);

    -- Ethernet interface
    eth_txd                 : in  std_logic_vector(3 downto 0);
    eth_tx_er               : in  std_logic;
    eth_tx_en               : in  std_logic;
    eth_col                 : out std_logic;
    eth_crs                 : out std_logic;
    eth_rxd                 : out std_logic_vector(3 downto 0);
    eth_rx_er               : out std_logic;
    eth_rx_dv               : out std_logic;
    eth_rx_avail            : out std_logic;
    eth_rx_ready            : in  std_logic;
    rx_fifo_almost_full     : out std_logic;
    rx_fifo_full            : out std_logic;
    eth_ref_clk             : in  std_logic;

    -- HDLC interface
    hdlc_rx_data            : out std_logic;
    hdlc_tx_data            : in  std_logic;
    hdlc_rx_data_valid      : out std_logic;
    hdlc_tx_enable          : out std_logic;

    -- Status interface
    stat_alarm              : out std_logic;
    stat_code               : out std_logic_vector(3 downto 0);
    stat_speed              : out std_logic_vector(14 downto 0);
    reset_request_in        : in  std_logic;
    sdi_request_in          : in  std_logic;
    reset_acknowledge_out   : out std_logic;
    sdi_request_out         : out std_logic;
    local_los               : out std_logic;
    local_lof               : out std_logic;
    local_rai               : out std_logic;
    remote_los              : out std_logic;
    remote_lof              : out std_logic;
    remote_rai              : out std_logic;
    fifo_transit_time       : out std_logic_vector(13 downto 0);
    coarse_timer_value      : out std_logic_vector(17 downto 0);
    barrel_shift_value      : out std_logic_vector(6 downto 0);
    tx_gb_latency_value     : out std_logic_vector(15 downto 0);
    rx_gb_latency_value     : out std_logic_vector(15 downto 0);
    stat_rx_delay_value     : out std_logic_vector(6 downto 0);
    hyperframe_number       : out std_logic_vector(7 downto 0);

    -- AXI-Lite Interface
    -----------------
    s_axi_aclk              : in  std_logic;
    s_axi_aresetn           : in  std_logic;
    s_axi_awaddr            : in  std_logic_vector(11 downto 0);
    s_axi_awvalid           : in  std_logic;
    s_axi_awready           : out std_logic;
    s_axi_wdata             : in  std_logic_vector(31 downto 0);
    s_axi_wvalid            : in  std_logic;
    s_axi_wready            : out std_logic;
    s_axi_bresp             : out std_logic_vector(1 downto 0);
    s_axi_bvalid            : out std_logic;
    s_axi_bready            : in  std_logic;
    s_axi_araddr            : in  std_logic_vector(11 downto 0);
    s_axi_arvalid           : in  std_logic;
    s_axi_arready           : out std_logic;
    s_axi_rdata             : out std_logic_vector(31 downto 0);
    s_axi_rresp             : out std_logic_vector(1 downto 0);
    s_axi_rvalid            : out std_logic;
    s_axi_rready            : in  std_logic;
    l1_timer_expired        : in  std_logic;

    -- Transceiver signals
    txp                     : out std_logic;
    txn                     : out std_logic;
    rxp                     : in  std_logic;
    rxn                     : in  std_logic;
    lossoflight             : in  std_logic;
    txinhibit               : out std_logic;

    -- Clocks
    refclk                  : in  std_logic;
    clk_in                  : in  std_logic;
    clk_ok_in               : in  std_logic;
    txusrclk                : in  std_logic;
    recclk_in               : in  std_logic;
    gtreset_sm_done         : out std_logic;
    userclk_tx_reset        : out std_logic;
    userclk_rx_reset        : out std_logic;
    aux_clk_out             : out std_logic;
    gtwiz_reset_clk_freerun_in : in std_logic;
    hires_clk               : in  std_logic;
    hires_clk_ok            : in  std_logic;
    qpll_select             : in  std_logic;
    core_is_master          : in  std_logic;
    recclk_ok               : out std_logic;
    txoutclk                : out std_logic;
    mmcm_rst                : out std_logic;  --Signal to reset mmcm in clocking module
    rxoutclk                : out std_logic;
    rxrecclkout             : out std_logic;
    txresetdone_out         : out std_logic;

    --Ports for phase_alignment module
    txdlyen_in              : in  std_logic;
    txphinit_in             : in  std_logic;
    phase_alignment_done_in : in  std_logic;
    txdlysreset_in          : in  std_logic;
    txphalign_in            : in  std_logic;
    txphaligndone_out       : out std_logic;
    txdlysresetdone_out     : out std_logic;
    txsyncdone_out          : out std_logic;
    txphinitdone_out        : out std_logic);
  end component;

  component cpri_0_reset_synchronizer is
    port (
      reset_in  : in  std_logic;
      clk       : in  std_logic;
      reset_out : out std_logic);
  end component;

  ---------------------------------------------------------------------
  -- Signal Declaration
  ---------------------------------------------------------------------
  signal txresetdone_i                     : std_logic;
  signal clk_ok_i                          : std_logic;
  signal txoutclk_i                        : std_logic;
  signal common_qpll0clk                   : std_logic;
  signal common_qpll0refclk                : std_logic;
  signal common_qpll0lock                  : std_logic;
  signal common_qpll0_pd                   : std_logic;
  signal common_qpll1clk                   : std_logic;
  signal common_qpll1refclk                : std_logic;
  signal common_qpll1lock                  : std_logic;
  signal common_qpll1_pd                   : std_logic;
  signal pll_reset                         : std_logic;
  signal mmcm_rst                          : std_logic;
  signal stat_speed_i                      : std_logic_vector(14 downto 0);
  signal core_clk_i                        : std_logic;
  signal recclk_i                          : std_logic;
  signal rxoutclk                          : std_logic;
  signal rec_clk_out                       : std_logic;
  signal rec_clk_i                         : std_logic;
  signal gtreset_sm_done                   : std_logic;
  signal reset_s                           : std_logic;
  signal aux_clk                           : std_logic;
  signal txusrclk                          : std_logic;
  signal txdlyen_vec                       : std_logic_vector(3 downto 0);
  signal reset_phalignment                 : std_logic;
  signal txphaligndone                     : std_logic;
  signal txphinitdone_out                  : std_logic;
  signal phase_alignment_done_i            : std_logic;
  signal phase_alignment_done_int          : std_logic;
  signal gtwiz_buffbypass_tx_reset_in      : std_logic := '0';
  signal gtwiz_buffbypass_tx_reset_in_mask : std_logic := '0';
  signal txresetdone_r                     : std_logic;
  signal txdlysresetdone                   : std_logic;
  signal txphaligndone_vec                 : std_logic_vector(3 downto 0);
  signal txdlysresetdone_vec               : std_logic_vector(3 downto 0);
  signal txphinit_vec                      : std_logic_vector(3 downto 0);
  signal txdlysreset_vec                   : std_logic_vector(3 downto 0);
  signal txphalign_vec                     : std_logic_vector(3 downto 0);
  signal txphinitdone_vec                  : std_logic_vector(3 downto 0);
  signal userclk_tx_reset                  : std_logic;
  signal userclk_rx_reset                  : std_logic;

begin

  reset_sync_i : cpri_0_reset_synchronizer
  port map (
    reset_in  => reset,
    clk       => aux_clk,
    reset_out => reset_s);

  cpri_i : cpri_0
  port map (
    -- Additional Debug Ports
    -- DRP Access
    gt_drpdaddr                => gt_drpdaddr,
    gt_drpdi                   => gt_drpdi,
    gt_drpen                   => gt_drpen,
    gt_drpwe                   => gt_drpwe,
    gt_drpdo                   => gt_drpdo,
    gt_drprdy                  => gt_drprdy,
    -- TX Reset and Initialization
    gt_txpmareset              => gt_txpmareset,
    gt_txpcsreset              => gt_txpcsreset,
    gt_txresetdone             => gt_txresetdone,
    -- RX Reset and Initialization
    gt_rxpmareset              => gt_rxpmareset,
    gt_rxpcsreset              => gt_rxpcsreset,
    gt_rxpmaresetdone          => gt_rxpmaresetdone,
    gt_rxresetdone             => gt_rxresetdone,
    -- Clocking
    gt_txphaligndone           => gt_txphaligndone,
    gt_txphinitdone            => gt_txphinitdone,
    gt_txdlysresetdone         => gt_txdlysresetdone,
    gt_rxphaligndone           => gt_rxphaligndone,
    gt_rxdlysresetdone         => gt_rxdlysresetdone,
    gt_rxsyncdone              => gt_rxsyncdone,
    gt_cplllock                => gt_cplllock,
    -- Signal Integrity and Functionality
    gt_rxrate                  => gt_rxrate,
    gt_eyescantrigger          => gt_eyescantrigger,
    gt_eyescanreset            => gt_eyescanreset,
    gt_eyescandataerror        => gt_eyescandataerror,
    gt_rxpolarity              => gt_rxpolarity,
    gt_txpolarity              => gt_txpolarity,
    gt_rxdfelpmreset           => gt_rxdfelpmreset,
    gt_rxlpmen                 => gt_rxlpmen,
    gt_txprecursor             => gt_txprecursor,
    gt_txpostcursor            => gt_txpostcursor,
    gt_txdiffctrl              => gt_txdiffctrl,
    gt_txprbsforceerr          => gt_txprbsforceerr,
    gt_txprbssel               => gt_txprbssel,
    gt_rxprbssel               => gt_rxprbssel,
    gt_rxprbserr               => gt_rxprbserr,
    gt_rxprbscntreset          => gt_rxprbscntreset,
    gt_rxcdrhold               => gt_rxcdrhold,
    gt_dmonitorout             => gt_dmonitorout,
    gt_rxdisperr               => gt_rxdisperr,
    gt_rxnotintable            => gt_rxnotintable,
    gt_rxheader                => gt_rxheader,
    gt_rxheadervalid           => gt_rxheadervalid,
    gt_rxcommadet              => gt_rxcommadet,
    gt_pcsrsvdin               => gt_pcsrsvdin,

    txdata                     => txdata,
    txcharisk                  => txcharisk,
    txheader                   => txheader,
    txsequence                 => txsequence,
    rxdata                     => rxdata,
    rxchariscomma              => rxchariscomma,
    rxcharisk                  => rxcharisk,
    rxdisperr                  => rxdisperr,
    rxnotintable               => rxnotintable,
    rxdatavalid                => rxdatavalid,
    rxheader                   => rxheader,
    rxheadervalid              => rxheadervalid,
    rxgearboxslip              => rxgearboxslip,
    reset                      => reset_s,

    -- I/Q interface
    iq_tx_enable               => iq_tx_enable,
    basic_frame_first_word     => basic_frame_first_word,
    iq_tx                      => iq_tx,
    iq_rx                      => iq_rx,

    -- GT Common Ports
    qpll0clk_in                => common_qpll0clk,
    qpll0refclk_in             => common_qpll0refclk,
    qpll0lock_in               => common_qpll0lock,
    qpll0_pd                   => common_qpll0_pd,
    qpll1clk_in                => common_qpll1clk,
    qpll1refclk_in             => common_qpll1refclk,
    qpll1lock_in               => common_qpll1lock,
    qpll1_pd                   => common_qpll1_pd,

    -- Vendor Specific Data
    vendor_tx_data             => vendor_tx_data,
    vendor_tx_xs               => vendor_tx_xs,
    vendor_tx_ns               => vendor_tx_ns,
    vendor_rx_data             => vendor_rx_data,
    vendor_rx_xs               => vendor_rx_xs,
    vendor_rx_ns               => vendor_rx_ns,
    vs_negotiation_complete    => vs_negotiation_complete,

    -- Synchronization
    nodebfn_tx_strobe          => nodebfn_tx_strobe,
    nodebfn_tx_nr              => nodebfn_tx_nr,
    nodebfn_rx_strobe          => nodebfn_rx_strobe,
    nodebfn_rx_nr              => nodebfn_rx_nr,

    -- Ethernet interface
    eth_txd                    => eth_txd,
    eth_tx_er                  => eth_tx_er,
    eth_tx_en                  => eth_tx_en,
    eth_col                    => eth_col,
    eth_crs                    => eth_crs,
    eth_rxd                    => eth_rxd,
    eth_rx_er                  => eth_rx_er,
    eth_rx_dv                  => eth_rx_dv,
    eth_rx_avail               => eth_rx_avail,
    eth_rx_ready               => eth_rx_ready,
    rx_fifo_almost_full        => rx_fifo_almost_full,
    rx_fifo_full               => rx_fifo_full,
    eth_ref_clk                => eth_ref_clk,

    -- HDLC interface
    hdlc_rx_data               => hdlc_rx_data,
    hdlc_tx_data               => hdlc_tx_data,
    hdlc_rx_data_valid         => hdlc_rx_data_valid,
    hdlc_tx_enable             => hdlc_tx_enable,

    -- Status interface
    stat_alarm                 => stat_alarm,
    stat_code                  => stat_code,
    stat_speed                 => stat_speed_i,
    reset_request_in           => reset_request_in,
    sdi_request_in             => sdi_request_in,
    reset_acknowledge_out      => reset_acknowledge_out,
    sdi_request_out            => sdi_request_out,
    local_los                  => local_los,
    local_lof                  => local_lof,
    local_rai                  => local_rai,
    remote_los                 => remote_los,
    remote_lof                 => remote_lof,
    remote_rai                 => remote_rai,
    fifo_transit_time          => fifo_transit_time,
    coarse_timer_value         => coarse_timer_value,
    barrel_shift_value         => barrel_shift_value,
    tx_gb_latency_value        => tx_gb_latency_value,
    rx_gb_latency_value        => rx_gb_latency_value,
    stat_rx_delay_value        => stat_rx_delay_value,
    hyperframe_number          => hyperframe_number,

    -- AXI-Lite Interface
    -----------------
    s_axi_aclk                 => s_axi_aclk,
    s_axi_aresetn              => s_axi_aresetn,
    s_axi_awaddr               => s_axi_awaddr,
    s_axi_awvalid              => s_axi_awvalid,
    s_axi_awready              => s_axi_awready,
    s_axi_wdata                => s_axi_wdata,
    s_axi_wvalid               => s_axi_wvalid,
    s_axi_wready               => s_axi_wready,
    s_axi_bresp                => s_axi_bresp,
    s_axi_bvalid               => s_axi_bvalid,
    s_axi_bready               => s_axi_bready,
    s_axi_araddr               => s_axi_araddr,
    s_axi_arvalid              => s_axi_arvalid,
    s_axi_arready              => s_axi_arready,
    s_axi_rdata                => s_axi_rdata,
    s_axi_rresp                => s_axi_rresp,
    s_axi_rvalid               => s_axi_rvalid,
    s_axi_rready               => s_axi_rready,
    l1_timer_expired           => l1_timer_expired,

    -- Transceiver signals
    txp                        => txp,
    txn                        => txn,
    rxp                        => rxp,
    rxn                        => rxn,
    lossoflight                => lossoflight,
    txinhibit                  => txinhibit,

    -- Clocks
    refclk                     => refclk,
    clk_in                     => core_clk_i,
    clk_ok_in                  => clk_ok_i,
    txusrclk                   => txusrclk,
    recclk_in                  => rec_clk_i,
    gtreset_sm_done            => gtreset_sm_done,
    userclk_tx_reset           => userclk_tx_reset,
    userclk_rx_reset           => userclk_rx_reset,
    aux_clk_out                => aux_clk,
    gtwiz_reset_clk_freerun_in => gtwiz_reset_clk_freerun_in,
    hires_clk                  => hires_clk,
    hires_clk_ok               => hires_clk_ok,
    qpll_select                => qpll_select,
    core_is_master             => core_is_master,
    recclk_ok                  => recclk_ok,
    txoutclk                   => txoutclk_i,
    mmcm_rst                   => mmcm_rst,
    rxoutclk                   => rxoutclk,
    rxrecclkout                => rxrecclkout,
    txresetdone_out            => txresetdone_i,

    txdlyen_in                 => txdlyen_vec(0),
    txphinit_in                => txphinit_vec(0),
    phase_alignment_done_in    => phase_alignment_done_i,
    txdlysreset_in             => txdlysreset_vec(0),
    txphalign_in               => txphalign_vec(0),
    txphaligndone_out          => txphaligndone,
    txdlysresetdone_out        => txdlysresetdone,
    txsyncdone_out             => open,
    txphinitdone_out           => txphinitdone_out);

  ---------------------------------------------------------------------
  -- Instantiate Shared Clocking Module
  -- Clocks from this module can be used to share with other CL modules
  ---------------------------------------------------------------------
  cpri_shared_clocks_i : cpri_0_clocking
  port map (
    reset                 => reset_s,
    stable_clk            => aux_clk,
    txoutclk_in           => txoutclk_i,
    rxoutclk_in           => rxoutclk,
    mmcm_reset            => mmcm_rst,
    txresetdone_in        => txresetdone_i,
    phase_alignment_done  => phase_alignment_done_i,
    enable                => gtreset_sm_done,
    speed_select          => stat_speed_i,
    clk_out               => core_clk_i,
    txusrclk              => txusrclk,
    clk_ok                => clk_ok_i,
    recclk_out            => rec_clk_i,
    userclk_tx_reset      => userclk_tx_reset,
    userclk_rx_reset      => userclk_rx_reset,
    reset_phalignment_out => reset_phalignment);

  cpri_shared_resets_i : cpri_0_resets
  port map (
    aux_clk     => aux_clk,
    reset       => reset_s,
    qpll_reset  => pll_reset);

  ---------------------------------------------------------------------
  -- Instantiate Common Phase Alignment Module
  ---------------------------------------------------------------------
  --Set bit 0 with outputs from CPRI core
  txdlysresetdone_vec(0) <= txdlysresetdone;
  txphaligndone_vec(0)   <= txphaligndone;
  txphinitdone_vec(0)    <= txphinitdone_out;

  txdlysresetdone_vec (3 downto 1) <= txdlysresetdone_in;
  txphaligndone_vec (3 downto 1)   <= txphaligndone_in;
  txphinitdone_vec (3 downto 1)    <= txphinitdone_in;

  cpri_shared_alignment_i : cpri_0_tx_alignment
  generic map (
    MASTER_LANE_ID => 0)
  port map (
    stable_clk             => aux_clk,
    reset_phalignment      => reset_phalignment,
    txphaligndone_vec      => txphaligndone_vec,
    txphinitdone_vec       => txphinitdone_vec,
    txdlysresetdone_vec    => txdlysresetdone_vec,
    txphinit_vec           => txphinit_vec,
    phase_alignment_done   => phase_alignment_done_int,
    txdlysreset_vec        => txdlysreset_vec,
    txphalign_vec          => txphalign_vec,
    txdlyen_vec            => txdlyen_vec);

  -- Turn off phase alignment when using the asynchronous gearbox, 24.3G, 12.1G, 10.1G or 8.1G.
  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if stat_speed_i(14 downto 7) = "00000000" then
        phase_alignment_done_i <= phase_alignment_done_int;
      else
        phase_alignment_done_i <= '1';
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------
  -- Instantiate Common GT Module
  ---------------------------------------------------------------------
  cpri_gt_common_i : cpri_0_gt_gtye4_common_wrapper
  generic map (
    SIM_VERSION => "4.0")
  port map (
    GTREFCLK0_IN            => refclk,
    QPLL0RESET_IN           => pll_reset,
    QPLL0LOCKDETCLK_IN      => aux_clk,
    QPLL1RESET_IN           => pll_reset,
    QPLL1LOCKDETCLK_IN      => aux_clk,
    QPLL0PD_IN              => common_qpll0_pd,
    QPLL1PD_IN              => common_qpll1_pd,
    QPLL0LOCK_OUT           => common_qpll0lock,
    QPLL0OUTCLK_OUT         => common_qpll0clk,
    QPLL0OUTREFCLK_OUT      => common_qpll0refclk,
    QPLL1LOCK_OUT           => common_qpll1lock,
    QPLL1OUTCLK_OUT         => common_qpll1clk,
    QPLL1OUTREFCLK_OUT      => common_qpll1refclk,
    speed_select            => stat_speed_i
    );

  txusrclk_out       <= txusrclk;

  ---------------------------------------------------------------------
  -- Assign Outputs
  ---------------------------------------------------------------------
  qpll0clk_out             <= common_qpll0clk;
  qpll0refclk_out          <= common_qpll0refclk;
  qpll1clk_out             <= common_qpll1clk;
  qpll1refclk_out          <= common_qpll1refclk;
  qpll0lock_out            <= common_qpll0lock;
  qpll1lock_out            <= common_qpll1lock;
  gt_qplllock              <= common_qpll0lock when qpll_select = '0' else
                              common_qpll1lock;
  clk_out                  <= core_clk_i;
  clk_ok_out               <= clk_ok_i;
  recclk                   <= rec_clk_i;
  phase_alignment_done_out <= phase_alignment_done_i;
  txphinit_out             <= txphinit_vec(3 downto 1);
  txdlysreset_out          <= txdlysreset_vec(3 downto 1);
  txphalign_out            <= txphalign_vec(3 downto 1);
  txdlyen_out              <= txdlyen_vec(3 downto 1);
  stat_speed               <= stat_speed_i;

end rtl;
