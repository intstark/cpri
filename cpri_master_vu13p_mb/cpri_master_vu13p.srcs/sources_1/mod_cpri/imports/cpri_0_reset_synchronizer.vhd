-----------------------------------------------------------------------
-- Title      : Reset Synchronizer
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : cpri_0_reset_synchronizer.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: Synchronizes a reset safely into another clock domain.
-- Generates a reset signal which has a falling edge synchronous with CLK; this
-- allows predictable reset recovery even with blocks with async reset
-- requirements. 
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

library xpm;
use xpm.vcomponents.all;

entity cpri_0_reset_synchronizer is

  port (
    reset_in  : in  std_logic;          -- Active high asynchronous reset
    clk       : in  std_logic;          -- clock to be sync'ed to
    reset_out : out std_logic);         -- "Synchronised" reset signal

end cpri_0_reset_synchronizer;

-------------------------------------------------------------------------------

architecture rtl of cpri_0_reset_synchronizer is

begin  -- rtl

  cdc_async_rst_i : xpm_cdc_async_rst
  generic map (
    RST_ACTIVE_HIGH  => 1
  )
  port map (
    src_arst         => reset_in,
    dest_clk         => clk,
    dest_arst        => reset_out
  );

end rtl;
