-----------------------------------------------------------------------
-- Title      : mu_law_encode
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : mu_law_encode.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: Performs a simple mu-law encoding of the input data
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

entity mu_law_encode is
  port(
    ap_clk    : in  std_logic;
    ap_rst    : in  std_logic;
    ap_ready  : out std_logic;
    pcm_val   : in  std_logic_vector(13 downto 0);
    ap_return : out std_logic_vector(7 downto 0)
    );
end mu_law_encode;

architecture rtl of mu_law_encode is
 
  signal data_in_reg    : std_logic_vector(13 downto 0);
  signal data_in_neg    : unsigned(12 downto 0);
  signal data_in_scaled : unsigned(12 downto 0);
  signal data_cw        : std_logic_vector(6 downto 0);
  signal ap_start_pipe  : std_logic_vector(3 downto 0);
    
begin

  -- Register the input
  data_in_reg_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        data_in_reg <= (others => '0');
      else
        data_in_reg <= pcm_val;
      end if;
    end if;
  end process;

  -- Check if the input is negative
  data_neg_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        data_in_neg <= (others => '0');
      else
        if data_in_reg(13) = '1' then
          data_in_neg <= unsigned(not(data_in_reg(12 downto 0)));
        else
          data_in_neg <= unsigned(data_in_reg(12 downto 0));
        end if;
      end if;
    end if;
  end process;
  
  -- Add 33 to the input data
  data_scaled_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        data_in_scaled <= (others => '0');
      else
        if (data_in_neg > 8158) then
          data_in_scaled <= "1111111011111"; --8159
        else
          data_in_scaled <= unsigned(data_in_neg) + 33;
        end if;
      end if;
    end if;
  end process;
  
  -- Encode the input data
  -- Biased Linear Input Code Compressed Code
  -- ------------------------ ---------------
  -- 00000001wxyza      000wxyz
  -- 0000001wxyzab      001wxyz
  -- 000001wxyzabc      010wxyz
  -- 00001wxyzabcd      011wxyz
  -- 0001wxyzabcde      100wxyz
  -- 001wxyzabcdef      101wxyz
  -- 01wxyzabcdefg      110wxyz
  -- 1wxyzabcdefgh      111wxyz
  encode_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        data_cw <= (others => '0');
      else
        if (data_in_scaled(12) = '1') then
          data_cw <= "111" & std_logic_vector(data_in_scaled(11 downto 8));
        elsif (data_in_scaled(11) = '1') then
          data_cw <= "110" & std_logic_vector(data_in_scaled(10 downto 7));
        elsif (data_in_scaled(10) = '1') then
          data_cw <= "101" & std_logic_vector(data_in_scaled(9 downto 6));
        elsif (data_in_scaled(9) = '1') then
          data_cw <= "100" & std_logic_vector(data_in_scaled(8 downto 5));
        elsif (data_in_scaled(8) = '1') then
          data_cw <= "011" & std_logic_vector(data_in_scaled(7 downto 4));
        elsif (data_in_scaled(7) = '1') then
          data_cw <= "010" & std_logic_vector(data_in_scaled(6 downto 3));
        elsif (data_in_scaled(6) = '1') then
          data_cw <= "001" & std_logic_vector(data_in_scaled(5 downto 2));
        else
          data_cw <= "000" & std_logic_vector(data_in_scaled(4 downto 1));
        end if;
      end if;
    end if;
  end process;
      
  ap_return <= not(data_in_reg(13)) & not(data_cw);
  
  -- Handshake signals
  hs_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        ap_ready <= '0';
      else
        ap_ready <= '1';
      end if;
    end if;
  end process;

end rtl;
