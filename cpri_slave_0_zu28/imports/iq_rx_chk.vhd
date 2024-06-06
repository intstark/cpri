-----------------------------------------------------------------------
-- Title      : iq_rx_chk
-- Project    : cpri_v8_11_5
-----------------------------------------------------------------------
-- File       : iq_rx_chk.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description: Generates IQ Data
-----------------------------------------------------------------------
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
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iq_rx_chk is
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
end entity;

architecture gen of iq_rx_chk is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of gen : architecture is "yes";

  signal iq_rx_reg       : std_logic_vector(63 downto 0);
  signal count           : unsigned (7 downto 0) := (others => '0');
  signal count2          : unsigned (8 downto 0) := (others => '0');
  signal frame_count_i   : unsigned(31 downto 0) := (others => '0');
  signal error_count_i   : unsigned(31 downto 0) := (others => '0');
  signal check_bytes     : std_logic_vector(7 downto 0);
  signal data_chk        : std_logic_vector(63 downto 0);
  signal error_in_byte   : std_logic;
  signal error_in_byte_r : std_logic;

begin

  -- Count through the bytes of the frame
  -- The data is an incrementing sequence.
  count_gen : process(clk)
  begin
    if rising_edge(clk) then
      if basic_frame_first_word = '1' then
        count  <= (others => '0');
        count2 <= (others => '0');
      else
        count  <= count + 1;
        count2 <= count2 + 4;
      end if;
    end if;
  end process;

  data_chk <= "0000000" & std_logic_vector(count2+3) &
              "0000000" & std_logic_vector(count2+2) &
              "0000000" & std_logic_vector(count2+1) &
              "0000000" & std_logic_vector(count2);

  -- Register the received data to line up with the count
  iq_rx_reg_gen : process(clk)
  begin
    if rising_edge(clk) then
      iq_rx_reg <= iq_rx;
    end if;
  end process;

  -- Count the number of frames received
  rx_count_gen : process(clk)
  begin
    if rising_edge(clk) then
      if enable = '0' then
        frame_count_i <= (others => '0');
      elsif basic_frame_first_word = '1' then
        frame_count_i <= frame_count_i + 1;
      end if;
    end if;
  end process;

  frame_count <= std_logic_vector(frame_count_i);

  -- Create signals to mask the control bytes at the start of the basic frame
  chk_gen : process(clk)
  begin
    if rising_edge(clk) then
      case speed is
        when "000000000000001" =>  -- 0.6G
          if count = "00000001" then
            check_bytes <= "11111110";
          else
            check_bytes <= "11111111";
          end if;
        when "000000000000010" =>  -- 1.2G
          if count = "00000011" then
            check_bytes <= "11111100";
          else
            check_bytes <= "11111111";
          end if;
        when "000000000000100" =>  -- 2.4G
          if count = "00000111" then
            check_bytes <= "11110000";
          else
            check_bytes <= "11111111";
          end if;
        when "000000000001000" =>  -- 3G
          if count = "00001001" then
            check_bytes <= "11100000";
          else
            check_bytes <= "11111111";
          end if;
        when "000000000010000" =>  -- 4.9G
          if count = "00001111" then
            check_bytes <= "00000000";
          else
            check_bytes <= "11111111";
          end if;
        when "000000000100000" =>  -- 6.1G
          if count = "00010011" then
            check_bytes <= "00000000";
          elsif count = "00000000" then
            check_bytes <= "11111100";
          else
            check_bytes <= "11111111";
          end if;
        when "000000001000000" =>  --9.8G
          if count = "00011111" or count = "00000000" then
            check_bytes <= "00000000";
          else
            check_bytes <= "11111111";
          end if;
        when "001000000000000" | "000000010000000" =>  -- 10.1G
          if count = "00100111" or count = "00000000" then
            check_bytes <= "00000000";
          else
            check_bytes <= "11111111";
          end if;
        when "000100000000000" | "000000100000000" =>  -- 8.1G
          if count = "00011111" or count = "00000000" then
            check_bytes <= "00000000";
          else
            check_bytes <= "11111111";
          end if;
        when "010000000000000" | "000001000000000" =>  -- 12.1G
          if count = "00101111" or count = "00000000" then
            check_bytes <= "00000000";
          else
            check_bytes <= "11111111";
          end if;
        when others =>  -- 24.3G
          if count = "01011111" or count = "00000000" then
            check_bytes <= "00000000";
          else
            check_bytes <= "11111111";
          end if;
      end case;
    end if;
  end process;

  -- Generate error count
  error_in_byte <= '1' when
    (check_bytes(7) = '1' and data_chk(63 downto 56) /= iq_rx_reg(63 downto 56)) or
    (check_bytes(6) = '1' and data_chk(55 downto 48) /= iq_rx_reg(55 downto 48)) or
    (check_bytes(5) = '1' and data_chk(47 downto 40) /= iq_rx_reg(47 downto 40)) or
    (check_bytes(4) = '1' and data_chk(39 downto 32) /= iq_rx_reg(39 downto 32)) or
    (check_bytes(3) = '1' and data_chk(31 downto 24) /= iq_rx_reg(31 downto 24)) or
    (check_bytes(2) = '1' and data_chk(23 downto 16) /= iq_rx_reg(23 downto 16)) or
    (check_bytes(1) = '1' and data_chk(15 downto 8)  /= iq_rx_reg(15 downto 8)) or
    (check_bytes(0) = '1' and data_chk(7 downto 0)   /= iq_rx_reg(7 downto 0))
    else '0';


  err_in_byte_r_gen : process(clk)
  begin
    if rising_edge(clk) then
      if enable = '0' then
        error_in_byte_r <= '0';
      else
        error_in_byte_r <= error_in_byte;
      end if;
    end if;
  end process;

  err_gen : process(clk)
  begin
    if rising_edge(clk) then
      if enable = '0' then
        error_count_i <= (others => '0');
        word_err <= '0';
      elsif error_in_byte_r = '1' then
        error_count_i <= error_count_i + 1;
        word_err <= '1';
      else
        word_err <= '0';
      end if;
    end if;
  end process;

  error_count <= std_logic_vector(error_count_i);

  -- Store RX NodeBFN number on RX strobe
  rxnodebfn_nr_gen : process(clk)
  begin
    if rising_edge(clk) then
      if enable = '0' then
        nodebfn_rx_nr_store <= (others => '0');
      elsif nodebfn_rx_strobe = '1' then
        nodebfn_rx_nr_store <= nodebfn_rx_nr;
      end if;
    end if;
  end process;

end architecture gen;
