-----------------------------------------------------------------------
-- Title      : Clocking
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : cpri_clocking.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: This file contains all the clocking required for
--              sharing clocks with other cores.
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

library unisim;
use unisim.vcomponents.all;

library cpri_v8_11_17;
use cpri_v8_11_17.all;

entity cpri_0_clocking is
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
end cpri_0_clocking;

architecture rtl of cpri_0_clocking is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  component cpri_0_reset_synchronizer is
    port (
      reset_in  : in  std_logic;
      clk       : in  std_logic;
      reset_out : out std_logic);
  end component;

  -------------- Signals Declaration --------------

  signal mmcm_rst_i               : std_logic;
  signal tx_sync_rst              : std_logic := '1';
  signal phase_alignment_done_r   : std_logic := '0';
  signal bufg_div                 : std_logic_vector(2 downto 0);
  signal bufg_div2                : std_logic_vector(2 downto 0);
  signal speed_select_r           : std_logic_vector(14 downto 0) := (others => '0');
  signal txresetdone_in_sync      : std_logic;
  signal txusrclk2                : std_logic;
  signal rxusrclk2                : std_logic;
  attribute dont_touch : string;
  attribute dont_touch of txusrclk2 : signal is "true";

begin

  mmcm_rst_i <= mmcm_reset;

  txusrclk2_bufg0 : BUFG_GT
    port map (
      I       => txoutclk_in,
      CE      => '1',
      CEMASK  => '0',
      CLR     => userclk_tx_reset,
      CLRMASK => '0',
      DIV     => bufg_div2,
      O       => txusrclk2);

  txusrclk_bufg0 : BUFG_GT
    port map (
      I       => txoutclk_in,
      CE      => '1',
      CEMASK  => '0',
      CLR     => userclk_tx_reset,
      CLRMASK => '0',
      DIV     => bufg_div,
      O       => txusrclk);

  speed_select_r_gen : process(stable_clk)
  begin
    if rising_edge(stable_clk) then
      speed_select_r <= speed_select;
    end if;
  end process speed_select_r_gen;

  bufg_div <= "011" when speed_select_r  = "000000000000001" else
              "001" when speed_select_r  = "000000000000010" else
              "000";

  bufg_div2 <= "111" when speed_select_r = "000000000000001" else
               "011" when speed_select_r = "000000000000010" else
               "001" when speed_select_r(6 downto 2) /= "00000" else
               "000";

  -- Rx clocking
  rxusrclk_bufg0 : BUFG_GT
    port map (
      I       => rxoutclk_in,
      CE      => '1',
      CEMASK  => '0',
      CLR     => userclk_rx_reset,
      CLRMASK => '0',
      DIV     => "000",
      O       => rxusrclk2);

  recclk_out <= rxusrclk2;

  -- System clock (core logic clock and most user logic)
  clk_out   <= txusrclk2;

  txresetdone_in_sync_i : cpri_0_reset_synchronizer
    port map (
      reset_in  => txresetdone_in,
      clk       => stable_clk,
      reset_out => txresetdone_in_sync);

  process(stable_clk)
  begin
    if rising_edge(stable_clk) then
      if speed_select(14 downto 7) /= "00000000" then
        reset_phalignment_out <= '1';
      else
        reset_phalignment_out <= not(txresetdone_in_sync);
      end if;
    end if;
  end process;

  tx_phase_alignment_done_sync_i : cpri_0_reset_synchronizer
    port map (
      reset_in  => phase_alignment_done,
      clk       => txusrclk2,
      reset_out => phase_alignment_done_r);

  -- Tx Sync reset held until Tx clocks OK and GTX Tx Reset done
  tx_sync_rst_gen : process(txusrclk2)
  begin
    if rising_edge(txusrclk2) then
      if txresetdone_in = '1' and phase_alignment_done_r = '1' then
        tx_sync_rst <= '0';
      else
        tx_sync_rst <= '1';
      end if;
    end if;
  end process tx_sync_rst_gen;

  -- output tx_clk domain reset
  clk_ok  <=  not(tx_sync_rst);

end rtl;
