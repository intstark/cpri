-----------------------------------------------------------------------
-- Title      : hdlc_stim
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : hdlc_stim.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: Generates and monitors HDLC data
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

entity hdlc_stim is
  port
  (
    reset                          : in  std_logic;
    clk_ok                         : in  std_logic;
    clk                            : in  std_logic;
    hdlc_rx_data                   : in  std_logic;
    hdlc_tx_data                   : out std_logic;
    hdlc_rx_data_valid             : in  std_logic;
    hdlc_tx_enable                 : in  std_logic;
    start_hdlc                     : in  std_logic;
    bit_count                      : out std_logic_vector(31 downto 0);
    error_count                    : out std_logic_vector(31 downto 0);
    hdlc_error                     : out std_logic
  );

end entity hdlc_stim;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture imp of hdlc_stim is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";

  component tx_prbs is
    Port ( clk   : in  std_logic;
           ce    : in  std_logic;
           sclr  : in  std_logic;
           q     : out std_logic);
  end component;

  signal hdlc_rx_data_comp   : std_logic;
  signal hdlc_rx_data_r      : std_logic;
  signal hdlc_tx_enable_i    : std_logic;
  signal hdlc_rx_enable      : std_logic := '0';
  signal hdlc_tx_data_i      : std_logic;
  signal hdlc_rx_enable_i    : std_logic_vector(7 downto 0) := (others => '1');
  signal err                 : std_logic;

  signal frame_compare       : std_logic := '0';
  signal shift_data_in       : std_logic_vector(7 downto 0) := (others => '0');
  signal clear_prbs          : std_logic := '0';

  signal start_hdlc_r        : std_logic;
  signal start_hdlc_i        : std_logic;

  signal bit_count_i         : unsigned(31 downto 0)         := (others => '0');
  signal error_count_i       : unsigned(31 downto 0)         := (others => '0');

begin

  clear_prbs <= reset or start_hdlc_i;

  tx_prbs_i : tx_prbs
  port map ( clk   => clk,
             ce    => hdlc_tx_enable_i,
             sclr  => clear_prbs,
             q     => hdlc_tx_data_i);

  hdlc_tx_data <= hdlc_tx_data_i;

  rx_prbs_i : tx_prbs
  port map ( clk   => clk,
             ce    => hdlc_rx_enable,
             sclr  => clear_prbs,
             q     => hdlc_rx_data_comp);

  hdlc_tx_enable_i <= hdlc_tx_enable and start_hdlc;

  -- Detect the HDLC start pattern in the incoming data
  detect_frame_start : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' or start_hdlc_i = '1' then
        frame_compare <= '0';
        shift_data_in <= (others => '0');
      elsif hdlc_rx_data_valid = '1' then
        shift_data_in(0) <= hdlc_rx_data;
        shift_data_in(7 downto 1) <= shift_data_in(6 downto 0);
        if shift_data_in(6 downto 0) = "0111111" and hdlc_rx_data = '0' then
          -- Start of frame pattern!
          frame_compare <= '1';
        end if;
      end if;
    end if;
  end process detect_frame_start;

  -- Scroll over the first 8 bits of the compare PRBS sequence
  -- and then wait for hdlc_rx_data_valid and frame_compare
  compare_en_gen : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' or start_hdlc_i = '1' then
        hdlc_rx_enable   <= '0';
        hdlc_rx_enable_i <= (others => '1');
        hdlc_rx_data_r   <= '0';
      elsif clk_ok = '1' then
        hdlc_rx_enable_i(0) <= '0';
        hdlc_rx_enable_i(7 downto 1) <= hdlc_rx_enable_i(6 downto 0);
        hdlc_rx_data_r <= hdlc_rx_data;
        if hdlc_rx_enable_i /= "00000000" or 
           (frame_compare = '1' and hdlc_rx_data_valid = '1') then
          hdlc_rx_enable <= '1';
        else
          hdlc_rx_enable <= '0';
        end if;
      end if;
    end if;
  end process compare_en_gen;

  err_count_gen : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' or start_hdlc_i = '1' then
        err           <= '0';
        bit_count_i   <= (others => '0');
        error_count_i <= (others => '0');
      elsif hdlc_rx_enable = '1' and frame_compare = '1' then
        bit_count_i <= bit_count_i + 1;
        if hdlc_rx_data_comp /= hdlc_rx_data_r then
          error_count_i <= error_count_i + 1;
          err <= '1';
        else
          err <= '0';
        end if;
      else
        err <= '0';
      end if;
    end if;
  end process;

  bit_count   <= std_logic_vector(bit_count_i);
  error_count <= std_logic_vector(error_count_i);
  hdlc_error  <= err;

  -- Generate a start pulse
  start_hdlc_gen : process(clk)
  begin
    if rising_edge(clk) then
      start_hdlc_r <= start_hdlc;
    end if;
  end process start_hdlc_gen;
  start_hdlc_i <= start_hdlc and not(start_hdlc_r);

end IMP;
