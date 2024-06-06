-----------------------------------------------------------------------
-- $Revision: 1.1 $Date:
-- Title      : Raw IQ compatibility module
-- Project    : cpri_v8_11_5
-----------------------------------------------------------------------
-- File       : raw_iq_legacy_module.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description:
-- Modules that maintains timing compatibility with v1.1 / v1.2
-- raw interface
-----------------------------------------------------------------------
-- (c) Copyright 2004 - 2019 Xilinx, Inc. All rights reserved.
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
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity raw_iq_legacy_module is
  port (
    clk              : in  std_logic;
    speed_select     : in  std_logic_vector(3 downto 0);
    basic_frame_first_word : in std_logic;
    iq_tx_enable     : in  std_logic;
    raw_iq_tx        : in  std_logic_vector (15 downto 0);
    raw_iq_tx_count  : out std_logic_vector (6 downto 0);
    raw_iq_rx        : out std_logic_vector (15 downto 0);
    raw_iq_rx_count  : out std_logic_vector (6 downto 0);
    rx_data_valid    : out std_logic;
    iq_tx            : out  std_logic_vector (15 downto 0);
    iq_rx            : in std_logic_vector (15 downto 0));
end raw_iq_legacy_module;

architecture rtl of raw_iq_legacy_module is
  signal srl_out1             : std_logic_vector(15 downto 0);
  signal srl_out2             : std_logic_vector(15 downto 0);
  signal srl_out3             : std_logic_vector(15 downto 0);
  signal int_a                : std_logic_vector(15 downto 0);
  signal int_a2               : std_logic_vector(15 downto 0);
  signal rx_word_count        : unsigned(6 downto 0);
  signal tx_word_count        : unsigned(6 downto 0);
  signal addr                 : std_logic_vector(4 downto 0);
  signal speed_select_i       : std_logic_vector(5 downto 0);
  begin

  speed_select_i <= "00" & speed_select;

  shift_reg_g: for i in 0 to 15 generate
    shift_1 : SRLC32E
      port map (
        Q31 => int_a(i),
        Q   => srl_out1(i),
        CLK => clk,
        CE  => '1',
        A   => addr,
        D   => raw_iq_tx(i) );

    shift_2 : SRLC32E
      port map (
        Q31 => int_a2(i),
        Q   => srl_out2(i),
        CLK => clk,
        CE  => '1',
        A   => addr,
        D   => int_a(i) );

    shift_3 : SRLC32E
      port map (
        Q31 => open,
        Q   => srl_out3(i),
        CLK => clk,
        CE  => '1',
        A   => addr,
        D   => int_a2(i) );
  end generate;

  addr <= "01000" when  speed_select_i = "000001" else
          "10000" when (speed_select_i = "000010"
                     or speed_select_i = "100000") else
          "00000" when (speed_select_i = "000100"
                     or speed_select_i = "010000") else
          "01000";

  iq_tx <= srl_out3 when (speed_select_i = "100000"
                       or speed_select_i = "010000") else
           srl_out2 when (speed_select_i = "001000"
                       or speed_select_i = "000100") else
           srl_out1;

  CAPTURE_RAW_RX_DATA : process (clk)
  begin
    if rising_edge(clk) then
      raw_iq_rx <= iq_rx;
    end if;
  end process CAPTURE_RAW_RX_DATA;

  p_rx_data_valid : process (clk)
  begin
    if rising_edge(clk) then
      rx_data_valid <= basic_frame_first_word;
    end if;
  end process p_rx_data_valid;

  process (clk)
  begin
    if rising_edge(clk) then
      if basic_frame_first_word = '1' then
        rx_word_count <= (others => '0');
      else
        if (((speed_select_i = "001000") and (rx_word_count = "0100111"))
         or ((speed_select_i = "100000") and (rx_word_count = "1001111"))) then
          rx_word_count <= (others => '0');
        else
          rx_word_count <= rx_word_count + 1;
        end if;
      end if;
    end if;
  end process;

  raw_iq_rx_count <= "0000" & std_logic_vector(rx_word_count(2 downto 0)) when speed_select_i = "000001" else
                     "000"  & std_logic_vector(rx_word_count(3 downto 0)) when speed_select_i = "000010" else
                     "00"   & std_logic_vector(rx_word_count(4 downto 0)) when speed_select_i = "000100" else
                     "0"    & std_logic_vector(rx_word_count(5 downto 0)) when (speed_select_i = "001000" or speed_select_i = "010000") else
                     std_logic_vector(rx_word_count);

  process (clk)
  begin
    if rising_edge(clk) then
      if iq_tx_enable = '1' then
        tx_word_count <= "0000001";
      else
        if (((speed_select_i = "001000") and (tx_word_count = "0100111"))
         or ((speed_select_i = "100000") and (tx_word_count = "1001111"))) then
          tx_word_count <= (others => '0');
        else
          tx_word_count <= tx_word_count + 1;
        end if;
      end if;
    end if;
  end process;

  raw_iq_tx_count <= "0000" & std_logic_vector(tx_word_count(2 downto 0)) when speed_select_i = "000001" else
                     "000"  & std_logic_vector(tx_word_count(3 downto 0)) when speed_select_i = "000010" else
                     "00"   & std_logic_vector(tx_word_count(4 downto 0)) when speed_select_i = "000100" else
                     "0"    & std_logic_vector(tx_word_count(5 downto 0)) when (speed_select_i = "001000" or speed_select_i = "010000") else
                     std_logic_vector(tx_word_count);

end architecture rtl;
