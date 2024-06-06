-----------------------------------------------------------------------
-- Title      : tx_prbs
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : tx_prbs.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: PRBS counter used by the HDLC and vendor specific 
-- data generators and monitors.
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

entity tx_prbs is
    port ( clk   : in  std_logic;
           ce    : in  std_logic;
           sclr  : in  std_logic;
           q     : out std_logic);
end tx_prbs;

architecture behavioral of tx_prbs is
  signal shift_data : std_logic_vector(7 downto 0) := (others => '1');

begin
  -- purpose: perform shift of bottom section on clock edge
  -- type   : sequential
  -- inputs : clk, sclr, d, ce
  -- outputs: q
  s1: process (clk)
  begin  -- process s1
    if clk'event and clk = '1' then   -- rising clock edge
      if sclr = '1' then
        -- 01111110 is the HDLC start of frame pattern.
        shift_data(7 downto 1) <= "0111111";
      elsif ce = '1' then
        shift_data(7 downto 1) <= shift_data(6 downto 1) & shift_data(0);
      end if;
    end if;
  end process s1;

  -- purpose: perform shift of bit0 on clock edge
  -- type   : sequential
  -- inputs : clk, sclr, shift_data
  -- outputs: shift_data(0)
  s3: process (clk)
  begin  -- process s3
    if clk'event and clk = '1' then  -- rising clock edge
      if sclr = '1' then
        shift_data(0) <= '0';
      elsif ce = '1' then
        shift_data(0) <= shift_data(3) xor shift_data(4) xor shift_data(5)
                         xor shift_data(7);
      end if;
    end if;
  end process s3;

  q <= shift_data(7);

end behavioral;
