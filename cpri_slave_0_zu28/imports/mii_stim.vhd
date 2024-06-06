-----------------------------------------------------------------------
-- Title      : mii_stim
-- Project    : cpri_v8_11_5
-----------------------------------------------------------------------
-- File       : mii_stim.vhd
-- Author     : Xilinx
------------------------------------------------------------------------
-- Description: Generates and monitors Ethernet frames.
------------------------------------------------------------------------
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mii_stim is
  port (
    eth_clk                        : in  std_logic;
    tx_eth_enable                  : out std_logic;
    tx_eth_data                    : out std_logic_vector( 3 downto 0);
    tx_eth_err                     : out std_logic;
    tx_eth_overflow                : in  std_logic;
    tx_eth_half                    : in  std_logic;
    rx_eth_data_valid              : in  std_logic;
    rx_eth_data                    : in  std_logic_vector( 3 downto 0);
    rx_eth_err                     : in  std_logic;
    tx_start                       : in  std_logic;
    rx_start                       : in  std_logic;
    tx_count                       : out std_logic_vector(31 downto 0);
    rx_count                       : out std_logic_vector(31 downto 0);
    err_count                      : out std_logic_vector(31 downto 0);
    eth_rx_error                   : out std_logic;
    eth_rx_avail                   : in  std_logic;
    eth_rx_ready                   : out std_logic;
    rx_fifo_almost_full            : in  std_logic;
    rx_fifo_full                   : in  std_logic);
end entity;

architecture rtl of mii_stim is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  ----------------------------------------------------------------------
  -- types to support frame data
  ----------------------------------------------------------------------
  -- BRAM inferred to store Frame data
  -- 9 bits wide (8 data plus control bit)
  -- Control acts as a valid with one '0' between frames

  type rom_type is array (natural range <>) of std_logic_vector (8 downto 0);
  constant mii_data : rom_type := (

       '1' & X"FF", -- Destination Address (Broadcast)
       '1' & X"FF",
       '1' & X"FF",
       '1' & X"FF",
       '1' & X"FF",
       '1' & X"FF",
       '1' & X"5A", -- Source Address       (5A)
       '1' & X"02",
       '1' & X"03",
       '1' & X"04",
       '1' & X"05",
       '1' & X"06",
       '1' & X"00",
       '1' & X"2E", -- Length/Type = Length = 46
       '1' & X"01",
       '1' & X"02",
       '1' & X"03",
       '1' & X"04",
       '1' & X"05",
       '1' & X"06",
       '1' & X"07",
       '1' & X"08",
       '1' & X"09",
       '1' & X"0A",
       '1' & X"0B",
       '1' & X"0C",
       '1' & X"0D",
       '1' & X"0E",
       '1' & X"0F",
       '1' & X"10",
       '1' & X"11",
       '1' & X"12",
       '1' & X"13",
       '1' & X"14",
       '1' & X"15",
       '1' & X"16",
       '1' & X"17",
       '1' & X"18",
       '1' & X"19",
       '1' & X"1A",
       '1' & X"1B",
       '1' & X"1C",
       '1' & X"1D",
       '1' & X"1E",
       '1' & X"1F",
       '1' & X"20",
       '1' & X"21",
       '1' & X"22",
       '1' & X"23",
       '1' & X"24",
       '1' & X"25",
       '1' & X"26",
       '1' & X"27",
       '1' & X"28",
       '1' & X"29",
       '1' & X"2A",
       '1' & X"2B",
       '1' & X"2C",
       '1' & X"2D",
       '1' & X"2E", -- 46th Byte of Data
       '0' & X"00",

       '1' & X"DA", -- Destination Address (DA)
       '1' & X"02",
       '1' & X"03",
       '1' & X"04",
       '1' & X"05",
       '1' & X"06",
       '1' & X"5A", -- Source Address       (5A)
       '1' & X"02",
       '1' & X"03",
       '1' & X"04",
       '1' & X"05",
       '1' & X"06",
       '1' & X"80", -- Length/Type = Type = 8000
       '1' & X"00",
       '1' & X"01",
       '1' & X"02",
       '1' & X"03",
       '1' & X"04",
       '1' & X"05",
       '1' & X"06",
       '1' & X"07",
       '1' & X"08",
       '1' & X"09",
       '1' & X"0A",
       '1' & X"0B",
       '1' & X"0C",
       '1' & X"0D",
       '1' & X"0E",
       '1' & X"0F",
       '1' & X"10",
       '1' & X"11",
       '1' & X"12",
       '1' & X"13",
       '1' & X"14",
       '1' & X"15",
       '1' & X"16",
       '1' & X"17",
       '1' & X"18",
       '1' & X"19",
       '1' & X"1A",
       '1' & X"1B",
       '1' & X"1C",
       '1' & X"1D",
       '1' & X"1E",
       '1' & X"1F",
       '1' & X"20",
       '1' & X"21",
       '1' & X"22",
       '1' & X"23",
       '1' & X"24",
       '1' & X"25",
       '1' & X"26",
       '1' & X"27",
       '1' & X"28",
       '1' & X"29",
       '1' & X"2A",
       '1' & X"2B",
       '1' & X"2C",
       '1' & X"2D",
       '1' & X"2E",
       '1' & X"2F", -- 47th Data byte
       '0' & X"00",

       '1' & X"DA", -- Destination Address (DA)
       '1' & X"02",
       '1' & X"03",
       '1' & X"04",
       '1' & X"05",
       '1' & X"06",
       '1' & X"5A", -- Source Address       (5A)
       '1' & X"02",
       '1' & X"03",
       '1' & X"04",
       '1' & X"05",
       '1' & X"06",
       '1' & X"00",
       '1' & X"2E", -- Length/Type = Length = 46
       '1' & X"01",
       '1' & X"02",
       '1' & X"03",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00", -- Error asserted
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '0' & X"00",

       '1' & X"DA", -- Destination Address (DA)
       '1' & X"02",
       '1' & X"03",
       '1' & X"04",
       '1' & X"05",
       '1' & X"06",
       '1' & X"5A", -- Source Address       (5A)
       '1' & X"02",
       '1' & X"03",
       '1' & X"04",
       '1' & X"05",
       '1' & X"06",
       '1' & X"00",
       '1' & X"03", -- Length/Type = Length = 03
       '1' & X"01", -- Therefore padding is required
       '1' & X"02",
       '1' & X"03",
       '1' & X"00", -- Padding starts here
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '1' & X"00",
       '0' & X"00");

  ----------------------------------------------------------------------
  -- CRC engine
  ----------------------------------------------------------------------
  function calc_crc (data : in std_logic_vector;
                     fcs  : in std_logic_vector)
  return std_logic_vector is

    variable crc          : std_logic_vector(31 downto 0);
    variable crc_feedback : std_logic;
  begin

    crc := not fcs;

    for I in 0 to 7 loop
      crc_feedback      := crc(0) xor data(I);

      crc(4 downto 0)   := crc(5 downto 1);
      crc(5)            := crc(6)  xor crc_feedback;
      crc(7 downto 6)   := crc(8 downto 7);
      crc(8)            := crc(9)  xor crc_feedback;
      crc(9)            := crc(10) xor crc_feedback;
      crc(14 downto 10) := crc(15 downto 11);
      crc(15)           := crc(16) xor crc_feedback;
      crc(18 downto 16) := crc(19 downto 17);
      crc(19)           := crc(20) xor crc_feedback;
      crc(20)           := crc(21) xor crc_feedback;
      crc(21)           := crc(22) xor crc_feedback;
      crc(22)           := crc(23);
      crc(23)           := crc(24) xor crc_feedback;
      crc(24)           := crc(25) xor crc_feedback;
      crc(25)           := crc(26);
      crc(26)           := crc(27) xor crc_feedback;
      crc(27)           := crc(28) xor crc_feedback;
      crc(28)           := crc(29);
      crc(29)           := crc(30) xor crc_feedback;
      crc(30)           := crc(31) xor crc_feedback;
      crc(31)           :=             crc_feedback;
    end loop;

    -- return the CRC result
    return not crc;
  end calc_crc;

  type states is (idle, preamble, frame, fcs, ifg, complete);
  signal mii_state          : states   := idle;
  signal rx_state           : states   := idle;
  signal data_counter       : integer  := 0;
  signal tx_frame_counter   : unsigned(31 downto 0) := (others => '0');
  signal rx_data_counter    : unsigned(7 downto 0)  := (others => '0');
  signal rx_data_end        : std_logic;
  signal rx_data_frame_end  : std_logic;
  signal mii_counter        : unsigned(4 downto 0)  := (others => '0');
  signal mii_toggle         : boolean;
  signal rx_toggle          : boolean;
  signal frame_fcs          : std_logic_vector(31 downto 0);
  signal rx_frame_fcs       : std_logic_vector(31 downto 0);
  signal rx_error           : std_logic;
  signal rx_error_counter   : unsigned(31 downto 0) := (others => '0');
  signal rx_frame_counter   : unsigned(31 downto 0) := (others => '0');
  signal tx_start_d         : std_logic;
  signal rx_first_frame     : std_logic := '1';
  signal tx_eth_half_r      : std_logic := '1';
  signal tx_eth_half_r2     : std_logic := '1';

  signal tx_eth_enable_i    : std_logic;
  signal tx_eth_data_i      : std_logic_vector(3 downto 0);
  signal tx_eth_err_i       : std_logic;

  attribute ASYNC_REG : string;
  attribute ASYNC_REG of tx_eth_half_r : signal is "true";
  attribute ASYNC_REG of tx_eth_half_r2 : signal is "true";

begin

  tx_count     <= std_logic_vector(tx_frame_counter);
  rx_count     <= std_logic_vector(rx_frame_counter);
  err_count    <= std_logic_vector(rx_error_counter);
  eth_rx_error <= rx_error;

  ----------------------------------------------------------------------
  -- Stimulus process. This process will inject frames of data into the
  -- PHY side of the receiver.
  ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    -- Send four frames through the MAC and Design Example
    --      -- frame 0 = minimum length frame
    --      -- frame 1 = type frame
    --      -- frame 2 = errored frame
    --      -- frame 3 = padded frame
    ----------------------------------------------------------------------
  p_stimulus : process(eth_clk)
  begin
    if rising_edge(eth_clk) then
      case mii_state is
        when idle =>
          tx_start_d <= tx_start;
          if tx_start_d = '0' then
            tx_frame_counter <= (others => '0');
          end if;
          tx_eth_enable_i <= '0';
          tx_eth_err_i <= '0';
          tx_eth_data_i <= X"0";
          if tx_start = '1' and tx_eth_half_r2 = '0' then
            mii_state <= preamble;
            mii_counter <= (others => '0');
            data_counter <= 0;
          end if;
        when preamble =>
          if tx_start = '0' then
            mii_state <= idle;
          else
            tx_eth_enable_i <= '1';
            tx_eth_err_i <= '0';
            if mii_counter = "01111" then -- 15x5
              tx_eth_data_i <= X"D";
              mii_counter <= "00000";
              mii_toggle <= false;
              mii_state <= frame;
              frame_fcs <= (others => '0');
            else
              mii_counter <= mii_counter + 1;
              tx_eth_data_i <= X"5";
              mii_state <= preamble;
            end if;
          end if;
        when frame =>
          if tx_start = '0' then
            mii_state <= idle;
          else
            mii_toggle <= not mii_toggle;
            tx_eth_enable_i <= '1';
            tx_eth_err_i <= '0';
            if mii_toggle then
              tx_eth_data_i <= mii_data(data_counter)(7 downto 4);
              data_counter <= data_counter + 1;
            else
              if mii_data(data_counter)(8) = '0' then
                data_counter <= data_counter + 1;
                mii_state <= fcs;
                tx_eth_data_i <= frame_fcs(3 downto 0);
                mii_counter <= "00001"; -- 1
              else
                frame_fcs <= calc_crc(mii_data(data_counter), frame_fcs);
                tx_eth_data_i <= mii_data(data_counter)(3 downto 0);
                mii_state <= frame;
              end if;
            end if;
          end if;
        when fcs =>
          if tx_start = '0' then
            mii_state <= idle;
          else
            mii_counter <= mii_counter + 1;
            tx_eth_enable_i <= '1';
            tx_eth_err_i <= '0';
            tx_eth_data_i <= frame_fcs(((4*to_integer(mii_counter))+3) downto (4*to_integer(mii_counter)));
            if mii_counter = "00111" then -- 7
              mii_counter <= "00000";
              mii_state <= ifg;
              tx_frame_counter <= tx_frame_counter + 1;
            end if;
          end if;
        when ifg =>
          if tx_start = '0' then
            mii_state <= idle;
          else
            tx_eth_data_i <= X"0";
            tx_eth_enable_i <= '0';
            tx_eth_err_i <= '0';
            if mii_counter = "11101" then -- 29
              if tx_eth_half_r2 = '0' then
                mii_counter <= "00000";
                if data_counter = mii_data'length then
                  mii_state <= idle;
                else
                  mii_state <= preamble;
                end if;
              end if;
            else
              mii_counter <= mii_counter + 1;
            end if;
          end if;
        when complete =>
          tx_eth_data_i <= X"0";
          tx_eth_enable_i <= '0';
          tx_eth_err_i <= '0';
          if tx_start = '0' then
            mii_state <= idle;
          end if;
      end case;
    end if;
  end process p_stimulus;

  tx_eth_enable     <= tx_eth_enable_i;
  tx_eth_data       <= tx_eth_data_i;
  tx_eth_err        <= tx_eth_err_i;

  ----------------------------------------------------------------------
  -- Monitor process. This process checks the data coming out of the
  -- transmitter to make sure that it matches that inserted into the
  -- receiver.
  ----------------------------------------------------------------------
  p_monitor : process(eth_clk)
  begin

    if rising_edge(eth_clk) then
      case rx_state is
        when idle =>
          -- Wait for preamble
          rx_error <= '0';
          if rx_eth_data_valid = '1' and rx_eth_data = X"5" and rx_start = '1' then
            rx_error_counter <= (others => '0');
            rx_frame_counter <= (others => '0');
            rx_state <= preamble;
            rx_data_counter <= (others => '0');
            rx_first_frame  <= '1';
          end if;
        when preamble =>
          if rx_start = '0' then
            rx_state <= idle;
          else
            -- We don't really care if the preamble is a bit short so just wait for SFD
            if rx_eth_data_valid = '1' and rx_eth_data = X"D" then
              rx_state <= frame;
              rx_frame_fcs <= x"00000000";
              rx_toggle <= false;
            elsif rx_eth_data_valid = '0' then
              -- Error condition
              rx_state <= ifg;
            end if;
          end if;
        when frame =>
          if rx_start = '0' then
            rx_state <= idle;
          else
            rx_toggle <= not rx_toggle;
            if rx_toggle then
              if rx_eth_data /= mii_data(to_integer(rx_data_counter))(7 downto 4) then
                -- Need to sync. up to the first frame in the sequence
                -- in a 2 board system.
                if rx_first_frame = '1' then
                  rx_state <= idle;
                else
                  rx_error <= '1';
                end if;
              else
                rx_first_frame <= '0';
              end if;
              rx_data_counter <= rx_data_counter + 1;
            else
              --if mii_data(to_integer(rx_data_counter))(8) = '0' then
              if rx_data_frame_end = '1' then
                rx_data_counter <= rx_data_counter + 1;
                rx_state <= fcs;
                if rx_eth_data /= rx_frame_fcs(3 downto 0) then
                  rx_error <= '1';
                end if;
              else
                if rx_eth_data_valid = '1' then
                  rx_frame_fcs <= calc_crc(mii_data(to_integer(rx_data_counter)), rx_frame_fcs);
                  if rx_eth_data /= mii_data(to_integer(rx_data_counter))(3 downto 0) then
                    -- Need to sync. up to the first frame in the sequence
                    -- in a 2 board system.
                    if rx_first_frame = '1' then
                      rx_state <= idle;
                    else
                      rx_error <= '1';
                    end if;
                  else
                    rx_first_frame <= '0';
                  end if;
                else
                  -- Error condition
                  rx_error <= '1';
                  rx_state <= ifg;
                end if;
              end if;
            end if;
          end if;
        when fcs =>
          if rx_start = '0' then
            rx_state <= idle;
          else
            if rx_eth_data_valid = '0' then
              rx_frame_counter <= rx_frame_counter + 1;
              rx_state <= ifg;
            end if;
          end if;
        when ifg =>
          if rx_start = '0' then
            rx_state <= idle;
          else
            if rx_error = '1' then
              rx_error_counter <= rx_error_counter + 1;
            end if;
            rx_error <= '0';
            if rx_start = '0' then
              rx_state <= idle;
            elsif rx_eth_data_valid = '1' and rx_eth_data = X"5" then
              rx_state <= preamble;
              --if rx_data_counter = mii_data'length then
              if rx_data_end = '1' then
                rx_data_counter <= (others => '0');
              end if;
            end if;
          end if;
        when complete => null;
      end case;
    end if;

  end process p_monitor;

  -- Register tx_eth_half onto the ethernet clock domain
  process(eth_clk)
  begin
    if rising_edge(eth_clk) then
      tx_eth_half_r  <= tx_eth_half;
      tx_eth_half_r2 <= tx_eth_half_r;
    end if;
  end process;

  -- Say that the monitor is ready whenever data is available
  -- This ensures that the logic is not optimized away.
  process(eth_clk)
  begin
    if rising_edge(eth_clk) then
      if rx_fifo_full = '1' or rx_fifo_almost_full = '1' then
        eth_rx_ready <= '1';
      else
        eth_rx_ready <= eth_rx_avail;
      end if;
    end if;
  end process;

  p_timing_regs : process(eth_clk)
  begin
    if rising_edge(eth_clk) then
      if rx_data_counter >= mii_data'length-1 then
        rx_data_end <= '1';
        rx_data_frame_end <= '1';
      else
        if mii_data(to_integer(rx_data_counter+1))(8) = '0' then
          rx_data_end <= '0';
          rx_data_frame_end <= '1';
        else
          rx_data_end <= '0';
          rx_data_frame_end <= '0';
        end if;
      end if;
    end if;
  end process;

end rtl;
