-----------------------------------------------------------------------
-- Title      : mu_law_decode
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : mu_law_decode.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: Performs a simple mu-law decode of the input data
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

entity mu_law_decode is
  port(
    ap_clk                 : in  std_logic;
    ap_rst                 : in  std_logic;
    ap_start               : in  std_logic;
    ap_done                : out std_logic;
    ap_ready               : out std_logic;
    u_val                  : in  std_logic_vector(7 downto 0);
    ap_return              : out std_logic_vector(13 downto 0);
    speed                  : in  std_logic_vector(14 downto 0);
    basic_frame_first_word : in  std_logic);
end mu_law_decode;

architecture rtl of mu_law_decode is

  signal data_in                   : std_logic_vector(7 downto 0);
  signal ap_start_pipe             : std_logic_vector(3 downto 0);
  signal decoded_cw                : std_logic_vector(12 downto 0);
  signal decoded_cw_less_bias      : unsigned(12 downto 0);
  signal count                     : unsigned(7 downto 0) := (others => '0');
  signal mask_cpri_codeword        : std_logic;

begin

  -- Complement the input
  sample_in_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        data_in <= (others => '0');
      else
        if mask_cpri_codeword = '0' then
          data_in <= not(u_val);
        end if;
      end if;
    end if;
  end process;

  -- Decode the input data
  -- Compressed Code   Biased Linear Input Code
  -- ---------------   ------------------------
  --  000wxyz        00000001wxyza
  --  001wxyz        0000001wxyzab
  --  010wxyz        000001wxyzabc
  --  011wxyz        00001wxyzabcd
  --  100wxyz        0001wxyzabcde
  --  101wxyz        001wxyzabcdef
  --  110wxyz        01wxyzabcdefg
  --  111wxyz        1wxyzabcdefgg
  decode_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        decoded_cw <= (others => '0');
      else
        case(data_in(6 downto 4)) is
          when "000" => decoded_cw <= "00000001" & data_in(3 downto 0) & '1';
          when "001" => decoded_cw <= "0000001" & data_in(3 downto 0) & "01";
          when "010" => decoded_cw <= "000001" & data_in(3 downto 0) & "001";
          when "011" => decoded_cw <= "00001" & data_in(3 downto 0) & "0001";
          when "100" => decoded_cw <= "0001" & data_in(3 downto 0) & "00001";
          when "101" => decoded_cw <= "001" & data_in(3 downto 0) & "000001";
          when "110" => decoded_cw <= "01" & data_in(3 downto 0) & "0000001";
          when others => decoded_cw <= '1' & data_in(3 downto 0) & "00000001";
        end case;
      end if;
    end if;
  end process;

  -- Take the sign into account
  output_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        decoded_cw_less_bias <= (others => '0');
      else
        if data_in(7) = '1' then
          -- -ve number
          decoded_cw_less_bias <= unsigned(not(decoded_cw)) + 33;
        else
          -- +ve number
          decoded_cw_less_bias <= unsigned(decoded_cw) - 33;
        end if;
      end if;
    end if;
  end process;

  ap_return <= data_in(7) & std_logic_vector(decoded_cw_less_bias);

  -- Handshake signals
  hs_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        ap_done  <= '0';
        ap_ready <= '0';
        ap_start_pipe <= (others => '0');
      else
        ap_ready <= '1';
        ap_start_pipe(0) <= ap_start;
        ap_start_pipe(3 downto 1) <= ap_start_pipe(2 downto 0);
        ap_done <= ap_start_pipe(3);
      end if;
    end if;
  end process;

  -- Don't decode the CPRI codeword at the start of the basic frame
  count_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      if ap_rst = '1' then
        count <= (others => '0');
      else
        if basic_frame_first_word = '1' then
          count <= (others => '0');
        else
          count <= count + 1;
        end if;
      end if;
    end if;
  end process;


  -- Create signals to mask the control bytes at the
  -- start of the basic frame
  chk_gen : process(ap_clk)
  begin
    if rising_edge(ap_clk) then
      case speed is
        when "000000000000001" =>  -- 614
          if count = "00000000" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when "000000000000010" =>  -- 1228
          if count = "00000010" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when "000000000000100" =>  -- 2457
          if count = "00000110" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when "000000000001000" =>  -- 3072
          if count = "00001000" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when "000000000010000" =>  -- 4915
          if count = "00001110" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when "000000000100000" =>  -- 6144
          if count = "00010010" or count = "00010011" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when "000000001000000" =>  -- 9830
          if count = "00011110" or count = "00011111" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when "001000000000000" | "000000010000000" =>  -- 10137
          if count = "00100110" or count = "00100111" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when "000100000000000" | "000000100000000" =>  -- 8110
          if count = "00011110" or count = "00011111" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when "010000000000000" | "000001000000000" => -- 12165
          if count = "00101110" or count = "00101111" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;
        when others =>         -- 24330
          if count = "01011110" or count = "01011111" then
            mask_cpri_codeword <= '1';
          else
            mask_cpri_codeword <= '0';
          end if;

      end case;
    end if;
  end process;


end rtl;
