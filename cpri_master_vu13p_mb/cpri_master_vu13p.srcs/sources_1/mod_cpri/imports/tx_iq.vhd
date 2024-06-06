-----------------------------------------------------------------------
-- Title      : IQ channel mapper
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : tx_iq.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: 
-- This unit samples an input IQ channel of data width C_WIDTH when 
-- iq_tx_enable is asserted.
-- The data is then output in the correct position within the BFN
-- as defined by C_STARTBIT with I/Q bit interleaved as per the CPRI
-- specification.
-- Output data can be directly OR'ed with other tx_iq modules to provide 
-- CPRI core IQ Data input.
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

entity tx_iq is
  generic (
    C_WIDTH    : natural := 16;
    C_STARTBIT : natural := 32);
  port (
    clk          : in  std_logic;
    iq_tx_enable : in  std_logic;
    speed_select : in  std_logic_vector(14 downto 0);
    iq_i         : in  std_logic_vector(C_WIDTH-1 downto 0);
    iq_q         : in  std_logic_vector(C_WIDTH-1 downto 0);
    tx_data_iq   : out std_logic_vector(63 downto 0));
end entity tx_iq;

architecture rtl of tx_iq is

  signal enable_sr : std_logic_vector(95 downto 0)            := (others => '0');
  signal iq        : std_logic_vector(C_WIDTH*2+127 downto 0) := (others => '0');
  signal shift     : std_logic;
  signal shift_d   : std_logic                                := '0';

  -- which data cycle within the BFN will contain C_STARTBIT ?
  function find_cycle(
    constant startbit : in natural)
    return natural is
    variable cycle : integer;
  begin
    cycle := (startbit / 64) - 1;
    if cycle < 0 then
      cycle := 0;  -- start bit position is in the 1st data cycle
    end if;
    return natural(cycle);
  end function find_cycle;

begin

  -- Enable SR : 1 hot SR to identify the output data cycle within the Basic Frame
  process(clk)
  begin
    if rising_edge(clk) then
      enable_sr <= enable_sr(enable_sr'left-1 downto 0) & iq_tx_enable;
    end if;
  end process;

  -- Load the I/Q data from the input port when iq_tx_enable is asserted
  -- Loads into the correct position in the internal IQ shift register based on C_STARTBIT and speed_select
  -- Also interleaves the I/Q data bits
  process(clk)
  begin
    if rising_edge(clk) then
      if iq_tx_enable = '1' then
        -- load the IQ shift register, positioning I/Q data correctly
        -- Note in some cases this directly outputs data on the 1st cycle

        iq <= (others => '0');  -- default assignment, all bits zero

        if speed_select(0) = '1' then    -- 614
          if C_STARTBIT < 56 then
            -- 8-bit CW, output IQ Data required in the 1st cycle
            for k in 0 to C_WIDTH-1 loop
              iq(2*k + 0 + 8 + (C_STARTBIT mod 64)) <= iq_i(k);
              iq(2*k + 1 + 8 + (C_STARTBIT mod 64)) <= iq_q(k);
            end loop;
          else
            -- shift data to allow for 8-bit CW
            for k in 0 to C_WIDTH-1 loop
              iq(2*k + 0 + 64 + ((C_STARTBIT-56) mod 64)) <= iq_i(k);
              iq(2*k + 1 + 64 + ((C_STARTBIT-56) mod 64)) <= iq_q(k);
            end loop;
          end if;          

        elsif speed_select(1) = '1' then -- 1228
          if C_STARTBIT < 48 then
            -- 16-bit CW, output IQ Data required in the 1st cycle
            for k in 0 to C_WIDTH-1 loop
              iq(2*k + 0 + 16 + (C_STARTBIT mod 64)) <= iq_i(k);
              iq(2*k + 1 + 16 + (C_STARTBIT mod 64)) <= iq_q(k);
            end loop;
          else
            -- shift data to allow for 16-bit CW
            for k in 0 to C_WIDTH-1 loop
              iq(2*k + 0 + 64 + ((C_STARTBIT-48) mod 64)) <= iq_i(k);
              iq(2*k + 1 + 64 + ((C_STARTBIT-48) mod 64)) <= iq_q(k);
            end loop;
          end if;

        elsif speed_select(2) = '1' then -- 2457
          if C_STARTBIT < 32 then
            -- 32-bit CW, output IQ Data required in the 1st cycle
            for k in 0 to C_WIDTH-1 loop
              iq(2*k + 0 + 32 + (C_STARTBIT mod 64)) <= iq_i(k);
              iq(2*k + 1 + 32 + (C_STARTBIT mod 64)) <= iq_q(k);
            end loop;
          else
            -- shift data to allow for 32-bit CW
            for k in 0 to C_WIDTH-1 loop
              iq(2*k + 0 + 64 + ((C_STARTBIT-32) mod 64)) <= iq_i(k);
              iq(2*k + 1 + 64 + ((C_STARTBIT-32) mod 64)) <= iq_q(k);
            end loop;
          end if;

        elsif speed_select(3) = '1' then -- 3072
          if C_STARTBIT < 24 then
            -- 40-bit CW, output data required in the 1st cycle
            for k in 0 to C_WIDTH-1 loop
              iq(2*k + 0 + 40 + (C_STARTBIT mod 64)) <= iq_i(k);
              iq(2*k + 1 + 40 + (C_STARTBIT mod 64)) <= iq_q(k);
            end loop;
          else
            -- shift data to allow for 40-bit CW
            for k in 0 to C_WIDTH-1 loop
              iq(2*k + 0 + 64 + ((C_STARTBIT-24) mod 64)) <= iq_i(k);
              iq(2*k + 1 + 64 + ((C_STARTBIT-24) mod 64)) <= iq_q(k);
            end loop;
          end if;
        
        elsif speed_select(5) = '1' then -- 6144
          -- shift data to allow for 80-bit CW
          for k in 0 to C_WIDTH-1 loop
            iq(2*k + 0 + 64 + ((C_STARTBIT+16) mod 64)) <= iq_i(k);
            iq(2*k + 1 + 64 + ((C_STARTBIT+16) mod 64)) <= iq_q(k);
          end loop;

        else                             -- 4915/9830/10137/8110/12165/24330
          -- CW is a direct multiple of 64-bits
          for k in 0 to C_WIDTH-1 loop
            iq(2*k + 0 + 64 + (C_STARTBIT mod 64)) <= iq_i(k);
            iq(2*k + 1 + 64 + (C_STARTBIT mod 64)) <= iq_q(k);
          end loop;
        end if;
      else
        -- Shift the IQ shift register by 64 bits when enabled
        if shift = '1' then
          -- shift down by 64 bits 
          iq(C_WIDTH*2+63 downto 0) <= iq(iq'left downto 64);

          -- fill upper bits with 0
          iq(iq'left downto iq'left-64) <= (others => '0');
        end if;
      end if;
    end if;

  end process;

  -- Depending on speed, adjust for the length of CPRI control word &
  -- enable the IQ shift register to output data in the correct cycle
  process(shift_d, speed_select, enable_sr)
  begin
    if speed_select(0) = '1' then    
      shift <= shift_d or enable_sr(find_cycle(C_STARTBIT+8));    --  614 8 bit CW
    elsif speed_select(1) = '1' then 
      shift <= shift_d or enable_sr(find_cycle(C_STARTBIT+16));   -- 1228 16 bit CW
    elsif speed_select(2) = '1' then 
      shift <= shift_d or enable_sr(find_cycle(C_STARTBIT+32));   -- 2467 32 bit CW
    elsif speed_select(3) = '1' then 
      shift <= shift_d or enable_sr(find_cycle(C_STARTBIT+40));   -- 3072 40 bit CW
    elsif speed_select(4) = '1' then 
      shift <= shift_d or enable_sr(find_cycle(C_STARTBIT+64));   -- 4915 64 bit CW
    elsif speed_select(5) = '1' then 
      shift <= shift_d or enable_sr(find_cycle(C_STARTBIT+80));   -- 6144 80 bit CW
    else                             
      shift <= shift_d or enable_sr(find_cycle(C_STARTBIT+128));  -- 9830/8110 & above 128 bit CW
    end if;
  end process;

  -- Register shift
  process(clk)
  begin
    if rising_edge(clk) then
      if iq_tx_enable = '1' then
        shift_d <= '0';
      else
        shift_d <= shift;
      end if;
    end if;
  end process;

  -- Mapped IQ Output is the LS 64 bits of the shifter
  -- This can be directly OR'ed with other tx_iq modules to provide CPRI core IQ Data input
  tx_data_iq <= iq(63 downto 0);

end architecture rtl;


