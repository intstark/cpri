-------------------------------------------------------------------------------
-- Title      : Demo Testbench
-- Project    : cpri_v8_11_5
-------------------------------------------------------------------------------
-- File       : demo_tb.vhd
-- Author     : Xilinx
-------------------------------------------------------------------------------
-- Description: Testbench harness.
--              This test case waits for the CPRI line to get up, then sends
--              ethernet packets, HDLC packets and some IQ data.
-------------------------------------------------------------------------------
-- (c) Copyright 2004 - 2020 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library unisim;
use unisim.Vcomponents.all;
use work.cpri_tb_pkg.all;

entity demo_tb is
end demo_tb;

architecture behavioral of demo_tb is

-------------------------------------------------------------------------------
-- component declaration of design under test.
-------------------------------------------------------------------------------

  component cpri_slave_0_example_design
  port (
    reset              : in  std_logic;
    stat_alarm         : out std_logic;
    stat_code          : out std_logic_vector(3 downto 0);
    stat_speed         : out std_logic_vector(14 downto 0);
    mu_law_encoding    : in  std_logic;
    s_axi_aclk         : in  std_logic;
    s_axi_aresetn      : in  std_logic;
    s_axi_awaddr       : in  std_logic_vector(11 downto 0);
    s_axi_awvalid      : in  std_logic;
    s_axi_awready      : out std_logic;
    s_axi_wdata        : in  std_logic_vector(31 downto 0);
    s_axi_wvalid       : in  std_logic;
    s_axi_wready       : out std_logic;
    s_axi_bresp        : out std_logic_vector(1 downto 0);
    s_axi_bvalid       : out std_logic;
    s_axi_bready       : in  std_logic;
    s_axi_araddr       : in  std_logic_vector(11 downto 0);
    s_axi_arvalid      : in  std_logic;
    s_axi_arready      : out std_logic;
    s_axi_rdata        : out std_logic_vector(31 downto 0);
    s_axi_rresp        : out std_logic_vector(1 downto 0);
    s_axi_rvalid       : out std_logic;
    s_axi_rready       : in  std_logic;
    txp                : out std_logic;
    txn                : out std_logic;
    rxp                : in  std_logic;
    rxn                : in  std_logic;
    refclk_p           : in  std_logic;
    refclk_n           : in  std_logic;
    gtwiz_reset_clk_freerun_in : in std_logic;
    hires_clk          : in  std_logic;
    hires_clk_ok       : in  std_logic;
    eth_ref_clk        : in  std_logic;
    ext_clk_ok         : in  std_logic;
    recclk_out         : out std_logic;
    enable_test_start  : in  std_logic);
  end component;

  constant AUXCLK_PERIOD       : time := 8.000 ns;
  constant RESETCLK_PERIOD     : time := 133.333 ns;
  constant HIRESCLK_PERIOD     : time := 2.63 ns;
  constant ETHCLK_PERIOD       : time := 25.00 ns;

  constant REFCLK_PERIOD       : time := 4.070 ns;

  signal refclk                : std_logic := '0';
  signal hires_clk             : std_logic := '0';
  signal eth_ref_clk           : std_logic := '0';
  signal aux_clk               : std_logic := '0';
  signal gtwiz_reset_clk_freerun_in : std_logic := '0';
  signal refseldypll0          : std_logic_vector(2 downto 0) := "000";
  signal refseldypll1          : std_logic_vector(2 downto 0) := "000";
  signal refclk_p              : std_logic := '1';
  signal refclk_n              : std_logic := '0';
  signal rxn                   : std_logic;
  signal rxp                   : std_logic;
  signal txn                   : std_logic;
  signal txp                   : std_logic;
  signal stat_code             : std_logic_vector(3 downto 0);
  signal stat_speed            : std_logic_vector(14 downto 0);
  signal stat_alarm            : std_logic;
  signal ext_clk_ok            : std_logic;
  signal recclk_out            : std_logic;
  signal s_axi_aresetn         : std_logic;
  signal enable_test_start     : std_logic := '0';

  signal simulation_finished   : boolean := false;

  procedure tbprint (message : in string) is
    variable outline : line;
  begin
    write(outline, string'("## Time: "));
    write(outline, NOW, RIGHT, 0, ps);
    write(outline, string'("  "));
    write(outline, string'(message));
    writeline(output,outline);
  end tbprint;

begin

-------------------------------------------------------------------------------
-- connect the design under test to the signals in the testbench.
-------------------------------------------------------------------------------

   dut : cpri_slave_0_example_design
    port map (
      reset                  => to_reset.reset,
      stat_alarm             => stat_alarm,
      stat_code              => stat_code,
      stat_speed             => stat_speed,
      mu_law_encoding        => '0',
    -- AXI-Lite Interface
    -----------------
      s_axi_aclk             => aux_clk,
      s_axi_aresetn          => s_axi_aresetn,
      s_axi_awaddr           => to_mgmnt.s_axi_awaddr,
      s_axi_awvalid          => to_mgmnt.s_axi_awvalid,
      s_axi_awready          => frm_mgmnt.s_axi_awready,
      s_axi_wdata            => to_mgmnt.s_axi_wdata,
      s_axi_wvalid           => to_mgmnt.s_axi_wvalid,
      s_axi_wready           => frm_mgmnt.s_axi_wready,
      s_axi_bresp            => frm_mgmnt.s_axi_bresp,
      s_axi_bvalid           => frm_mgmnt.s_axi_bvalid,
      s_axi_bready           => to_mgmnt.s_axi_bready,
      s_axi_araddr           => to_mgmnt.s_axi_araddr,
      s_axi_arvalid          => to_mgmnt.s_axi_arvalid,
      s_axi_arready          => frm_mgmnt.s_axi_arready,
      s_axi_rdata            => frm_mgmnt.s_axi_rdata,
      s_axi_rresp            => frm_mgmnt.s_axi_rresp,
      s_axi_rvalid           => frm_mgmnt.s_axi_rvalid,
      s_axi_rready           => to_mgmnt.s_axi_rready,
      txp                    => txp,
      txn                    => txn,
      rxp                    => rxp,
      rxn                    => rxn,
      refclk_p               => refclk_p,
      refclk_n               => refclk_n,
      gtwiz_reset_clk_freerun_in => gtwiz_reset_clk_freerun_in,
      hires_clk              => hires_clk,
      hires_clk_ok           => '1',
      eth_ref_clk            => eth_ref_clk,
      ext_clk_ok             => ext_clk_ok,
      recclk_out             => recclk_out,
      enable_test_start      => enable_test_start);

  s_axi_aresetn <= not(to_reset.reset);

-------------------------------------------------------------------------------
-- generate the clock signals.
-------------------------------------------------------------------------------
  P_REFCLK : process
  begin
    wait for REFCLK_PERIOD /2;
    refclk_p <= not refclk_p;
    refclk_n <= not refclk_n;
  end process P_REFCLK;

  P_AUX_CLK : process
  begin
    wait for AUXCLK_PERIOD /2;
    aux_clk <= not aux_clk;
  end process P_AUX_CLK;

  P_RESET_CLK : process
  begin
    wait for RESETCLK_PERIOD /2;
    gtwiz_reset_clk_freerun_in <= not gtwiz_reset_clk_freerun_in;
  end process P_RESET_CLK;

  P_HIRES_CLK : process
  begin
    wait for HIRESCLK_PERIOD /2;
    hires_clk <= not hires_clk;
  end process P_HIRES_CLK;

  P_ETH_CLK : process
  begin
    wait for ETHCLK_PERIOD /2;
    eth_ref_clk <= not eth_ref_clk;
  end process P_ETH_CLK;

  -- Issue a GSR reset
  p_gsr : process
   begin
     gsr <= '1';
     wait for 100 ns;
     gsr <= '0';
     wait;
  end process p_gsr;

  -- Management process.
  -- Waits until core is in operational state;
  -- Sends 5 Ethernet packets;
  -- Sends HDLC packet.
  p_tb : process
    variable status : stat_typ := (others => '0');
    variable pnr : natural := 0;
    variable data     : dat_typ;
  begin
    reset(to_reset);

    -- The DUT is configured as a Slave. For the demo simulation the device is
    -- configured in loopback. This is not representative of a typical configuration.
    -- In a CPRI system the slave should inhibit its TX output until the RX
    -- achieves HFNSYNC. For loopback we must turn on the TX prior to HFNSYNC.
    write_slave_tx_enable(to_mgmnt, frm_mgmnt);


    --Check the status interface until the REC is in the active state
    while TRUE loop
        read_status_code(status, to_mgmnt, frm_mgmnt);
        case status is
          when STAT_PASSI => assert false report "negotiated to unexpected PASSIVE start up state!" severity failure;
          when STAT_OPERA => report "CPRI active link is up!" severity note;  exit;
          when others => null;
        end case;
    end loop;

    -- Enable interface checking (IQ, Ethernet, HDLC & Vendor)
    enable_test_start <= '1';

    -- Wait for 1000 basic frames to be received
    while TRUE loop
      read(IQ_FRAME_COUNT, data, to_mgmnt, frm_mgmnt);
      if (to_integer(unsigned(data)) > 1000) then exit;
      end if;
    end loop;

    -- Read frame and error counts from the test blocks
    read(IQ_FRAME_COUNT, data, to_mgmnt, frm_mgmnt);
    tbprint(string'("Number of IQ basic frames received = "
      & integer'image(to_integer(unsigned(data)))));

    read(IQ_ERROR_COUNT, data, to_mgmnt, frm_mgmnt);
    tbprint(string'("Number of incorrect IQ words received = "
      & integer'image(to_integer(unsigned(data)))));
    if (data /= x"00000000") then
      assert false report "** IQ Errors Received" severity failure;
    end if;

    read(HDLC_BIT_COUNT, data, to_mgmnt, frm_mgmnt);
    tbprint(string'("Number of HDLC bits received = "
      & integer'image(to_integer(unsigned(data)))));
    if (data = x"00000000") then
      assert false report "** Error - No HDLC bits received" severity failure;
    end if;

    read(HDLC_ERROR_COUNT, data, to_mgmnt, frm_mgmnt);
    tbprint(string'("Number of incorrect HDLC bits received = "
      & integer'image(to_integer(unsigned(data)))));
    if (data /= x"00000000") then
      assert false report "** HDLC Errors Received" severity failure;
    end if;

    read(VENDOR_WORD_COUNT, data, to_mgmnt, frm_mgmnt);
    tbprint(string'("Number of vendor specific words received = "
      & integer'image(to_integer(unsigned(data)))));
    if (data = x"00000000") then
      assert false report "** Error - No vendor specific words received" severity failure;
    end if;

    read(VENDOR_ERROR_COUNT, data, to_mgmnt, frm_mgmnt);
    tbprint(string'("Number of incorrect vendor specific words received = "
      & integer'image(to_integer(unsigned(data)))));
    if (data /= x"00000000") then
      assert false report "** Vendor Specific Errors Received" severity failure;
    end if;

    read(ETH_TRANSMIT_COUNT, data, to_mgmnt, frm_mgmnt);
    tbprint(string'("Number of Ethernet frames transmitted = "
      & integer'image(to_integer(unsigned(data)))));

    read(ETH_RECEIVE_COUNT, data, to_mgmnt, frm_mgmnt);
    tbprint(string'("Number of Ethernet frames received = "
      & integer'image(to_integer(unsigned(data)))));
    if (data = x"00000000") then
      assert false report "** Error - No Ethernet frames received" severity failure;
    end if;

    read(ETH_ERROR_COUNT, data, to_mgmnt, frm_mgmnt);
    tbprint(string'("Number of incorrect Ethernet frames received = "
      & integer'image(to_integer(unsigned(data)))));
    if (data /= x"00000000") then
      assert false report "** Ethernet Errors Received" severity failure;
    end if;

    simulation_finished <= true;

    wait;

  end process p_tb;

  -- Connect the DUT in loopback
  rxn <= txn;
  rxp <= txp;

  rocbuf_i : GLBL_VHD;

  -- Emulate external PLL lock
  ext_clk_ok <= '1';


  p_end_simulation : process
  begin
     wait until simulation_finished for 20 ms;
     assert simulation_finished
        report "Error: Testbench timed out"
        severity failure;
     if simulation_finished then
        assert false
           report "Test completed successfully"
           severity note;
     end if;
     assert false
        report "Simulation Stopped."
        severity failure;
  end process p_end_simulation;

end;
