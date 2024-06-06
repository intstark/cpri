-- Module cpri_slave_0_gt_gtye4_common_wrapper (a GT Wrapper)

-- (c) Copyright 2010-2019 Xilinx, Inc. All rights reserved.

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
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library cpri_v8_11_5;
use cpri_v8_11_5.all;
library gtwizard_ultrascale_v1_7_9;
use gtwizard_ultrascale_v1_7_9.all;

--***************************** Entity Declaration ****************************

entity cpri_slave_0_gt_gtye4_common_wrapper is
generic (
    -- Simulation attributes
    SIM_RESET_SPEEDUP       : string     :=  "false";        -- Set to "true" to speed up sim reset
    SIM_VERSION             : string     :=  "4.0");
port (
    GTREFCLK0_IN            : in  std_logic;
    QPLL0RESET_IN           : in  std_logic;
    QPLL0LOCKDETCLK_IN      : in  std_logic;	
    QPLL0PD_IN              : in  std_logic;
    QPLL0LOCK_OUT           : out std_logic;
    QPLL0OUTCLK_OUT         : out std_logic;
    QPLL0OUTREFCLK_OUT      : out std_logic;
    QPLL1RESET_IN           : in  std_logic;
    QPLL1LOCKDETCLK_IN      : in  std_logic;	
    QPLL1PD_IN              : in  std_logic;
    QPLL1LOCK_OUT           : out std_logic;
    QPLL1OUTCLK_OUT         : out std_logic;
    QPLL1OUTREFCLK_OUT      : out std_logic;
    speed_select            : in  std_logic_vector(14 downto 0)
    );
end cpri_slave_0_gt_gtye4_common_wrapper;

architecture RTL of cpri_slave_0_gt_gtye4_common_wrapper is

  component cpri_slave_0_gt_common
  port(
    GTYE4_COMMON_BGBYPASSB : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_BGMONITORENB : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_BGPDB : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_BGRCALOVRD : in std_logic_vector(4 downto 0);
    GTYE4_COMMON_BGRCALOVRDENB : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_DRPADDR : in std_logic_vector(15 downto 0);
    GTYE4_COMMON_DRPCLK : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_DRPDI : in std_logic_vector(15 downto 0);
    GTYE4_COMMON_DRPDO : out std_logic_vector(15 downto 0);
    GTYE4_COMMON_DRPEN : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_DRPRDY : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_DRPWE : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTGREFCLK0 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTGREFCLK1 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTNORTHREFCLK00 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTNORTHREFCLK01 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTNORTHREFCLK10 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTNORTHREFCLK11 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTREFCLK00 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTREFCLK01 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTREFCLK10 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTREFCLK11 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTSOUTHREFCLK00 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTSOUTHREFCLK01 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTSOUTHREFCLK10 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_GTSOUTHREFCLK11 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_PCIERATEQPLL0 : in std_logic_vector(2 downto 0);
    GTYE4_COMMON_PCIERATEQPLL1 : in std_logic_vector(2 downto 0);
    GTYE4_COMMON_PMARSVD0 : in std_logic_vector(7 downto 0);
    GTYE4_COMMON_PMARSVD1 : in std_logic_vector(7 downto 0);
    GTYE4_COMMON_PMARSVDOUT0 : out std_logic_vector(7 downto 0);
    GTYE4_COMMON_PMARSVDOUT1 : out std_logic_vector(7 downto 0);
    GTYE4_COMMON_QPLL0CLKRSVD0 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0CLKRSVD1 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0FBCLKLOST : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0FBDIV : in std_logic_vector(7 downto 0);
    GTYE4_COMMON_QPLL0LOCK : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0LOCKDETCLK : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0LOCKEN : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0OUTCLK : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0OUTREFCLK : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0PD : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0REFCLKLOST : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL0REFCLKSEL : in std_logic_vector(2 downto 0);
    GTYE4_COMMON_QPLL0RESET : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1CLKRSVD0 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1CLKRSVD1 : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1FBCLKLOST : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1FBDIV : in std_logic_vector(7 downto 0);
    GTYE4_COMMON_QPLL1LOCK : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1LOCKDETCLK : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1LOCKEN : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1OUTCLK : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1OUTREFCLK : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1PD : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1REFCLKLOST : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLL1REFCLKSEL : in std_logic_vector(2 downto 0);
    GTYE4_COMMON_QPLL1RESET : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_QPLLDMONITOR0 : out std_logic_vector(7 downto 0);
    GTYE4_COMMON_QPLLDMONITOR1 : out std_logic_vector(7 downto 0);
    GTYE4_COMMON_QPLLRSVD1 : in std_logic_vector(7 downto 0);
    GTYE4_COMMON_QPLLRSVD2 : in std_logic_vector(4 downto 0);
    GTYE4_COMMON_QPLLRSVD3 : in std_logic_vector(4 downto 0);
    GTYE4_COMMON_QPLLRSVD4 : in std_logic_vector(7 downto 0);
    GTYE4_COMMON_RCALENB : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_REFCLKOUTMONITOR0 : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_REFCLKOUTMONITOR1 : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_RXRECCLK0SEL : out std_logic_vector(1 downto 0);
    GTYE4_COMMON_RXRECCLK1SEL : out std_logic_vector(1 downto 0);
    GTYE4_COMMON_SDM0DATA : in std_logic_vector(24 downto 0);
    GTYE4_COMMON_SDM0FINALOUT : out std_logic_vector(3 downto 0);
    GTYE4_COMMON_SDM0RESET : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_SDM0TESTDATA : out std_logic_vector(14 downto 0);
    GTYE4_COMMON_SDM0TOGGLE : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_SDM0WIDTH : in std_logic_vector(1 downto 0);
    GTYE4_COMMON_SDM1DATA : in std_logic_vector(24 downto 0);
    GTYE4_COMMON_SDM1FINALOUT : out std_logic_vector(3 downto 0);
    GTYE4_COMMON_SDM1RESET : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_SDM1TESTDATA : out std_logic_vector(14 downto 0);
    GTYE4_COMMON_SDM1TOGGLE : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_SDM1WIDTH : in std_logic_vector(1 downto 0);
    GTYE4_COMMON_UBCFGSTREAMEN : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBDADDR : out std_logic_vector(15 downto 0);
    GTYE4_COMMON_UBDEN : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBDI : out std_logic_vector(15 downto 0);
    GTYE4_COMMON_UBDO : in std_logic_vector(15 downto 0);
    GTYE4_COMMON_UBDRDY : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBDWE : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBENABLE : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBGPI : in std_logic_vector(1 downto 0);
    GTYE4_COMMON_UBINTR : in std_logic_vector(1 downto 0);
    GTYE4_COMMON_UBIOLMBRST : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBMBRST : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBMDMCAPTURE : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBMDMDBGRST : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBMDMDBGUPDATE : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBMDMREGEN : in std_logic_vector(3 downto 0);
    GTYE4_COMMON_UBMDMSHIFT : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBMDMSYSRST : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBMDMTCK : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBMDMTDI : in std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBMDMTDO : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBRSVDOUT : out std_logic_vector(0 downto 0);
    GTYE4_COMMON_UBTXUART : out std_logic_vector(0 downto 0)
  );  end component;

  signal GTYE4_COMMON_DRPADDR : std_logic_vector(15 downto 0);
  signal GTYE4_COMMON_DRPCLK : std_logic;
  signal GTYE4_COMMON_DRPCLK_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_DRPDI : std_logic_vector(15 downto 0);
  signal GTYE4_COMMON_DRPDO : std_logic_vector(15 downto 0);
  signal GTYE4_COMMON_DRPEN : std_logic;
  signal GTYE4_COMMON_DRPEN_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_DRPRDY : std_logic;
  signal GTYE4_COMMON_DRPRDY_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_DRPWE : std_logic;
  signal GTYE4_COMMON_DRPWE_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_GTREFCLK00 : std_logic;
  signal GTYE4_COMMON_GTREFCLK00_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_GTREFCLK01 : std_logic;
  signal GTYE4_COMMON_GTREFCLK01_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL0LOCK : std_logic;
  signal GTYE4_COMMON_QPLL0LOCK_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL0LOCKDETCLK : std_logic;
  signal GTYE4_COMMON_QPLL0LOCKDETCLK_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL0OUTCLK : std_logic;
  signal GTYE4_COMMON_QPLL0OUTCLK_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL0OUTREFCLK : std_logic;
  signal GTYE4_COMMON_QPLL0OUTREFCLK_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL0PD : std_logic;
  signal GTYE4_COMMON_QPLL0PD_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL0RESET : std_logic;
  signal GTYE4_COMMON_QPLL0RESET_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL1LOCK : std_logic;
  signal GTYE4_COMMON_QPLL1LOCK_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL1LOCKDETCLK : std_logic;
  signal GTYE4_COMMON_QPLL1LOCKDETCLK_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL1OUTCLK : std_logic;
  signal GTYE4_COMMON_QPLL1OUTCLK_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL1OUTREFCLK : std_logic;
  signal GTYE4_COMMON_QPLL1OUTREFCLK_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL1PD : std_logic;
  signal GTYE4_COMMON_QPLL1PD_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_QPLL1RESET : std_logic;
  signal GTYE4_COMMON_QPLL1RESET_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_SDM0DATA : std_logic_vector(24 downto 0);
  signal GTYE4_COMMON_SDM0RESET : std_logic;
  signal GTYE4_COMMON_SDM0RESET_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_SDM0WIDTH : std_logic_vector(1 downto 0);
  signal GTYE4_COMMON_SDM1DATA : std_logic_vector(24 downto 0);
  signal GTYE4_COMMON_SDM1RESET : std_logic;
  signal GTYE4_COMMON_SDM1RESET_int : std_logic_vector(0 downto 0);
  signal GTYE4_COMMON_SDM1WIDTH : std_logic_vector(1 downto 0);


    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    type t_state is (idle,
                     read_0E, wait_for_0Er_rdy, write_0E, wait_for_0E_rdy,
                     read_8E, wait_for_8Er_rdy, write_8E, wait_for_8E_rdy,
                     read_18, wait_for_18r_rdy, write_18, wait_for_18_rdy,
                     read_98, wait_for_98r_rdy, write_98, wait_for_98_rdy,
                     read_14, wait_for_14r_rdy, write_14, wait_for_14_rdy,
                     read_94, wait_for_94r_rdy, write_94, wait_for_94_rdy,
                     read_19, wait_for_19r_rdy, write_19, wait_for_19_rdy,
                     read_99, wait_for_99r_rdy, write_99, wait_for_99_rdy,
                     write_11, wait_for_11_rdy, write_91, wait_for_91_rdy,
                     write_83, wait_for_83_rdy,
                     write_30, wait_for_30_rdy, write_B0, wait_for_B0_rdy,
                     write_0D, wait_for_0D_rdy, write_8D, wait_for_8D_rdy,
                     write_20, wait_for_20_rdy, write_A0, wait_for_A0_rdy,
                     write_08, wait_for_08_rdy, write_88, wait_for_88_rdy);

    signal speed_sm_state : t_state := idle;
    signal drp_rdy        : std_logic;
    signal drp_do         : std_logic_vector(15 downto 0);
    signal rdata          : std_logic_vector(15 downto 0);
    signal drp_addr       : std_logic_vector(8 downto 0);
    signal drp_di         : std_logic_vector(15 downto 0);
    signal drp_den        : std_logic;
    signal drp_wen        : std_logic;
    signal speed_select_r : std_logic_vector(10 downto 0);
    signal speed_select_i : std_logic_vector(10 downto 0);
    signal qpll_rst       : std_logic := '0';
    signal sdm0data       : std_logic_vector(24 downto 0);
    signal sdm1data       : std_logic_vector(24 downto 0);
    signal sdm0width      : std_logic_vector(1 downto 0);
    signal sdm1width      : std_logic_vector(1 downto 0);
    signal sdm0reset      : std_logic;
    signal sdm1reset      : std_logic;

begin

    -- Connect only required internal signals to GT Common block
    GTYE4_COMMON_GTREFCLK00      <= GTREFCLK0_IN;
    GTYE4_COMMON_QPLL0RESET      <= QPLL0RESET_IN or qpll_rst;
    GTYE4_COMMON_QPLL0LOCKDETCLK <= QPLL0LOCKDETCLK_IN;
    GTYE4_COMMON_QPLL0PD         <= QPLL0PD_IN;
    GTYE4_COMMON_GTREFCLK01      <= GTREFCLK0_IN;
    GTYE4_COMMON_QPLL1RESET      <= QPLL1RESET_IN or qpll_rst;
    GTYE4_COMMON_QPLL1LOCKDETCLK <= QPLL1LOCKDETCLK_IN;
    GTYE4_COMMON_QPLL1PD         <= QPLL1PD_IN;
    QPLL0LOCK_OUT                <= GTYE4_COMMON_QPLL0LOCK;
    QPLL0OUTCLK_OUT              <= GTYE4_COMMON_QPLL0OUTCLK;
    QPLL0OUTREFCLK_OUT           <= GTYE4_COMMON_QPLL0OUTREFCLK;
    QPLL1LOCK_OUT                <= GTYE4_COMMON_QPLL1LOCK;
    QPLL1OUTCLK_OUT              <= GTYE4_COMMON_QPLL1OUTCLK;
    QPLL1OUTREFCLK_OUT           <= GTYE4_COMMON_QPLL1OUTREFCLK;
    GTYE4_COMMON_DRPCLK          <= QPLL0LOCKDETCLK_IN;
    GTYE4_COMMON_DRPADDR         <= "0000000" & drp_addr;
    GTYE4_COMMON_DRPDI           <= drp_di;
    GTYE4_COMMON_DRPEN           <= drp_den;
    GTYE4_COMMON_DRPWE           <= drp_wen;
    drp_do                       <= GTYE4_COMMON_DRPDO;
    drp_rdy                      <= GTYE4_COMMON_DRPRDY;
    GTYE4_COMMON_SDM0DATA        <= sdm0data;
    GTYE4_COMMON_SDM0WIDTH       <= sdm0width;
    GTYE4_COMMON_SDM0RESET       <= sdm0reset;
    GTYE4_COMMON_SDM1DATA        <= sdm1data;
    GTYE4_COMMON_SDM1WIDTH       <= sdm1width;
    GTYE4_COMMON_SDM1RESET       <= sdm1reset;

      -- Map single bits to unit-length vectors...
  GTYE4_COMMON_DRPCLK_int(0) <= GTYE4_COMMON_DRPCLK;
  GTYE4_COMMON_DRPEN_int(0) <= GTYE4_COMMON_DRPEN;
  GTYE4_COMMON_DRPRDY <= GTYE4_COMMON_DRPRDY_int(0);
  GTYE4_COMMON_DRPWE_int(0) <= GTYE4_COMMON_DRPWE;
  GTYE4_COMMON_GTREFCLK00_int(0) <= GTYE4_COMMON_GTREFCLK00;
  GTYE4_COMMON_GTREFCLK01_int(0) <= GTYE4_COMMON_GTREFCLK01;
  GTYE4_COMMON_QPLL0LOCK <= GTYE4_COMMON_QPLL0LOCK_int(0);
  GTYE4_COMMON_QPLL0LOCKDETCLK_int(0) <= GTYE4_COMMON_QPLL0LOCKDETCLK;
  GTYE4_COMMON_QPLL0OUTCLK <= GTYE4_COMMON_QPLL0OUTCLK_int(0);
  GTYE4_COMMON_QPLL0OUTREFCLK <= GTYE4_COMMON_QPLL0OUTREFCLK_int(0);
  GTYE4_COMMON_QPLL0PD_int(0) <= GTYE4_COMMON_QPLL0PD;
  GTYE4_COMMON_QPLL0RESET_int(0) <= GTYE4_COMMON_QPLL0RESET;
  GTYE4_COMMON_QPLL1LOCK <= GTYE4_COMMON_QPLL1LOCK_int(0);
  GTYE4_COMMON_QPLL1LOCKDETCLK_int(0) <= GTYE4_COMMON_QPLL1LOCKDETCLK;
  GTYE4_COMMON_QPLL1OUTCLK <= GTYE4_COMMON_QPLL1OUTCLK_int(0);
  GTYE4_COMMON_QPLL1OUTREFCLK <= GTYE4_COMMON_QPLL1OUTREFCLK_int(0);
  GTYE4_COMMON_QPLL1PD_int(0) <= GTYE4_COMMON_QPLL1PD;
  GTYE4_COMMON_QPLL1RESET_int(0) <= GTYE4_COMMON_QPLL1RESET;
  GTYE4_COMMON_SDM0RESET_int(0) <= GTYE4_COMMON_SDM0RESET;
  GTYE4_COMMON_SDM1RESET_int(0) <= GTYE4_COMMON_SDM1RESET;


  -- Instance of GT
  cpri_slave_0_gt_common_i : cpri_slave_0_gt_common
  port map(
    GTYE4_COMMON_BGBYPASSB => "1",
    GTYE4_COMMON_BGMONITORENB => "1",
    GTYE4_COMMON_BGPDB => "1",
    GTYE4_COMMON_BGRCALOVRD => "10000",
    GTYE4_COMMON_BGRCALOVRDENB => "1",
    GTYE4_COMMON_DRPADDR => GTYE4_COMMON_DRPADDR,
    GTYE4_COMMON_DRPCLK => GTYE4_COMMON_DRPCLK_int,
    GTYE4_COMMON_DRPDI => GTYE4_COMMON_DRPDI,
    GTYE4_COMMON_DRPDO => GTYE4_COMMON_DRPDO,
    GTYE4_COMMON_DRPEN => GTYE4_COMMON_DRPEN_int,
    GTYE4_COMMON_DRPRDY => GTYE4_COMMON_DRPRDY_int,
    GTYE4_COMMON_DRPWE => GTYE4_COMMON_DRPWE_int,
    GTYE4_COMMON_GTGREFCLK0 => "0",
    GTYE4_COMMON_GTGREFCLK1 => "0",
    GTYE4_COMMON_GTNORTHREFCLK00 => "0",
    GTYE4_COMMON_GTNORTHREFCLK01 => "0",
    GTYE4_COMMON_GTNORTHREFCLK10 => "0",
    GTYE4_COMMON_GTNORTHREFCLK11 => "0",
    GTYE4_COMMON_GTREFCLK00 => GTYE4_COMMON_GTREFCLK00_int,
    GTYE4_COMMON_GTREFCLK01 => GTYE4_COMMON_GTREFCLK01_int,
    GTYE4_COMMON_GTREFCLK10 => "0",
    GTYE4_COMMON_GTREFCLK11 => "0",
    GTYE4_COMMON_GTSOUTHREFCLK00 => "0",
    GTYE4_COMMON_GTSOUTHREFCLK01 => "0",
    GTYE4_COMMON_GTSOUTHREFCLK10 => "0",
    GTYE4_COMMON_GTSOUTHREFCLK11 => "0",
    GTYE4_COMMON_PCIERATEQPLL0 => "000",
    GTYE4_COMMON_PCIERATEQPLL1 => "000",
    GTYE4_COMMON_PMARSVD0 => "00000000",
    GTYE4_COMMON_PMARSVD1 => "00000000",
    GTYE4_COMMON_PMARSVDOUT0 => open,
    GTYE4_COMMON_PMARSVDOUT1 => open,
    GTYE4_COMMON_QPLL0CLKRSVD0 => "0",
    GTYE4_COMMON_QPLL0CLKRSVD1 => "0",
    GTYE4_COMMON_QPLL0FBCLKLOST => open,
    GTYE4_COMMON_QPLL0FBDIV => "00000000",
    GTYE4_COMMON_QPLL0LOCK => GTYE4_COMMON_QPLL0LOCK_int,
    GTYE4_COMMON_QPLL0LOCKDETCLK => GTYE4_COMMON_QPLL0LOCKDETCLK_int,
    GTYE4_COMMON_QPLL0LOCKEN => "0",
    GTYE4_COMMON_QPLL0OUTCLK => GTYE4_COMMON_QPLL0OUTCLK_int,
    GTYE4_COMMON_QPLL0OUTREFCLK => GTYE4_COMMON_QPLL0OUTREFCLK_int,
    GTYE4_COMMON_QPLL0PD => GTYE4_COMMON_QPLL0PD_int,
    GTYE4_COMMON_QPLL0REFCLKLOST => open,
    GTYE4_COMMON_QPLL0REFCLKSEL => "001",
    GTYE4_COMMON_QPLL0RESET => GTYE4_COMMON_QPLL0RESET_int,
    GTYE4_COMMON_QPLL1CLKRSVD0 => "0",
    GTYE4_COMMON_QPLL1CLKRSVD1 => "0",
    GTYE4_COMMON_QPLL1FBCLKLOST => open,
    GTYE4_COMMON_QPLL1FBDIV => "00000000",
    GTYE4_COMMON_QPLL1LOCK => GTYE4_COMMON_QPLL1LOCK_int,
    GTYE4_COMMON_QPLL1LOCKDETCLK => GTYE4_COMMON_QPLL1LOCKDETCLK_int,
    GTYE4_COMMON_QPLL1LOCKEN => "1",
    GTYE4_COMMON_QPLL1OUTCLK => GTYE4_COMMON_QPLL1OUTCLK_int,
    GTYE4_COMMON_QPLL1OUTREFCLK => GTYE4_COMMON_QPLL1OUTREFCLK_int,
    GTYE4_COMMON_QPLL1PD => GTYE4_COMMON_QPLL1PD_int,
    GTYE4_COMMON_QPLL1REFCLKLOST => open,
    GTYE4_COMMON_QPLL1REFCLKSEL => "001",
    GTYE4_COMMON_QPLL1RESET => GTYE4_COMMON_QPLL1RESET_int,
    GTYE4_COMMON_QPLLDMONITOR0 => open,
    GTYE4_COMMON_QPLLDMONITOR1 => open,
    GTYE4_COMMON_QPLLRSVD1 => "00000000",
    GTYE4_COMMON_QPLLRSVD2 => "00000",
    GTYE4_COMMON_QPLLRSVD3 => "00000",
    GTYE4_COMMON_QPLLRSVD4 => "00000000",
    GTYE4_COMMON_RCALENB => "1",
    GTYE4_COMMON_REFCLKOUTMONITOR0 => open,
    GTYE4_COMMON_REFCLKOUTMONITOR1 => open,
    GTYE4_COMMON_RXRECCLK0SEL => open,
    GTYE4_COMMON_RXRECCLK1SEL => open,
    GTYE4_COMMON_SDM0DATA => GTYE4_COMMON_SDM0DATA,
    GTYE4_COMMON_SDM0FINALOUT => open,
    GTYE4_COMMON_SDM0RESET => GTYE4_COMMON_SDM0RESET_int,
    GTYE4_COMMON_SDM0TESTDATA => open,
    GTYE4_COMMON_SDM0TOGGLE => "0",
    GTYE4_COMMON_SDM0WIDTH => GTYE4_COMMON_SDM0WIDTH,
    GTYE4_COMMON_SDM1DATA => GTYE4_COMMON_SDM1DATA,
    GTYE4_COMMON_SDM1FINALOUT => open,
    GTYE4_COMMON_SDM1RESET => GTYE4_COMMON_SDM1RESET_int,
    GTYE4_COMMON_SDM1TESTDATA => open,
    GTYE4_COMMON_SDM1TOGGLE => "0",
    GTYE4_COMMON_SDM1WIDTH => GTYE4_COMMON_SDM1WIDTH,
    GTYE4_COMMON_UBCFGSTREAMEN => "0",
    GTYE4_COMMON_UBDADDR => open,
    GTYE4_COMMON_UBDEN => open,
    GTYE4_COMMON_UBDI => open,
    GTYE4_COMMON_UBDO => "0000000000000000",
    GTYE4_COMMON_UBDRDY => "0",
    GTYE4_COMMON_UBDWE => open,
    GTYE4_COMMON_UBENABLE => "0",
    GTYE4_COMMON_UBGPI => "00",
    GTYE4_COMMON_UBINTR => "00",
    GTYE4_COMMON_UBIOLMBRST => "0",
    GTYE4_COMMON_UBMBRST => "0",
    GTYE4_COMMON_UBMDMCAPTURE => "0",
    GTYE4_COMMON_UBMDMDBGRST => "0",
    GTYE4_COMMON_UBMDMDBGUPDATE => "0",
    GTYE4_COMMON_UBMDMREGEN => "0000",
    GTYE4_COMMON_UBMDMSHIFT => "0",
    GTYE4_COMMON_UBMDMSYSRST => "0",
    GTYE4_COMMON_UBMDMTCK => "0",
    GTYE4_COMMON_UBMDMTDI => "0",
    GTYE4_COMMON_UBMDMTDO => open,
    GTYE4_COMMON_UBRSVDOUT => open,
    GTYE4_COMMON_UBTXUART => open
  );



    speed_select_i(10) <= speed_select(10) or speed_select(14);
    speed_select_i(9)  <= speed_select(9)  or speed_select(13);
    speed_select_i(8)  <= speed_select(8)  or speed_select(11);
    speed_select_i(7)  <= speed_select(7)  or speed_select(12);
    speed_select_i(6 downto 0) <= speed_select(6 downto 0);

    -- Detect a speed change.
    speed_change_det : process(QPLL0LOCKDETCLK_IN)
    begin
      if rising_edge(QPLL0LOCKDETCLK_IN) then
        if (QPLL0RESET_IN = '1' and QPLL1RESET_IN = '1') then
          speed_select_r <= (others => '0');
        else
          speed_select_r <= speed_select_i;
        end if;
      end if;
    end process speed_change_det;

    ----------------------------------------------------------------------------------------------------------------
    -- DRP speed change state machine
    -- Dynamically switches between 24.33024G, 12.16512G, 10.1376G & 8.11008G line rates with a 245.76MHz ref clock.
    ----------------------------------------------------------------------------------------------------------------
    speed_change_sm : process(QPLL0LOCKDETCLK_IN)
    begin
      if rising_edge(QPLL0LOCKDETCLK_IN) then
        if (QPLL0RESET_IN = '1' and QPLL1RESET_IN = '1') then
          speed_sm_state <= idle;
          drp_addr <= (others => '0');
          drp_di   <= (others => '0');
          drp_den  <= '0';
          drp_wen  <= '0';
          rdata    <= (others => '0');
          qpll_rst <= '1';
        else
          case speed_sm_state is
            when idle =>
              drp_addr <= (others => '0');
              drp_di   <= (others => '0');
              drp_den  <= '0';
              drp_wen  <= '0';
              rdata    <= (others => '0');
              qpll_rst <= '0';
              if (speed_select_r(10 downto 7) /= speed_select_i(10 downto 7)) 
                and speed_select_i(10 downto 7) /= "0000" then
                speed_sm_state <= read_0E;
              end if;

            -- 0x0E holds QPLL0CLKOUT_RATE
            when read_0E =>
              drp_addr(7 downto 0) <= x"0E";
              drp_den              <= '1';
              drp_wen              <= '0';
              speed_sm_state       <= wait_for_0Er_rdy;
            when wait_for_0Er_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                rdata              <= drp_do;
                speed_sm_state     <= write_0E;
              end if;
            when write_0E =>
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>  -- 24.3G
                  drp_di <= rdata(15 downto 1) & '1';  -- FULL
                when others =>  -- 12.1G and below
                  drp_di <= rdata(15 downto 1) & '0';  -- HALF
              end case;
              speed_sm_state <= wait_for_0E_rdy;
            when wait_for_0E_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= read_8E;
              end if;

            -- 0x8E holds QPLL1CLKOUT_RATE
            when read_8E =>
              drp_addr(7 downto 0) <= x"8E";
              drp_den              <= '1';
              drp_wen              <= '0';
              speed_sm_state       <= wait_for_8Er_rdy;
            when wait_for_8Er_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                rdata              <= drp_do;
                speed_sm_state     <= write_8E;
              end if;
            when write_8E =>
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>  -- 24.3G
                  drp_di <= rdata(15 downto 1) & '1';  -- FULL
                when others =>  -- 12.1G and below
                  drp_di <= rdata(15 downto 1) & '0';  -- HALF
              end case;
              speed_sm_state <= wait_for_8E_rdy;
            when wait_for_8E_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= read_18;
              end if;

            -- 0x18 holds QPLL0_REFCLK_DIV
            when read_18 =>
              drp_addr(7 downto 0) <= x"18";
              drp_den              <= '1';
              drp_wen              <= '0';
              speed_sm_state       <= wait_for_18r_rdy;
            when wait_for_18r_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                rdata              <= drp_do;
                speed_sm_state     <= write_18;
              end if;
            when write_18 =>
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" | "01000000000" =>  --24.3G and 12.1G
                  drp_di <= rdata(15 downto 12) & "00000" & rdata(6 downto 0); -- M=2
                when others =>  -- 10.1G and below
                  drp_di <= rdata(15 downto 12) & "10000" & rdata(6 downto 0); -- M=1
              end case;
              speed_sm_state <= wait_for_18_rdy;
            when wait_for_18_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= read_98;
              end if;

            -- 0x98 holds QPLL1_REFCLK_DIV
            when read_98 =>
              drp_addr(7 downto 0) <= x"98";
              drp_den              <= '1';
              drp_wen              <= '0';
              speed_sm_state       <= wait_for_98r_rdy;
            when wait_for_98r_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                rdata              <= drp_do;
                speed_sm_state     <= write_98;
              end if;
            when write_98 =>
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" | "01000000000" =>  --24.3G and 12.1G
                  drp_di <= rdata(15 downto 12) & "00000" & rdata(6 downto 0); -- M=2
                when others =>  -- 10.1G and below
                  drp_di <= rdata(15 downto 12) & "10000" & rdata(6 downto 0); -- M=1
              end case;
              speed_sm_state       <= wait_for_98_rdy;
            when wait_for_98_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= read_14;
              end if;

            -- 0x14 holds QPLL0_FBDIV
            when read_14 =>
              drp_addr(7 downto 0) <= x"14";
              drp_den              <= '1';
              drp_wen              <= '0';
              speed_sm_state       <= wait_for_14r_rdy;
            when wait_for_14r_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                rdata              <= drp_do;
                speed_sm_state     <= write_14;
              end if;
            when write_14 =>
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" | "01000000000" =>  -- 24.3G and 12.1G
                  drp_di <= rdata(15 downto 8) & x"61"; -- N=99
                when "00100000000" =>  -- 8.1G
                  drp_di <= rdata(15 downto 8) & x"40"; -- N=66
                when "00010000000" =>  -- 10.1G
                  drp_di <= rdata(15 downto 8) & x"27"; -- N=41
                when others =>  -- 9.8G
                  drp_di <= rdata(15 downto 8) & x"26"; -- N=40
              end case;
              speed_sm_state       <= wait_for_14_rdy;
            when wait_for_14_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= read_94;
              end if;

            -- 0x94 holds QPLL1_FBDIV
            when read_94 =>
              drp_addr(7 downto 0) <= x"94";
              drp_den              <= '1';
              drp_wen              <= '0';
              speed_sm_state <= wait_for_94r_rdy;
            when wait_for_94r_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                rdata              <= drp_do;
                speed_sm_state     <= write_94;
              end if;
            when write_94 =>
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" | "01000000000" =>  -- 24.3G and 12.1G
                  drp_di <= rdata(15 downto 8) & x"61"; -- N=99
                when "00100000000" =>  -- 8.1G
                  drp_di <= rdata(15 downto 8) & x"1F"; -- N=33
                when "00010000000" =>  -- 10.1G
                  drp_di <= rdata(15 downto 8) & x"27"; -- N=41
                when others =>  -- 9.8G
                  drp_di <= rdata(15 downto 8) & x"26"; -- N=40
              end case;
              speed_sm_state       <= wait_for_94_rdy;
            when wait_for_94_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_11;
              end if;

            -- 0x11 holds QPLL0_CFG2
            --   24.3G : "0000111111000011"
            --   12.1G : "0000111111000011"
            --   10.1G : "0000111111000001"
            --    9.8G : "0000111111000001"
            --    8.1G : "0000111111000000"
            when write_11 =>
              drp_addr(7 downto 0) <= x"11";
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0000111111000011";
                when "01000000000" =>
                  drp_di <= "0000111111000011";
                when "00100000000" =>
                  drp_di <= "0000111111000000";
                when "00010000000" =>
                  drp_di <= "0000111111000001";
                when others =>
                  drp_di <= "0000111111000001";
              end case;          
              speed_sm_state       <= wait_for_11_rdy;
            when wait_for_11_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_91;
              end if;

            -- 0x91 holds QPLL1_CFG2
            --   24.3G : "0000111111000000"
            --   12.1G : "0000111111000000"
            --   10.1G : "0000111111000001"
            --    9.8G : "0000111111000001"
            --    8.1G : "0000111111000001"
            when write_91 =>
              drp_addr(7 downto 0) <= x"91";
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0000111111000000";
                when "01000000000" =>
                  drp_di <= "0000111111000000";
                when "00100000000" =>
                  drp_di <= "0000111111000001";
                when "00010000000" =>
                  drp_di <= "0000111111000001";
                when others =>
                  drp_di <= "0000111111000001";
              end case;       
              speed_sm_state       <= wait_for_91_rdy;
            when wait_for_91_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_30;
              end if;

            -- 0x30 holds QPLL0_CFG4
            --   24.3G : "0000000000000011"
            --   12.1G : "0000000000000010"
            --   10.1G : "0000000000000001"
            --    9.8G : "0000000000000001"
            --    8.1G : "0000000000000010"
            when write_30 =>
              drp_addr(7 downto 0) <= x"30";
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0000000000000011";
                when "01000000000" =>
                  drp_di <= "0000000000000010";
                when "00100000000" =>
                  drp_di <= "0000000000000010";
                when "00010000000" =>
                  drp_di <= "0000000000000001";
                when others =>
                  drp_di <= "0000000000000001";
              end case;             
              speed_sm_state       <= wait_for_30_rdy;
            when wait_for_30_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_B0;
              end if;

            -- 0xB0 holds QPLL1_CFG4
            --   24.3G : "0000000000000011"
            --   12.1G : "0000000000000010"
            --   10.1G : "0000000000000001"
            --    9.8G : "0000000000000001"
            --    8.1G : "0000000000000001"
            when write_B0 =>
              drp_addr(7 downto 0) <= x"B0";
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0000000000000011";
                when "01000000000" =>
                  drp_di <= "0000000000000010";
                when "00100000000" =>
                  drp_di <= "0000000000000001";
                when "00010000000" =>
                  drp_di <= "0000000000000001";
                when others =>
                  drp_di <= "0000000000000001";
              end case;              
              speed_sm_state       <= wait_for_B0_rdy;
            when wait_for_B0_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_83;
              end if;

            -- 0x83 holds BIAS_CFG2
            --   24.3G : "0000010100100100"
            --   12.1G : "0000010100100100"
            --   10.1G : "0000010100100100"
            --    9.8G : "0000010100100100"
            --    8.1G : "0000010100100100"
            when write_83 =>
              drp_addr(7 downto 0) <= x"83";
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0000010100100100";
                when "01000000000" =>
                  drp_di <= "0000010100100100";
                when "00100000000" =>
                  drp_di <= "0000010100100100";
                when "00010000000" =>
                  drp_di <= "0000010100100100";
                when others =>
                  drp_di <= "0000010100100100";
              end case;
              speed_sm_state       <= wait_for_83_rdy;
            when wait_for_83_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= read_19;
              end if;

              -- 0x19 holds QPLL0_LPF
              --   24.3G : "1000011111"
              --   12.1G : "1000011111"
              --   10.1G : "1101111111"
              --    9.8G : "1101111111"
              --    8.1G : "1100011101"
            when read_19 =>
              drp_addr(7 downto 0) <= x"19";
              drp_den              <= '1';
              drp_wen              <= '0';
              speed_sm_state       <= wait_for_19r_rdy;
            when wait_for_19r_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                rdata              <= drp_do;
                speed_sm_state     <= write_19;
              end if;
            when write_19 =>
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= rdata(15 downto 10) & "1000011111";
                when "01000000000" =>
                  drp_di <= rdata(15 downto 10) & "1000011111";
                when "00100000000" =>
                  drp_di <= rdata(15 downto 10) & "1100011101";
                when "00010000000" =>
                  drp_di <= rdata(15 downto 10) & "1101111111";
                when others =>
                  drp_di <= rdata(15 downto 10) & "1101111111";
              end case;
              speed_sm_state       <= wait_for_19_rdy;
            when wait_for_19_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= read_99;
              end if;

            -- 0x99 holds QPLL1_LPF
            --   24.3G : "1100111111"
            --   12.1G : "1100111111"
            --   10.1G : "1100111111"
            --    9.8G : "1100111111"
            --    8.1G : "1100111111"
            when read_99 =>
              drp_addr(7 downto 0) <= x"99";
              drp_den              <= '1';
              drp_wen              <= '0';
              speed_sm_state       <= wait_for_99r_rdy;
            when wait_for_99r_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                rdata              <= drp_do;
                speed_sm_state     <= write_99;
              end if;
            when write_99 =>
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= rdata(15 downto 10) & "1100111111";
                when "01000000000" =>
                  drp_di <= rdata(15 downto 10) & "1100111111";
                when "00100000000" =>
                  drp_di <= rdata(15 downto 10) & "1100111111";
                when "00010000000" =>
                  drp_di <= rdata(15 downto 10) & "1100111111";
                when others =>
                  drp_di <= rdata(15 downto 10) & "1100111111";
              end case;
              speed_sm_state       <= wait_for_99_rdy;

            when wait_for_99_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_0D;
              end if;

            -- 0x0D holds PPF0_CFG
            --   24.3G : "0000011000000000"
            --   12.1G : "0000011000000000"
            --   10.1G : "0000010000000000"
            --    9.8G : "0000010000000000"
            --    8.1G : "0000101100000000"
            when write_0D =>
              drp_den              <= '1';
              drp_wen              <= '1';
              drp_addr(7 downto 0) <= x"0D";
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0000011000000000";
                when "01000000000" =>
                  drp_di <= "0000011000000000";
                when "00100000000" =>
                  drp_di <= "0000101100000000";
                when "00010000000" =>
                  drp_di <= "0000010000000000";
                when others =>
                  drp_di <= "0000010000000000";
              end case;
              speed_sm_state       <= wait_for_0D_rdy;
            when wait_for_0D_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_8D;
              end if;

            -- 0x8D holds PPF1_CFG
            --   24.3G : "0000011000000000"
            --   12.1G : "0000011000000000"
            --   10.1G : "0000010000000000"
            --    9.8G : "0000010000000000"
            --    8.1G : "0000010000000000"
            when write_8D =>
              drp_den              <= '1';
              drp_wen              <= '1';
              drp_addr(7 downto 0) <= x"8D";
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0000011000000000";
                when "01000000000" =>
                  drp_di <= "0000011000000000";
                when "00100000000" =>
                  drp_di <= "0000010000000000";
                when "00010000000" =>
                  drp_di <= "0000010000000000";
                when others =>
                  drp_di <= "0000010000000000";
              end case;
              speed_sm_state       <= wait_for_8D_rdy;
            when wait_for_8D_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_08;
              end if;

            -- 0x08 holds QPLL0_CFG0
            --   24.3G : "0011001100011100"
            --   12.1G : "0011001100011100"
            --   10.1G : "0011001100011100"
            --    9.8G : "0011001100011100"
            --    8.1G : "0011001100111100"
            when write_08 =>
              drp_addr(7 downto 0) <= x"08";
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0011001100011100";
                when "01000000000" =>
                  drp_di <= "0011001100011100";
                when "00100000000" =>
                  drp_di <= "0011001100111100";
                when "00010000000" =>
                  drp_di <= "0011001100011100";
                when others =>
                  drp_di <= "0011001100011100";
              end case;
              speed_sm_state       <= wait_for_08_rdy;
            when wait_for_08_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_88;
              end if;

            when write_88 =>
              -- 0x88 holds QPLL1_CFG0
              --   24.3G : "0011001100011100"
              --   12.1G : "0011001100011100"
              --   10.1G : "0011001100011100"
              --    9.8G : "0011001100011100"
              --    8.1G : "0011001100011100"
              drp_addr(7 downto 0) <= x"88";
              drp_den              <= '1';
              drp_wen              <= '1';
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0011001100011100";
                when "01000000000" =>
                  drp_di <= "0011001100011100";
                when "00100000000" =>
                  drp_di <= "0011001100011100";
                when "00010000000" =>
                  drp_di <= "0011001100011100";
                when others =>
                  drp_di <= "0011001100011100";
              end case;
              speed_sm_state       <= wait_for_88_rdy;
            when wait_for_88_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_20;
              end if;

            -- 0x20 holds QPLL0_SDM_CFG0
            --   24.3G : "0000000010000000"
            --   12.1G : "0000000010000000"
            --   10.1G : "0000000000000000"
            --    9.8G : "0000000010000000"
            --    8.1G : "0000000010000000"
            when write_20 =>
              drp_den              <= '1';
              drp_wen              <= '1';
              drp_addr(7 downto 0) <= x"20";
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0000000010000000";
                when "01000000000" =>
                  drp_di <= "0000000010000000";
                when "00100000000" =>
                  drp_di <= "0000000010000000";
                when "00010000000" =>
                  drp_di <= "0000000000000000";
                when others =>
                  drp_di <= "0000000010000000";
              end case;
              speed_sm_state       <= wait_for_20_rdy;
            when wait_for_20_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                speed_sm_state     <= write_A0;
              end if;

            -- 0xA0 holds QPLL1_SDM_CFG0
            --   24.3G : "0000000010000000"
            --   12.1G : "0000000010000000"
            --   10.1G : "0000000000000000"
            --    9.8G : "0000000010000000"
            --    8.1G : "0000000010000000"
            when write_A0 =>
              drp_den              <= '1';
              drp_wen              <= '1';
              drp_addr(7 downto 0) <= x"A0";
              case speed_select_i is
                when "10000000000" =>
                  drp_di <= "0000000010000000";
                when "01000000000" =>
                  drp_di <= "0000000010000000";
                when "00100000000" =>
                  drp_di <= "0000000010000000";
                when "00010000000" =>
                  drp_di <= "0000000000000000";
                when others =>
                  drp_di <= "0000000010000000";
              end case;
              speed_sm_state       <= wait_for_A0_rdy;
            when wait_for_A0_rdy =>
              drp_den              <= '0';
              drp_wen              <= '0';
              if (drp_rdy = '1') then
                qpll_rst           <= '1';
                speed_sm_state     <= idle;
              end if;

            when others =>
              speed_sm_state       <= idle;
          end case;
        end if;
      end if;
    end process speed_change_sm;

    -- Assign gt common port inputs
    sdm0data  <= '0' & x"400000" when speed_select_i(7) = '1'  -- equates to 0.25
            else '0' & x"000000";
    sdm1data  <= '0' & x"400000" when speed_select_i(7) = '1'  -- equates to 0.25
            else '0' & x"000000";
    sdm0width <= "00";
    sdm1width <= "00";
    sdm0reset <= '0';
    sdm1reset <= '0';

end RTL;
