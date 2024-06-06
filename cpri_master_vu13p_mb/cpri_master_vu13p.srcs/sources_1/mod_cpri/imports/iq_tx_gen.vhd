-----------------------------------------------------------------------
-- Title      : iq_tx_gen
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : iq_tx_gen.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: Generates IQ Data
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

entity iq_tx_gen is
  port (
    clk               : in  std_logic;
    iq_tx_enable      : in  std_logic;
    speed             : in  std_logic_vector(14 downto 0);
    iq_tx             : out std_logic_vector(63 downto 0);
    nodebfn_tx_strobe : out std_logic;
    nodebfn_tx_nr     : out std_logic_vector(11 downto 0));
end entity;

architecture gen of iq_tx_gen is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of gen : architecture is "yes";

  constant bfc_max           : unsigned(15 downto 0) := x"95FF"; -- basic frame count 256x150=38400

  signal bfn_i               : unsigned(15 downto 0) := x"9400";  -- CHANGE ARBITRARY START UP BFN No.
  signal nodebfn_tx_nr_i     : unsigned(11 downto 0) := x"29A";   -- CHANGE ARBITRARY START UP NODEBFN No.
  signal iq_tx_cnt           : unsigned(15 downto 0) := (others => '0');
  signal iq_tx_max_cnt       : unsigned(15 downto 0) := (others => '0');
  signal byte_width          : unsigned(3 downto 0)  := x"4";
  signal nodebfn_tx_strobe_i : std_logic := '0';
  signal iq_tx_i             : std_logic_vector(63 downto 0);
  signal speed_r             : std_logic_vector(14 downto 0) := (others => '0');

begin

  -- Number of words in a basic frame
  iq_tx_max_count : process(clk)
  begin
    if rising_edge(clk) then
      case speed is
        when "000000000000001" => -- 0.6G
          iq_tx_max_cnt <= x"0008" - byte_width;
        when "000000000000010" => -- 1.2G
          iq_tx_max_cnt <= x"0010" - byte_width;
        when "000000000000100" => -- 2.4G
          iq_tx_max_cnt <= x"0020" - byte_width;
        when "000000000001000" => -- 3.0G
          iq_tx_max_cnt <= x"0028" - byte_width;
        when "000000000010000" => -- 4.9G
          iq_tx_max_cnt <= x"0040" - byte_width;
        when "000000000100000" => -- 6.1G
          iq_tx_max_cnt <= x"0050" - byte_width;
        when "000000001000000" => -- 9.8G
          iq_tx_max_cnt <= x"0080" - byte_width;
        when "000000010000000" => -- 10.1G
          iq_tx_max_cnt <= x"00A0" - byte_width;
        when "000000100000000" => -- 8.1G
          iq_tx_max_cnt <= x"0080" - byte_width;
        when "000001000000000" => -- 12.1G
          iq_tx_max_cnt <= x"00C0" - byte_width;
        when "000010000000000" => -- 24.3G
          iq_tx_max_cnt <= x"0180" - byte_width;
        when "000100000000000" => -- 8.1G FEC
          iq_tx_max_cnt <= x"0080" - byte_width;
        when "001000000000000" => -- 10.1G FEC
          iq_tx_max_cnt <= x"00A0" - byte_width;
        when "010000000000000" => -- 12.1G FEC
          iq_tx_max_cnt <= x"00C0" - byte_width;
        when "100000000000000" => -- 24.3G FEC
          iq_tx_max_cnt <= x"0180" - byte_width;
        when others =>
          iq_tx_max_cnt <= x"0000";
      end case;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      speed_r <= speed;
    end if;
  end process;

  -- Basic frame counter
  -- There are 38400 basic frames in a CPRI 10ms frame (150x256).
  -- Increment the Node B frame number and send a strobe every 10 ms.
  strobe_gen : process(clk)
  begin
    if rising_edge(clk) then
      if speed /= speed_r then
        iq_tx_cnt <= (others => '0');
        bfn_i <= x"9400";
        nodebfn_tx_nr_i <= x"29A";
      elsif iq_tx_enable = '1' then
        iq_tx_cnt <= x"000" & byte_width;
      elsif iq_tx_cnt = iq_tx_max_cnt then
        iq_tx_cnt <= (others => '0');
        if bfn_i = bfc_max then
          nodebfn_tx_nr_i <= nodebfn_tx_nr_i + 1;
          bfn_i <= (others => '0');
        else
          bfn_i <= bfn_i + 1;
        end if;
        if bfn_i = bfc_max - 1 then
          nodebfn_tx_strobe_i <= '1';
        else
          nodebfn_tx_strobe_i <= '0';
        end if;
      else
        iq_tx_cnt <= iq_tx_cnt + 4;
      end if;
      -- Register outputs
      iq_tx <= iq_tx_i;
      nodebfn_tx_nr     <= std_logic_vector(nodebfn_tx_nr_i);
      nodebfn_tx_strobe <= nodebfn_tx_strobe_i;
    end if;
  end process;


  iq_tx_i <= std_logic_vector(iq_tx_cnt+3) & std_logic_vector(iq_tx_cnt+2) & std_logic_vector(iq_tx_cnt+1) & std_logic_vector(iq_tx_cnt);

end architecture gen;
