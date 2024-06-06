-----------------------------------------------------------------------
-- Title      : vendor_stim
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : vendor_stim.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: Generates and monitors vendor specific data
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

entity vendor_stim is
  port (
    clk                : in  std_logic;
    reset              : in  std_logic;
    iq_tx_enable       : in  std_logic;
    bffw               : in  std_logic;
    vendor_tx_data     : out std_logic_vector(127 downto 0);
    vendor_tx_xs       : in  std_logic_vector(1 downto 0);
    vendor_tx_ns       : in  std_logic_vector(5 downto 0);
    vendor_rx_data     : in  std_logic_vector(127 downto 0);
    vendor_rx_xs       : in  std_logic_vector(1 downto 0);
    vendor_rx_ns       : in  std_logic_vector(5 downto 0);
    start_vendor       : in  std_logic;
    word_count         : out std_logic_vector(31 downto 0);
    error_count        : out std_logic_vector(31 downto 0);
    vendor_error       : out std_logic;
    speed              : in  std_logic_vector(14 downto 0)
  );
end entity vendor_stim;

architecture imp of vendor_stim is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";

  -- Serial PRBS generator
  component tx_prbs is
  port (
    clk   : in  std_logic;
    ce    : in  std_logic;
    sclr  : in  std_logic;
    q     : out std_logic);
  end component;

  signal send_vendor        : std_logic := '0';
  signal iq_tx_enable_d1    : std_logic := '0';

  signal tx_vs_on           : std_logic := '0';
  signal tx_vs_on_en        : std_logic := '0';
  signal tx_word_nr         : unsigned(6 downto 0)          := (others => '0');
  signal tx_load_seed       : std_logic := '0';
  signal tx_prbs_vs         : std_logic;
  signal tx_data_vs         : std_logic_vector(31 downto 0) := (others => '0');

  signal bffw_d1            : std_logic := '0';

  signal rx_data_vs         : std_logic_vector(31 downto 0) := (others => '0');
  signal rx_data_vs_d1      : std_logic                     := '0';
  signal rx_vs_on           : std_logic := '0';
  signal rx_vs_on_en        : std_logic := '0';
  signal rx_word_nr         : unsigned(6 downto 0)          := (others => '0');
  signal rx_load_seed       : std_logic := '0';
  signal rx_prbs_vs         : std_logic;

  signal word_count_i       : unsigned(31 downto 0)         := (others => '0');
  signal error_i            : std_logic := '0';
  signal error_count_i      : unsigned(31 downto 0)         := (others => '0');

  constant start_frame_nr   : integer := 61;  -- Arbitrary vendor data frame start position
                                              -- following start_vendor transition to high.
begin

  -- PRBS generator for Tx VS data
  tx_prbs_i : tx_prbs
  port map (
    clk   => clk,
    ce    => tx_vs_on_en,
    sclr  => tx_load_seed,
    q     => tx_prbs_vs);

  tx_load_seed <= iq_tx_enable and not(tx_vs_on);

  -- Generate the clock enable for the TX serial PRBS.
  -- VS data is sent when Ns is 16, 17, 18 or 19.
  -- This presumes an Ethernet pointer of 20.
  tx_vs_gen : process(clk)
  begin
    if rising_edge(clk) then
      if (start_vendor = '1') then
        if iq_tx_enable = '1' then
          -- Initiate the Vendor traffic
          if unsigned(vendor_tx_ns) = start_frame_nr then
            send_vendor <= '1';
          end if;

          -- VS - enabled during Ns 16 -> 19
          if unsigned(vendor_tx_ns) = 14 then
            send_vendor <= '1';
            tx_vs_on    <= '1';
          elsif unsigned(vendor_tx_ns) = 18 then
            tx_vs_on    <= '0';
          end if;

        end if;
      else
        send_vendor <= '0';
        tx_vs_on    <= '0';
      end if;

      -- Keep track of position within the basic frame
      if iq_tx_enable = '1' then
        tx_word_nr <= (others => '0');
      else
        tx_word_nr <= tx_word_nr + 1;
      end if;

    end if;
  end process;

  -- Disable the VS Tx PRBS generator and Shift Register when outside the CW and data size range
  tx_vs_on_en <= tx_vs_on when (tx_word_nr < 32) else '0';

  -- Parallel-ize the data to send to the CPRI core
  tx_shift_reg_gen : process(clk)
  begin
    if rising_edge(clk) then
      -- VS
      if tx_vs_on_en = '1' then
        tx_data_vs(31)          <= tx_prbs_vs;
        tx_data_vs(30 downto 0) <= tx_data_vs(31 downto 1);
      end if;
    end if;
  end process;

  -- Send to the CPRI core
  op_gen : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        vendor_tx_data    <= (others => '0');
      else
        iq_tx_enable_d1 <= iq_tx_enable;
        if iq_tx_enable_d1 = '1' then
          case speed is
            when "000000000000001" =>  -- 614
              vendor_tx_data(1 downto 0)    <= tx_data_vs(31 downto 30);
              vendor_tx_data(3 downto 2)    <= tx_data_vs(31 downto 30);
              vendor_tx_data(5 downto 4)    <= tx_data_vs(31 downto 30);
              vendor_tx_data(7 downto 6)    <= tx_data_vs(31 downto 30);
            when "000000000000010" =>  -- 1228
              vendor_tx_data( 3 downto  0)  <= tx_data_vs(31 downto 28);
              vendor_tx_data( 7 downto  4)  <= tx_data_vs(31 downto 28);
              vendor_tx_data(11 downto  8)  <= tx_data_vs(31 downto 28);
              vendor_tx_data(15 downto 12)  <= tx_data_vs(31 downto 28);
            when "000000000000100" =>  -- 2457
              vendor_tx_data( 7 downto  0)  <= tx_data_vs(31 downto 24);
              vendor_tx_data(15 downto  8)  <= tx_data_vs(31 downto 24);
              vendor_tx_data(23 downto 16)  <= tx_data_vs(31 downto 24);
              vendor_tx_data(31 downto 24)  <= tx_data_vs(31 downto 24);
            when "000000000001000" =>  -- 3072
              vendor_tx_data( 9 downto  0)  <= tx_data_vs(31 downto 22);
              vendor_tx_data(19 downto 10)  <= tx_data_vs(31 downto 22);
              vendor_tx_data(29 downto 20)  <= tx_data_vs(31 downto 22);
              vendor_tx_data(39 downto 30)  <= tx_data_vs(31 downto 22);
            when "000000000010000" =>  -- 4195
              vendor_tx_data(15 downto  0)  <= tx_data_vs(31 downto 16);
              vendor_tx_data(31 downto 16)  <= tx_data_vs(31 downto 16);
              vendor_tx_data(47 downto 32)  <= tx_data_vs(31 downto 16);
              vendor_tx_data(63 downto 48)  <= tx_data_vs(31 downto 16);
            when "000000000100000" =>  -- 6144
              vendor_tx_data(19 downto  0)  <= tx_data_vs(31 downto 12);
              vendor_tx_data(39 downto 20)  <= tx_data_vs(31 downto 12);
              vendor_tx_data(59 downto 40)  <= tx_data_vs(31 downto 12);
              vendor_tx_data(79 downto 60)  <= tx_data_vs(31 downto 12);
            when others =>         -- 8110/9830/10137/12165/24330
              vendor_tx_data( 31 downto  0) <= tx_data_vs;
              vendor_tx_data( 63 downto 32) <= tx_data_vs;
              vendor_tx_data( 95 downto 64) <= tx_data_vs;
              vendor_tx_data(127 downto 96) <= tx_data_vs;
          end case;
        end if;
      end if;
    end if;
  end process;

  -- PRBS generator for Rx VS data
  rx_prbs_i : tx_prbs
  port map (
    clk   => clk,
    ce    => rx_vs_on_en,
    sclr  => rx_load_seed,
    q     => rx_prbs_vs);

  rx_load_seed <= bffw and not(rx_vs_on);

  -- Generate the clock enable for the RX serial PRBS.
  -- Vendor specific data is received when Ns is 16, 17, 18 or 19.
  -- This presumes an Ethernet pointer of 20.
  rx_vs_on_gen : process(clk)
  begin
    if rising_edge(clk) then
      if start_vendor = '1' then
        if bffw_d1 = '1' then
          -- VS - enable during Ns 16 -> 19
          if unsigned(vendor_rx_ns) = 17 then
            rx_vs_on <= '1';
          elsif unsigned(vendor_rx_ns) = 21 then
            rx_vs_on <= '0';
          end if;

        end if;
      else
        rx_vs_on   <= '0';
      end if;

      -- Keep track of position within the basic frame
      if bffw_d1 = '1' then
        rx_word_nr <= (others => '0');
      else
        rx_word_nr <= rx_word_nr + 1;
      end if;

    end if;
  end process;

  -- Disable the VS Rx PRBS generator and Shift Register when outside the CW and data size range
  rx_vs_on_en <= rx_vs_on when (rx_word_nr < 32) else '0';

  -- Serialize the VS data received from the CPRI core
  rx_shift_reg_gen : process(clk)
  begin
    if rising_edge(clk) then
      bffw_d1 <= bffw;
      if bffw = '1' then
        rx_data_vs <= vendor_rx_data(31 downto 0);
      else
        rx_data_vs(30 downto 0) <= rx_data_vs(31 downto 1);
      end if;
      rx_data_vs_d1 <= rx_data_vs(0);  -- align with PRBS data
    end if;
  end process;

  -- Compare the received VS data with the PRBS sequence
  err_gen : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' or start_vendor = '0' then
        error_i <= '0';
      elsif rx_vs_on_en = '1' and send_vendor = '1' then
        if rx_prbs_vs /= rx_data_vs_d1 then
          error_i <= '1';
        else
          error_i <= '0';
        end if;
      else
        error_i <= '0';
      end if;
    end if;
  end process;

  -- Count the number of VS errors
  vs_err_cnt_gen : process(clk)
  begin
    if rising_edge(clk) then

      if reset = '1' or start_vendor = '0' then
        error_count_i <= (others => '0');
      elsif error_i = '1' then
        error_count_i <= error_count_i + 1;
      end if;

      if reset = '1' or start_vendor = '0' then
        word_count_i  <= (others => '0');
      elsif rx_vs_on = '1' and bffw = '1' then
        word_count_i  <= word_count_i + 1;
      end if;

    end if;
  end process;

  word_count   <= std_logic_vector(word_count_i);
  error_count  <= std_logic_vector(error_count_i);
  vendor_error <= error_i;

end imp;
