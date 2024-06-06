-----------------------------------------------------------------------
-- Title      : Example top level for CPRI design
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : cpri_0_example_design.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: This example design for CPRI adds data generators
--              and monitors to the IQ, vendor specific, HDLC and
--              Ethernet ports. An IBUFDS is added to the reference
--              clock input to allow the design to place and route.
--              A DCM/MMCM is instantiated to generate the Ethernet
--              and hires clocks if needed.
--              In addition the recovered clock output is output
--              at a constant frequency across all line rates.
--              A simple example of a mu-law encoder and decoder
--              are also provided.
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
use ieee.numeric_std.all;

entity cpri_0_example_design is
  port (
    reset                      : in  std_logic;
    stat_alarm                 : out std_logic;
    stat_code                  : out std_logic_vector(3 downto 0);
    stat_speed                 : out std_logic_vector(14 downto 0);
    mu_law_encoding            : in  std_logic;
    s_axi_aclk                 : in  std_logic;
    s_axi_aresetn              : in  std_logic;
    s_axi_awaddr               : in  std_logic_vector(11 downto 0);
    s_axi_awvalid              : in  std_logic;
    s_axi_awready              : out std_logic;
    s_axi_wdata                : in  std_logic_vector(31 downto 0);
    s_axi_wvalid               : in  std_logic;
    s_axi_wready               : out std_logic;
    s_axi_bresp                : out std_logic_vector(1 downto 0);
    s_axi_bvalid               : out std_logic;
    s_axi_bready               : in  std_logic;
    s_axi_araddr               : in  std_logic_vector(11 downto 0);
    s_axi_arvalid              : in  std_logic;
    s_axi_arready              : out std_logic;
    s_axi_rdata                : out std_logic_vector(31 downto 0);
    s_axi_rresp                : out std_logic_vector(1 downto 0);
    s_axi_rvalid               : out std_logic;
    s_axi_rready               : in  std_logic;
    txp                        : out std_logic;
    txn                        : out std_logic;
    rxp                        : in  std_logic;
    rxn                        : in  std_logic;
    refclk_p                   : in  std_logic;
    refclk_n                   : in  std_logic;
    core_is_master             : in  std_logic;
    gtwiz_reset_clk_freerun_in : in  std_logic;
    hires_clk                  : in  std_logic;
    hires_clk_ok               : in  std_logic;
    eth_ref_clk                : in  std_logic;
    ext_clk_ok                 : in  std_logic;
    recclk_out                 : out std_logic;
    enable_test_start          : in  std_logic);
end cpri_0_example_design;

library unisim;
use unisim.vcomponents.all;

Library xpm;
use xpm.vcomponents.all;

architecture rtl of cpri_0_example_design is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  component cpri_0_support
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
      reset                    : in  std_logic;
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
      core_is_master           : in  std_logic;
      gtwiz_reset_clk_freerun_in : in std_logic;
      hires_clk                : in  std_logic;
      hires_clk_ok             : in  std_logic;
      qpll_select              : in  std_logic;
      recclk_ok                : out std_logic;
      clk_ok_out               : out std_logic;
      recclk                   : out std_logic;
      clk_out                  : out std_logic;
      rxrecclkout              : out std_logic;
      txusrclk_out             : out std_logic;
      -- Tx Phase Alignment
      txphaligndone_in         : in  std_logic_vector(2 downto 0);
      txdlysresetdone_in       : in  std_logic_vector(2 downto 0);
      txphinitdone_in          : in  std_logic_vector(2 downto 0);
      txphinit_out             : out std_logic_vector(2 downto 0);
      phase_alignment_done_out : out std_logic;
      txdlysreset_out          : out std_logic_vector(2 downto 0);
      txphalign_out            : out std_logic_vector(2 downto 0);
      txdlyen_out              : out std_logic_vector(2 downto 0));
  end component;

  component cpri_example_sync
    port (
      core_clk                 : in  std_logic;
      core_reset               : in  std_logic;
      aux_clk                  : in  std_logic;
      aux_reset                : in  std_logic;
      eth_clk                  : in  std_logic;
      eth_reset                : in  std_logic;
      rec_clk                  : in  std_logic;
      -- Inputs
      iq_frame_count           : in  std_logic_vector(31 downto 0);
      iq_error_count           : in  std_logic_vector(31 downto 0);
      nodebfn_rx_nr_store      : in  std_logic_vector(11 downto 0);
      hdlc_bit_count           : in  std_logic_vector(31 downto 0);
      hdlc_error_count         : in  std_logic_vector(31 downto 0);
      vs_word_count            : in  std_logic_vector(31 downto 0);
      vs_error_count           : in  std_logic_vector(31 downto 0);
      eth_tx_count             : in  std_logic_vector(31 downto 0);
      eth_rx_count             : in  std_logic_vector(31 downto 0);
      eth_error_count          : in  std_logic_vector(31 downto 0);
      stat_speed               : in  std_logic_vector(14 downto 0);
      -- Synchronized outputs
      iq_frame_count_sync      : out std_logic_vector(31 downto 0);
      iq_error_count_sync      : out std_logic_vector(31 downto 0);
      nodebfn_rx_nr_store_sync : out std_logic_vector(11 downto 0);
      hdlc_bit_count_sync      : out std_logic_vector(31 downto 0);
      hdlc_error_count_sync    : out std_logic_vector(31 downto 0);
      vs_word_count_sync       : out std_logic_vector(31 downto 0);
      vs_error_count_sync      : out std_logic_vector(31 downto 0);
      eth_tx_count_sync        : out std_logic_vector(31 downto 0);
      eth_rx_count_sync        : out std_logic_vector(31 downto 0);
      eth_error_count_sync     : out std_logic_vector(31 downto 0);
      stat_speed_core_clk      : out std_logic_vector(14 downto 0);
      stat_speed_rec_clk       : out std_logic_vector(14 downto 0));
  end component;

  component iq_tx_gen
    port (
      clk                    : in  std_logic;
      iq_tx_enable           : in  std_logic;
      speed                  : in  std_logic_vector(14 downto 0);
      iq_tx                  : out std_logic_vector(63 downto 0);
      nodebfn_tx_strobe      : out std_logic;
      nodebfn_tx_nr          : out std_logic_vector(11 downto 0));
  end component;

  component iq_rx_chk
    port (
      clk                    : in  std_logic;
      enable                 : in  std_logic;
      speed                  : in  std_logic_vector(14 downto 0);
      basic_frame_first_word : in  std_logic;
      iq_rx                  : in  std_logic_vector(63 downto 0);
      nodebfn_rx_strobe      : in  std_logic;
      nodebfn_rx_nr          : in  std_logic_vector(11 downto 0);
      frame_count            : out std_logic_vector(31 downto 0);
      error_count            : out std_logic_vector(31 downto 0);
      nodebfn_rx_nr_store    : out std_logic_vector(11 downto 0);
      word_err               : out std_logic);
  end component;

  component hdlc_stim
    port (
      reset                  : in  std_logic;
      clk_ok                 : in  std_logic;
      clk                    : in  std_logic;
      hdlc_rx_data           : in  std_logic;
      hdlc_tx_data           : out std_logic;
      hdlc_rx_data_valid     : in  std_logic;
      hdlc_tx_enable         : in  std_logic;
      start_hdlc             : in  std_logic;
      bit_count              : out std_logic_vector(31 downto 0);
      error_count            : out std_logic_vector(31 downto 0);
      hdlc_error             : out std_logic);
  end component;

  component mii_stim
    port (
      eth_clk                : in  std_logic;
      tx_eth_enable          : out std_logic;
      tx_eth_data            : out std_logic_vector(3 downto 0);
      tx_eth_err             : out std_logic;
      tx_eth_overflow        : in  std_logic;
      tx_eth_half            : in  std_logic;
      rx_eth_data_valid      : in  std_logic;
      rx_eth_data            : in  std_logic_vector(3 downto 0);
      rx_eth_err             : in  std_logic;
      tx_start               : in  std_logic;
      rx_start               : in  std_logic;
      tx_count               : out std_logic_vector(31 downto 0);
      rx_count               : out std_logic_vector(31 downto 0);
      err_count              : out std_logic_vector(31 downto 0);
      eth_rx_error           : out std_logic;
      eth_rx_avail           : in  std_logic;
      eth_rx_ready           : out std_logic;
      rx_fifo_almost_full    : in  std_logic;
      rx_fifo_full           : in  std_logic);
  end component;

  component vendor_stim
    port (
      clk                    : in  std_logic;
      reset                  : in  std_logic;
      iq_tx_enable           : in  std_logic;
      bffw                   : in  std_logic;
      vendor_tx_data         : out std_logic_vector(127 downto 0);
      vendor_tx_xs           : in  std_logic_vector(1 downto 0);
      vendor_tx_ns           : in  std_logic_vector(5 downto 0);
      vendor_rx_data         : in  std_logic_vector(127 downto 0);
      vendor_rx_xs           : in  std_logic_vector(1 downto 0);
      vendor_rx_ns           : in  std_logic_vector(5 downto 0);
      start_vendor           : in  std_logic;
      word_count             : out std_logic_vector(31 downto 0);
      error_count            : out std_logic_vector(31 downto 0);
      vendor_error           : out std_logic;
      speed                  : in  std_logic_vector(14 downto 0));
  end component;

  component mu_law_encode
    port (
      ap_clk                 : in  std_logic;
      ap_rst                 : in  std_logic;
      ap_ready               : out std_logic;
      pcm_val                : in  std_logic_vector(13 downto 0);
      ap_return              : out std_logic_vector(7 downto 0));
  end component;

  component mu_law_decode
    port (
      ap_clk                 : in  std_logic;
      ap_rst                 : in  std_logic;
      ap_start               : in  std_logic;
      ap_done                : out std_logic;
      ap_ready               : out std_logic;
      u_val                  : in  std_logic_vector(7 downto 0);
      ap_return              : out std_logic_vector(13 downto 0);
      speed                  : in  std_logic_vector(14 downto 0);
      basic_frame_first_word : in  std_logic);
  end component;

  signal refclk                : std_logic;
  signal recclk                : std_logic;
  signal hires_clk_i           : std_logic;
  signal hires_clk_ok_qual     : std_logic;
  signal clk_i                 : std_logic;
  signal aux_clk_i             : std_logic;
  signal gtwiz_reset_clk_freerun_in_i : std_logic;
  signal eth_ref_clk_i         : std_logic;
  signal stat_speed_i          : std_logic_vector(14 downto 0);
  signal stat_speed_i_clk      : std_logic_vector(14 downto 0);
  signal stat_speed_i_rec      : std_logic_vector(14 downto 0);
  signal count                 : unsigned (4 downto 0) := "00000";
  signal clk_ok_i              : std_logic;
  signal recclkout_i           : std_logic := '0';
  signal rxlpmen_in            : std_logic;

  -- IQ Data generation and checking
  signal iq_tx_enable          : std_logic;
  signal iq_tx                 : std_logic_vector(63 downto 0);
  signal iq_tx_i               : std_logic_vector(63 downto 0);
  signal iq_tx_encoded         : std_logic_vector(63 downto 0);
  signal basic_frame_first_word : std_logic;
  signal iq_rx                 : std_logic_vector(63 downto 0);
  signal iq_rx_decoded         : std_logic_vector(13 downto 0);
  signal nodebfn_tx_strobe     : std_logic;
  signal nodebfn_tx_nr         : std_logic_vector(11 downto 0);
  signal hyperframe_nr         : std_logic_vector(7 downto 0);
  signal nodebfn_rx_strobe     : std_logic;
  signal nodebfn_rx_nr         : std_logic_vector(11 downto 0);
  signal nodebfn_rx_nr_store   : std_logic_vector(11 downto 0);
  signal frame_count           : std_logic_vector(31 downto 0);
  signal error_count           : std_logic_vector(31 downto 0);
  signal stat_code_i           : std_logic_vector(3 downto 0);
  signal operate_state         : std_logic;
  signal operate_state_clk     : std_logic;

  -- HDLC Data generation and checking
  signal hdlc_rx_data          : std_logic;
  signal hdlc_tx_data          : std_logic;
  signal hdlc_rx_data_valid    : std_logic;
  signal hdlc_tx_enable        : std_logic;
  signal hdlc_bit_count        : std_logic_vector(31 downto 0);
  signal hdlc_error_count      : std_logic_vector(31 downto 0);

  -- Ethernet data generation and checking
  signal eth_txd               : std_logic_vector(3 downto 0);
  signal eth_tx_er             : std_logic;
  signal eth_tx_en             : std_logic;
  signal eth_col               : std_logic;
  signal eth_crs               : std_logic;
  signal eth_rxd               : std_logic_vector(3 downto 0);
  signal eth_rx_er             : std_logic;
  signal eth_rx_dv             : std_logic;
  signal eth_tx_count          : std_logic_vector(31 downto 0);
  signal eth_rx_count          : std_logic_vector(31 downto 0);
  signal eth_error_count       : std_logic_vector(31 downto 0);
  signal eth_rx_avail          : std_logic;
  signal eth_rx_ready          : std_logic;
  signal rx_fifo_almost_full   : std_logic;
  signal rx_fifo_full          : std_logic;

  -- Vendor specific data generation and checking
  signal vendor_tx_data        : std_logic_vector(127 downto 0);
  signal vendor_tx_xs          : std_logic_vector(1 downto 0);
  signal vendor_tx_ns          : std_logic_vector(5 downto 0);
  signal vendor_rx_data        : std_logic_vector(127 downto 0);
  signal vendor_rx_xs          : std_logic_vector(1 downto 0);
  signal vendor_rx_ns          : std_logic_vector(5 downto 0);
  signal vs_word_count         : std_logic_vector(31 downto 0);
  signal vs_error_count        : std_logic_vector(31 downto 0);

  -- AXI Lite mux signals
  signal s_axi_araddr_ed       : std_logic_vector(11 downto 0);
  signal s_axi_arready_ed      : std_logic;
  signal s_axi_rdata_ed        : std_logic_vector(31 downto 0);
  signal s_axi_rvalid_ed       : std_logic;
  signal s_axi_rresp_ed        : std_logic_vector(1 downto 0);
  signal s_axi_arready_i       : std_logic;
  signal s_axi_rdata_i         : std_logic_vector(31 downto 0);
  signal s_axi_rvalid_i        : std_logic;
  signal s_axi_rresp_i         : std_logic_vector(1 downto 0);
  signal s_axi_arvalid_i       : std_logic;
  signal s_axi_arvalid_r       : std_logic;
  signal s_axi_rready_i        : std_logic;
  signal s_axi_rready_r        : std_logic;

  signal test_start_clk        : std_logic := '0';
  signal nodebfn_valid         : std_logic := '0';
  signal test_start_eth        : std_logic;

  signal txphalign_vec         : std_logic_vector(2 downto 0);
  signal txdlysreset_vec       : std_logic_vector(2 downto 0);
  signal txphinit_vec          : std_logic_vector(2 downto 0);

  -- Synchronization
  signal reset_i                 : std_logic;
  signal eth_reset               : std_logic;
  signal iq_frame_count_sync     : std_logic_vector(31 downto 0);
  signal iq_error_count_sync     : std_logic_vector(31 downto 0);
  signal nodebfn_rx_nr_store_sync: std_logic_vector(11 downto 0);
  signal hdlc_bit_count_sync     : std_logic_vector(31 downto 0);
  signal hdlc_error_count_sync   : std_logic_vector(31 downto 0);
  signal vs_word_count_sync      : std_logic_vector(31 downto 0);
  signal vs_error_count_sync     : std_logic_vector(31 downto 0);
  signal eth_tx_count_sync       : std_logic_vector(31 downto 0);
  signal eth_rx_count_sync       : std_logic_vector(31 downto 0);
  signal eth_error_count_sync    : std_logic_vector(31 downto 0);

begin

  process(aux_clk_i)
  begin
    if rising_edge(aux_clk_i) then
      if core_is_master = '0' then
        hires_clk_ok_qual <= hires_clk_ok and ext_clk_ok;
      else
        hires_clk_ok_qual <= hires_clk_ok;
      end if;
    end if;
  end process;

  cpri_block_i: cpri_0_support
    port map (
      -- Additional Debug Ports
      -- DRP Access
      gt_drpdaddr              => "0000000000",
      gt_drpdi                 => x"0000",
      gt_drpen                 => '0',
      gt_drpwe                 => '0',
      gt_drpdo                 => open,
      gt_drprdy                => open,
      -- TX Reset and Initialization
      gt_txpmareset            => '0',
      gt_txpcsreset            => '0',
      gt_txresetdone           => open,
      -- RX Reset and Initialization
      gt_rxpmareset            => '0',
      gt_rxpcsreset            => '0',
      gt_rxpmaresetdone        => open,
      gt_rxresetdone           => open,
      -- Clocking
      gt_txphaligndone         => open,
      gt_txphinitdone          => open,
      gt_txdlysresetdone       => open,
      gt_rxphaligndone         => open,
      gt_rxdlysresetdone       => open,
      gt_rxsyncdone            => open,
      gt_cplllock              => open,
      gt_qplllock              => open,
      -- Signal Integrity and Functionality
      gt_rxrate                => "000",
      gt_eyescantrigger        => '0',
      gt_eyescanreset          => '0',
      gt_eyescandataerror      => open,
      gt_rxpolarity            => '0',
      gt_txpolarity            => '0',
      gt_rxdfelpmreset         => '0',
      gt_rxlpmen               => rxlpmen_in,
      gt_txprecursor           => "00000",
      gt_txpostcursor          => "00000",
      gt_txdiffctrl            => "01100",
      gt_txprbsforceerr        => '0',
      gt_txprbssel             => "0000",
      gt_rxprbssel             => "0000",
      gt_rxprbserr             => open,
      gt_rxprbscntreset        => '0',
      gt_rxcdrhold             => '0',
      gt_dmonitorout           => open,
      gt_rxheader              => open,
      gt_rxheadervalid         => open,
      gt_rxdisperr             => open,
      gt_rxnotintable          => open,
      gt_rxcommadet            => open,
      gt_pcsrsvdin             => x"0000",

      -- Transceiver monitor interface
      txdata                  => open,
      txcharisk               => open,
      txheader                => open,
      txsequence              => open,
      rxdata                  => open,
      rxchariscomma           => open,
      rxcharisk               => open,
      rxdisperr               => open,
      rxnotintable            => open,
      rxdatavalid             => open,
      rxheader                => open,
      rxheadervalid           => open,
      rxgearboxslip           => open,
      reset                   => reset,
      -- I/Q interface
      iq_tx_enable            => iq_tx_enable,
      basic_frame_first_word  => basic_frame_first_word,
      iq_tx                   => iq_tx,
      iq_rx                   => iq_rx,
      -- GT Common Ports
      qpll0clk_out            => open,
      qpll0refclk_out         => open,
      qpll1clk_out            => open,
      qpll1refclk_out         => open,
      qpll0lock_out           => open,
      qpll1lock_out           => open,
      -- Vendor interface
      vendor_tx_data          => vendor_tx_data,
      vendor_tx_xs            => vendor_tx_xs,
      vendor_tx_ns            => vendor_tx_ns,
      vendor_rx_data          => vendor_rx_data,
      vendor_rx_xs            => vendor_rx_xs,
      vendor_rx_ns            => vendor_rx_ns,
      vs_negotiation_complete => '1',
      -- Synchronization
      nodebfn_tx_strobe       => nodebfn_tx_strobe,
      nodebfn_tx_nr           => nodebfn_tx_nr,
      nodebfn_rx_strobe       => nodebfn_rx_strobe,
      nodebfn_rx_nr           => nodebfn_rx_nr,
      -- Ethernet interface
      eth_txd                 => eth_txd,
      eth_tx_er               => eth_tx_er,
      eth_tx_en               => eth_tx_en,
      eth_col                 => eth_col,
      eth_crs                 => eth_crs,
      eth_rxd                 => eth_rxd,
      eth_rx_er               => eth_rx_er,
      eth_rx_dv               => eth_rx_dv,
      eth_rx_avail            => eth_rx_avail,
      eth_rx_ready            => eth_rx_ready,
      rx_fifo_almost_full     => rx_fifo_almost_full,
      rx_fifo_full            => rx_fifo_full,
      eth_ref_clk             => eth_ref_clk_i,
      -- HDLC interface
      hdlc_rx_data            => hdlc_rx_data,
      hdlc_tx_data            => hdlc_tx_data,
      hdlc_rx_data_valid      => hdlc_rx_data_valid,
      hdlc_tx_enable          => hdlc_tx_enable,
      -- Status interface
      stat_alarm              => stat_alarm,
      stat_code               => stat_code_i,
      stat_speed              => stat_speed_i,
      reset_request_in        => '0',
      sdi_request_in          => '0',
      reset_acknowledge_out   => open,
      sdi_request_out         => open,
      local_los               => open,
      local_lof               => open,
      local_rai               => open,
      remote_los              => open,
      remote_lof              => open,
      remote_rai              => open,
      fifo_transit_time       => open,
      coarse_timer_value      => open,
      barrel_shift_value      => open,
      tx_gb_latency_value     => open,
      rx_gb_latency_value     => open,
      stat_rx_delay_value     => open,
      hyperframe_number       => hyperframe_nr,
      -- AXI management interface
      s_axi_aclk              => aux_clk_i,
      s_axi_aresetn           => s_axi_aresetn,
      s_axi_awaddr            => s_axi_awaddr,
      s_axi_awvalid           => s_axi_awvalid,
      s_axi_awready           => s_axi_awready,
      s_axi_wdata             => s_axi_wdata,
      s_axi_wvalid            => s_axi_wvalid,
      s_axi_wready            => s_axi_wready,
      s_axi_bresp             => s_axi_bresp,
      s_axi_bvalid            => s_axi_bvalid,
      s_axi_bready            => s_axi_bready,
      s_axi_araddr            => s_axi_araddr_ed,
      s_axi_arvalid           => s_axi_arvalid_i,
      s_axi_arready           => s_axi_arready_i,
      s_axi_rdata             => s_axi_rdata_i,
      s_axi_rresp             => s_axi_rresp_i,
      s_axi_rvalid            => s_axi_rvalid_i,
      s_axi_rready            => s_axi_rready_i,
      l1_timer_expired        => '0',
      -- SFP interface
      txp                     => txp,
      txn                     => txn,
      rxp                     => rxp,
      rxn                     => rxn,
      lossoflight             => '0',
      txinhibit               => open,
      -- Clocks
      core_is_master          => core_is_master,
      refclk                  => refclk,
      gtwiz_reset_clk_freerun_in => gtwiz_reset_clk_freerun_in_i,
      hires_clk               => hires_clk_i,
      hires_clk_ok            => hires_clk_ok_qual,
      qpll_select             => '1',
      recclk_ok               => open,
      recclk                  => recclk,
      clk_out                 => clk_i,
      clk_ok_out              => clk_ok_i,
      rxrecclkout             => open,
      txusrclk_out            => open,
      -- Tx Phase alignment
      txphaligndone_in        => txphalign_vec,
      txdlysresetdone_in      => txdlysreset_vec,
      txphinitdone_in         => txphinit_vec,
      txphinit_out            => txphinit_vec,
      phase_alignment_done_out => open,
      txdlysreset_out         => txdlysreset_vec,
      txphalign_out           => txphalign_vec,
      txdlyen_out             => open);

  cpri_example_sync_i : cpri_example_sync
    port map (
      core_clk                 => clk_i,
      core_reset               => reset_i,
      aux_clk                  => aux_clk_i,
      aux_reset                => s_axi_aresetn,
      eth_clk                  => eth_ref_clk_i,
      eth_reset                => eth_reset,
      rec_clk                  => recclk,
      -- Inputs
      iq_frame_count           => frame_count,
      iq_error_count           => error_count,
      nodebfn_rx_nr_store      => nodebfn_rx_nr_store,
      hdlc_bit_count           => hdlc_bit_count,
      hdlc_error_count         => hdlc_error_count,
      vs_word_count            => vs_word_count,
      vs_error_count           => vs_error_count,
      eth_tx_count             => eth_tx_count,
      eth_rx_count             => eth_rx_count,
      eth_error_count          => eth_error_count,
      stat_speed               => stat_speed_i,
      -- Synchronized outputs
      iq_frame_count_sync      => iq_frame_count_sync,
      iq_error_count_sync      => iq_error_count_sync,
      nodebfn_rx_nr_store_sync => nodebfn_rx_nr_store_sync,
      hdlc_bit_count_sync      => hdlc_bit_count_sync,
      hdlc_error_count_sync    => hdlc_error_count_sync,
      vs_word_count_sync       => vs_word_count_sync,
      vs_error_count_sync      => vs_error_count_sync,
      eth_tx_count_sync        => eth_tx_count_sync,
      eth_rx_count_sync        => eth_rx_count_sync,
      eth_error_count_sync     => eth_error_count_sync,
      stat_speed_core_clk      => stat_speed_i_clk,
      stat_speed_rec_clk       => stat_speed_i_rec);

  -- IQ Data generator
  iq_tx_gen_i : iq_tx_gen
    port map (
      clk                    => clk_i,
      iq_tx_enable           => iq_tx_enable,
      speed                  => stat_speed_i_clk,
      iq_tx                  => iq_tx_i,
      nodebfn_tx_strobe      => nodebfn_tx_strobe,
      nodebfn_tx_nr          => nodebfn_tx_nr);

  -- IQ Data monitor
  iq_rx_chk_i : iq_rx_chk
    port map (
      clk                    => clk_i,
      enable                 => test_start_clk,
      speed                  => stat_speed_i_clk,
      basic_frame_first_word => basic_frame_first_word,
      iq_rx                  => iq_rx,
      nodebfn_rx_strobe      => nodebfn_rx_strobe,
      nodebfn_rx_nr          => nodebfn_rx_nr,
      frame_count            => frame_count,
      error_count            => error_count,
      nodebfn_rx_nr_store    => nodebfn_rx_nr_store,
      word_err               => open);

  -- Mu-law encoding and decoding
  mu_law_enc_1 : mu_law_encode
    port map (
      ap_clk    => clk_i,
      ap_rst    => reset_i,
      ap_ready  => open,
      pcm_val   => iq_tx_i(13 downto 0),
      ap_return => iq_tx_encoded(7 downto 0));

  mu_law_enc_2 : mu_law_encode
    port map (
      ap_clk    => clk_i,
      ap_rst    => reset_i,
      ap_ready  => open,
      pcm_val   => iq_tx_i(13 downto 0),
      ap_return => iq_tx_encoded(15 downto 8));

  mu_law_enc_3 : mu_law_encode
    port map (
      ap_clk    => clk_i,
      ap_rst    => reset_i,
      ap_ready  => open,
      pcm_val   => iq_tx_i(13 downto 0),
      ap_return => iq_tx_encoded(23 downto 16));

  mu_law_enc_4 : mu_law_encode
    port map (
      ap_clk    => clk_i,
      ap_rst    => reset_i,
      ap_ready  => open,
      pcm_val   => iq_tx_i(13 downto 0),
      ap_return => iq_tx_encoded(31 downto 24));

  mu_law_enc_5 : mu_law_encode
    port map (
      ap_clk    => clk_i,
      ap_rst    => reset_i,
      ap_ready  => open,
      pcm_val   => iq_tx_i(13 downto 0),
      ap_return => iq_tx_encoded(39 downto 32));

  mu_law_enc_6 : mu_law_encode
    port map (
      ap_clk    => clk_i,
      ap_rst    => reset_i,
      ap_ready  => open,
      pcm_val   => iq_tx_i(13 downto 0),
      ap_return => iq_tx_encoded(47 downto 40));

  mu_law_enc_7 : mu_law_encode
    port map (
      ap_clk    => clk_i,
      ap_rst    => reset_i,
      ap_ready  => open,
      pcm_val   => iq_tx_i(13 downto 0),
      ap_return => iq_tx_encoded(55 downto 48));

  mu_law_enc_8 : mu_law_encode
    port map (
      ap_clk    => clk_i,
      ap_rst    => reset_i,
      ap_ready  => open,
      pcm_val   => iq_tx_i(13 downto 0),
      ap_return => iq_tx_encoded(63 downto 56));

  mu_law_dec : mu_law_decode
    port map (
      ap_clk                 => clk_i,
      ap_rst                 => reset_i,
      ap_start               => '1',
      ap_done                => open,
      ap_ready               => open,
      u_val                  => iq_rx(7 downto 0),
      ap_return              => iq_rx_decoded,
      speed                  => stat_speed_i_clk,
      basic_frame_first_word => basic_frame_first_word);

  iq_tx <= iq_tx_i when mu_law_encoding = '0' else iq_tx_encoded;

  -- Synchronize reset to the core clock domain
  core_clk_reset_sync_i : xpm_cdc_async_rst
    generic map (
      RST_ACTIVE_HIGH => 1)
    port map (
      src_arst  => reset,
      dest_clk  => clk_i,
      dest_arst => reset_i);

  -- Synchronize reset to the eth clock doamin
  eth_clk_reset_sync_i : xpm_cdc_async_rst
    generic map (
      RST_ACTIVE_HIGH => 1)
    port map (
      src_arst  => reset,
      dest_clk  => eth_ref_clk_i,
      dest_arst => eth_reset);

  process(aux_clk_i)
  begin
    if rising_edge(aux_clk_i) then
      -- Don't check the output when mu-law endcoding is enabled as it will not mirror the input data exactly.
      if stat_code_i = "1111" and mu_law_encoding = '0' then
        operate_state <= '1';
      else
        operate_state <= '0';
      end if;
    end if;
  end process;

  -- Synchronise to the core clock
  operate_state_clk_i : xpm_cdc_single
  generic map (
    DEST_SYNC_FF  => 5,
    SRC_INPUT_REG => 0)
  port map (
    src_clk  => aux_clk_i,
    src_in   => operate_state,
    dest_clk => clk_i,
    dest_out => operate_state_clk);

  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if operate_state_clk = '0' then
        nodebfn_valid <= '0';
      elsif nodebfn_tx_nr = x"29B" and nodebfn_rx_nr = x"29B" then  -- Wait for nodebfn nums to sync.
        nodebfn_valid <= '1';
      end if;
      test_start_clk <= nodebfn_valid and enable_test_start;
    end if;
  end process;

  -- Synchronise to the ethernet clock
  test_start_eth_i : xpm_cdc_single
  generic map (
    DEST_SYNC_FF  => 5,
    SRC_INPUT_REG => 0)
  port map (
    src_clk  => clk_i,
    src_in   => test_start_clk,
    dest_clk => eth_ref_clk_i,
    dest_out => test_start_eth);

  -- HDLC data generator and monitor
  hdlc_tx_rx_i :  hdlc_stim
    port map (
      reset                  => reset_i,
      clk_ok                 => clk_ok_i,
      clk                    => clk_i,
      hdlc_rx_data           => hdlc_rx_data,
      hdlc_tx_data           => hdlc_tx_data,
      hdlc_rx_data_valid     => hdlc_rx_data_valid,
      hdlc_tx_enable         => hdlc_tx_enable,
      start_hdlc             => test_start_clk,
      bit_count              => hdlc_bit_count,
      error_count            => hdlc_error_count,
      hdlc_error             => open);

  -- Ethernet data generator and monitor
  mii_tx_rx_i : mii_stim
    port map (
      eth_clk                => eth_ref_clk_i,
      tx_eth_enable          => eth_tx_en,
      tx_eth_data            => eth_txd,
      tx_eth_err             => eth_tx_er,
      tx_eth_overflow        => eth_col,
      tx_eth_half            => eth_crs,
      rx_eth_data_valid      => eth_rx_dv,
      rx_eth_data            => eth_rxd,
      rx_eth_err             => eth_rx_er,
      tx_start               => test_start_eth,
      rx_start               => test_start_eth,
      tx_count               => eth_tx_count,
      rx_count               => eth_rx_count,
      err_count              => eth_error_count,
      eth_rx_error           => open,
      eth_rx_avail           => eth_rx_avail,
      eth_rx_ready           => eth_rx_ready,
      rx_fifo_almost_full    => rx_fifo_almost_full,
      rx_fifo_full           => rx_fifo_full);

  -- Vendor specific data generator and monitor
  vendor_tx_rx_i : vendor_stim
    port map (
      clk                => clk_i,
      reset              => reset_i,
      iq_tx_enable       => iq_tx_enable,
      bffw               => basic_frame_first_word,
      vendor_tx_data     => vendor_tx_data,
      vendor_tx_xs       => vendor_tx_xs,
      vendor_tx_ns       => vendor_tx_ns,
      vendor_rx_data     => vendor_rx_data,
      vendor_rx_xs       => vendor_rx_xs,
      vendor_rx_ns       => vendor_rx_ns,
      start_vendor       => test_start_clk,
      word_count         => vs_word_count,
      error_count        => vs_error_count,
      vendor_error       => open,
      speed              => stat_speed_i_clk);

  -- Implement a read only AXI interface to give access to the error counters
  -- from the example design monitor blocks
  -- The address map is given as:
  -- s_axi_araddr  | s_axi_rdata
  -- 0x100         | IQ frame count
  -- 0x104         | RX NodeBFN number
  -- 0x108         | IQ error count
  -- 0x10C         | HDLC bit count
  -- 0x110         | HDLC error count
  -- 0x114         | Vendor specific word count
  -- 0x118         | Vendor specific error count
  -- 0x11C         | Ethernet transmit frame count
  -- 0x120         | Ethernet receive frame count
  -- 0x124         | Ethernet error count

  -- AXI-Lite Address process
  axi_read_addr_gen : process(aux_clk_i, s_axi_aresetn)
  begin
    if s_axi_aresetn = '0' then
      s_axi_araddr_ed    <= (others => '0');
      s_axi_arready_ed   <= '0';
      s_axi_arvalid_r    <= '0';
      s_axi_rready_r     <= '0';
    elsif rising_edge(aux_clk_i) then
      s_axi_arvalid_r <= s_axi_arvalid;
      s_axi_rready_r  <= s_axi_rready;
      if s_axi_arvalid = '1' then
        s_axi_araddr_ed  <= s_axi_araddr;
        s_axi_arready_ed <= '1';
      else
        s_axi_arready_ed <= '0';
      end if;
    end if;
  end process;

  s_axi_arvalid_i <= s_axi_arvalid_r and not(s_axi_araddr_ed(8));
  s_axi_rready_i  <= s_axi_rready_r and not(s_axi_araddr_ed(8));

  -- AXI-Lite Read data process
  axi_read_gen : process(aux_clk_i, s_axi_aresetn)
  begin
    if s_axi_aresetn = '0' then
      s_axi_rdata_ed    <= (others => '0');
      s_axi_rvalid_ed   <= '0';
    elsif rising_edge(aux_clk_i) then
      if s_axi_rready = '1' then
        case s_axi_araddr_ed(5 downto 2) is
          when "0000" =>
            s_axi_rdata_ed  <= iq_frame_count_sync;
          when "0001" =>
            s_axi_rdata_ed  <= x"00000" & nodebfn_rx_nr_store_sync;
          when "0010" =>
            s_axi_rdata_ed  <= iq_error_count_sync;
          when "0011" =>
            s_axi_rdata_ed  <= hdlc_bit_count_sync;
          when "0100" =>
            s_axi_rdata_ed  <= hdlc_error_count_sync;
          when "0101" =>
            s_axi_rdata_ed  <= vs_word_count_sync;
          when "0110" =>
            s_axi_rdata_ed  <= vs_error_count_sync;
          when "0111" =>
            s_axi_rdata_ed  <= eth_tx_count_sync;
          when "1000" =>
            s_axi_rdata_ed  <= eth_rx_count_sync;
          when "1001" =>
            s_axi_rdata_ed  <= eth_error_count_sync;
          when others =>
            s_axi_rdata_ed  <= (others => '0');
        end case;
        s_axi_rvalid_ed <= '1';
      else
        s_axi_rvalid_ed <= '0';
      end if;
    end if;
  end process;

  s_axi_rresp_ed  <= "00";

  -- Mux between the core and example design AXI outputs
  axi_mux_gen : process(aux_clk_i, s_axi_aresetn)
  begin
    if s_axi_aresetn = '0' then
      s_axi_arready   <= '0';
      s_axi_rdata     <= (others => '0');
      s_axi_rvalid    <= '0';
      s_axi_rresp     <= (others => '0');
    elsif rising_edge(aux_clk_i) then
      case s_axi_araddr_ed(8) is
        when '0' =>
          s_axi_arready   <= s_axi_arready_i;
          s_axi_rdata     <= s_axi_rdata_i;
          s_axi_rvalid    <= s_axi_rvalid_i;
          s_axi_rresp     <= s_axi_rresp_i;
        when others =>
          s_axi_arready   <= s_axi_arready_ed;
          s_axi_rdata     <= s_axi_rdata_ed;
          s_axi_rvalid    <= s_axi_rvalid_ed;
          s_axi_rresp     <= s_axi_rresp_ed;
      end case;
    end if;
  end process;

  -- Assign outputs
  stat_speed <= stat_speed_i;
  stat_code  <= stat_code_i;

  refclk_ibufds : IBUFDS_GTE4
    port map (
      I     => refclk_p,
      IB    => refclk_n,
      O     => refclk,
      CEB   => '0',
      ODIV2 => open);

  hires_bufg : BUFG
    port map (
      O => hires_clk_i,
      I => hires_clk);

  aux_bufg : BUFG
    port map (
      O => aux_clk_i,
      I => s_axi_aclk);

  reset_block_clk_bufg : BUFG
    port map (
      O => gtwiz_reset_clk_freerun_in_i,
      I => gtwiz_reset_clk_freerun_in);

  eth_ref_clk_bufg : BUFG
    port map (
      O => eth_ref_clk_i,
      I => eth_ref_clk);

  -- Now create the divided clock to the outside world - 7.68MHz
  process(recclk)
  begin
    if rising_edge(recclk) then
      case stat_speed_i_rec is
        when "100000000000000" | "000010000000000" => -- 24.3G
          if count = 23 then
            recclkout_i <= not recclkout_i;
            count <= "00000";
          else
            count <= count + 1;
          end if;
        when "010000000000000" | "000001000000000" => -- 12.1G
          if count = 11 then
            recclkout_i <= not recclkout_i;
            count <= "00000";
          else
            count <= count + 1;
          end if;
        when "000100000000000" | "000000100000000" |
             "000000000010000" =>                     -- 8.1G/4.9G
          if count = 7 then
            recclkout_i <= not recclkout_i;
            count <= "00000";
          else
            count <= count + 1;
          end if;
        when "001000000000000" | "000000010000000" |
             "000000000100000" =>                     -- 10.1G/6.1G
          if count = 9 then
            recclkout_i <= not recclkout_i;
            count <= "00000";
          else
            count <= count + 1;
          end if;
        when "000000001000000" =>                     -- 9.8G
          if count = 15 then
            recclkout_i <= not recclkout_i;
            count <= "00000";
          else
            count <= count + 1;
          end if;
        when "000000000001000" =>                     -- 3.0G
          if count = 4 then
            recclkout_i <= not recclkout_i;
            count <= "00000";
          else
            count <= count + 1;
          end if;
        when "000000000000100" =>                     -- 2.4G
          if count = 3 then
            recclkout_i <= not recclkout_i;
            count <= "00000";
          else
            count <= count + 1;
          end if;
        when "000000000000010" =>                     -- 1.2G
          if count = 1 then
            recclkout_i <= not recclkout_i;
            count <= "00000";
          else
            count <= count + 1;
          end if;
        when others =>                                -- 0.6G
          recclkout_i <= not recclkout_i;
      end case;
    end if;
  end process;

  -- Output 7.68MHz
  recclkout_gen : FDCE
    port map (
      D   => recclkout_i,
      CE  => '1',
      C   => recclk,
      CLR => '0',
      Q   => recclk_out);

  -- Change the equalization mode depending on the settings from the GUI
  rxdfegen : process (stat_speed_i)
  begin
    case stat_speed_i is
      when "100000000000000" | "000010000000000" =>
        rxlpmen_in                   <= '0';
      when "010000000000000" | "000001000000000" =>
        rxlpmen_in                   <= '0';
      when "001000000000000" | "000000010000000" =>
        rxlpmen_in                   <= '0';
      when "000100000000000" | "000000100000000" =>
        rxlpmen_in                   <= '0';
      when "000000001000000" =>
        rxlpmen_in                   <= '0';
      when "000000000100000" =>
        rxlpmen_in                   <= '0';
      when "000000000010000" =>
        rxlpmen_in                   <= '0';
      when "000000000001000" =>
        rxlpmen_in                   <= '1';
      when "000000000000100" =>
        rxlpmen_in                   <= '1';
      when "000000000000010" =>
        rxlpmen_in                   <= '1';
      when others =>
        rxlpmen_in                   <= '1';
    end case;
  end process;

end rtl;
