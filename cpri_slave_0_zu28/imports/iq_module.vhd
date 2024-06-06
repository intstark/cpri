-----------------------------------------------------------------------
-- Title      : Top entity for CPRI core UTRA-FDD IQ Module
-- Project    : cpri_v8_11_5
-----------------------------------------------------------------------
-- File       : iq_module.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description:
-- This is the top entity for the CPRI IQ Data Module for UTRA-FDD
--
-----------------------------------------------------------------------
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
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iq_module is
  generic (
    C_TX_WIDTH_1  : natural :=  10;
    C_TX_START_1  : natural :=   0;
    C_RX_WIDTH_1  : natural :=  10;
    C_RX_START_1  : natural :=   0;

    C_TX_WIDTH_2  : natural :=  10;
    C_TX_START_2  : natural :=  20;
    C_RX_WIDTH_2  : natural :=  10;
    C_RX_START_2  : natural :=  20;

    C_TX_WIDTH_3  : natural :=  10;
    C_TX_START_3  : natural :=  40;
    C_RX_WIDTH_3  : natural :=  10;
    C_RX_START_3  : natural :=  40;

    C_TX_WIDTH_4  : natural :=  10;
    C_TX_START_4  : natural :=  60;
    C_RX_WIDTH_4  : natural :=  10;
    C_RX_START_4  : natural :=  60;

    C_TX_WIDTH_5  : natural :=  10;
    C_TX_START_5  : natural :=  80;
    C_RX_WIDTH_5  : natural :=  10;
    C_RX_START_5  : natural :=  80;

    C_TX_WIDTH_6  : natural :=  10;
    C_TX_START_6  : natural := 100;
    C_RX_WIDTH_6  : natural :=  10;
    C_RX_START_6  : natural := 100;

    C_TX_WIDTH_7  : natural :=   0;
    C_TX_START_7  : natural := 120;
    C_RX_WIDTH_7  : natural :=   0;
    C_RX_START_7  : natural := 120;

    C_TX_WIDTH_8  : natural :=   0;
    C_TX_START_8  : natural := 140;
    C_RX_WIDTH_8  : natural :=   0;
    C_RX_START_8  : natural := 140;

    C_TX_WIDTH_9  : natural :=   0;
    C_TX_START_9  : natural := 160;
    C_RX_WIDTH_9  : natural :=   0;
    C_RX_START_9  : natural := 160;

    C_TX_WIDTH_10 : natural :=   0;
    C_TX_START_10 : natural := 180;
    C_RX_WIDTH_10 : natural :=   0;
    C_RX_START_10 : natural := 180;

    C_TX_WIDTH_11 : natural :=   0;
    C_TX_START_11 : natural := 200;
    C_RX_WIDTH_11 : natural :=   0;
    C_RX_START_11 : natural := 200;

    C_TX_WIDTH_12 : natural :=   0;
    C_TX_START_12 : natural := 220;
    C_RX_WIDTH_12 : natural :=   0;
    C_RX_START_12 : natural := 220;

    C_TX_WIDTH_13 : natural :=   0;
    C_TX_START_13 : natural := 240;
    C_RX_WIDTH_13 : natural :=   0;
    C_RX_START_13 : natural := 240;

    C_TX_WIDTH_14 : natural :=   0;
    C_TX_START_14 : natural := 260;
    C_RX_WIDTH_14 : natural :=   0;
    C_RX_START_14 : natural := 260;

    C_TX_WIDTH_15 : natural :=   0;
    C_TX_START_15 : natural := 280;
    C_RX_WIDTH_15 : natural :=   0;
    C_RX_START_15 : natural := 280;

    C_TX_WIDTH_16 : natural :=   0;
    C_TX_START_16 : natural := 300;
    C_RX_WIDTH_16 : natural :=   0;
    C_RX_START_16 : natural := 300;

    C_TX_WIDTH_17 : natural :=   0;
    C_TX_START_17 : natural := 320;
    C_RX_WIDTH_17 : natural :=   0;
    C_RX_START_17 : natural := 320;

    C_TX_WIDTH_18 : natural :=   0;
    C_TX_START_18 : natural := 340;
    C_RX_WIDTH_18 : natural :=   0;
    C_RX_START_18 : natural := 340;

    C_TX_WIDTH_19 : natural :=   0;
    C_TX_START_19 : natural := 360;
    C_RX_WIDTH_19 : natural :=   0;
    C_RX_START_19 : natural := 360;

    C_TX_WIDTH_20 : natural :=   0;
    C_TX_START_20 : natural := 380;
    C_RX_WIDTH_20 : natural :=   0;
    C_RX_START_20 : natural := 380;

    C_TX_WIDTH_21 : natural :=   0;
    C_TX_START_21 : natural := 400;
    C_RX_WIDTH_21 : natural :=   0;
    C_RX_START_21 : natural := 400;

    C_TX_WIDTH_22 : natural :=   0;
    C_TX_START_22 : natural := 420;
    C_RX_WIDTH_22 : natural :=   0;
    C_RX_START_22 : natural := 420;

    C_TX_WIDTH_23 : natural :=   0;
    C_TX_START_23 : natural := 440;
    C_RX_WIDTH_23 : natural :=   0;
    C_RX_START_23 : natural := 440;

    C_TX_WIDTH_24 : natural :=   0;
    C_TX_START_24 : natural := 460;
    C_RX_WIDTH_24 : natural :=   0;
    C_RX_START_24 : natural := 460;

    C_TX_WIDTH_25 : natural :=   0;
    C_TX_START_25 : natural := 480;
    C_RX_WIDTH_25 : natural :=   0;
    C_RX_START_25 : natural := 480;

    C_TX_WIDTH_26 : natural :=   0;
    C_TX_START_26 : natural := 500;
    C_RX_WIDTH_26 : natural :=   0;
    C_RX_START_26 : natural := 500;

    C_TX_WIDTH_27 : natural :=   0;
    C_TX_START_27 : natural := 520;
    C_RX_WIDTH_27 : natural :=   0;
    C_RX_START_27 : natural := 520;

    C_TX_WIDTH_28 : natural :=   0;
    C_TX_START_28 : natural := 540;
    C_RX_WIDTH_28 : natural :=   0;
    C_RX_START_28 : natural := 540;

    C_TX_WIDTH_29 : natural :=   0;
    C_TX_START_29 : natural := 560;
    C_RX_WIDTH_29 : natural :=   0;
    C_RX_START_29 : natural := 560;

    C_TX_WIDTH_30 : natural :=   0;
    C_TX_START_30 : natural := 580;
    C_RX_WIDTH_30 : natural :=   0;
    C_RX_START_30 : natural := 580;

    C_TX_WIDTH_31 : natural :=   0;
    C_TX_START_31 : natural := 600;
    C_RX_WIDTH_31 : natural :=   0;
    C_RX_START_31 : natural := 600;

    C_TX_WIDTH_32 : natural :=   0;
    C_TX_START_32 : natural := 620;
    C_RX_WIDTH_32 : natural :=   0;
    C_RX_START_32 : natural := 620;

    C_TX_WIDTH_33 : natural :=   0;
    C_TX_START_33 : natural := 640;
    C_RX_WIDTH_33 : natural :=   0;
    C_RX_START_33 : natural := 640;

    C_TX_WIDTH_34 : natural :=   0;
    C_TX_START_34 : natural := 660;
    C_RX_WIDTH_34 : natural :=   0;
    C_RX_START_34 : natural := 660;

    C_TX_WIDTH_35 : natural :=   0;
    C_TX_START_35 : natural := 680;
    C_RX_WIDTH_35 : natural :=   0;
    C_RX_START_35 : natural := 680;

    C_TX_WIDTH_36 : natural :=   0;
    C_TX_START_36 : natural := 700;
    C_RX_WIDTH_36 : natural :=   0;
    C_RX_START_36 : natural := 700;

    C_TX_WIDTH_37 : natural :=   0;
    C_TX_START_37 : natural := 720;
    C_RX_WIDTH_37 : natural :=   0;
    C_RX_START_37 : natural := 720;

    C_TX_WIDTH_38 : natural :=   0;
    C_TX_START_38 : natural := 740;
    C_RX_WIDTH_38 : natural :=   0;
    C_RX_START_38 : natural := 740;

    C_TX_WIDTH_39 : natural :=   0;
    C_TX_START_39 : natural := 760;
    C_RX_WIDTH_39 : natural :=   0;
    C_RX_START_39 : natural := 760;

    C_TX_WIDTH_40 : natural :=   0;
    C_TX_START_40 : natural := 780;
    C_RX_WIDTH_40 : natural :=   0;
    C_RX_START_40 : natural := 780;

    C_TX_WIDTH_41 : natural :=   0;
    C_TX_START_41 : natural := 800;
    C_RX_WIDTH_41 : natural :=   0;
    C_RX_START_41 : natural := 800;

    C_TX_WIDTH_42 : natural :=   0;
    C_TX_START_42 : natural := 820;
    C_RX_WIDTH_42 : natural :=   0;
    C_RX_START_42 : natural := 820;

    C_TX_WIDTH_43 : natural :=   0;
    C_TX_START_43 : natural := 840;
    C_RX_WIDTH_43 : natural :=   0;
    C_RX_START_43 : natural := 840;

    C_TX_WIDTH_44 : natural :=   0;
    C_TX_START_44 : natural := 860;
    C_RX_WIDTH_44 : natural :=   0;
    C_RX_START_44 : natural := 860;

    C_TX_WIDTH_45 : natural :=   0;
    C_TX_START_45 : natural := 880;
    C_RX_WIDTH_45 : natural :=   0;
    C_RX_START_45 : natural := 880;

    C_TX_WIDTH_46 : natural :=   0;
    C_TX_START_46 : natural := 900;
    C_RX_WIDTH_46 : natural :=   0;
    C_RX_START_46 : natural := 900;

    C_TX_WIDTH_47 : natural :=   0;
    C_TX_START_47 : natural := 920;
    C_RX_WIDTH_47 : natural :=   0;
    C_RX_START_47 : natural := 920;

    C_TX_WIDTH_48 : natural :=   0;
    C_TX_START_48 : natural := 940;
    C_RX_WIDTH_48 : natural :=   0;
    C_RX_START_48 : natural := 940
    );
  port (
    -- I/Q interface common
    iq_tx_enable     : in  std_logic;
    iq_rx_data_valid : out std_logic;
    -- I/Q i/f #1
    iq_tx_i_1        : in  std_logic_vector(C_TX_WIDTH_1-1 downto 0);
    iq_tx_q_1        : in  std_logic_vector(C_TX_WIDTH_1-1 downto 0);
    iq_rx_i_1        : out std_logic_vector(C_RX_WIDTH_1-1 downto 0);
    iq_rx_q_1        : out std_logic_vector(C_RX_WIDTH_1-1 downto 0);
    -- I/Q i/f #2
    iq_tx_i_2        : in  std_logic_vector(C_TX_WIDTH_2-1 downto 0);
    iq_tx_q_2        : in  std_logic_vector(C_TX_WIDTH_2-1 downto 0);
    iq_rx_i_2        : out std_logic_vector(C_RX_WIDTH_2-1 downto 0);
    iq_rx_q_2        : out std_logic_vector(C_RX_WIDTH_2-1 downto 0);
    -- I/Q i/f #3
    iq_tx_i_3        : in  std_logic_vector(C_TX_WIDTH_3-1 downto 0);
    iq_tx_q_3        : in  std_logic_vector(C_TX_WIDTH_3-1 downto 0);
    iq_rx_i_3        : out std_logic_vector(C_RX_WIDTH_3-1 downto 0);
    iq_rx_q_3        : out std_logic_vector(C_RX_WIDTH_3-1 downto 0);
    -- I/Q i/f #4
    iq_tx_i_4        : in  std_logic_vector(C_TX_WIDTH_4-1 downto 0);
    iq_tx_q_4        : in  std_logic_vector(C_TX_WIDTH_4-1 downto 0);
    iq_rx_i_4        : out std_logic_vector(C_RX_WIDTH_4-1 downto 0);
    iq_rx_q_4        : out std_logic_vector(C_RX_WIDTH_4-1 downto 0);
    -- I/Q i/f #5
    iq_tx_i_5        : in  std_logic_vector(C_TX_WIDTH_5-1 downto 0);
    iq_tx_q_5        : in  std_logic_vector(C_TX_WIDTH_5-1 downto 0);
    iq_rx_i_5        : out std_logic_vector(C_RX_WIDTH_5-1 downto 0);
    iq_rx_q_5        : out std_logic_vector(C_RX_WIDTH_5-1 downto 0);
    -- I/Q i/f #6
    iq_tx_i_6        : in  std_logic_vector(C_TX_WIDTH_6-1 downto 0);
    iq_tx_q_6        : in  std_logic_vector(C_TX_WIDTH_6-1 downto 0);
    iq_rx_i_6        : out std_logic_vector(C_RX_WIDTH_6-1 downto 0);
    iq_rx_q_6        : out std_logic_vector(C_RX_WIDTH_6-1 downto 0);
    -- I/Q i/f #7
    iq_tx_i_7        : in  std_logic_vector(C_TX_WIDTH_7-1 downto 0);
    iq_tx_q_7        : in  std_logic_vector(C_TX_WIDTH_7-1 downto 0);
    iq_rx_i_7        : out std_logic_vector(C_RX_WIDTH_7-1 downto 0);
    iq_rx_q_7        : out std_logic_vector(C_RX_WIDTH_7-1 downto 0);
    -- I/Q i/f #8
    iq_tx_i_8        : in  std_logic_vector(C_TX_WIDTH_8-1 downto 0);
    iq_tx_q_8        : in  std_logic_vector(C_TX_WIDTH_8-1 downto 0);
    iq_rx_i_8        : out std_logic_vector(C_RX_WIDTH_8-1 downto 0);
    iq_rx_q_8        : out std_logic_vector(C_RX_WIDTH_8-1 downto 0);
    -- I/Q i/f #9
    iq_tx_i_9        : in  std_logic_vector(C_TX_WIDTH_9-1 downto 0);
    iq_tx_q_9        : in  std_logic_vector(C_TX_WIDTH_9-1 downto 0);
    iq_rx_i_9        : out std_logic_vector(C_RX_WIDTH_9-1 downto 0);
    iq_rx_q_9        : out std_logic_vector(C_RX_WIDTH_9-1 downto 0);
    -- I/Q i/f #10
    iq_tx_i_10       : in  std_logic_vector(C_TX_WIDTH_10-1 downto 0);
    iq_tx_q_10       : in  std_logic_vector(C_TX_WIDTH_10-1 downto 0);
    iq_rx_i_10       : out std_logic_vector(C_RX_WIDTH_10-1 downto 0);
    iq_rx_q_10       : out std_logic_vector(C_RX_WIDTH_10-1 downto 0);
    -- I/Q i/f #11
    iq_tx_i_11       : in  std_logic_vector(C_TX_WIDTH_11-1 downto 0);
    iq_tx_q_11       : in  std_logic_vector(C_TX_WIDTH_11-1 downto 0);
    iq_rx_i_11       : out std_logic_vector(C_RX_WIDTH_11-1 downto 0);
    iq_rx_q_11       : out std_logic_vector(C_RX_WIDTH_11-1 downto 0);
    -- I/Q i/f #12
    iq_tx_i_12       : in  std_logic_vector(C_TX_WIDTH_12-1 downto 0);
    iq_tx_q_12       : in  std_logic_vector(C_TX_WIDTH_12-1 downto 0);
    iq_rx_i_12       : out std_logic_vector(C_RX_WIDTH_12-1 downto 0);
    iq_rx_q_12       : out std_logic_vector(C_RX_WIDTH_12-1 downto 0);
    -- I/Q i/f #13
    iq_tx_i_13       : in  std_logic_vector(C_TX_WIDTH_13-1 downto 0);
    iq_tx_q_13       : in  std_logic_vector(C_TX_WIDTH_13-1 downto 0);
    iq_rx_i_13       : out std_logic_vector(C_RX_WIDTH_13-1 downto 0);
    iq_rx_q_13       : out std_logic_vector(C_RX_WIDTH_13-1 downto 0);
    -- I/Q i/f #14
    iq_tx_i_14       : in  std_logic_vector(C_TX_WIDTH_14-1 downto 0);
    iq_tx_q_14       : in  std_logic_vector(C_TX_WIDTH_14-1 downto 0);
    iq_rx_i_14       : out std_logic_vector(C_RX_WIDTH_14-1 downto 0);
    iq_rx_q_14       : out std_logic_vector(C_RX_WIDTH_14-1 downto 0);
    -- I/Q i/f #15
    iq_tx_i_15       : in  std_logic_vector(C_TX_WIDTH_15-1 downto 0);
    iq_tx_q_15       : in  std_logic_vector(C_TX_WIDTH_15-1 downto 0);
    iq_rx_i_15       : out std_logic_vector(C_RX_WIDTH_15-1 downto 0);
    iq_rx_q_15       : out std_logic_vector(C_RX_WIDTH_15-1 downto 0);
    -- I/Q i/f #16
    iq_tx_i_16       : in  std_logic_vector(C_TX_WIDTH_16-1 downto 0);
    iq_tx_q_16       : in  std_logic_vector(C_TX_WIDTH_16-1 downto 0);
    iq_rx_i_16       : out std_logic_vector(C_RX_WIDTH_16-1 downto 0);
    iq_rx_q_16       : out std_logic_vector(C_RX_WIDTH_16-1 downto 0);
    -- I/Q i/f #17
    iq_tx_i_17       : in  std_logic_vector(C_TX_WIDTH_17-1 downto 0);
    iq_tx_q_17       : in  std_logic_vector(C_TX_WIDTH_17-1 downto 0);
    iq_rx_i_17       : out std_logic_vector(C_RX_WIDTH_17-1 downto 0);
    iq_rx_q_17       : out std_logic_vector(C_RX_WIDTH_17-1 downto 0);
    -- I/Q i/f #18
    iq_tx_i_18       : in  std_logic_vector(C_TX_WIDTH_18-1 downto 0);
    iq_tx_q_18       : in  std_logic_vector(C_TX_WIDTH_18-1 downto 0);
    iq_rx_i_18       : out std_logic_vector(C_RX_WIDTH_18-1 downto 0);
    iq_rx_q_18       : out std_logic_vector(C_RX_WIDTH_18-1 downto 0);
    -- I/Q i/f #19
    iq_tx_i_19       : in  std_logic_vector(C_TX_WIDTH_19-1 downto 0);
    iq_tx_q_19       : in  std_logic_vector(C_TX_WIDTH_19-1 downto 0);
    iq_rx_i_19       : out std_logic_vector(C_RX_WIDTH_19-1 downto 0);
    iq_rx_q_19       : out std_logic_vector(C_RX_WIDTH_19-1 downto 0);
    -- I/Q i/f #20
    iq_tx_i_20       : in  std_logic_vector(C_TX_WIDTH_20-1 downto 0);
    iq_tx_q_20       : in  std_logic_vector(C_TX_WIDTH_20-1 downto 0);
    iq_rx_i_20       : out std_logic_vector(C_RX_WIDTH_20-1 downto 0);
    iq_rx_q_20       : out std_logic_vector(C_RX_WIDTH_20-1 downto 0);
    -- I/Q i/f #21
    iq_tx_i_21       : in  std_logic_vector(C_TX_WIDTH_21-1 downto 0);
    iq_tx_q_21       : in  std_logic_vector(C_TX_WIDTH_21-1 downto 0);
    iq_rx_i_21       : out std_logic_vector(C_RX_WIDTH_21-1 downto 0);
    iq_rx_q_21       : out std_logic_vector(C_RX_WIDTH_21-1 downto 0);
    -- I/Q i/f #22
    iq_tx_i_22       : in  std_logic_vector(C_TX_WIDTH_22-1 downto 0);
    iq_tx_q_22       : in  std_logic_vector(C_TX_WIDTH_22-1 downto 0);
    iq_rx_i_22       : out std_logic_vector(C_RX_WIDTH_22-1 downto 0);
    iq_rx_q_22       : out std_logic_vector(C_RX_WIDTH_22-1 downto 0);
    -- I/Q i/f #23
    iq_tx_i_23       : in  std_logic_vector(C_TX_WIDTH_23-1 downto 0);
    iq_tx_q_23       : in  std_logic_vector(C_TX_WIDTH_23-1 downto 0);
    iq_rx_i_23       : out std_logic_vector(C_RX_WIDTH_23-1 downto 0);
    iq_rx_q_23       : out std_logic_vector(C_RX_WIDTH_23-1 downto 0);
    -- I/Q i/f #24
    iq_tx_i_24       : in  std_logic_vector(C_TX_WIDTH_24-1 downto 0);
    iq_tx_q_24       : in  std_logic_vector(C_TX_WIDTH_24-1 downto 0);
    iq_rx_i_24       : out std_logic_vector(C_RX_WIDTH_24-1 downto 0);
    iq_rx_q_24       : out std_logic_vector(C_RX_WIDTH_24-1 downto 0);
    -- I/Q i/f #25
    iq_tx_i_25       : in  std_logic_vector(C_TX_WIDTH_25-1 downto 0);
    iq_tx_q_25       : in  std_logic_vector(C_TX_WIDTH_25-1 downto 0);
    iq_rx_i_25       : out std_logic_vector(C_RX_WIDTH_25-1 downto 0);
    iq_rx_q_25       : out std_logic_vector(C_RX_WIDTH_25-1 downto 0);
    -- I/Q i/f #26
    iq_tx_i_26       : in  std_logic_vector(C_TX_WIDTH_26-1 downto 0);
    iq_tx_q_26       : in  std_logic_vector(C_TX_WIDTH_26-1 downto 0);
    iq_rx_i_26       : out std_logic_vector(C_RX_WIDTH_26-1 downto 0);
    iq_rx_q_26       : out std_logic_vector(C_RX_WIDTH_26-1 downto 0);
    -- I/Q i/f #27
    iq_tx_i_27       : in  std_logic_vector(C_TX_WIDTH_27-1 downto 0);
    iq_tx_q_27       : in  std_logic_vector(C_TX_WIDTH_27-1 downto 0);
    iq_rx_i_27       : out std_logic_vector(C_RX_WIDTH_27-1 downto 0);
    iq_rx_q_27       : out std_logic_vector(C_RX_WIDTH_27-1 downto 0);
    -- I/Q i/f #28
    iq_tx_i_28       : in  std_logic_vector(C_TX_WIDTH_28-1 downto 0);
    iq_tx_q_28       : in  std_logic_vector(C_TX_WIDTH_28-1 downto 0);
    iq_rx_i_28       : out std_logic_vector(C_RX_WIDTH_28-1 downto 0);
    iq_rx_q_28       : out std_logic_vector(C_RX_WIDTH_28-1 downto 0);
    -- I/Q i/f #29
    iq_tx_i_29       : in  std_logic_vector(C_TX_WIDTH_29-1 downto 0);
    iq_tx_q_29       : in  std_logic_vector(C_TX_WIDTH_29-1 downto 0);
    iq_rx_i_29       : out std_logic_vector(C_RX_WIDTH_29-1 downto 0);
    iq_rx_q_29       : out std_logic_vector(C_RX_WIDTH_29-1 downto 0);
    -- I/Q i/f #30
    iq_tx_i_30       : in  std_logic_vector(C_TX_WIDTH_30-1 downto 0);
    iq_tx_q_30       : in  std_logic_vector(C_TX_WIDTH_30-1 downto 0);
    iq_rx_i_30       : out std_logic_vector(C_RX_WIDTH_30-1 downto 0);
    iq_rx_q_30       : out std_logic_vector(C_RX_WIDTH_30-1 downto 0);
    -- I/Q i/f #31
    iq_tx_i_31       : in  std_logic_vector(C_TX_WIDTH_31-1 downto 0);
    iq_tx_q_31       : in  std_logic_vector(C_TX_WIDTH_31-1 downto 0);
    iq_rx_i_31       : out std_logic_vector(C_RX_WIDTH_31-1 downto 0);
    iq_rx_q_31       : out std_logic_vector(C_RX_WIDTH_31-1 downto 0);
    -- I/Q i/f #32
    iq_tx_i_32       : in  std_logic_vector(C_TX_WIDTH_32-1 downto 0);
    iq_tx_q_32       : in  std_logic_vector(C_TX_WIDTH_32-1 downto 0);
    iq_rx_i_32       : out std_logic_vector(C_RX_WIDTH_32-1 downto 0);
    iq_rx_q_32       : out std_logic_vector(C_RX_WIDTH_32-1 downto 0);
    -- I/Q i/f #33
    iq_tx_i_33       : in  std_logic_vector(C_TX_WIDTH_33-1 downto 0);
    iq_tx_q_33       : in  std_logic_vector(C_TX_WIDTH_33-1 downto 0);
    iq_rx_i_33       : out std_logic_vector(C_RX_WIDTH_33-1 downto 0);
    iq_rx_q_33       : out std_logic_vector(C_RX_WIDTH_33-1 downto 0);
    -- I/Q i/f #34
    iq_tx_i_34       : in  std_logic_vector(C_TX_WIDTH_34-1 downto 0);
    iq_tx_q_34       : in  std_logic_vector(C_TX_WIDTH_34-1 downto 0);
    iq_rx_i_34       : out std_logic_vector(C_RX_WIDTH_34-1 downto 0);
    iq_rx_q_34       : out std_logic_vector(C_RX_WIDTH_34-1 downto 0);
    -- I/Q i/f #35
    iq_tx_i_35       : in  std_logic_vector(C_TX_WIDTH_35-1 downto 0);
    iq_tx_q_35       : in  std_logic_vector(C_TX_WIDTH_35-1 downto 0);
    iq_rx_i_35       : out std_logic_vector(C_RX_WIDTH_35-1 downto 0);
    iq_rx_q_35       : out std_logic_vector(C_RX_WIDTH_35-1 downto 0);
    -- I/Q i/f #36
    iq_tx_i_36       : in  std_logic_vector(C_TX_WIDTH_36-1 downto 0);
    iq_tx_q_36       : in  std_logic_vector(C_TX_WIDTH_36-1 downto 0);
    iq_rx_i_36       : out std_logic_vector(C_RX_WIDTH_36-1 downto 0);
    iq_rx_q_36       : out std_logic_vector(C_RX_WIDTH_36-1 downto 0);
    -- I/Q i/f #37
    iq_tx_i_37       : in  std_logic_vector(C_TX_WIDTH_37-1 downto 0);
    iq_tx_q_37       : in  std_logic_vector(C_TX_WIDTH_37-1 downto 0);
    iq_rx_i_37       : out std_logic_vector(C_RX_WIDTH_37-1 downto 0);
    iq_rx_q_37       : out std_logic_vector(C_RX_WIDTH_37-1 downto 0);
    -- I/Q i/f #38
    iq_tx_i_38       : in  std_logic_vector(C_TX_WIDTH_38-1 downto 0);
    iq_tx_q_38       : in  std_logic_vector(C_TX_WIDTH_38-1 downto 0);
    iq_rx_i_38       : out std_logic_vector(C_RX_WIDTH_38-1 downto 0);
    iq_rx_q_38       : out std_logic_vector(C_RX_WIDTH_38-1 downto 0);
    -- I/Q i/f #39
    iq_tx_i_39       : in  std_logic_vector(C_TX_WIDTH_39-1 downto 0);
    iq_tx_q_39       : in  std_logic_vector(C_TX_WIDTH_39-1 downto 0);
    iq_rx_i_39       : out std_logic_vector(C_RX_WIDTH_39-1 downto 0);
    iq_rx_q_39       : out std_logic_vector(C_RX_WIDTH_39-1 downto 0);
    -- I/Q i/f #40
    iq_tx_i_40       : in  std_logic_vector(C_TX_WIDTH_40-1 downto 0);
    iq_tx_q_40       : in  std_logic_vector(C_TX_WIDTH_40-1 downto 0);
    iq_rx_i_40       : out std_logic_vector(C_RX_WIDTH_40-1 downto 0);
    iq_rx_q_40       : out std_logic_vector(C_RX_WIDTH_40-1 downto 0);
    -- I/Q i/f #41
    iq_tx_i_41       : in  std_logic_vector(C_TX_WIDTH_41-1 downto 0);
    iq_tx_q_41       : in  std_logic_vector(C_TX_WIDTH_41-1 downto 0);
    iq_rx_i_41       : out std_logic_vector(C_RX_WIDTH_41-1 downto 0);
    iq_rx_q_41       : out std_logic_vector(C_RX_WIDTH_41-1 downto 0);
    -- I/Q i/f #42
    iq_tx_i_42       : in  std_logic_vector(C_TX_WIDTH_42-1 downto 0);
    iq_tx_q_42       : in  std_logic_vector(C_TX_WIDTH_42-1 downto 0);
    iq_rx_i_42       : out std_logic_vector(C_RX_WIDTH_42-1 downto 0);
    iq_rx_q_42       : out std_logic_vector(C_RX_WIDTH_42-1 downto 0);
    -- I/Q i/f #43
    iq_tx_i_43       : in  std_logic_vector(C_TX_WIDTH_43-1 downto 0);
    iq_tx_q_43       : in  std_logic_vector(C_TX_WIDTH_43-1 downto 0);
    iq_rx_i_43       : out std_logic_vector(C_RX_WIDTH_43-1 downto 0);
    iq_rx_q_43       : out std_logic_vector(C_RX_WIDTH_43-1 downto 0);
    -- I/Q i/f #44
    iq_tx_i_44       : in  std_logic_vector(C_TX_WIDTH_44-1 downto 0);
    iq_tx_q_44       : in  std_logic_vector(C_TX_WIDTH_44-1 downto 0);
    iq_rx_i_44       : out std_logic_vector(C_RX_WIDTH_44-1 downto 0);
    iq_rx_q_44       : out std_logic_vector(C_RX_WIDTH_44-1 downto 0);
    -- I/Q i/f #45
    iq_tx_i_45       : in  std_logic_vector(C_TX_WIDTH_45-1 downto 0);
    iq_tx_q_45       : in  std_logic_vector(C_TX_WIDTH_45-1 downto 0);
    iq_rx_i_45       : out std_logic_vector(C_RX_WIDTH_45-1 downto 0);
    iq_rx_q_45       : out std_logic_vector(C_RX_WIDTH_45-1 downto 0);
    -- I/Q i/f #46
    iq_tx_i_46       : in  std_logic_vector(C_TX_WIDTH_46-1 downto 0);
    iq_tx_q_46       : in  std_logic_vector(C_TX_WIDTH_46-1 downto 0);
    iq_rx_i_46       : out std_logic_vector(C_RX_WIDTH_46-1 downto 0);
    iq_rx_q_46       : out std_logic_vector(C_RX_WIDTH_46-1 downto 0);
    -- I/Q i/f #47
    iq_tx_i_47       : in  std_logic_vector(C_TX_WIDTH_47-1 downto 0);
    iq_tx_q_47       : in  std_logic_vector(C_TX_WIDTH_47-1 downto 0);
    iq_rx_i_47       : out std_logic_vector(C_RX_WIDTH_47-1 downto 0);
    iq_rx_q_47       : out std_logic_vector(C_RX_WIDTH_47-1 downto 0);
    -- I/Q i/f #48
    iq_tx_i_48       : in  std_logic_vector(C_TX_WIDTH_48-1 downto 0);
    iq_tx_q_48       : in  std_logic_vector(C_TX_WIDTH_48-1 downto 0);
    iq_rx_i_48       : out std_logic_vector(C_RX_WIDTH_48-1 downto 0);
    iq_rx_q_48       : out std_logic_vector(C_RX_WIDTH_48-1 downto 0);

    -- raw iq stream
    iq_tx                  : out  std_logic_vector (63 downto 0);
    iq_rx                  : in   std_logic_vector (63 downto 0);
    basic_frame_first_word : in   std_logic;
    speed_select           : in std_logic_vector(14 downto 0);
    clk                    : in std_logic);
end iq_module;

architecture rtl of iq_module is

  component tx_iq is
    generic (
      C_WIDTH    : natural;
      C_STARTBIT : natural);
    port (
      clk          : in  std_logic;
      iq_tx_enable : in  std_logic;
      speed_select : in  std_logic_vector(14 downto 0);
      iq_i         : in  std_logic_vector(C_WIDTH-1 downto 0);
      iq_q         : in  std_logic_vector(C_WIDTH-1 downto 0);
      tx_data_iq   : out std_logic_vector(63 downto 0));
  end component tx_iq;

  component rx_iq_64 is
    generic (
      C_WIDTH    : natural;
      C_STARTBIT : natural);
    port (
      clk                    : in  std_logic;
      rx_data                : in  std_logic_vector(63 downto 0);
      speed_select           : in  std_logic_vector(14 downto 0);
      basic_frame_first_word : in  std_logic;
      rx_i                   : out std_logic_vector(C_WIDTH-1 downto 0);
      rx_q                   : out std_logic_vector(C_WIDTH-1 downto 0));
  end component rx_iq_64;

  signal tx_iq_data_1       : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_2       : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_3       : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_4       : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_5       : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_6       : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_7       : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_8       : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_9       : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_10      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_11      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_12      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_13      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_14      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_15      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_16      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_17      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_18      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_19      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_20      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_21      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_22      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_23      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_24      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_25      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_26      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_27      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_28      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_29      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_30      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_31      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_32      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_33      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_34      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_35      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_36      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_37      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_38      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_39      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_40      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_41      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_42      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_43      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_44      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_45      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_46      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_47      : std_logic_vector(63 downto  0) := (others => '0');
  signal tx_iq_data_48      : std_logic_vector(63 downto  0) := (others => '0');

  signal speed_select_i     : std_logic_vector(14 downto 0);

begin

  speed_select_i <= speed_select;


  tx_iq_1 : if C_TX_WIDTH_1 > 1 generate
    I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_1,
       C_STARTBIT => C_TX_START_1)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_1,
       iq_q         => iq_tx_q_1,
       tx_data_iq   => tx_iq_data_1);
  end generate tx_iq_1;

  tx_iq_2 : if C_TX_WIDTH_2 > 1 generate
    I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_2,
       C_STARTBIT => C_TX_START_2)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_2,
       iq_q         => iq_tx_q_2,
       tx_data_iq   => tx_iq_data_2);
  end generate tx_iq_2;

  tx_iq_3 : if C_TX_WIDTH_3 > 1 generate
    I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_3,
       C_STARTBIT => C_TX_START_3)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_3,
       iq_q         => iq_tx_q_3,
       tx_data_iq   => tx_iq_data_3);
  end generate tx_iq_3;

  tx_iq_4 : if C_TX_WIDTH_4 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_4,
       C_STARTBIT => C_TX_START_4)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_4,
       iq_q         => iq_tx_q_4,
       tx_data_iq   => tx_iq_data_4);
  end generate tx_iq_4;

  tx_iq_5 : if C_TX_WIDTH_5 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_5,
       C_STARTBIT => C_TX_START_5)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_5,
       iq_q         => iq_tx_q_5,
       tx_data_iq   => tx_iq_data_5);
  end generate tx_iq_5;

  tx_iq_6 : if C_TX_WIDTH_6 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_6,
       C_STARTBIT => C_TX_START_6)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_6,
       iq_q         => iq_tx_q_6,
       tx_data_iq   => tx_iq_data_6);
  end generate tx_iq_6;

  tx_iq_7 : if C_TX_WIDTH_7 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_7,
       C_STARTBIT => C_TX_START_7)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_7,
       iq_q         => iq_tx_q_7,
       tx_data_iq   => tx_iq_data_7);
  end generate tx_iq_7;

  tx_iq_8 : if C_TX_WIDTH_8 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_8,
       C_STARTBIT => C_TX_START_8)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_8,
       iq_q         => iq_tx_q_8,
       tx_data_iq   => tx_iq_data_8);
  end generate tx_iq_8;

  tx_iq_9 : if C_TX_WIDTH_9 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_9,
       C_STARTBIT => C_TX_START_9)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_9,
       iq_q         => iq_tx_q_9,
       tx_data_iq   => tx_iq_data_9);
  end generate tx_iq_9;

  tx_iq_10 : if C_TX_WIDTH_10 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_10,
       C_STARTBIT => C_TX_START_10)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_10,
       iq_q         => iq_tx_q_10,
       tx_data_iq   => tx_iq_data_10);
  end generate tx_iq_10;

  tx_iq_11 : if C_TX_WIDTH_11 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_11,
       C_STARTBIT => C_TX_START_11)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_11,
       iq_q         => iq_tx_q_11,
       tx_data_iq   => tx_iq_data_11);
  end generate tx_iq_11;

  tx_iq_12 : if C_TX_WIDTH_12 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_12,
       C_STARTBIT => C_TX_START_12)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_12,
       iq_q         => iq_tx_q_12,
       tx_data_iq   => tx_iq_data_12);
  end generate tx_iq_12;

  tx_iq_13 : if C_TX_WIDTH_13 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_13,
       C_STARTBIT => C_TX_START_13)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_13,
       iq_q         => iq_tx_q_13,
       tx_data_iq   => tx_iq_data_13);
  end generate tx_iq_13;

  tx_iq_14 : if C_TX_WIDTH_14 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_14,
       C_STARTBIT => C_TX_START_14)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_14,
       iq_q         => iq_tx_q_14,
       tx_data_iq   => tx_iq_data_14);
  end generate tx_iq_14;

  tx_iq_15 : if C_TX_WIDTH_15 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_15,
       C_STARTBIT => C_TX_START_15)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_15,
       iq_q         => iq_tx_q_15,
       tx_data_iq   => tx_iq_data_15);
  end generate tx_iq_15;

  tx_iq_16 : if C_TX_WIDTH_16 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_16,
       C_STARTBIT => C_TX_START_16)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_16,
       iq_q         => iq_tx_q_16,
       tx_data_iq   => tx_iq_data_16);
  end generate tx_iq_16;

  tx_iq_17 : if C_TX_WIDTH_17 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_17,
       C_STARTBIT => C_TX_START_17)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_17,
       iq_q         => iq_tx_q_17,
       tx_data_iq   => tx_iq_data_17);
  end generate tx_iq_17;

  tx_iq_18 : if C_TX_WIDTH_18 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_18,
       C_STARTBIT => C_TX_START_18)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_18,
       iq_q         => iq_tx_q_18,
       tx_data_iq   => tx_iq_data_18);
  end generate tx_iq_18;

  tx_iq_19 : if C_TX_WIDTH_19 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_19,
       C_STARTBIT => C_TX_START_19)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_19,
       iq_q         => iq_tx_q_19,
       tx_data_iq   => tx_iq_data_19);
  end generate tx_iq_19;

  tx_iq_20 : if C_TX_WIDTH_20 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_20,
       C_STARTBIT => C_TX_START_20)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_20,
       iq_q         => iq_tx_q_20,
       tx_data_iq   => tx_iq_data_20);
  end generate tx_iq_20;

  tx_iq_21 : if C_TX_WIDTH_21 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_21,
       C_STARTBIT => C_TX_START_21)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_21,
       iq_q         => iq_tx_q_21,
       tx_data_iq   => tx_iq_data_21);
  end generate tx_iq_21;

  tx_iq_22 : if C_TX_WIDTH_22 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_22,
       C_STARTBIT => C_TX_START_22)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_22,
       iq_q         => iq_tx_q_22,
       tx_data_iq   => tx_iq_data_22);
  end generate tx_iq_22;

  tx_iq_23 : if C_TX_WIDTH_23 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_23,
       C_STARTBIT => C_TX_START_23)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_23,
       iq_q         => iq_tx_q_23,
       tx_data_iq   => tx_iq_data_23);
  end generate tx_iq_23;

  tx_iq_24 : if C_TX_WIDTH_24 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_24,
       C_STARTBIT => C_TX_START_24)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_24,
       iq_q         => iq_tx_q_24,
       tx_data_iq   => tx_iq_data_24);
  end generate tx_iq_24;

  tx_iq_25 : if C_TX_WIDTH_25 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_25,
       C_STARTBIT => C_TX_START_25)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_25,
       iq_q         => iq_tx_q_25,
       tx_data_iq   => tx_iq_data_25);
  end generate tx_iq_25;

  tx_iq_26 : if C_TX_WIDTH_26 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_26,
       C_STARTBIT => C_TX_START_26)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_26,
       iq_q         => iq_tx_q_26,
       tx_data_iq   => tx_iq_data_26);
  end generate tx_iq_26;

  tx_iq_27 : if C_TX_WIDTH_27 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_27,
       C_STARTBIT => C_TX_START_27)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_27,
       iq_q         => iq_tx_q_27,
       tx_data_iq   => tx_iq_data_27);
  end generate tx_iq_27;

  tx_iq_28 : if C_TX_WIDTH_28 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_28,
       C_STARTBIT => C_TX_START_28)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_28,
       iq_q         => iq_tx_q_28,
       tx_data_iq   => tx_iq_data_28);
  end generate tx_iq_28;

  tx_iq_29 : if C_TX_WIDTH_29 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_29,
       C_STARTBIT => C_TX_START_29)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_29,
       iq_q         => iq_tx_q_29,
       tx_data_iq   => tx_iq_data_29);
  end generate tx_iq_29;

  tx_iq_30 : if C_TX_WIDTH_30 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_30,
       C_STARTBIT => C_TX_START_30)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_30,
       iq_q         => iq_tx_q_30,
       tx_data_iq   => tx_iq_data_30);
  end generate tx_iq_30;

  tx_iq_31 : if C_TX_WIDTH_31 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_31,
       C_STARTBIT => C_TX_START_31)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_31,
       iq_q         => iq_tx_q_31,
       tx_data_iq   => tx_iq_data_31);
  end generate tx_iq_31;

  tx_iq_32 : if C_TX_WIDTH_32 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_32,
       C_STARTBIT => C_TX_START_32)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_32,
       iq_q         => iq_tx_q_32,
       tx_data_iq   => tx_iq_data_32);
  end generate tx_iq_32;

  tx_iq_33 : if C_TX_WIDTH_33 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_33,
       C_STARTBIT => C_TX_START_33)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_33,
       iq_q         => iq_tx_q_33,
       tx_data_iq   => tx_iq_data_33);
  end generate tx_iq_33;


  tx_iq_34 : if C_TX_WIDTH_34 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_34,
       C_STARTBIT => C_TX_START_34)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_34,
       iq_q         => iq_tx_q_34,
       tx_data_iq   => tx_iq_data_34);
  end generate tx_iq_34;

  tx_iq_35 : if C_TX_WIDTH_35 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_35,
       C_STARTBIT => C_TX_START_35)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_35,
       iq_q         => iq_tx_q_35,
       tx_data_iq   => tx_iq_data_35);
  end generate tx_iq_35;

  tx_iq_36 : if C_TX_WIDTH_36 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_36,
       C_STARTBIT => C_TX_START_36)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_36,
       iq_q         => iq_tx_q_36,
       tx_data_iq   => tx_iq_data_36);
  end generate tx_iq_36;

  tx_iq_37 : if C_TX_WIDTH_37 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_37,
       C_STARTBIT => C_TX_START_37)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_37,
       iq_q         => iq_tx_q_37,
       tx_data_iq   => tx_iq_data_37);
  end generate tx_iq_37;

  tx_iq_38 : if C_TX_WIDTH_38 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_38,
       C_STARTBIT => C_TX_START_38)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_38,
       iq_q         => iq_tx_q_38,
       tx_data_iq   => tx_iq_data_38);
  end generate tx_iq_38;

  tx_iq_39 : if C_TX_WIDTH_39 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_39,
       C_STARTBIT => C_TX_START_39)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_39,
       iq_q         => iq_tx_q_39,
       tx_data_iq   => tx_iq_data_39);
  end generate tx_iq_39;

  tx_iq_40 : if C_TX_WIDTH_40 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_40,
       C_STARTBIT => C_TX_START_40)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_40,
       iq_q         => iq_tx_q_40,
       tx_data_iq   => tx_iq_data_40);
  end generate tx_iq_40;

  tx_iq_41 : if C_TX_WIDTH_41 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_41,
       C_STARTBIT => C_TX_START_41)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_41,
       iq_q         => iq_tx_q_41,
       tx_data_iq   => tx_iq_data_41);
  end generate tx_iq_41;

  tx_iq_42 : if C_TX_WIDTH_42 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_42,
       C_STARTBIT => C_TX_START_42)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_42,
       iq_q         => iq_tx_q_42,
       tx_data_iq   => tx_iq_data_42);
  end generate tx_iq_42;

  tx_iq_43 : if C_TX_WIDTH_43 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_43,
       C_STARTBIT => C_TX_START_43)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_43,
       iq_q         => iq_tx_q_43,
       tx_data_iq   => tx_iq_data_43);
  end generate tx_iq_43;

  tx_iq_44 : if C_TX_WIDTH_44 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_44,
       C_STARTBIT => C_TX_START_44)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_44,
       iq_q         => iq_tx_q_44,
       tx_data_iq   => tx_iq_data_44);
  end generate tx_iq_44;

  tx_iq_45 : if C_TX_WIDTH_45 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_45,
       C_STARTBIT => C_TX_START_45)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_45,
       iq_q         => iq_tx_q_45,
       tx_data_iq   => tx_iq_data_45);
  end generate tx_iq_45;

  tx_iq_46 : if C_TX_WIDTH_46 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_46,
       C_STARTBIT => C_TX_START_46)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_46,
       iq_q         => iq_tx_q_46,
       tx_data_iq   => tx_iq_data_46);
  end generate tx_iq_46;

  tx_iq_47 : if C_TX_WIDTH_47 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_47,
       C_STARTBIT => C_TX_START_47)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_47,
       iq_q         => iq_tx_q_47,
       tx_data_iq   => tx_iq_data_47);
  end generate tx_iq_47;

  tx_iq_48 : if C_TX_WIDTH_48 > 1 generate
   I : tx_iq
     generic map (
       C_WIDTH    => C_TX_WIDTH_48,
       C_STARTBIT => C_TX_START_48)
     port map (
       clk          => clk,
       iq_tx_enable => iq_tx_enable,
       speed_select => speed_select_i,
       iq_i         => iq_tx_i_48,
       iq_q         => iq_tx_q_48,
       tx_data_iq   => tx_iq_data_48);
  end generate tx_iq_48;

  -- Mux the output TX data
  iq_tx <= tx_iq_data_1  or tx_iq_data_2  or tx_iq_data_3  or tx_iq_data_4  or
           tx_iq_data_5  or tx_iq_data_6  or tx_iq_data_7  or tx_iq_data_8  or
           tx_iq_data_9  or tx_iq_data_10 or tx_iq_data_11 or tx_iq_data_12 or
           tx_iq_data_13 or tx_iq_data_14 or tx_iq_data_15 or tx_iq_data_16 or
           tx_iq_data_17 or tx_iq_data_18 or tx_iq_data_19 or tx_iq_data_20 or
           tx_iq_data_21 or tx_iq_data_22 or tx_iq_data_23 or tx_iq_data_24 or
           tx_iq_data_25 or tx_iq_data_26 or tx_iq_data_27 or tx_iq_data_28 or
           tx_iq_data_29 or tx_iq_data_30 or tx_iq_data_31 or tx_iq_data_32 or
           tx_iq_data_33 or tx_iq_data_34 or tx_iq_data_35 or tx_iq_data_36 or
           tx_iq_data_37 or tx_iq_data_38 or tx_iq_data_39 or tx_iq_data_40 or
           tx_iq_data_41 or tx_iq_data_42 or tx_iq_data_43 or tx_iq_data_44 or
           tx_iq_data_45 or tx_iq_data_46 or tx_iq_data_47 or tx_iq_data_48;

  rx_iq_64_1 : if C_RX_WIDTH_1 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_1,
       C_STARTBIT => C_RX_START_1)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_1,
       rx_q                   => iq_rx_q_1);
  end generate rx_iq_64_1;

  rx_iq_64_2 : if C_RX_WIDTH_2 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_2,
       C_STARTBIT => C_RX_START_2)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_2,
       rx_q                   => iq_rx_q_2);
  end generate rx_iq_64_2;

  rx_iq_64_3 : if C_RX_WIDTH_3 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_3,
       C_STARTBIT => C_RX_START_3)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_3,
       rx_q                   => iq_rx_q_3);
  end generate rx_iq_64_3;

  rx_iq_64_4 : if C_RX_WIDTH_4 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_4,
       C_STARTBIT => C_RX_START_4)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_4,
       rx_q                   => iq_rx_q_4);
  end generate rx_iq_64_4;

  rx_iq_64_5 : if C_RX_WIDTH_5 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_5,
       C_STARTBIT => C_RX_START_5)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_5,
       rx_q                   => iq_rx_q_5);
  end generate rx_iq_64_5;

  rx_iq_64_6 : if C_RX_WIDTH_6 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_6,
       C_STARTBIT => C_RX_START_6)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_6,
       rx_q                   => iq_rx_q_6);
  end generate rx_iq_64_6;

  rx_iq_64_7 : if C_RX_WIDTH_7 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_7,
       C_STARTBIT => C_RX_START_7)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_7,
       rx_q                   => iq_rx_q_7);
  end generate rx_iq_64_7;

  rx_iq_64_8 : if C_RX_WIDTH_8 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_8,
       C_STARTBIT => C_RX_START_8)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_8,
       rx_q                   => iq_rx_q_8);
  end generate rx_iq_64_8;

  rx_iq_64_9 : if C_RX_WIDTH_9 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_9,
       C_STARTBIT => C_RX_START_9)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_9,
       rx_q                   => iq_rx_q_9);
  end generate rx_iq_64_9;

  rx_iq_64_10 : if C_RX_WIDTH_10 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_10,
       C_STARTBIT => C_RX_START_10)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_10,
       rx_q                   => iq_rx_q_10);
  end generate rx_iq_64_10;

  rx_iq_64_11 : if C_RX_WIDTH_11 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_11,
       C_STARTBIT => C_RX_START_11)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_11,
       rx_q                   => iq_rx_q_11);
  end generate rx_iq_64_11;

  rx_iq_64_12 : if C_RX_WIDTH_12 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_12,
       C_STARTBIT => C_RX_START_12)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_12,
       rx_q                   => iq_rx_q_12);
  end generate rx_iq_64_12;

  rx_iq_64_13 : if C_RX_WIDTH_13 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_13,
       C_STARTBIT => C_RX_START_13)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_13,
       rx_q                   => iq_rx_q_13);
  end generate rx_iq_64_13;

  rx_iq_64_14 : if C_RX_WIDTH_14 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_14,
       C_STARTBIT => C_RX_START_14)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_14,
       rx_q                   => iq_rx_q_14);
  end generate rx_iq_64_14;

  rx_iq_64_15 : if C_RX_WIDTH_15 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_15,
       C_STARTBIT => C_RX_START_15)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_15,
       rx_q                   => iq_rx_q_15);
  end generate rx_iq_64_15;

  rx_iq_64_16 : if C_RX_WIDTH_16 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_16,
       C_STARTBIT => C_RX_START_16)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_16,
       rx_q                   => iq_rx_q_16);
  end generate rx_iq_64_16;

  rx_iq_64_17 : if C_RX_WIDTH_17 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_17,
       C_STARTBIT => C_RX_START_17)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_17,
       rx_q                   => iq_rx_q_17);
  end generate rx_iq_64_17;

  rx_iq_64_18 : if C_RX_WIDTH_18 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_18,
       C_STARTBIT => C_RX_START_18)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_18,
       rx_q                   => iq_rx_q_18);
  end generate rx_iq_64_18;

  rx_iq_64_19 : if C_RX_WIDTH_19 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_19,
       C_STARTBIT => C_RX_START_19)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_19,
       rx_q                   => iq_rx_q_19);
  end generate rx_iq_64_19;

  rx_iq_64_20 : if C_RX_WIDTH_20 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_20,
       C_STARTBIT => C_RX_START_20)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_20,
       rx_q                   => iq_rx_q_20);
  end generate rx_iq_64_20;

  rx_iq_64_21 : if C_RX_WIDTH_21 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_21,
       C_STARTBIT => C_RX_START_21)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_21,
       rx_q                   => iq_rx_q_21);
  end generate rx_iq_64_21;

  rx_iq_64_22 : if C_RX_WIDTH_22 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_22,
       C_STARTBIT => C_RX_START_22)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_22,
       rx_q                   => iq_rx_q_22);
  end generate rx_iq_64_22;

  rx_iq_64_23 : if C_RX_WIDTH_23 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_23,
       C_STARTBIT => C_RX_START_23)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_23,
       rx_q                   => iq_rx_q_23);
  end generate rx_iq_64_23;

  rx_iq_64_24 : if C_RX_WIDTH_24 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_24,
       C_STARTBIT => C_RX_START_24)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_24,
       rx_q                   => iq_rx_q_24);
  end generate rx_iq_64_24;

  rx_iq_64_25 : if C_RX_WIDTH_25 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_25,
       C_STARTBIT => C_RX_START_25)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_25,
       rx_q                   => iq_rx_q_25);
  end generate rx_iq_64_25;

  rx_iq_64_26 : if C_RX_WIDTH_26 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_26,
       C_STARTBIT => C_RX_START_26)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_26,
       rx_q                   => iq_rx_q_26);
  end generate rx_iq_64_26;

  rx_iq_64_27 : if C_RX_WIDTH_27 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_27,
       C_STARTBIT => C_RX_START_27)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_27,
       rx_q                   => iq_rx_q_27);
  end generate rx_iq_64_27;

  rx_iq_64_28 : if C_RX_WIDTH_28 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_28,
       C_STARTBIT => C_RX_START_28)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_28,
       rx_q                   => iq_rx_q_28);
  end generate rx_iq_64_28;

  rx_iq_64_29 : if C_RX_WIDTH_29 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_29,
       C_STARTBIT => C_RX_START_29)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_29,
       rx_q                   => iq_rx_q_29);
  end generate rx_iq_64_29;

  rx_iq_64_30 : if C_RX_WIDTH_30 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_30,
       C_STARTBIT => C_RX_START_30)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_30,
       rx_q                   => iq_rx_q_30);
  end generate rx_iq_64_30;

  rx_iq_64_31 : if C_RX_WIDTH_31 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_31,
       C_STARTBIT => C_RX_START_31)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_31,
       rx_q                   => iq_rx_q_31);
  end generate rx_iq_64_31;

  rx_iq_64_32 : if C_RX_WIDTH_32 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_32,
       C_STARTBIT => C_RX_START_32)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_32,
       rx_q                   => iq_rx_q_32);
  end generate rx_iq_64_32;

  rx_iq_64_33 : if C_RX_WIDTH_33 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_33,
       C_STARTBIT => C_RX_START_33)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_33,
       rx_q                   => iq_rx_q_33);
  end generate rx_iq_64_33;

  rx_iq_64_34 : if C_RX_WIDTH_34 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_34,
       C_STARTBIT => C_RX_START_34)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_34,
       rx_q                   => iq_rx_q_34);
  end generate rx_iq_64_34;

  rx_iq_64_35 : if C_RX_WIDTH_35 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_35,
       C_STARTBIT => C_RX_START_35)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_35,
       rx_q                   => iq_rx_q_35);
  end generate rx_iq_64_35;

  rx_iq_64_36 : if C_RX_WIDTH_36 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_36,
       C_STARTBIT => C_RX_START_36)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_36,
       rx_q                   => iq_rx_q_36);
  end generate rx_iq_64_36;

  rx_iq_64_37 : if C_RX_WIDTH_37 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_37,
       C_STARTBIT => C_RX_START_37)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_37,
       rx_q                   => iq_rx_q_37);
  end generate rx_iq_64_37;

  rx_iq_64_38 : if C_RX_WIDTH_38 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_38,
       C_STARTBIT => C_RX_START_38)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_38,
       rx_q                   => iq_rx_q_38);
  end generate rx_iq_64_38;

  rx_iq_64_39 : if C_RX_WIDTH_39 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_39,
       C_STARTBIT => C_RX_START_39)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_39,
       rx_q                   => iq_rx_q_39);
  end generate rx_iq_64_39;

  rx_iq_64_40 : if C_RX_WIDTH_40 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_40,
       C_STARTBIT => C_RX_START_40)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_40,
       rx_q                   => iq_rx_q_40);
  end generate rx_iq_64_40;

  rx_iq_64_41 : if C_RX_WIDTH_41 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_41,
       C_STARTBIT => C_RX_START_41)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_41,
       rx_q                   => iq_rx_q_41);
  end generate rx_iq_64_41;

  rx_iq_64_42 : if C_RX_WIDTH_42 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_42,
       C_STARTBIT => C_RX_START_42)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_42,
       rx_q                   => iq_rx_q_42);
  end generate rx_iq_64_42;

  rx_iq_64_43 : if C_RX_WIDTH_43 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_43,
       C_STARTBIT => C_RX_START_43)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_43,
       rx_q                   => iq_rx_q_43);
  end generate rx_iq_64_43;

  rx_iq_64_44 : if C_RX_WIDTH_44 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_44,
       C_STARTBIT => C_RX_START_44)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_44,
       rx_q                   => iq_rx_q_44);
  end generate rx_iq_64_44;

  rx_iq_64_45 : if C_RX_WIDTH_45 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_45,
       C_STARTBIT => C_RX_START_45)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_45,
       rx_q                   => iq_rx_q_45);
  end generate rx_iq_64_45;

  rx_iq_64_46 : if C_RX_WIDTH_46 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_46,
       C_STARTBIT => C_RX_START_46)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_46,
       rx_q                   => iq_rx_q_46);
  end generate rx_iq_64_46;

  rx_iq_64_47 : if C_RX_WIDTH_47 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_47,
       C_STARTBIT => C_RX_START_47)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_47,
       rx_q                   => iq_rx_q_47);
  end generate rx_iq_64_47;

  rx_iq_64_48 : if C_RX_WIDTH_48 > 1 generate
   I : rx_iq_64
     generic map (
       C_WIDTH    => C_RX_WIDTH_48,
       C_STARTBIT => C_RX_START_48)
     port map (
       clk                    => clk,
       rx_data                => iq_rx,
       speed_select           => speed_select_i,
       basic_frame_first_word => basic_frame_first_word,
       rx_i                   => iq_rx_i_48,
       rx_q                   => iq_rx_q_48);
  end generate rx_iq_64_48;


   iq_rx_data_valid <= basic_frame_first_word;

end architecture rtl;
