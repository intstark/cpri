-----------------------------------------------------------------------
-- Title      : IQ Channel demapper
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : rx_iq.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: 
-- This unit demultiplexes/de-interleaves an IQ channel of data width
-- C_WIDTH from CPRI core Rx IQ data output.
-- Channel position within the BFN is defined by C_STARTBIT.
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

entity rx_iq_64 is
  generic (
    C_WIDTH    : natural := 20;
    C_STARTBIT : natural := 80);
  port (
    clk                    : in  std_logic;
    rx_data                : in  std_logic_vector(63 downto 0);
    speed_select           : in  std_logic_vector(14 downto 0);
    basic_frame_first_word : in  std_logic;
    rx_i                   : out std_logic_vector(C_WIDTH-1 downto 0);
    rx_q                   : out std_logic_vector(C_WIDTH-1 downto 0));
end entity rx_iq_64;

architecture rtl of rx_iq_64 is

  -- which data cycle within the BFN contains I(index) ?
  function find_i_cycle (
    constant startbit : in natural;
    constant index    : in natural)
    return natural is
  begin
    return((startbit + index*2)/64);
  end function find_i_cycle;

  -- which data cycle within the BFN contains Q(index) ?
  function find_q_cycle (
    constant startbit : in natural;
    constant index    : in natural)
    return natural is
  begin
    return((startbit + index*2 + 1)/64);
  end function find_q_cycle;

  -- which rx_data bit contains I(index) ?
  function find_i_bit(
    constant startbit : natural;
    constant index    : natural)
    return natural is
  begin
    return (startbit + (2*index)) mod 64;
  end function find_i_bit;

  -- which rx_data bit contains Q(index) ?
  function find_q_bit (
    constant startbit : natural;
    constant index    : natural)
    return natural is
  begin
    return (startbit + (2*index) + 1) mod 64;
  end function find_q_bit;

  signal bfn_cycle_sr : std_logic_vector(94 downto 0)        := (others => '0');
  signal bfn_cycle    : std_logic_vector(95 downto 0);

  signal rxi          : std_logic_vector(C_WIDTH-1 downto 0) := (others => '0');
  signal rxq          : std_logic_vector(C_WIDTH-1 downto 0) := (others => '0');

  --## debug
  signal i_enable : std_logic_vector(C_WIDTH-1 downto 0);
  signal q_enable : std_logic_vector(C_WIDTH-1 downto 0);


begin

  -- Cycle ID SR : 1 hot SR to identify the input data cycle within the Basic Frame
  process(clk)
  begin
    if rising_edge(clk) then
      bfn_cycle_sr <= bfn_cycle_sr(bfn_cycle_sr'left-1 downto 0) & basic_frame_first_word;
    end if;
  end process;

  bfn_cycle <= bfn_cycle_sr & basic_frame_first_word;

  -- Demux I/Q data bits

  I: for b in 0 to C_WIDTH-1 generate
    -- Data bit within the 64-bit data is fixed in one of 5 positions dependant on the speed (CW length)
    constant bit_pos0 : natural := find_i_bit(C_STARTBIT,      b); -- bit position for speeds 4915, 9830>
    constant bit_pos1 : natural := find_i_bit(C_STARTBIT+8,    b); -- bit position for speed   614
    constant bit_pos2 : natural := find_i_bit(C_STARTBIT+16,   b); -- bit position for speeds 1228, 6144
    constant bit_pos3 : natural := find_i_bit(C_STARTBIT+32,   b); -- bit position for speed  2457
    constant bit_pos4 : natural := find_i_bit(C_STARTBIT+40,   b); -- bit position for speed  3072

    signal enable_cycle : std_logic;

  begin

    -- Data cycle within the BFN is identified by selecting the correct bfn_cycle index as clock enable
    -- This varies with speed due to the different CW sizes
    enable_select: process(speed_select, bfn_cycle)
    begin
      if speed_select(0) = '1' then    --  614 8 bit CW
        enable_cycle <= bfn_cycle(find_i_cycle(C_STARTBIT+8,  b));
      elsif speed_select(1) = '1' then -- 1228 16 bit CW
        enable_cycle <= bfn_cycle(find_i_cycle(C_STARTBIT+16, b));
      elsif speed_select(2) = '1' then -- 2467 32 bit CW
        enable_cycle <= bfn_cycle(find_i_cycle(C_STARTBIT+32, b));
      elsif speed_select(3) = '1' then -- 3072 40 bit CW
        enable_cycle <= bfn_cycle(find_i_cycle(C_STARTBIT+40, b));
      elsif speed_select(4) = '1' then -- 4915 64 bit CW
        enable_cycle <= bfn_cycle(find_i_cycle(C_STARTBIT+64, b));
      elsif speed_select(5) = '1' then -- 6144 80 bit CW
        enable_cycle <= bfn_cycle(find_i_cycle(C_STARTBIT+80, b));
      else                             -- 9830/8110 & above 128 bit CW
        enable_cycle <= bfn_cycle(find_i_cycle(C_STARTBIT+128, b));
      end if;
    end process;
    i_enable(b) <= enable_cycle;

    demux: process(clk)
    begin
      if rising_edge(clk) then
        if enable_cycle = '1' then
          if (speed_select(0) = '1') then                         -- 614
            rxi(b) <= rx_data(bit_pos1);
          elsif (speed_select(1) or speed_select(5)) = '1' then   -- 1228, 6144
            rxi(b) <= rx_data(bit_pos2);
          elsif (speed_select(2) = '1') then                      -- 2457
            rxi(b) <= rx_data(bit_pos3);
          elsif (speed_select(3) = '1') then                      -- 3072
            rxi(b) <= rx_data(bit_pos4);
          else                                                    -- 4915, 9830 & above
            rxi(b) <= rx_data(bit_pos0);
          end if;
        end if;
      end if;
    end process;

  end generate I;

  Q: for b in 0 to C_WIDTH-1 generate
    -- Data bit within the 64-bit data is fixed in one of 5 positions dependant on the speed (CW length)
    constant bit_pos0 : natural := find_q_bit(C_STARTBIT,      b); -- bit position for speeds 4915, 9830>
    constant bit_pos1 : natural := find_q_bit(C_STARTBIT+8,    b); -- bit position for speed   614
    constant bit_pos2 : natural := find_q_bit(C_STARTBIT+16,   b); -- bit position for speeds 1228, 6144
    constant bit_pos3 : natural := find_q_bit(C_STARTBIT+32,   b); -- bit position for speed  2457
    constant bit_pos4 : natural := find_q_bit(C_STARTBIT+40,   b); -- bit position for speed  3072

    signal enable_cycle : std_logic;

  begin
    
    -- Data cycle within the BFN is identified by selecting the correct bfn_cycle index as clock enable
    -- This varies with speed due to the different CW sizes
    enable_select: process(speed_select, bfn_cycle)
    begin
      if speed_select(0) = '1' then    --  614 8 bit CW
        enable_cycle <= bfn_cycle(find_q_cycle(C_STARTBIT+8,  b));
      elsif speed_select(1) = '1' then -- 1228 16 bit CW
        enable_cycle <= bfn_cycle(find_q_cycle(C_STARTBIT+16, b));
      elsif speed_select(2) = '1' then -- 2467 32 bit CW
        enable_cycle <= bfn_cycle(find_q_cycle(C_STARTBIT+32, b));
      elsif speed_select(3) = '1' then -- 3072 40 bit CW
        enable_cycle <= bfn_cycle(find_q_cycle(C_STARTBIT+40, b));
      elsif speed_select(4) = '1' then -- 4915 64 bit CW
        enable_cycle <= bfn_cycle(find_q_cycle(C_STARTBIT+64, b));
      elsif speed_select(5) = '1' then -- 6144 80 bit CW
        enable_cycle <= bfn_cycle(find_q_cycle(C_STARTBIT+80, b));
      else                             -- 9830/8110 & above 128 bit CW
        enable_cycle <= bfn_cycle(find_q_cycle(C_STARTBIT+128, b));
      end if;
    end process;
    q_enable(b) <= enable_cycle;

    demux: process(clk)
    begin
      if rising_edge(clk) then
        if enable_cycle = '1' then
          if (speed_select(0) = '1') then                         -- 614
            rxq(b) <= rx_data(bit_pos1);
          elsif (speed_select(1) or speed_select(5)) = '1' then   -- 1228, 6144
            rxq(b) <= rx_data(bit_pos2);
          elsif (speed_select(2) = '1') then                      -- 2457
            rxq(b) <= rx_data(bit_pos3);
          elsif (speed_select(3) = '1') then                      -- 3072
            rxq(b) <= rx_data(bit_pos4);
          else                                                    -- 4915, 9830 & above
            rxq(b) <= rx_data(bit_pos0);
          end if;
        end if;
      end if;
    end process;
  end generate Q;

  -- Outputs 
  rx_i <= rxi;
  rx_q <= rxq;

end architecture rtl;

