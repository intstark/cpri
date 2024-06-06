-----------------------------------------------------------------------
-- Title      : Top entity EUTRA IQ module
-- Project    : cpri_v8_11_5
-----------------------------------------------------------------------
-- File       : iq_module_eutra.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description:
-- This is the top entity for the CPRI EUTRA IQ Data Module.
-- Transmit:
-- The module takes up to 8 channel inputs of I/Q data, each with an
-- independent width and number of samples (C_TX_S_#).
-- The data is muxed together onto the iq_tx input of the CPRI core.
-- The iq_tx_data_enable_# port for each channel stays high for a number
-- of clock cycles that is equal to the number of samples in that channel.
-- The user should input the sample data with the iq_tx_data_enable_#
-- signal is high.
--
-- Receive:
-- The receiver de-multiplexes the data from the iq_rx port of the
-- CPRI core into up to 8 channels of I/Q data each with an independent
-- width and number of samples (C_RX_S_#).
-- The iq_rx_data_valid_# output of each channel is asserted for
-- the number of samples in the channel. The data should be sampled
-- by the client when these signals are high.
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

entity iq_module_eutra is
  generic (
    -- Channel #1 widths and number of samples.
    C_TX_WIDTH_1  : natural              :=  10;
    C_TX_S_1      : natural              :=  3;
    C_RX_WIDTH_1  : natural              :=  10;
    C_RX_S_1      : natural              :=  3;

    -- Channel #2 widths and number of samples.
    C_TX_WIDTH_2  : natural              :=  10;
    C_TX_S_2      : natural              :=  3;
    C_RX_WIDTH_2  : natural              :=  10;
    C_RX_S_2      : natural              :=  3;

    -- Channel #3 widths and number of samples.
    C_TX_WIDTH_3  : natural              :=  0;
    C_TX_S_3      : natural              :=  0;
    C_RX_WIDTH_3  : natural              :=  0;
    C_RX_S_3      : natural              :=  0;

    -- Channel #4 widths and number of samples.
    C_TX_WIDTH_4  : natural              :=  0;
    C_TX_S_4      : natural              :=  0;
    C_RX_WIDTH_4  : natural              :=  0;
    C_RX_S_4      : natural              :=  0;

    -- Channel #5 widths and number of samples.
    C_TX_WIDTH_5  : natural              :=  0;
    C_TX_S_5      : natural              :=  0;
    C_RX_WIDTH_5  : natural              :=  0;
    C_RX_S_5      : natural              :=  0;

    -- Channel #6 widths and number of samples.
    C_TX_WIDTH_6  : natural              :=  0;
    C_TX_S_6      : natural              :=  0;
    C_RX_WIDTH_6  : natural              :=  0;
    C_RX_S_6      : natural              :=  0;

    -- Channel #7 widths and number of samples.
    C_TX_WIDTH_7  : natural              :=  0;
    C_TX_S_7      : natural              :=  0;
    C_RX_WIDTH_7  : natural              :=  0;
    C_RX_S_7      : natural              :=  0;

    -- Channel #8 widths and number of samples.
    C_TX_WIDTH_8  : natural              :=  0;
    C_TX_S_8      : natural              :=  0;
    C_RX_WIDTH_8  : natural              :=  0;
    C_RX_S_8      : natural              :=  0
    );
  port (
    -- I/Q i/f #1
    iq_tx_i_1           : in  std_logic_vector(C_TX_WIDTH_1-1 downto 0);
    iq_tx_q_1           : in  std_logic_vector(C_TX_WIDTH_1-1 downto 0);
    iq_rx_i_1           : out std_logic_vector(C_RX_WIDTH_1-1 downto 0);
    iq_rx_q_1           : out std_logic_vector(C_RX_WIDTH_1-1 downto 0);
    iq_tx_data_enable_1 : out std_logic;
    iq_rx_data_valid_1  : out std_logic;
    -- I/Q i/f #2
    iq_tx_i_2           : in  std_logic_vector(C_TX_WIDTH_2-1 downto 0);
    iq_tx_q_2           : in  std_logic_vector(C_TX_WIDTH_2-1 downto 0);
    iq_rx_i_2           : out std_logic_vector(C_RX_WIDTH_2-1 downto 0);
    iq_rx_q_2           : out std_logic_vector(C_RX_WIDTH_2-1 downto 0);
    iq_tx_data_enable_2 : out std_logic;
    iq_rx_data_valid_2  : out std_logic;
    -- I/Q i/f #3
    iq_tx_i_3           : in  std_logic_vector(C_TX_WIDTH_3-1 downto 0);
    iq_tx_q_3           : in  std_logic_vector(C_TX_WIDTH_3-1 downto 0);
    iq_rx_i_3           : out std_logic_vector(C_RX_WIDTH_3-1 downto 0);
    iq_rx_q_3           : out std_logic_vector(C_RX_WIDTH_3-1 downto 0);
    iq_tx_data_enable_3 : out std_logic;
    iq_rx_data_valid_3  : out std_logic;
    -- I/Q i/f #4
    iq_tx_i_4           : in  std_logic_vector(C_TX_WIDTH_4-1 downto 0);
    iq_tx_q_4           : in  std_logic_vector(C_TX_WIDTH_4-1 downto 0);
    iq_rx_i_4           : out std_logic_vector(C_RX_WIDTH_4-1 downto 0);
    iq_rx_q_4           : out std_logic_vector(C_RX_WIDTH_4-1 downto 0);
    iq_tx_data_enable_4 : out std_logic;
    iq_rx_data_valid_4  : out std_logic;
    -- I/Q i/f #5
    iq_tx_i_5           : in  std_logic_vector(C_TX_WIDTH_5-1 downto 0);
    iq_tx_q_5           : in  std_logic_vector(C_TX_WIDTH_5-1 downto 0);
    iq_rx_i_5           : out std_logic_vector(C_RX_WIDTH_5-1 downto 0);
    iq_rx_q_5           : out std_logic_vector(C_RX_WIDTH_5-1 downto 0);
    iq_tx_data_enable_5 : out std_logic;
    iq_rx_data_valid_5  : out std_logic;
    -- I/Q i/f #6
    iq_tx_i_6           : in  std_logic_vector(C_TX_WIDTH_6-1 downto 0);
    iq_tx_q_6           : in  std_logic_vector(C_TX_WIDTH_6-1 downto 0);
    iq_rx_i_6           : out std_logic_vector(C_RX_WIDTH_6-1 downto 0);
    iq_rx_q_6           : out std_logic_vector(C_RX_WIDTH_6-1 downto 0);
    iq_tx_data_enable_6 : out std_logic;
    iq_rx_data_valid_6  : out std_logic;
    -- I/Q i/f #7
    iq_tx_i_7           : in  std_logic_vector(C_TX_WIDTH_7-1 downto 0);
    iq_tx_q_7           : in  std_logic_vector(C_TX_WIDTH_7-1 downto 0);
    iq_rx_i_7           : out std_logic_vector(C_RX_WIDTH_7-1 downto 0);
    iq_rx_q_7           : out std_logic_vector(C_RX_WIDTH_7-1 downto 0);
    iq_tx_data_enable_7 : out std_logic;
    iq_rx_data_valid_7  : out std_logic;
    -- I/Q i/f #8
    iq_tx_i_8           : in  std_logic_vector(C_TX_WIDTH_8-1 downto 0);
    iq_tx_q_8           : in  std_logic_vector(C_TX_WIDTH_8-1 downto 0);
    iq_rx_i_8           : out std_logic_vector(C_RX_WIDTH_8-1 downto 0);
    iq_rx_q_8           : out std_logic_vector(C_RX_WIDTH_8-1 downto 0);
    iq_tx_data_enable_8 : out std_logic;
    iq_rx_data_valid_8  : out std_logic;

    -- I/Q (Data interface)
    iq_tx                  : out  std_logic_vector (63 downto 0);
    iq_tx_enable           : in   std_logic;
    iq_rx                  : in   std_logic_vector (63 downto 0);
    basic_frame_first_word : in   std_logic;

    speed_select           : in   std_logic_vector(14 downto 0);
    clk                    : in   std_logic);
end iq_module_eutra;

architecture rtl of iq_module_eutra is

  -- The module uses the UTRA-FDD IQ module to map the data.
  -- In the transmit direction the logic in this wrapper maps the
  -- 8 channels with up to 8 samples into the 48 channels of the
  -- UTRA-FDD module, each containing one sample. The receiver performs
  -- the mirror image of this mapping.
  component iq_module
  generic (
    C_TX_WIDTH_1  : natural              :=  10;
    C_TX_START_1  : natural              :=   0;
    C_RX_WIDTH_1  : natural              :=  10;
    C_RX_START_1  : natural              :=   0;

    C_TX_WIDTH_2  : natural              :=  10;
    C_TX_START_2  : natural              :=  20;
    C_RX_WIDTH_2  : natural              :=  10;
    C_RX_START_2  : natural              :=  20;

    C_TX_WIDTH_3  : natural              :=  10;
    C_TX_START_3  : natural              :=  40;
    C_RX_WIDTH_3  : natural              :=  10;
    C_RX_START_3  : natural              :=  40;

    C_TX_WIDTH_4  : natural              :=  10;
    C_TX_START_4  : natural              :=  60;
    C_RX_WIDTH_4  : natural              :=  10;
    C_RX_START_4  : natural              :=  60;

    C_TX_WIDTH_5  : natural              :=  10;
    C_TX_START_5  : natural              :=  80;
    C_RX_WIDTH_5  : natural              :=  10;
    C_RX_START_5  : natural              :=  80;

    C_TX_WIDTH_6  : natural              :=  10;
    C_TX_START_6  : natural              := 100;
    C_RX_WIDTH_6  : natural              :=  10;
    C_RX_START_6  : natural              := 100;

    C_TX_WIDTH_7  : natural              :=   0;
    C_TX_START_7  : natural              := 120;
    C_RX_WIDTH_7  : natural              :=   0;
    C_RX_START_7  : natural              := 120;

    C_TX_WIDTH_8  : natural              :=   0;
    C_TX_START_8  : natural              := 140;
    C_RX_WIDTH_8  : natural              :=   0;
    C_RX_START_8  : natural              := 140;

    C_TX_WIDTH_9  : natural              :=   0;
    C_TX_START_9  : natural              := 160;
    C_RX_WIDTH_9  : natural              :=   0;
    C_RX_START_9  : natural              := 160;

    C_TX_WIDTH_10 : natural              :=   0;
    C_TX_START_10 : natural              := 180;
    C_RX_WIDTH_10 : natural              :=   0;
    C_RX_START_10 : natural              := 180;

    C_TX_WIDTH_11 : natural              :=   0;
    C_TX_START_11 : natural              := 200;
    C_RX_WIDTH_11 : natural              :=   0;
    C_RX_START_11 : natural              := 200;

    C_TX_WIDTH_12 : natural              :=   0;
    C_TX_START_12 : natural              := 220;
    C_RX_WIDTH_12 : natural              :=   0;
    C_RX_START_12 : natural              := 220;

    C_TX_WIDTH_13 : natural              :=   0;
    C_TX_START_13 : natural              := 240;
    C_RX_WIDTH_13 : natural              :=   0;
    C_RX_START_13 : natural              := 240;

    C_TX_WIDTH_14 : natural              :=   0;
    C_TX_START_14 : natural              := 260;
    C_RX_WIDTH_14 : natural              :=   0;
    C_RX_START_14 : natural              := 260;

    C_TX_WIDTH_15 : natural              :=   0;
    C_TX_START_15 : natural              := 280;
    C_RX_WIDTH_15 : natural              :=   0;
    C_RX_START_15 : natural              := 280;

    C_TX_WIDTH_16 : natural              :=   0;
    C_TX_START_16 : natural              := 300;
    C_RX_WIDTH_16 : natural              :=   0;
    C_RX_START_16 : natural              := 300;

    C_TX_WIDTH_17 : natural              :=   0;
    C_TX_START_17 : natural              := 320;
    C_RX_WIDTH_17 : natural              :=   0;
    C_RX_START_17 : natural              := 320;

    C_TX_WIDTH_18 : natural              :=   0;
    C_TX_START_18 : natural              := 340;
    C_RX_WIDTH_18 : natural              :=   0;
    C_RX_START_18 : natural              := 340;

    C_TX_WIDTH_19 : natural              :=   0;
    C_TX_START_19 : natural              := 360;
    C_RX_WIDTH_19 : natural              :=   0;
    C_RX_START_19 : natural              := 360;

    C_TX_WIDTH_20 : natural              :=   0;
    C_TX_START_20 : natural              := 380;
    C_RX_WIDTH_20 : natural              :=   0;
    C_RX_START_20 : natural              := 380;

    C_TX_WIDTH_21 : natural              :=   0;
    C_TX_START_21 : natural              := 400;
    C_RX_WIDTH_21 : natural              :=   0;
    C_RX_START_21 : natural              := 400;

    C_TX_WIDTH_22 : natural              :=   0;
    C_TX_START_22 : natural              := 420;
    C_RX_WIDTH_22 : natural              :=   0;
    C_RX_START_22 : natural              := 420;

    C_TX_WIDTH_23 : natural              :=   0;
    C_TX_START_23 : natural              := 440;
    C_RX_WIDTH_23 : natural              :=   0;
    C_RX_START_23 : natural              := 440;

    C_TX_WIDTH_24 : natural              :=   0;
    C_TX_START_24 : natural              := 460;
    C_RX_WIDTH_24 : natural              :=   0;
    C_RX_START_24 : natural              := 460;

    C_TX_WIDTH_25 : natural              :=   0;
    C_TX_START_25 : natural              := 480;
    C_RX_WIDTH_25 : natural              :=   0;
    C_RX_START_25 : natural              := 480;

    C_TX_WIDTH_26 : natural              :=   0;
    C_TX_START_26 : natural              := 500;
    C_RX_WIDTH_26 : natural              :=   0;
    C_RX_START_26 : natural              := 500;

    C_TX_WIDTH_27 : natural              :=   0;
    C_TX_START_27 : natural              := 520;
    C_RX_WIDTH_27 : natural              :=   0;
    C_RX_START_27 : natural              := 520;

    C_TX_WIDTH_28 : natural              :=   0;
    C_TX_START_28 : natural              := 540;
    C_RX_WIDTH_28 : natural              :=   0;
    C_RX_START_28 : natural              := 540;

    C_TX_WIDTH_29 : natural              :=   0;
    C_TX_START_29 : natural              := 560;
    C_RX_WIDTH_29 : natural              :=   0;
    C_RX_START_29 : natural              := 560;

    C_TX_WIDTH_30 : natural              :=   0;
    C_TX_START_30 : natural              := 580;
    C_RX_WIDTH_30 : natural              :=   0;
    C_RX_START_30 : natural              := 580;

    C_TX_WIDTH_31 : natural              :=   0;
    C_TX_START_31 : natural              := 600;
    C_RX_WIDTH_31 : natural              :=   0;
    C_RX_START_31 : natural              := 600;

    C_TX_WIDTH_32 : natural              :=   0;
    C_TX_START_32 : natural              := 620;
    C_RX_WIDTH_32 : natural              :=   0;
    C_RX_START_32 : natural              := 620;

    C_TX_WIDTH_33 : natural              :=   0;
    C_TX_START_33 : natural              := 640;
    C_RX_WIDTH_33 : natural              :=   0;
    C_RX_START_33 : natural              := 640;

    C_TX_WIDTH_34 : natural              :=   0;
    C_TX_START_34 : natural              := 660;
    C_RX_WIDTH_34 : natural              :=   0;
    C_RX_START_34 : natural              := 660;

    C_TX_WIDTH_35 : natural              :=   0;
    C_TX_START_35 : natural              := 680;
    C_RX_WIDTH_35 : natural              :=   0;
    C_RX_START_35 : natural              := 680;

    C_TX_WIDTH_36 : natural              :=   0;
    C_TX_START_36 : natural              := 700;
    C_RX_WIDTH_36 : natural              :=   0;
    C_RX_START_36 : natural              := 700;

    C_TX_WIDTH_37 : natural              :=   0;
    C_TX_START_37 : natural              := 720;
    C_RX_WIDTH_37 : natural              :=   0;
    C_RX_START_37 : natural              := 720;

    C_TX_WIDTH_38 : natural              :=   0;
    C_TX_START_38 : natural              := 740;
    C_RX_WIDTH_38 : natural              :=   0;
    C_RX_START_38 : natural              := 740;

    C_TX_WIDTH_39 : natural              :=   0;
    C_TX_START_39 : natural              := 760;
    C_RX_WIDTH_39 : natural              :=   0;
    C_RX_START_39 : natural              := 760;

    C_TX_WIDTH_40 : natural              :=   0;
    C_TX_START_40 : natural              := 780;
    C_RX_WIDTH_40 : natural              :=   0;
    C_RX_START_40 : natural              := 780;

    C_TX_WIDTH_41 : natural              :=   0;
    C_TX_START_41 : natural              := 800;
    C_RX_WIDTH_41 : natural              :=   0;
    C_RX_START_41 : natural              := 800;

    C_TX_WIDTH_42 : natural              :=   0;
    C_TX_START_42 : natural              := 820;
    C_RX_WIDTH_42 : natural              :=   0;
    C_RX_START_42 : natural              := 820;

    C_TX_WIDTH_43 : natural              :=   0;
    C_TX_START_43 : natural              := 840;
    C_RX_WIDTH_43 : natural              :=   0;
    C_RX_START_43 : natural              := 840;

    C_TX_WIDTH_44 : natural              :=   0;
    C_TX_START_44 : natural              := 860;
    C_RX_WIDTH_44 : natural              :=   0;
    C_RX_START_44 : natural              := 860;

    C_TX_WIDTH_45 : natural              :=   0;
    C_TX_START_45 : natural              := 880;
    C_RX_WIDTH_45 : natural              :=   0;
    C_RX_START_45 : natural              := 880;

    C_TX_WIDTH_46 : natural              :=   0;
    C_TX_START_46 : natural              := 900;
    C_RX_WIDTH_46 : natural              :=   0;
    C_RX_START_46 : natural              := 900;

    C_TX_WIDTH_47 : natural              :=   0;
    C_TX_START_47 : natural              := 920;
    C_RX_WIDTH_47 : natural              :=   0;
    C_RX_START_47 : natural              := 920;

    C_TX_WIDTH_48 : natural              :=   0;
    C_TX_START_48 : natural              := 940;
    C_RX_WIDTH_48 : natural              :=   0;
    C_RX_START_48 : natural              := 940
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
    iq_tx            : out std_logic_vector (63 downto 0);
    iq_rx            : in  std_logic_vector (63 downto 0);
    basic_frame_first_word : in  std_logic;

    speed_select     : in  std_logic_vector(14 downto 0);
    clk                    : in  std_logic);
  end component;

  -- Start positions of each of the AxC containers.
  -- Assumes "packed position" mapping
  constant C_TX_START_CH_2 : natural := (2*C_TX_WIDTH_1)*C_TX_S_1;
  constant C_TX_START_CH_3 : natural := C_TX_START_CH_2 + ((2*C_TX_WIDTH_2)*C_TX_S_2);
  constant C_TX_START_CH_4 : natural := C_TX_START_CH_3 + ((2*C_TX_WIDTH_3)*C_TX_S_3);
  constant C_TX_START_CH_5 : natural := C_TX_START_CH_4 + ((2*C_TX_WIDTH_4)*C_TX_S_4);
  constant C_TX_START_CH_6 : natural := C_TX_START_CH_5 + ((2*C_TX_WIDTH_5)*C_TX_S_5);
  constant C_TX_START_CH_7 : natural := C_TX_START_CH_6 + ((2*C_TX_WIDTH_6)*C_TX_S_6);
  constant C_TX_START_CH_8 : natural := C_TX_START_CH_7 + ((2*C_TX_WIDTH_7)*C_TX_S_7);
  constant C_TX_END        : natural := C_TX_START_CH_8 + ((2*C_TX_WIDTH_8)*C_TX_S_8);
  constant C_RX_START_CH_2 : natural := (2*C_RX_WIDTH_1)*C_RX_S_1;
  constant C_RX_START_CH_3 : natural := C_RX_START_CH_2 + ((2*C_RX_WIDTH_2)*C_RX_S_2);
  constant C_RX_START_CH_4 : natural := C_RX_START_CH_3 + ((2*C_RX_WIDTH_3)*C_RX_S_3);
  constant C_RX_START_CH_5 : natural := C_RX_START_CH_4 + ((2*C_RX_WIDTH_4)*C_RX_S_4);
  constant C_RX_START_CH_6 : natural := C_RX_START_CH_5 + ((2*C_RX_WIDTH_5)*C_RX_S_5);
  constant C_RX_START_CH_7 : natural := C_RX_START_CH_6 + ((2*C_RX_WIDTH_6)*C_RX_S_6);
  constant C_RX_START_CH_8 : natural := C_RX_START_CH_7 + ((2*C_RX_WIDTH_7)*C_RX_S_7);
  constant C_RX_END        : natural := C_RX_START_CH_8 + ((2*C_RX_WIDTH_8)*C_RX_S_8);

  -- In the transmit direction the start positions of each of the internal
  -- UTRA-FDD IQ module channels are calculated by the tx_calc_start_positions
  -- function.
  function tx_calc_start_positions(channel_no : natural) return natural is
  variable ret_val : natural := 0;
  begin
    if (channel_no-1)*(2*C_TX_WIDTH_1) < C_TX_START_CH_2 then
      ret_val := (channel_no-1)*(2*C_TX_WIDTH_1);
    elsif C_TX_START_CH_2 + (channel_no-C_TX_S_1-1)*(2*C_TX_WIDTH_2) < C_TX_START_CH_3 then
      ret_val := C_TX_START_CH_2 + (channel_no-C_TX_S_1-1)*(2*C_TX_WIDTH_2);
    elsif C_TX_START_CH_3 + (channel_no-C_TX_S_1-C_TX_S_2-1)*(2*C_TX_WIDTH_3) < C_TX_START_CH_4 then
      ret_val := C_TX_START_CH_3 + (channel_no-C_TX_S_1-C_TX_S_2-1)*(2*C_TX_WIDTH_3);
    elsif C_TX_START_CH_4 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-1)*(2*C_TX_WIDTH_4) < C_TX_START_CH_5 then
      ret_val := C_TX_START_CH_4 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-1)*(2*C_TX_WIDTH_4);
    elsif C_TX_START_CH_5 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-1)*(2*C_TX_WIDTH_5) < C_TX_START_CH_6 then
      ret_val := C_TX_START_CH_5 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-1)*(2*C_TX_WIDTH_5);
    elsif C_TX_START_CH_6 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-1)*(2*C_TX_WIDTH_6) < C_TX_START_CH_7 then
      ret_val := C_TX_START_CH_6 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-1)*(2*C_TX_WIDTH_6);
    elsif C_TX_START_CH_7 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-1)*(2*C_TX_WIDTH_7) < C_TX_START_CH_8 then
      ret_val := C_TX_START_CH_7 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-1)*(2*C_TX_WIDTH_7);
    else
      ret_val := C_TX_START_CH_8 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-C_TX_S_7-1)*(2*C_TX_WIDTH_8);
    end if;
    return ret_val;
  end function;

  -- In the transmit direction the widths of each of the internal
  -- UTRA-FDD IQ module channels are calculated by the tx_calc_widths
  -- function.
  function tx_calc_widths(channel_no : natural) return natural is
  variable ret_val : natural := 0;
  begin
    if (channel_no-1)*(2*C_TX_WIDTH_1) < C_TX_START_CH_2 then
      ret_val := C_TX_WIDTH_1;
    elsif C_TX_START_CH_2 + (channel_no-C_TX_S_1-1)*(2*C_TX_WIDTH_2) < C_TX_START_CH_3 then
      ret_val := C_TX_WIDTH_2;
    elsif C_TX_START_CH_3 + (channel_no-C_TX_S_1-C_TX_S_2-1)*(2*C_TX_WIDTH_3) < C_TX_START_CH_4 then
      ret_val := C_TX_WIDTH_3;
    elsif C_TX_START_CH_4 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-1)*(2*C_TX_WIDTH_4) < C_TX_START_CH_5 then
      ret_val := C_TX_WIDTH_4;
    elsif C_TX_START_CH_5 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-1)*(2*C_TX_WIDTH_5) < C_TX_START_CH_6 then
      ret_val := C_TX_WIDTH_5;
    elsif C_TX_START_CH_6 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-1)*(2*C_TX_WIDTH_6) < C_TX_START_CH_7 then
      ret_val := C_TX_WIDTH_6;
    elsif C_TX_START_CH_7 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-1)*(2*C_TX_WIDTH_7) < C_TX_START_CH_8 then
      ret_val := C_TX_WIDTH_7;
    elsif C_TX_START_CH_8 + (channel_no-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-C_TX_S_7-1)*(2*C_TX_WIDTH_8) < C_TX_END then
      ret_val := C_TX_WIDTH_8;
    else
      ret_val := 0;
    end if;
    return ret_val;
  end function;

  -- In the receive direction the start positions of each of the internal
  -- UTRA-FDD IQ module channels are calculated by the rx_calc_start_positions
  -- function.
  function rx_calc_start_positions(channel_no : natural) return natural is
  variable ret_val : natural := 0;
  begin
    if (channel_no-1)*(2*C_RX_WIDTH_1) < C_RX_START_CH_2 then
      ret_val := (channel_no-1)*(2*C_RX_WIDTH_1);
    elsif C_RX_START_CH_2 + (channel_no-C_RX_S_1-1)*(2*C_RX_WIDTH_2) < C_RX_START_CH_3 then
      ret_val := C_RX_START_CH_2 + (channel_no-C_RX_S_1-1)*(2*C_RX_WIDTH_2);
    elsif C_RX_START_CH_3 + (channel_no-C_RX_S_1-C_RX_S_2-1)*(2*C_RX_WIDTH_3) < C_RX_START_CH_4 then
      ret_val := C_RX_START_CH_3 + (channel_no-C_RX_S_1-C_RX_S_2-1)*(2*C_RX_WIDTH_3);
    elsif C_RX_START_CH_4 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-1)*(2*C_RX_WIDTH_4) < C_RX_START_CH_5 then
      ret_val := C_RX_START_CH_4 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-1)*(2*C_RX_WIDTH_4);
    elsif C_RX_START_CH_5 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-1)*(2*C_RX_WIDTH_5) < C_RX_START_CH_6 then
      ret_val := C_RX_START_CH_5 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-1)*(2*C_RX_WIDTH_5);
    elsif C_RX_START_CH_6 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-C_RX_S_5-1)*(2*C_RX_WIDTH_6) < C_RX_START_CH_7 then
      ret_val := C_RX_START_CH_6 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-C_RX_S_5-1)*(2*C_RX_WIDTH_6);
    elsif C_RX_START_CH_7 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-C_RX_S_5-C_RX_S_6-1)*(2*C_RX_WIDTH_7) < C_RX_START_CH_8 then
      ret_val := C_RX_START_CH_7 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-C_RX_S_5-C_RX_S_6-1)*(2*C_RX_WIDTH_7);
    else
      ret_val := C_RX_START_CH_8 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-C_RX_S_5-C_RX_S_6-C_RX_S_7-1)*(2*C_RX_WIDTH_8);
    end if;
    return ret_val;
  end function;

  -- In the receive direction the widths of each of the internal
  -- UTRA-FDD IQ module channels are calculated by the rx_calc_widths
  -- function.
  function rx_calc_widths(channel_no : natural) return natural is
  variable ret_val : natural := 0;
  begin
    if (channel_no-1)*(2*C_RX_WIDTH_1) < C_RX_START_CH_2 then
      ret_val := C_RX_WIDTH_1;
    elsif C_RX_START_CH_2 + (channel_no-C_RX_S_1-1)*(2*C_RX_WIDTH_2) < C_RX_START_CH_3 then
      ret_val := C_RX_WIDTH_2;
    elsif C_RX_START_CH_3 + (channel_no-C_RX_S_1-C_RX_S_2-1)*(2*C_RX_WIDTH_3) < C_RX_START_CH_4 then
      ret_val := C_RX_WIDTH_3;
    elsif C_RX_START_CH_4 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-1)*(2*C_RX_WIDTH_4) < C_RX_START_CH_5 then
      ret_val := C_RX_WIDTH_4;
    elsif C_RX_START_CH_5 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-1)*(2*C_RX_WIDTH_5) < C_RX_START_CH_6 then
      ret_val := C_RX_WIDTH_5;
    elsif C_RX_START_CH_6 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-C_RX_S_5-1)*(2*C_RX_WIDTH_6) < C_RX_START_CH_7 then
      ret_val := C_RX_WIDTH_6;
    elsif C_RX_START_CH_7 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-C_RX_S_5-C_RX_S_6-1)*(2*C_RX_WIDTH_7) < C_RX_START_CH_8 then
      ret_val := C_RX_WIDTH_7;
    elsif C_RX_START_CH_8 + (channel_no-C_RX_S_1-C_RX_S_2-C_RX_S_3-C_RX_S_4-C_RX_S_5-C_RX_S_6-C_RX_S_7-1)*(2*C_RX_WIDTH_8) < C_RX_END then
      ret_val := C_RX_WIDTH_8;
    else
      ret_val := 0;
    end if;
    return ret_val;
  end function;

  signal iq_tx_i_1_i  : std_logic_vector(tx_calc_widths(1)-1 downto 0) := (others => '0');
  signal iq_tx_q_1_i  : std_logic_vector(tx_calc_widths(1)-1 downto 0) := (others => '0');
  signal iq_rx_i_1_i  : std_logic_vector(rx_calc_widths(1)-1 downto 0);
  signal iq_rx_q_1_i  : std_logic_vector(rx_calc_widths(1)-1 downto 0);
  signal iq_tx_i_2_i  : std_logic_vector(tx_calc_widths(2)-1 downto 0) := (others => '0');
  signal iq_tx_q_2_i  : std_logic_vector(tx_calc_widths(2)-1 downto 0) := (others => '0');
  signal iq_rx_i_2_i  : std_logic_vector(rx_calc_widths(2)-1 downto 0);
  signal iq_rx_q_2_i  : std_logic_vector(rx_calc_widths(2)-1 downto 0);
  signal iq_tx_i_3_i  : std_logic_vector(tx_calc_widths(3)-1 downto 0) := (others => '0');
  signal iq_tx_q_3_i  : std_logic_vector(tx_calc_widths(3)-1 downto 0) := (others => '0');
  signal iq_rx_i_3_i  : std_logic_vector(rx_calc_widths(3)-1 downto 0);
  signal iq_rx_q_3_i  : std_logic_vector(rx_calc_widths(3)-1 downto 0);
  signal iq_tx_i_4_i  : std_logic_vector(tx_calc_widths(4)-1 downto 0) := (others => '0');
  signal iq_tx_q_4_i  : std_logic_vector(tx_calc_widths(4)-1 downto 0) := (others => '0');
  signal iq_rx_i_4_i  : std_logic_vector(rx_calc_widths(4)-1 downto 0);
  signal iq_rx_q_4_i  : std_logic_vector(rx_calc_widths(4)-1 downto 0);
  signal iq_tx_i_5_i  : std_logic_vector(tx_calc_widths(5)-1 downto 0) := (others => '0');
  signal iq_tx_q_5_i  : std_logic_vector(tx_calc_widths(5)-1 downto 0) := (others => '0');
  signal iq_rx_i_5_i  : std_logic_vector(rx_calc_widths(5)-1 downto 0);
  signal iq_rx_q_5_i  : std_logic_vector(rx_calc_widths(5)-1 downto 0);
  signal iq_tx_i_6_i  : std_logic_vector(tx_calc_widths(6)-1 downto 0) := (others => '0');
  signal iq_tx_q_6_i  : std_logic_vector(tx_calc_widths(6)-1 downto 0) := (others => '0');
  signal iq_rx_i_6_i  : std_logic_vector(rx_calc_widths(6)-1 downto 0);
  signal iq_rx_q_6_i  : std_logic_vector(rx_calc_widths(6)-1 downto 0);
  signal iq_tx_i_7_i  : std_logic_vector(tx_calc_widths(7)-1 downto 0) := (others => '0');
  signal iq_tx_q_7_i  : std_logic_vector(tx_calc_widths(7)-1 downto 0) := (others => '0');
  signal iq_rx_i_7_i  : std_logic_vector(rx_calc_widths(7)-1 downto 0);
  signal iq_rx_q_7_i  : std_logic_vector(rx_calc_widths(7)-1 downto 0);
  signal iq_tx_i_8_i  : std_logic_vector(tx_calc_widths(8)-1 downto 0) := (others => '0');
  signal iq_tx_q_8_i  : std_logic_vector(tx_calc_widths(8)-1 downto 0) := (others => '0');
  signal iq_rx_i_8_i  : std_logic_vector(rx_calc_widths(8)-1 downto 0);
  signal iq_rx_q_8_i  : std_logic_vector(rx_calc_widths(8)-1 downto 0);
  signal iq_tx_i_9_i  : std_logic_vector(tx_calc_widths(9)-1 downto 0) := (others => '0');
  signal iq_tx_q_9_i  : std_logic_vector(tx_calc_widths(9)-1 downto 0) := (others => '0');
  signal iq_rx_i_9_i  : std_logic_vector(rx_calc_widths(9)-1 downto 0);
  signal iq_rx_q_9_i  : std_logic_vector(rx_calc_widths(9)-1 downto 0);
  signal iq_tx_i_10_i : std_logic_vector(tx_calc_widths(10)-1 downto 0) := (others => '0');
  signal iq_tx_q_10_i : std_logic_vector(tx_calc_widths(10)-1 downto 0) := (others => '0');
  signal iq_rx_i_10_i : std_logic_vector(rx_calc_widths(10)-1 downto 0);
  signal iq_rx_q_10_i : std_logic_vector(rx_calc_widths(10)-1 downto 0);
  signal iq_tx_i_11_i : std_logic_vector(tx_calc_widths(11)-1 downto 0) := (others => '0');
  signal iq_tx_q_11_i : std_logic_vector(tx_calc_widths(11)-1 downto 0) := (others => '0');
  signal iq_rx_i_11_i : std_logic_vector(rx_calc_widths(11)-1 downto 0);
  signal iq_rx_q_11_i : std_logic_vector(rx_calc_widths(11)-1 downto 0);
  signal iq_tx_i_12_i : std_logic_vector(tx_calc_widths(12)-1 downto 0) := (others => '0');
  signal iq_tx_q_12_i : std_logic_vector(tx_calc_widths(12)-1 downto 0) := (others => '0');
  signal iq_rx_i_12_i : std_logic_vector(rx_calc_widths(12)-1 downto 0);
  signal iq_rx_q_12_i : std_logic_vector(rx_calc_widths(12)-1 downto 0);
  signal iq_tx_i_13_i : std_logic_vector(tx_calc_widths(13)-1 downto 0) := (others => '0');
  signal iq_tx_q_13_i : std_logic_vector(tx_calc_widths(13)-1 downto 0) := (others => '0');
  signal iq_rx_i_13_i : std_logic_vector(rx_calc_widths(13)-1 downto 0);
  signal iq_rx_q_13_i : std_logic_vector(rx_calc_widths(13)-1 downto 0);
  signal iq_tx_i_14_i : std_logic_vector(tx_calc_widths(14)-1 downto 0) := (others => '0');
  signal iq_tx_q_14_i : std_logic_vector(tx_calc_widths(14)-1 downto 0) := (others => '0');
  signal iq_rx_i_14_i : std_logic_vector(rx_calc_widths(14)-1 downto 0);
  signal iq_rx_q_14_i : std_logic_vector(rx_calc_widths(14)-1 downto 0);
  signal iq_tx_i_15_i : std_logic_vector(tx_calc_widths(15)-1 downto 0) := (others => '0');
  signal iq_tx_q_15_i : std_logic_vector(tx_calc_widths(15)-1 downto 0) := (others => '0');
  signal iq_rx_i_15_i : std_logic_vector(rx_calc_widths(15)-1 downto 0);
  signal iq_rx_q_15_i : std_logic_vector(rx_calc_widths(15)-1 downto 0);
  signal iq_tx_i_16_i : std_logic_vector(tx_calc_widths(16)-1 downto 0) := (others => '0');
  signal iq_tx_q_16_i : std_logic_vector(tx_calc_widths(16)-1 downto 0) := (others => '0');
  signal iq_rx_i_16_i : std_logic_vector(rx_calc_widths(16)-1 downto 0);
  signal iq_rx_q_16_i : std_logic_vector(rx_calc_widths(16)-1 downto 0);
  signal iq_tx_i_17_i : std_logic_vector(tx_calc_widths(17)-1 downto 0) := (others => '0');
  signal iq_tx_q_17_i : std_logic_vector(tx_calc_widths(17)-1 downto 0) := (others => '0');
  signal iq_rx_i_17_i : std_logic_vector(rx_calc_widths(17)-1 downto 0);
  signal iq_rx_q_17_i : std_logic_vector(rx_calc_widths(17)-1 downto 0);
  signal iq_tx_i_18_i : std_logic_vector(tx_calc_widths(18)-1 downto 0) := (others => '0');
  signal iq_tx_q_18_i : std_logic_vector(tx_calc_widths(18)-1 downto 0) := (others => '0');
  signal iq_rx_i_18_i : std_logic_vector(rx_calc_widths(18)-1 downto 0);
  signal iq_rx_q_18_i : std_logic_vector(rx_calc_widths(18)-1 downto 0);
  signal iq_tx_i_19_i : std_logic_vector(tx_calc_widths(19)-1 downto 0) := (others => '0');
  signal iq_tx_q_19_i : std_logic_vector(tx_calc_widths(19)-1 downto 0) := (others => '0');
  signal iq_rx_i_19_i : std_logic_vector(rx_calc_widths(19)-1 downto 0);
  signal iq_rx_q_19_i : std_logic_vector(rx_calc_widths(19)-1 downto 0);
  signal iq_tx_i_20_i : std_logic_vector(tx_calc_widths(20)-1 downto 0) := (others => '0');
  signal iq_tx_q_20_i : std_logic_vector(tx_calc_widths(20)-1 downto 0) := (others => '0');
  signal iq_rx_i_20_i : std_logic_vector(rx_calc_widths(20)-1 downto 0);
  signal iq_rx_q_20_i : std_logic_vector(rx_calc_widths(20)-1 downto 0);
  signal iq_tx_i_21_i : std_logic_vector(tx_calc_widths(21)-1 downto 0) := (others => '0');
  signal iq_tx_q_21_i : std_logic_vector(tx_calc_widths(21)-1 downto 0) := (others => '0');
  signal iq_rx_i_21_i : std_logic_vector(rx_calc_widths(21)-1 downto 0);
  signal iq_rx_q_21_i : std_logic_vector(rx_calc_widths(21)-1 downto 0);
  signal iq_tx_i_22_i : std_logic_vector(tx_calc_widths(22)-1 downto 0) := (others => '0');
  signal iq_tx_q_22_i : std_logic_vector(tx_calc_widths(22)-1 downto 0) := (others => '0');
  signal iq_rx_i_22_i : std_logic_vector(rx_calc_widths(22)-1 downto 0);
  signal iq_rx_q_22_i : std_logic_vector(rx_calc_widths(22)-1 downto 0);
  signal iq_tx_i_23_i : std_logic_vector(tx_calc_widths(23)-1 downto 0) := (others => '0');
  signal iq_tx_q_23_i : std_logic_vector(tx_calc_widths(23)-1 downto 0) := (others => '0');
  signal iq_rx_i_23_i : std_logic_vector(rx_calc_widths(23)-1 downto 0);
  signal iq_rx_q_23_i : std_logic_vector(rx_calc_widths(23)-1 downto 0);
  signal iq_tx_i_24_i : std_logic_vector(tx_calc_widths(24)-1 downto 0) := (others => '0');
  signal iq_tx_q_24_i : std_logic_vector(tx_calc_widths(24)-1 downto 0) := (others => '0');
  signal iq_rx_i_24_i : std_logic_vector(rx_calc_widths(24)-1 downto 0);
  signal iq_rx_q_24_i : std_logic_vector(rx_calc_widths(24)-1 downto 0);
  signal iq_tx_i_25_i : std_logic_vector(tx_calc_widths(25)-1 downto 0) := (others => '0');
  signal iq_tx_q_25_i : std_logic_vector(tx_calc_widths(25)-1 downto 0) := (others => '0');
  signal iq_rx_i_25_i : std_logic_vector(rx_calc_widths(25)-1 downto 0);
  signal iq_rx_q_25_i : std_logic_vector(rx_calc_widths(25)-1 downto 0);
  signal iq_tx_i_26_i : std_logic_vector(tx_calc_widths(26)-1 downto 0) := (others => '0');
  signal iq_tx_q_26_i : std_logic_vector(tx_calc_widths(26)-1 downto 0) := (others => '0');
  signal iq_rx_i_26_i : std_logic_vector(rx_calc_widths(26)-1 downto 0);
  signal iq_rx_q_26_i : std_logic_vector(rx_calc_widths(26)-1 downto 0);
  signal iq_tx_i_27_i : std_logic_vector(tx_calc_widths(27)-1 downto 0) := (others => '0');
  signal iq_tx_q_27_i : std_logic_vector(tx_calc_widths(27)-1 downto 0) := (others => '0');
  signal iq_rx_i_27_i : std_logic_vector(rx_calc_widths(27)-1 downto 0);
  signal iq_rx_q_27_i : std_logic_vector(rx_calc_widths(27)-1 downto 0);
  signal iq_tx_i_28_i : std_logic_vector(tx_calc_widths(28)-1 downto 0) := (others => '0');
  signal iq_tx_q_28_i : std_logic_vector(tx_calc_widths(28)-1 downto 0) := (others => '0');
  signal iq_rx_i_28_i : std_logic_vector(rx_calc_widths(28)-1 downto 0);
  signal iq_rx_q_28_i : std_logic_vector(rx_calc_widths(28)-1 downto 0);
  signal iq_tx_i_29_i : std_logic_vector(tx_calc_widths(29)-1 downto 0) := (others => '0');
  signal iq_tx_q_29_i : std_logic_vector(tx_calc_widths(29)-1 downto 0) := (others => '0');
  signal iq_rx_i_29_i : std_logic_vector(rx_calc_widths(29)-1 downto 0);
  signal iq_rx_q_29_i : std_logic_vector(rx_calc_widths(29)-1 downto 0);
  signal iq_tx_i_30_i : std_logic_vector(tx_calc_widths(30)-1 downto 0) := (others => '0');
  signal iq_tx_q_30_i : std_logic_vector(tx_calc_widths(30)-1 downto 0) := (others => '0');
  signal iq_rx_i_30_i : std_logic_vector(rx_calc_widths(30)-1 downto 0);
  signal iq_rx_q_30_i : std_logic_vector(rx_calc_widths(30)-1 downto 0);
  signal iq_tx_i_31_i : std_logic_vector(tx_calc_widths(31)-1 downto 0) := (others => '0');
  signal iq_tx_q_31_i : std_logic_vector(tx_calc_widths(31)-1 downto 0) := (others => '0');
  signal iq_rx_i_31_i : std_logic_vector(rx_calc_widths(31)-1 downto 0);
  signal iq_rx_q_31_i : std_logic_vector(rx_calc_widths(31)-1 downto 0);
  signal iq_tx_i_32_i : std_logic_vector(tx_calc_widths(32)-1 downto 0) := (others => '0');
  signal iq_tx_q_32_i : std_logic_vector(tx_calc_widths(32)-1 downto 0) := (others => '0');
  signal iq_rx_i_32_i : std_logic_vector(rx_calc_widths(32)-1 downto 0);
  signal iq_rx_q_32_i : std_logic_vector(rx_calc_widths(32)-1 downto 0);
  signal iq_tx_i_33_i : std_logic_vector(tx_calc_widths(33)-1 downto 0) := (others => '0');
  signal iq_tx_q_33_i : std_logic_vector(tx_calc_widths(33)-1 downto 0) := (others => '0');
  signal iq_rx_i_33_i : std_logic_vector(rx_calc_widths(33)-1 downto 0);
  signal iq_rx_q_33_i : std_logic_vector(rx_calc_widths(33)-1 downto 0);
  signal iq_tx_i_34_i : std_logic_vector(tx_calc_widths(34)-1 downto 0) := (others => '0');
  signal iq_tx_q_34_i : std_logic_vector(tx_calc_widths(34)-1 downto 0) := (others => '0');
  signal iq_rx_i_34_i : std_logic_vector(rx_calc_widths(34)-1 downto 0);
  signal iq_rx_q_34_i : std_logic_vector(rx_calc_widths(34)-1 downto 0);
  signal iq_tx_i_35_i : std_logic_vector(tx_calc_widths(35)-1 downto 0) := (others => '0');
  signal iq_tx_q_35_i : std_logic_vector(tx_calc_widths(35)-1 downto 0) := (others => '0');
  signal iq_rx_i_35_i : std_logic_vector(rx_calc_widths(35)-1 downto 0);
  signal iq_rx_q_35_i : std_logic_vector(rx_calc_widths(35)-1 downto 0);
  signal iq_tx_i_36_i : std_logic_vector(tx_calc_widths(36)-1 downto 0) := (others => '0');
  signal iq_tx_q_36_i : std_logic_vector(tx_calc_widths(36)-1 downto 0) := (others => '0');
  signal iq_rx_i_36_i : std_logic_vector(rx_calc_widths(36)-1 downto 0);
  signal iq_rx_q_36_i : std_logic_vector(rx_calc_widths(36)-1 downto 0);
  signal iq_tx_i_37_i : std_logic_vector(tx_calc_widths(37)-1 downto 0) := (others => '0');
  signal iq_tx_q_37_i : std_logic_vector(tx_calc_widths(37)-1 downto 0) := (others => '0');
  signal iq_rx_i_37_i : std_logic_vector(rx_calc_widths(37)-1 downto 0);
  signal iq_rx_q_37_i : std_logic_vector(rx_calc_widths(37)-1 downto 0);
  signal iq_tx_i_38_i : std_logic_vector(tx_calc_widths(38)-1 downto 0) := (others => '0');
  signal iq_tx_q_38_i : std_logic_vector(tx_calc_widths(38)-1 downto 0) := (others => '0');
  signal iq_rx_i_38_i : std_logic_vector(rx_calc_widths(38)-1 downto 0);
  signal iq_rx_q_38_i : std_logic_vector(rx_calc_widths(38)-1 downto 0);
  signal iq_tx_i_39_i : std_logic_vector(tx_calc_widths(39)-1 downto 0) := (others => '0');
  signal iq_tx_q_39_i : std_logic_vector(tx_calc_widths(39)-1 downto 0) := (others => '0');
  signal iq_rx_i_39_i : std_logic_vector(rx_calc_widths(39)-1 downto 0);
  signal iq_rx_q_39_i : std_logic_vector(rx_calc_widths(39)-1 downto 0);
  signal iq_tx_i_40_i : std_logic_vector(tx_calc_widths(40)-1 downto 0) := (others => '0');
  signal iq_tx_q_40_i : std_logic_vector(tx_calc_widths(40)-1 downto 0) := (others => '0');
  signal iq_rx_i_40_i : std_logic_vector(rx_calc_widths(40)-1 downto 0);
  signal iq_rx_q_40_i : std_logic_vector(rx_calc_widths(40)-1 downto 0);
  signal iq_tx_i_41_i : std_logic_vector(tx_calc_widths(41)-1 downto 0) := (others => '0');
  signal iq_tx_q_41_i : std_logic_vector(tx_calc_widths(41)-1 downto 0) := (others => '0');
  signal iq_rx_i_41_i : std_logic_vector(rx_calc_widths(41)-1 downto 0);
  signal iq_rx_q_41_i : std_logic_vector(rx_calc_widths(41)-1 downto 0);
  signal iq_tx_i_42_i : std_logic_vector(tx_calc_widths(42)-1 downto 0) := (others => '0');
  signal iq_tx_q_42_i : std_logic_vector(tx_calc_widths(42)-1 downto 0) := (others => '0');
  signal iq_rx_i_42_i : std_logic_vector(rx_calc_widths(42)-1 downto 0);
  signal iq_rx_q_42_i : std_logic_vector(rx_calc_widths(42)-1 downto 0);
  signal iq_tx_i_43_i : std_logic_vector(tx_calc_widths(43)-1 downto 0) := (others => '0');
  signal iq_tx_q_43_i : std_logic_vector(tx_calc_widths(43)-1 downto 0) := (others => '0');
  signal iq_rx_i_43_i : std_logic_vector(rx_calc_widths(43)-1 downto 0);
  signal iq_rx_q_43_i : std_logic_vector(rx_calc_widths(43)-1 downto 0);
  signal iq_tx_i_44_i : std_logic_vector(tx_calc_widths(44)-1 downto 0) := (others => '0');
  signal iq_tx_q_44_i : std_logic_vector(tx_calc_widths(44)-1 downto 0) := (others => '0');
  signal iq_rx_i_44_i : std_logic_vector(rx_calc_widths(44)-1 downto 0);
  signal iq_rx_q_44_i : std_logic_vector(rx_calc_widths(44)-1 downto 0);
  signal iq_tx_i_45_i : std_logic_vector(tx_calc_widths(45)-1 downto 0) := (others => '0');
  signal iq_tx_q_45_i : std_logic_vector(tx_calc_widths(45)-1 downto 0) := (others => '0');
  signal iq_rx_i_45_i : std_logic_vector(rx_calc_widths(45)-1 downto 0);
  signal iq_rx_q_45_i : std_logic_vector(rx_calc_widths(45)-1 downto 0);
  signal iq_tx_i_46_i : std_logic_vector(tx_calc_widths(46)-1 downto 0) := (others => '0');
  signal iq_tx_q_46_i : std_logic_vector(tx_calc_widths(46)-1 downto 0) := (others => '0');
  signal iq_rx_i_46_i : std_logic_vector(rx_calc_widths(46)-1 downto 0);
  signal iq_rx_q_46_i : std_logic_vector(rx_calc_widths(46)-1 downto 0);
  signal iq_tx_i_47_i : std_logic_vector(tx_calc_widths(47)-1 downto 0) := (others => '0');
  signal iq_tx_q_47_i : std_logic_vector(tx_calc_widths(47)-1 downto 0) := (others => '0');
  signal iq_rx_i_47_i : std_logic_vector(rx_calc_widths(47)-1 downto 0);
  signal iq_rx_q_47_i : std_logic_vector(rx_calc_widths(47)-1 downto 0);
  signal iq_tx_i_48_i : std_logic_vector(tx_calc_widths(48)-1 downto 0) := (others => '0');
  signal iq_tx_q_48_i : std_logic_vector(tx_calc_widths(48)-1 downto 0) := (others => '0');
  signal iq_rx_i_48_i : std_logic_vector(rx_calc_widths(48)-1 downto 0);
  signal iq_rx_q_48_i : std_logic_vector(rx_calc_widths(48)-1 downto 0);

  type ch_1_tx_pipe is array (0 to C_TX_S_1-1) of std_logic_vector(C_TX_WIDTH_1-1 downto 0);
  type ch_2_tx_pipe is array (0 to C_TX_S_2-1) of std_logic_vector(C_TX_WIDTH_2-1 downto 0);
  type ch_3_tx_pipe is array (0 to C_TX_S_3-1) of std_logic_vector(C_TX_WIDTH_3-1 downto 0);
  type ch_4_tx_pipe is array (0 to C_TX_S_4-1) of std_logic_vector(C_TX_WIDTH_4-1 downto 0);
  type ch_5_tx_pipe is array (0 to C_TX_S_5-1) of std_logic_vector(C_TX_WIDTH_5-1 downto 0);
  type ch_6_tx_pipe is array (0 to C_TX_S_6-1) of std_logic_vector(C_TX_WIDTH_6-1 downto 0);
  type ch_7_tx_pipe is array (0 to C_TX_S_7-1) of std_logic_vector(C_TX_WIDTH_7-1 downto 0);
  type ch_8_tx_pipe is array (0 to C_TX_S_8-1) of std_logic_vector(C_TX_WIDTH_8-1 downto 0);
  type ch_1_rx_pipe is array (0 to C_RX_S_1-1) of std_logic_vector(C_RX_WIDTH_1-1 downto 0);
  type ch_2_rx_pipe is array (0 to C_RX_S_2-1) of std_logic_vector(C_RX_WIDTH_2-1 downto 0);
  type ch_3_rx_pipe is array (0 to C_RX_S_3-1) of std_logic_vector(C_RX_WIDTH_3-1 downto 0);
  type ch_4_rx_pipe is array (0 to C_RX_S_4-1) of std_logic_vector(C_RX_WIDTH_4-1 downto 0);
  type ch_5_rx_pipe is array (0 to C_RX_S_5-1) of std_logic_vector(C_RX_WIDTH_5-1 downto 0);
  type ch_6_rx_pipe is array (0 to C_RX_S_6-1) of std_logic_vector(C_RX_WIDTH_6-1 downto 0);
  type ch_7_rx_pipe is array (0 to C_RX_S_7-1) of std_logic_vector(C_RX_WIDTH_7-1 downto 0);
  type ch_8_rx_pipe is array (0 to C_RX_S_8-1) of std_logic_vector(C_RX_WIDTH_8-1 downto 0);

  signal iq_i_tx_1_pipe : ch_1_tx_pipe := (others => (others => '0'));
  signal iq_q_tx_1_pipe : ch_1_tx_pipe := (others => (others => '0'));
  signal iq_i_tx_2_pipe : ch_2_tx_pipe := (others => (others => '0'));
  signal iq_q_tx_2_pipe : ch_2_tx_pipe := (others => (others => '0'));
  signal iq_i_tx_3_pipe : ch_3_tx_pipe := (others => (others => '0'));
  signal iq_q_tx_3_pipe : ch_3_tx_pipe := (others => (others => '0'));
  signal iq_i_tx_4_pipe : ch_4_tx_pipe := (others => (others => '0'));
  signal iq_q_tx_4_pipe : ch_4_tx_pipe := (others => (others => '0'));
  signal iq_i_tx_5_pipe : ch_5_tx_pipe := (others => (others => '0'));
  signal iq_q_tx_5_pipe : ch_5_tx_pipe := (others => (others => '0'));
  signal iq_i_tx_6_pipe : ch_6_tx_pipe := (others => (others => '0'));
  signal iq_q_tx_6_pipe : ch_6_tx_pipe := (others => (others => '0'));
  signal iq_i_tx_7_pipe : ch_7_tx_pipe := (others => (others => '0'));
  signal iq_q_tx_7_pipe : ch_7_tx_pipe := (others => (others => '0'));
  signal iq_i_tx_8_pipe : ch_8_tx_pipe := (others => (others => '0'));
  signal iq_q_tx_8_pipe : ch_8_tx_pipe := (others => (others => '0'));
  signal iq_i_rx_1_pipe : ch_1_rx_pipe;
  signal iq_q_rx_1_pipe : ch_1_rx_pipe;
  signal iq_i_rx_2_pipe : ch_2_rx_pipe;
  signal iq_q_rx_2_pipe : ch_2_rx_pipe;
  signal iq_i_rx_3_pipe : ch_3_rx_pipe;
  signal iq_q_rx_3_pipe : ch_3_rx_pipe;
  signal iq_i_rx_4_pipe : ch_4_rx_pipe;
  signal iq_q_rx_4_pipe : ch_4_rx_pipe;
  signal iq_i_rx_5_pipe : ch_5_rx_pipe;
  signal iq_q_rx_5_pipe : ch_5_rx_pipe;
  signal iq_i_rx_6_pipe : ch_6_rx_pipe;
  signal iq_q_rx_6_pipe : ch_6_rx_pipe;
  signal iq_i_rx_7_pipe : ch_7_rx_pipe;
  signal iq_q_rx_7_pipe : ch_7_rx_pipe;
  signal iq_i_rx_8_pipe : ch_8_rx_pipe;
  signal iq_q_rx_8_pipe : ch_8_rx_pipe;

  type iq_bus is array (0 to 47) of std_logic_vector(19 downto 0);
  signal tx_iq_i_bus : iq_bus;
  signal tx_iq_q_bus : iq_bus;
  signal rx_iq_i_bus : iq_bus;
  signal rx_iq_q_bus : iq_bus;

  signal iq_tx_enable_reg            : std_logic_vector(7 downto 0);
  signal basic_frame_first_word_reg  : std_logic_vector(8 downto 0);
  signal iq_tx_data_enable_pipe      : std_logic_vector(7 downto 0);
  signal basic_frame_first_word_pipe : std_logic_vector(7 downto 0);

  type sample_size_array_type is array (1 to 8) of natural;
  signal tx_sample_size_array : sample_size_array_type := (C_TX_S_1, C_TX_S_2, C_TX_S_3, C_TX_S_4,
                                                           C_TX_S_5, C_TX_S_6, C_TX_S_7, C_TX_S_8);
  signal rx_sample_size_array : sample_size_array_type := (C_RX_S_1, C_RX_S_2, C_RX_S_3, C_RX_S_4,
                                                           C_RX_S_5, C_RX_S_6, C_RX_S_7, C_RX_S_8);

  signal count : unsigned(6 downto 0);

begin

  iq_module_i : iq_module
  generic map (
    C_TX_WIDTH_1  => tx_calc_widths(1),
    C_TX_START_1  => tx_calc_start_positions(1),
    C_RX_WIDTH_1  => rx_calc_widths(1),
    C_RX_START_1  => rx_calc_start_positions(1),

    C_TX_WIDTH_2  => tx_calc_widths(2),
    C_TX_START_2  => tx_calc_start_positions(2),
    C_RX_WIDTH_2  => rx_calc_widths(2),
    C_RX_START_2  => rx_calc_start_positions(2),

    C_TX_WIDTH_3  => tx_calc_widths(3),
    C_TX_START_3  => tx_calc_start_positions(3),
    C_RX_WIDTH_3  => rx_calc_widths(3),
    C_RX_START_3  => rx_calc_start_positions(3),

    C_TX_WIDTH_4  => tx_calc_widths(4),
    C_TX_START_4  => tx_calc_start_positions(4),
    C_RX_WIDTH_4  => rx_calc_widths(4),
    C_RX_START_4  => rx_calc_start_positions(4),

    C_TX_WIDTH_5  => tx_calc_widths(5),
    C_TX_START_5  => tx_calc_start_positions(5),
    C_RX_WIDTH_5  => rx_calc_widths(5),
    C_RX_START_5  => rx_calc_start_positions(5),

    C_TX_WIDTH_6  => tx_calc_widths(6),
    C_TX_START_6  => tx_calc_start_positions(6),
    C_RX_WIDTH_6  => rx_calc_widths(6),
    C_RX_START_6  => rx_calc_start_positions(6),

    C_TX_WIDTH_7  => tx_calc_widths(7),
    C_TX_START_7  => tx_calc_start_positions(7),
    C_RX_WIDTH_7  => rx_calc_widths(7),
    C_RX_START_7  => rx_calc_start_positions(7),

    C_TX_WIDTH_8  => tx_calc_widths(8),
    C_TX_START_8  => tx_calc_start_positions(8),
    C_RX_WIDTH_8  => rx_calc_widths(8),
    C_RX_START_8  => rx_calc_start_positions(8),

    C_TX_WIDTH_9  => tx_calc_widths(9),
    C_TX_START_9  => tx_calc_start_positions(9),
    C_RX_WIDTH_9  => rx_calc_widths(9),
    C_RX_START_9  => rx_calc_start_positions(9),

    C_TX_WIDTH_10 => tx_calc_widths(10),
    C_TX_START_10 => tx_calc_start_positions(10),
    C_RX_WIDTH_10 => rx_calc_widths(10),
    C_RX_START_10 => rx_calc_start_positions(10),

    C_TX_WIDTH_11 => tx_calc_widths(11),
    C_TX_START_11 => tx_calc_start_positions(11),
    C_RX_WIDTH_11 => rx_calc_widths(11),
    C_RX_START_11 => rx_calc_start_positions(11),

    C_TX_WIDTH_12 => tx_calc_widths(12),
    C_TX_START_12 => tx_calc_start_positions(12),
    C_RX_WIDTH_12 => rx_calc_widths(12),
    C_RX_START_12 => rx_calc_start_positions(12),

    C_TX_WIDTH_13 => tx_calc_widths(13),
    C_TX_START_13 => tx_calc_start_positions(13),
    C_RX_WIDTH_13 => rx_calc_widths(13),
    C_RX_START_13 => rx_calc_start_positions(13),

    C_TX_WIDTH_14 => tx_calc_widths(14),
    C_TX_START_14 => tx_calc_start_positions(14),
    C_RX_WIDTH_14 => rx_calc_widths(14),
    C_RX_START_14 => rx_calc_start_positions(14),

    C_TX_WIDTH_15 => tx_calc_widths(15),
    C_TX_START_15 => tx_calc_start_positions(15),
    C_RX_WIDTH_15 => rx_calc_widths(15),
    C_RX_START_15 => rx_calc_start_positions(15),

    C_TX_WIDTH_16 => tx_calc_widths(16),
    C_TX_START_16 => tx_calc_start_positions(16),
    C_RX_WIDTH_16 => rx_calc_widths(16),
    C_RX_START_16 => rx_calc_start_positions(16),

    C_TX_WIDTH_17 => tx_calc_widths(17),
    C_TX_START_17 => tx_calc_start_positions(17),
    C_RX_WIDTH_17 => rx_calc_widths(17),
    C_RX_START_17 => rx_calc_start_positions(17),

    C_TX_WIDTH_18 => tx_calc_widths(18),
    C_TX_START_18 => tx_calc_start_positions(18),
    C_RX_WIDTH_18 => rx_calc_widths(18),
    C_RX_START_18 => rx_calc_start_positions(18),

    C_TX_WIDTH_19 => tx_calc_widths(19),
    C_TX_START_19 => tx_calc_start_positions(19),
    C_RX_WIDTH_19 => rx_calc_widths(19),
    C_RX_START_19 => rx_calc_start_positions(19),

    C_TX_WIDTH_20 => tx_calc_widths(20),
    C_TX_START_20 => tx_calc_start_positions(20),
    C_RX_WIDTH_20 => rx_calc_widths(20),
    C_RX_START_20 => rx_calc_start_positions(20),

    C_TX_WIDTH_21 => tx_calc_widths(21),
    C_TX_START_21 => tx_calc_start_positions(21),
    C_RX_WIDTH_21 => rx_calc_widths(21),
    C_RX_START_21 => rx_calc_start_positions(21),

    C_TX_WIDTH_22 => tx_calc_widths(22),
    C_TX_START_22 => tx_calc_start_positions(22),
    C_RX_WIDTH_22 => rx_calc_widths(22),
    C_RX_START_22 => rx_calc_start_positions(22),

    C_TX_WIDTH_23 => tx_calc_widths(23),
    C_TX_START_23 => tx_calc_start_positions(23),
    C_RX_WIDTH_23 => rx_calc_widths(23),
    C_RX_START_23 => rx_calc_start_positions(23),

    C_TX_WIDTH_24 => tx_calc_widths(24),
    C_TX_START_24 => tx_calc_start_positions(24),
    C_RX_WIDTH_24 => rx_calc_widths(24),
    C_RX_START_24 => rx_calc_start_positions(24),

    C_TX_WIDTH_25 => tx_calc_widths(25),
    C_TX_START_25 => tx_calc_start_positions(25),
    C_RX_WIDTH_25 => rx_calc_widths(25),
    C_RX_START_25 => rx_calc_start_positions(25),

    C_TX_WIDTH_26 => tx_calc_widths(26),
    C_TX_START_26 => tx_calc_start_positions(26),
    C_RX_WIDTH_26 => rx_calc_widths(26),
    C_RX_START_26 => rx_calc_start_positions(26),

    C_TX_WIDTH_27 => tx_calc_widths(27),
    C_TX_START_27 => tx_calc_start_positions(27),
    C_RX_WIDTH_27 => rx_calc_widths(27),
    C_RX_START_27 => rx_calc_start_positions(27),

    C_TX_WIDTH_28 => tx_calc_widths(28),
    C_TX_START_28 => tx_calc_start_positions(28),
    C_RX_WIDTH_28 => rx_calc_widths(28),
    C_RX_START_28 => rx_calc_start_positions(28),

    C_TX_WIDTH_29 => tx_calc_widths(29),
    C_TX_START_29 => tx_calc_start_positions(29),
    C_RX_WIDTH_29 => rx_calc_widths(29),
    C_RX_START_29 => rx_calc_start_positions(29),

    C_TX_WIDTH_30 => tx_calc_widths(30),
    C_TX_START_30 => tx_calc_start_positions(30),
    C_RX_WIDTH_30 => rx_calc_widths(30),
    C_RX_START_30 => rx_calc_start_positions(30),

    C_TX_WIDTH_31 => tx_calc_widths(31),
    C_TX_START_31 => tx_calc_start_positions(31),
    C_RX_WIDTH_31 => rx_calc_widths(31),
    C_RX_START_31 => rx_calc_start_positions(31),

    C_TX_WIDTH_32 => tx_calc_widths(32),
    C_TX_START_32 => tx_calc_start_positions(32),
    C_RX_WIDTH_32 => rx_calc_widths(32),
    C_RX_START_32 => rx_calc_start_positions(32),

    C_TX_WIDTH_33 => tx_calc_widths(33),
    C_TX_START_33 => tx_calc_start_positions(33),
    C_RX_WIDTH_33 => rx_calc_widths(33),
    C_RX_START_33 => rx_calc_start_positions(33),

    C_TX_WIDTH_34 => tx_calc_widths(34),
    C_TX_START_34 => tx_calc_start_positions(34),
    C_RX_WIDTH_34 => rx_calc_widths(34),
    C_RX_START_34 => rx_calc_start_positions(34),

    C_TX_WIDTH_35 => tx_calc_widths(35),
    C_TX_START_35 => tx_calc_start_positions(35),
    C_RX_WIDTH_35 => rx_calc_widths(35),
    C_RX_START_35 => rx_calc_start_positions(35),

    C_TX_WIDTH_36 => tx_calc_widths(36),
    C_TX_START_36 => tx_calc_start_positions(36),
    C_RX_WIDTH_36 => rx_calc_widths(36),
    C_RX_START_36 => rx_calc_start_positions(36),

    C_TX_WIDTH_37 => tx_calc_widths(37),
    C_TX_START_37 => tx_calc_start_positions(37),
    C_RX_WIDTH_37 => rx_calc_widths(37),
    C_RX_START_37 => rx_calc_start_positions(37),

    C_TX_WIDTH_38 => tx_calc_widths(38),
    C_TX_START_38 => tx_calc_start_positions(38),
    C_RX_WIDTH_38 => rx_calc_widths(38),
    C_RX_START_38 => rx_calc_start_positions(38),

    C_TX_WIDTH_39 => tx_calc_widths(39),
    C_TX_START_39 => tx_calc_start_positions(39),
    C_RX_WIDTH_39 => rx_calc_widths(39),
    C_RX_START_39 => rx_calc_start_positions(39),

    C_TX_WIDTH_40 => tx_calc_widths(40),
    C_TX_START_40 => tx_calc_start_positions(40),
    C_RX_WIDTH_40 => rx_calc_widths(40),
    C_RX_START_40 => rx_calc_start_positions(40),

    C_TX_WIDTH_41 => tx_calc_widths(41),
    C_TX_START_41 => tx_calc_start_positions(41),
    C_RX_WIDTH_41 => rx_calc_widths(41),
    C_RX_START_41 => rx_calc_start_positions(41),

    C_TX_WIDTH_42 => tx_calc_widths(42),
    C_TX_START_42 => tx_calc_start_positions(42),
    C_RX_WIDTH_42 => rx_calc_widths(42),
    C_RX_START_42 => rx_calc_start_positions(42),

    C_TX_WIDTH_43 => tx_calc_widths(43),
    C_TX_START_43 => tx_calc_start_positions(43),
    C_RX_WIDTH_43 => rx_calc_widths(43),
    C_RX_START_43 => rx_calc_start_positions(43),

    C_TX_WIDTH_44 => tx_calc_widths(44),
    C_TX_START_44 => tx_calc_start_positions(44),
    C_RX_WIDTH_44 => rx_calc_widths(44),
    C_RX_START_44 => rx_calc_start_positions(44),

    C_TX_WIDTH_45 => tx_calc_widths(45),
    C_TX_START_45 => tx_calc_start_positions(45),
    C_RX_WIDTH_45 => rx_calc_widths(45),
    C_RX_START_45 => rx_calc_start_positions(45),

    C_TX_WIDTH_46 => tx_calc_widths(46),
    C_TX_START_46 => tx_calc_start_positions(46),
    C_RX_WIDTH_46 => rx_calc_widths(46),
    C_RX_START_46 => rx_calc_start_positions(46),

    C_TX_WIDTH_47 => tx_calc_widths(47),
    C_TX_START_47 => tx_calc_start_positions(47),
    C_RX_WIDTH_47 => rx_calc_widths(47),
    C_RX_START_47 => rx_calc_start_positions(47),

    C_TX_WIDTH_48 => tx_calc_widths(48),
    C_TX_START_48 => tx_calc_start_positions(48),
    C_RX_WIDTH_48 => rx_calc_widths(48),
    C_RX_START_48 => rx_calc_start_positions(48)

    )
  port map (
    iq_tx_enable     => iq_tx_enable,
    iq_rx_data_valid => open,
    iq_tx_i_1        => iq_tx_i_1_i,
    iq_tx_q_1        => iq_tx_q_1_i,
    iq_rx_i_1        => iq_rx_i_1_i,
    iq_rx_q_1        => iq_rx_q_1_i,
    iq_tx_i_2        => iq_tx_i_2_i,
    iq_tx_q_2        => iq_tx_q_2_i,
    iq_rx_i_2        => iq_rx_i_2_i,
    iq_rx_q_2        => iq_rx_q_2_i,
    iq_tx_i_3        => iq_tx_i_3_i,
    iq_tx_q_3        => iq_tx_q_3_i,
    iq_rx_i_3        => iq_rx_i_3_i,
    iq_rx_q_3        => iq_rx_q_3_i,
    iq_tx_i_4        => iq_tx_i_4_i,
    iq_tx_q_4        => iq_tx_q_4_i,
    iq_rx_i_4        => iq_rx_i_4_i,
    iq_rx_q_4        => iq_rx_q_4_i,
    iq_tx_i_5        => iq_tx_i_5_i,
    iq_tx_q_5        => iq_tx_q_5_i,
    iq_rx_i_5        => iq_rx_i_5_i,
    iq_rx_q_5        => iq_rx_q_5_i,
    iq_tx_i_6        => iq_tx_i_6_i,
    iq_tx_q_6        => iq_tx_q_6_i,
    iq_rx_i_6        => iq_rx_i_6_i,
    iq_rx_q_6        => iq_rx_q_6_i,
    iq_tx_i_7        => iq_tx_i_7_i,
    iq_tx_q_7        => iq_tx_q_7_i,
    iq_rx_i_7        => iq_rx_i_7_i,
    iq_rx_q_7        => iq_rx_q_7_i,
    iq_tx_i_8        => iq_tx_i_8_i,
    iq_tx_q_8        => iq_tx_q_8_i,
    iq_rx_i_8        => iq_rx_i_8_i,
    iq_rx_q_8        => iq_rx_q_8_i,
    iq_tx_i_9        => iq_tx_i_9_i,
    iq_tx_q_9        => iq_tx_q_9_i,
    iq_rx_i_9        => iq_rx_i_9_i,
    iq_rx_q_9        => iq_rx_q_9_i,
    iq_tx_i_10       => iq_tx_i_10_i,
    iq_tx_q_10       => iq_tx_q_10_i,
    iq_rx_i_10       => iq_rx_i_10_i,
    iq_rx_q_10       => iq_rx_q_10_i,
    iq_tx_i_11       => iq_tx_i_11_i,
    iq_tx_q_11       => iq_tx_q_11_i,
    iq_rx_i_11       => iq_rx_i_11_i,
    iq_rx_q_11       => iq_rx_q_11_i,
    iq_tx_i_12       => iq_tx_i_12_i,
    iq_tx_q_12       => iq_tx_q_12_i,
    iq_rx_i_12       => iq_rx_i_12_i,
    iq_rx_q_12       => iq_rx_q_12_i,
    iq_tx_i_13       => iq_tx_i_13_i,
    iq_tx_q_13       => iq_tx_q_13_i,
    iq_rx_i_13       => iq_rx_i_13_i,
    iq_rx_q_13       => iq_rx_q_13_i,
    iq_tx_i_14       => iq_tx_i_14_i,
    iq_tx_q_14       => iq_tx_q_14_i,
    iq_rx_i_14       => iq_rx_i_14_i,
    iq_rx_q_14       => iq_rx_q_14_i,
    iq_tx_i_15       => iq_tx_i_15_i,
    iq_tx_q_15       => iq_tx_q_15_i,
    iq_rx_i_15       => iq_rx_i_15_i,
    iq_rx_q_15       => iq_rx_q_15_i,
    iq_tx_i_16       => iq_tx_i_16_i,
    iq_tx_q_16       => iq_tx_q_16_i,
    iq_rx_i_16       => iq_rx_i_16_i,
    iq_rx_q_16       => iq_rx_q_16_i,
    iq_tx_i_17       => iq_tx_i_17_i,
    iq_tx_q_17       => iq_tx_q_17_i,
    iq_rx_i_17       => iq_rx_i_17_i,
    iq_rx_q_17       => iq_rx_q_17_i,
    iq_tx_i_18       => iq_tx_i_18_i,
    iq_tx_q_18       => iq_tx_q_18_i,
    iq_rx_i_18       => iq_rx_i_18_i,
    iq_rx_q_18       => iq_rx_q_18_i,
    iq_tx_i_19       => iq_tx_i_19_i,
    iq_tx_q_19       => iq_tx_q_19_i,
    iq_rx_i_19       => iq_rx_i_19_i,
    iq_rx_q_19       => iq_rx_q_19_i,
    iq_tx_i_20       => iq_tx_i_20_i,
    iq_tx_q_20       => iq_tx_q_20_i,
    iq_rx_i_20       => iq_rx_i_20_i,
    iq_rx_q_20       => iq_rx_q_20_i,
    iq_tx_i_21       => iq_tx_i_21_i,
    iq_tx_q_21       => iq_tx_q_21_i,
    iq_rx_i_21       => iq_rx_i_21_i,
    iq_rx_q_21       => iq_rx_q_21_i,
    iq_tx_i_22       => iq_tx_i_22_i,
    iq_tx_q_22       => iq_tx_q_22_i,
    iq_rx_i_22       => iq_rx_i_22_i,
    iq_rx_q_22       => iq_rx_q_22_i,
    iq_tx_i_23       => iq_tx_i_23_i,
    iq_tx_q_23       => iq_tx_q_23_i,
    iq_rx_i_23       => iq_rx_i_23_i,
    iq_rx_q_23       => iq_rx_q_23_i,
    iq_tx_i_24       => iq_tx_i_24_i,
    iq_tx_q_24       => iq_tx_q_24_i,
    iq_rx_i_24       => iq_rx_i_24_i,
    iq_rx_q_24       => iq_rx_q_24_i,
    iq_tx_i_25       => iq_tx_i_25_i,
    iq_tx_q_25       => iq_tx_q_25_i,
    iq_rx_i_25       => iq_rx_i_25_i,
    iq_rx_q_25       => iq_rx_q_25_i,
    iq_tx_i_26       => iq_tx_i_26_i,
    iq_tx_q_26       => iq_tx_q_26_i,
    iq_rx_i_26       => iq_rx_i_26_i,
    iq_rx_q_26       => iq_rx_q_26_i,
    iq_tx_i_27       => iq_tx_i_27_i,
    iq_tx_q_27       => iq_tx_q_27_i,
    iq_rx_i_27       => iq_rx_i_27_i,
    iq_rx_q_27       => iq_rx_q_27_i,
    iq_tx_i_28       => iq_tx_i_28_i,
    iq_tx_q_28       => iq_tx_q_28_i,
    iq_rx_i_28       => iq_rx_i_28_i,
    iq_rx_q_28       => iq_rx_q_28_i,
    iq_tx_i_29       => iq_tx_i_29_i,
    iq_tx_q_29       => iq_tx_q_29_i,
    iq_rx_i_29       => iq_rx_i_29_i,
    iq_rx_q_29       => iq_rx_q_29_i,
    iq_tx_i_30       => iq_tx_i_30_i,
    iq_tx_q_30       => iq_tx_q_30_i,
    iq_rx_i_30       => iq_rx_i_30_i,
    iq_rx_q_30       => iq_rx_q_30_i,
    iq_tx_i_31       => iq_tx_i_31_i,
    iq_tx_q_31       => iq_tx_q_31_i,
    iq_rx_i_31       => iq_rx_i_31_i,
    iq_rx_q_31       => iq_rx_q_31_i,
    iq_tx_i_32       => iq_tx_i_32_i,
    iq_tx_q_32       => iq_tx_q_32_i,
    iq_rx_i_32       => iq_rx_i_32_i,
    iq_rx_q_32       => iq_rx_q_32_i,
    iq_tx_i_33       => iq_tx_i_33_i,
    iq_tx_q_33       => iq_tx_q_33_i,
    iq_rx_i_33       => iq_rx_i_33_i,
    iq_rx_q_33       => iq_rx_q_33_i,
    iq_tx_i_34       => iq_tx_i_34_i,
    iq_tx_q_34       => iq_tx_q_34_i,
    iq_rx_i_34       => iq_rx_i_34_i,
    iq_rx_q_34       => iq_rx_q_34_i,
    iq_tx_i_35       => iq_tx_i_35_i,
    iq_tx_q_35       => iq_tx_q_35_i,
    iq_rx_i_35       => iq_rx_i_35_i,
    iq_rx_q_35       => iq_rx_q_35_i,
    iq_tx_i_36       => iq_tx_i_36_i,
    iq_tx_q_36       => iq_tx_q_36_i,
    iq_rx_i_36       => iq_rx_i_36_i,
    iq_rx_q_36       => iq_rx_q_36_i,
    iq_tx_i_37       => iq_tx_i_37_i,
    iq_tx_q_37       => iq_tx_q_37_i,
    iq_rx_i_37       => iq_rx_i_37_i,
    iq_rx_q_37       => iq_rx_q_37_i,
    iq_tx_i_38       => iq_tx_i_38_i,
    iq_tx_q_38       => iq_tx_q_38_i,
    iq_rx_i_38       => iq_rx_i_38_i,
    iq_rx_q_38       => iq_rx_q_38_i,
    iq_tx_i_39       => iq_tx_i_39_i,
    iq_tx_q_39       => iq_tx_q_39_i,
    iq_rx_i_39       => iq_rx_i_39_i,
    iq_rx_q_39       => iq_rx_q_39_i,
    iq_tx_i_40       => iq_tx_i_40_i,
    iq_tx_q_40       => iq_tx_q_40_i,
    iq_rx_i_40       => iq_rx_i_40_i,
    iq_rx_q_40       => iq_rx_q_40_i,
    iq_tx_i_41       => iq_tx_i_41_i,
    iq_tx_q_41       => iq_tx_q_41_i,
    iq_rx_i_41       => iq_rx_i_41_i,
    iq_rx_q_41       => iq_rx_q_41_i,
    iq_tx_i_42       => iq_tx_i_42_i,
    iq_tx_q_42       => iq_tx_q_42_i,
    iq_rx_i_42       => iq_rx_i_42_i,
    iq_rx_q_42       => iq_rx_q_42_i,
    iq_tx_i_43       => iq_tx_i_43_i,
    iq_tx_q_43       => iq_tx_q_43_i,
    iq_rx_i_43       => iq_rx_i_43_i,
    iq_rx_q_43       => iq_rx_q_43_i,
    iq_tx_i_44       => iq_tx_i_44_i,
    iq_tx_q_44       => iq_tx_q_44_i,
    iq_rx_i_44       => iq_rx_i_44_i,
    iq_rx_q_44       => iq_rx_q_44_i,
    iq_tx_i_45       => iq_tx_i_45_i,
    iq_tx_q_45       => iq_tx_q_45_i,
    iq_rx_i_45       => iq_rx_i_45_i,
    iq_rx_q_45       => iq_rx_q_45_i,
    iq_tx_i_46       => iq_tx_i_46_i,
    iq_tx_q_46       => iq_tx_q_46_i,
    iq_rx_i_46       => iq_rx_i_46_i,
    iq_rx_q_46       => iq_rx_q_46_i,
    iq_tx_i_47       => iq_tx_i_47_i,
    iq_tx_q_47       => iq_tx_q_47_i,
    iq_rx_i_47       => iq_rx_i_47_i,
    iq_rx_q_47       => iq_rx_q_47_i,
    iq_tx_i_48       => iq_tx_i_48_i,
    iq_tx_q_48       => iq_tx_q_48_i,
    iq_rx_i_48       => iq_rx_i_48_i,
    iq_rx_q_48       => iq_rx_q_48_i,
    -- raw iq stream
    iq_tx                  => iq_tx,
    iq_rx                  => iq_rx,
    basic_frame_first_word => basic_frame_first_word,

    speed_select           => speed_select,
    clk                    => clk
    );

    -- Transmit side. Map the samples from the 8 EUTRA channels
    -- into the 48 channels of the IQ module (1 sample per channel).
    -- These are transmitted sequentially.
    process(clk)
    begin
      if rising_edge(clk) then
        iq_tx_enable_reg(0) <= iq_tx_enable;
        iq_tx_enable_reg(7 downto 1) <= iq_tx_enable_reg(6 downto 0);
      end if;
    end process;

    -- Pipeline for each channel. This stores the samples from each
    -- of the 8 EUTRA channels.
    -- Channel 1
    ch1_pipe_gen : if C_TX_WIDTH_1 > 0 generate
      ch1_pipe_gen_1 : for i in 0 to C_TX_S_1-1 generate
        process(clk)
        begin
          if rising_edge(clk) then
            if iq_tx_enable_reg(i) = '1' then
              iq_i_tx_1_pipe(i) <= iq_tx_i_1;
              iq_q_tx_1_pipe(i) <= iq_tx_q_1;
            end if;
          end if;
        end process;
      end generate ch1_pipe_gen_1;
    end generate ch1_pipe_gen;

    -- Channel 2
    ch2_pipe_gen : if C_TX_WIDTH_2 > 0 generate
      ch2_pipe_gen_1 : for i in 0 to C_TX_S_2-1 generate
        process(clk)
        begin
          if rising_edge(clk) then
            if iq_tx_enable_reg(i) = '1' then
              iq_i_tx_2_pipe(i) <= iq_tx_i_2;
              iq_q_tx_2_pipe(i) <= iq_tx_q_2;
            end if;
          end if;
        end process;
      end generate ch2_pipe_gen_1;
    end generate ch2_pipe_gen;

    -- Channel 3
    ch3_pipe_gen : if C_TX_WIDTH_3 > 0 generate
      ch3_pipe_gen_1 : for i in 0 to C_TX_S_3-1 generate
        process(clk)
        begin
          if rising_edge(clk) then
            if iq_tx_enable_reg(i) = '1' then
              iq_i_tx_3_pipe(i) <= iq_tx_i_3;
              iq_q_tx_3_pipe(i) <= iq_tx_q_3;
            end if;
          end if;
        end process;
      end generate ch3_pipe_gen_1;
    end generate ch3_pipe_gen;

    -- Channel 4
    ch4_pipe_gen : if C_TX_WIDTH_4 > 0 generate
      ch4_pipe_gen_1 : for i in 0 to C_TX_S_4-1 generate
        process(clk)
        begin
          if rising_edge(clk) then
            if iq_tx_enable_reg(i) = '1' then
              iq_i_tx_4_pipe(i) <= iq_tx_i_4;
              iq_q_tx_4_pipe(i) <= iq_tx_q_4;
            end if;
          end if;
        end process;
      end generate ch4_pipe_gen_1;
    end generate ch4_pipe_gen;

    -- Channel 5
    ch5_pipe_gen : if C_TX_WIDTH_5 > 0 generate
      ch5_pipe_gen_1 : for i in 0 to C_TX_S_5-1 generate
        process(clk)
        begin
          if rising_edge(clk) then
            if iq_tx_enable_reg(i) = '1' then
              iq_i_tx_5_pipe(i) <= iq_tx_i_5;
              iq_q_tx_5_pipe(i) <= iq_tx_q_5;
            end if;
          end if;
        end process;
      end generate ch5_pipe_gen_1;
    end generate ch5_pipe_gen;

    -- Channel 6
    ch6_pipe_gen : if C_TX_WIDTH_6 > 0 generate
      ch6_pipe_gen_1 : for i in 0 to C_TX_S_6-1 generate
        process(clk)
        begin
          if rising_edge(clk) then
            if iq_tx_enable_reg(i) = '1' then
              iq_i_tx_6_pipe(i) <= iq_tx_i_6;
              iq_q_tx_6_pipe(i) <= iq_tx_q_6;
            end if;
          end if;
        end process;
      end generate ch6_pipe_gen_1;
    end generate ch6_pipe_gen;

    -- Channel 7
    ch7_pipe_gen : if C_TX_WIDTH_7 > 0 generate
      ch7_pipe_gen_1 : for i in 0 to C_TX_S_7-1 generate
        process(clk)
        begin
          if rising_edge(clk) then
            if iq_tx_enable_reg(i) = '1' then
              iq_i_tx_7_pipe(i) <= iq_tx_i_7;
              iq_q_tx_7_pipe(i) <= iq_tx_q_7;
            end if;
          end if;
        end process;
      end generate ch7_pipe_gen_1;
    end generate ch7_pipe_gen;

    -- Channel 8
    ch8_pipe_gen : if C_TX_WIDTH_8 > 0 generate
      ch8_pipe_gen_1 : for i in 0 to C_TX_S_8-1 generate
        process(clk)
        begin
          if rising_edge(clk) then
            if iq_tx_enable_reg(i) = '1' then
              iq_i_tx_8_pipe(i) <= iq_tx_i_8;
              iq_q_tx_8_pipe(i) <= iq_tx_q_8;
            end if;
          end if;
        end process;
      end generate ch8_pipe_gen_1;
    end generate ch8_pipe_gen;

    -- Connect up the TX input buses to the internal (48 channel) IQ module.
    tx_ip_gen : for i in 1 to 48 generate
      process(iq_i_tx_1_pipe, iq_q_tx_1_pipe, iq_i_tx_2_pipe, iq_q_tx_2_pipe,
              iq_i_tx_3_pipe, iq_q_tx_3_pipe, iq_i_tx_4_pipe, iq_q_tx_4_pipe,
              iq_i_tx_5_pipe, iq_q_tx_5_pipe, iq_i_tx_6_pipe, iq_q_tx_6_pipe,
              iq_i_tx_7_pipe, iq_q_tx_7_pipe, iq_i_tx_8_pipe, iq_q_tx_8_pipe)
      begin
        if (i-1)*(2*C_TX_WIDTH_1) < C_TX_START_CH_2 then
          tx_iq_i_bus(i-1)(C_TX_WIDTH_1-1 downto 0) <= iq_i_tx_1_pipe(i-1);
          tx_iq_q_bus(i-1)(C_TX_WIDTH_1-1 downto 0) <= iq_q_tx_1_pipe(i-1);
        elsif C_TX_START_CH_2 + (i-C_TX_S_1-1)*(2*C_TX_WIDTH_2) < C_TX_START_CH_3 then
          tx_iq_i_bus(i-1)(C_TX_WIDTH_2-1 downto 0) <= iq_i_tx_2_pipe(i-C_TX_S_1-1);
          tx_iq_q_bus(i-1)(C_TX_WIDTH_2-1 downto 0) <= iq_q_tx_2_pipe(i-C_TX_S_1-1);
        elsif C_TX_START_CH_3 + (i-C_TX_S_1-C_TX_S_2-1)*(2*C_TX_WIDTH_3) < C_TX_START_CH_4 then
          tx_iq_i_bus(i-1)(C_TX_WIDTH_3-1 downto 0) <= iq_i_tx_3_pipe(i-C_TX_S_1-C_TX_S_2-1);
          tx_iq_q_bus(i-1)(C_TX_WIDTH_3-1 downto 0) <= iq_q_tx_3_pipe(i-C_TX_S_1-C_TX_S_2-1);
        elsif C_TX_START_CH_4 + (i-C_TX_S_1-C_TX_S_2-C_TX_S_3-1)*(2*C_TX_WIDTH_4) < C_TX_START_CH_5 then
          tx_iq_i_bus(i-1)(C_TX_WIDTH_4-1 downto 0) <= iq_i_tx_4_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-1);
          tx_iq_q_bus(i-1)(C_TX_WIDTH_4-1 downto 0) <= iq_q_tx_4_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-1);
        elsif C_TX_START_CH_5 + (i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-1)*(2*C_TX_WIDTH_5) < C_TX_START_CH_6 then
          tx_iq_i_bus(i-1)(C_TX_WIDTH_5-1 downto 0) <= iq_i_tx_5_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-1);
          tx_iq_q_bus(i-1)(C_TX_WIDTH_5-1 downto 0) <= iq_q_tx_5_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-1);
        elsif C_TX_START_CH_6 + (i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-1)*(2*C_TX_WIDTH_6) < C_TX_START_CH_7 then
          tx_iq_i_bus(i-1)(C_TX_WIDTH_6-1 downto 0) <= iq_i_tx_6_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-1);
          tx_iq_q_bus(i-1)(C_TX_WIDTH_6-1 downto 0) <= iq_q_tx_6_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-1);
        elsif C_TX_START_CH_7 + (i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-1)*(2*C_TX_WIDTH_7) < C_TX_START_CH_8 then
          tx_iq_i_bus(i-1)(C_TX_WIDTH_7-1 downto 0) <= iq_i_tx_7_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-1);
          tx_iq_q_bus(i-1)(C_TX_WIDTH_7-1 downto 0) <= iq_q_tx_7_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-1);
        elsif C_TX_START_CH_8 + (i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-C_TX_S_7-1)*(2*C_TX_WIDTH_8) < C_TX_END then
          tx_iq_i_bus(i-1)(C_TX_WIDTH_8-1 downto 0) <= iq_i_tx_8_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-C_TX_S_7-1);
          tx_iq_q_bus(i-1)(C_TX_WIDTH_8-1 downto 0) <= iq_q_tx_8_pipe(i-C_TX_S_1-C_TX_S_2-C_TX_S_3-C_TX_S_4-C_TX_S_5-C_TX_S_6-C_TX_S_7-1);
        else
          tx_iq_i_bus(i-1)(C_TX_WIDTH_8-1 downto 0) <= (others => '0');
          tx_iq_q_bus(i-1)(C_TX_WIDTH_8-1 downto 0) <= (others => '0');
        end if;
      end process;
    end generate tx_ip_gen;

    iq_tx_i_1_i  <= tx_iq_i_bus(0)(tx_calc_widths(1)-1 downto 0);
    iq_tx_q_1_i  <= tx_iq_q_bus(0)(tx_calc_widths(1)-1 downto 0);
    iq_tx_i_2_i  <= tx_iq_i_bus(1)(tx_calc_widths(2)-1 downto 0);
    iq_tx_q_2_i  <= tx_iq_q_bus(1)(tx_calc_widths(2)-1 downto 0);
    iq_tx_i_3_i  <= tx_iq_i_bus(2)(tx_calc_widths(3)-1 downto 0);
    iq_tx_q_3_i  <= tx_iq_q_bus(2)(tx_calc_widths(3)-1 downto 0);
    iq_tx_i_4_i  <= tx_iq_i_bus(3)(tx_calc_widths(4)-1 downto 0);
    iq_tx_q_4_i  <= tx_iq_q_bus(3)(tx_calc_widths(4)-1 downto 0);
    iq_tx_i_5_i  <= tx_iq_i_bus(4)(tx_calc_widths(5)-1 downto 0);
    iq_tx_q_5_i  <= tx_iq_q_bus(4)(tx_calc_widths(5)-1 downto 0);
    iq_tx_i_6_i  <= tx_iq_i_bus(5)(tx_calc_widths(6)-1 downto 0);
    iq_tx_q_6_i  <= tx_iq_q_bus(5)(tx_calc_widths(6)-1 downto 0);
    iq_tx_i_7_i  <= tx_iq_i_bus(6)(tx_calc_widths(7)-1 downto 0);
    iq_tx_q_7_i  <= tx_iq_q_bus(6)(tx_calc_widths(7)-1 downto 0);
    iq_tx_i_8_i  <= tx_iq_i_bus(7)(tx_calc_widths(8)-1 downto 0);
    iq_tx_q_8_i  <= tx_iq_q_bus(7)(tx_calc_widths(8)-1 downto 0);
    iq_tx_i_9_i  <= tx_iq_i_bus(8)(tx_calc_widths(9)-1 downto 0);
    iq_tx_q_9_i  <= tx_iq_q_bus(8)(tx_calc_widths(9)-1 downto 0);
    iq_tx_i_10_i <= tx_iq_i_bus(9)(tx_calc_widths(10)-1 downto 0);
    iq_tx_q_10_i <= tx_iq_q_bus(9)(tx_calc_widths(10)-1 downto 0);
    iq_tx_i_11_i <= tx_iq_i_bus(10)(tx_calc_widths(11)-1 downto 0);
    iq_tx_q_11_i <= tx_iq_q_bus(10)(tx_calc_widths(11)-1 downto 0);
    iq_tx_i_12_i <= tx_iq_i_bus(11)(tx_calc_widths(12)-1 downto 0);
    iq_tx_q_12_i <= tx_iq_q_bus(11)(tx_calc_widths(12)-1 downto 0);
    iq_tx_i_13_i <= tx_iq_i_bus(12)(tx_calc_widths(13)-1 downto 0);
    iq_tx_q_13_i <= tx_iq_q_bus(12)(tx_calc_widths(13)-1 downto 0);
    iq_tx_i_14_i <= tx_iq_i_bus(13)(tx_calc_widths(14)-1 downto 0);
    iq_tx_q_14_i <= tx_iq_q_bus(13)(tx_calc_widths(14)-1 downto 0);
    iq_tx_i_15_i <= tx_iq_i_bus(14)(tx_calc_widths(15)-1 downto 0);
    iq_tx_q_15_i <= tx_iq_q_bus(14)(tx_calc_widths(15)-1 downto 0);
    iq_tx_i_16_i <= tx_iq_i_bus(15)(tx_calc_widths(16)-1 downto 0);
    iq_tx_q_16_i <= tx_iq_q_bus(15)(tx_calc_widths(16)-1 downto 0);
    iq_tx_i_17_i <= tx_iq_i_bus(16)(tx_calc_widths(17)-1 downto 0);
    iq_tx_q_17_i <= tx_iq_q_bus(16)(tx_calc_widths(17)-1 downto 0);
    iq_tx_i_18_i <= tx_iq_i_bus(17)(tx_calc_widths(18)-1 downto 0);
    iq_tx_q_18_i <= tx_iq_q_bus(17)(tx_calc_widths(18)-1 downto 0);
    iq_tx_i_19_i <= tx_iq_i_bus(18)(tx_calc_widths(19)-1 downto 0);
    iq_tx_q_19_i <= tx_iq_q_bus(18)(tx_calc_widths(19)-1 downto 0);
    iq_tx_i_20_i <= tx_iq_i_bus(19)(tx_calc_widths(20)-1 downto 0);
    iq_tx_q_20_i <= tx_iq_q_bus(19)(tx_calc_widths(20)-1 downto 0);
    iq_tx_i_21_i <= tx_iq_i_bus(20)(tx_calc_widths(21)-1 downto 0);
    iq_tx_q_21_i <= tx_iq_q_bus(20)(tx_calc_widths(21)-1 downto 0);
    iq_tx_i_22_i <= tx_iq_i_bus(21)(tx_calc_widths(22)-1 downto 0);
    iq_tx_q_22_i <= tx_iq_q_bus(21)(tx_calc_widths(22)-1 downto 0);
    iq_tx_i_23_i <= tx_iq_i_bus(22)(tx_calc_widths(23)-1 downto 0);
    iq_tx_q_23_i <= tx_iq_q_bus(22)(tx_calc_widths(23)-1 downto 0);
    iq_tx_i_24_i <= tx_iq_i_bus(23)(tx_calc_widths(24)-1 downto 0);
    iq_tx_q_24_i <= tx_iq_q_bus(23)(tx_calc_widths(24)-1 downto 0);
    iq_tx_i_25_i <= tx_iq_i_bus(24)(tx_calc_widths(25)-1 downto 0);
    iq_tx_q_25_i <= tx_iq_q_bus(24)(tx_calc_widths(25)-1 downto 0);
    iq_tx_i_26_i <= tx_iq_i_bus(25)(tx_calc_widths(26)-1 downto 0);
    iq_tx_q_26_i <= tx_iq_q_bus(25)(tx_calc_widths(26)-1 downto 0);
    iq_tx_i_27_i <= tx_iq_i_bus(26)(tx_calc_widths(27)-1 downto 0);
    iq_tx_q_27_i <= tx_iq_q_bus(26)(tx_calc_widths(27)-1 downto 0);
    iq_tx_i_28_i <= tx_iq_i_bus(27)(tx_calc_widths(28)-1 downto 0);
    iq_tx_q_28_i <= tx_iq_q_bus(27)(tx_calc_widths(28)-1 downto 0);
    iq_tx_i_29_i <= tx_iq_i_bus(28)(tx_calc_widths(29)-1 downto 0);
    iq_tx_q_29_i <= tx_iq_q_bus(28)(tx_calc_widths(29)-1 downto 0);
    iq_tx_i_30_i <= tx_iq_i_bus(29)(tx_calc_widths(30)-1 downto 0);
    iq_tx_q_30_i <= tx_iq_q_bus(29)(tx_calc_widths(30)-1 downto 0);
    iq_tx_i_31_i <= tx_iq_i_bus(30)(tx_calc_widths(31)-1 downto 0);
    iq_tx_q_31_i <= tx_iq_q_bus(30)(tx_calc_widths(31)-1 downto 0);
    iq_tx_i_32_i <= tx_iq_i_bus(31)(tx_calc_widths(32)-1 downto 0);
    iq_tx_q_32_i <= tx_iq_q_bus(31)(tx_calc_widths(32)-1 downto 0);
    iq_tx_i_33_i <= tx_iq_i_bus(32)(tx_calc_widths(33)-1 downto 0);
    iq_tx_q_33_i <= tx_iq_q_bus(32)(tx_calc_widths(33)-1 downto 0);
    iq_tx_i_34_i <= tx_iq_i_bus(33)(tx_calc_widths(34)-1 downto 0);
    iq_tx_q_34_i <= tx_iq_q_bus(33)(tx_calc_widths(34)-1 downto 0);
    iq_tx_i_35_i <= tx_iq_i_bus(34)(tx_calc_widths(35)-1 downto 0);
    iq_tx_q_35_i <= tx_iq_q_bus(34)(tx_calc_widths(35)-1 downto 0);
    iq_tx_i_36_i <= tx_iq_i_bus(35)(tx_calc_widths(36)-1 downto 0);
    iq_tx_q_36_i <= tx_iq_q_bus(35)(tx_calc_widths(36)-1 downto 0);
    iq_tx_i_37_i <= tx_iq_i_bus(36)(tx_calc_widths(37)-1 downto 0);
    iq_tx_q_37_i <= tx_iq_q_bus(36)(tx_calc_widths(37)-1 downto 0);
    iq_tx_i_38_i <= tx_iq_i_bus(37)(tx_calc_widths(38)-1 downto 0);
    iq_tx_q_38_i <= tx_iq_q_bus(37)(tx_calc_widths(38)-1 downto 0);
    iq_tx_i_39_i <= tx_iq_i_bus(38)(tx_calc_widths(39)-1 downto 0);
    iq_tx_q_39_i <= tx_iq_q_bus(38)(tx_calc_widths(39)-1 downto 0);
    iq_tx_i_40_i <= tx_iq_i_bus(39)(tx_calc_widths(40)-1 downto 0);
    iq_tx_q_40_i <= tx_iq_q_bus(39)(tx_calc_widths(40)-1 downto 0);
    iq_tx_i_41_i <= tx_iq_i_bus(40)(tx_calc_widths(41)-1 downto 0);
    iq_tx_q_41_i <= tx_iq_q_bus(40)(tx_calc_widths(41)-1 downto 0);
    iq_tx_i_42_i <= tx_iq_i_bus(41)(tx_calc_widths(42)-1 downto 0);
    iq_tx_q_42_i <= tx_iq_q_bus(41)(tx_calc_widths(42)-1 downto 0);
    iq_tx_i_43_i <= tx_iq_i_bus(42)(tx_calc_widths(43)-1 downto 0);
    iq_tx_q_43_i <= tx_iq_q_bus(42)(tx_calc_widths(43)-1 downto 0);
    iq_tx_i_44_i <= tx_iq_i_bus(43)(tx_calc_widths(44)-1 downto 0);
    iq_tx_q_44_i <= tx_iq_q_bus(43)(tx_calc_widths(44)-1 downto 0);
    iq_tx_i_45_i <= tx_iq_i_bus(44)(tx_calc_widths(45)-1 downto 0);
    iq_tx_q_45_i <= tx_iq_q_bus(44)(tx_calc_widths(45)-1 downto 0);
    iq_tx_i_46_i <= tx_iq_i_bus(45)(tx_calc_widths(46)-1 downto 0);
    iq_tx_q_46_i <= tx_iq_q_bus(45)(tx_calc_widths(46)-1 downto 0);
    iq_tx_i_47_i <= tx_iq_i_bus(46)(tx_calc_widths(47)-1 downto 0);
    iq_tx_q_47_i <= tx_iq_q_bus(46)(tx_calc_widths(47)-1 downto 0);
    iq_tx_i_48_i <= tx_iq_i_bus(47)(tx_calc_widths(48)-1 downto 0);
    iq_tx_q_48_i <= tx_iq_q_bus(47)(tx_calc_widths(48)-1 downto 0);

    -- Generate iq_tx_data_enables to the client
    -- The number of clock cycles these are asserted for corresponds to the
    -- number of samples in the channel.
    data_en_gen : for i in 0 to 7 generate
      iq_tx_data_enable_pipe(i) <= iq_tx_enable_reg(0) when tx_sample_size_array(i+1) = 1 else
                                 (iq_tx_enable_reg(0)
                               or iq_tx_enable_reg(1)) when tx_sample_size_array(i+1) = 2 else
                                 (iq_tx_enable_reg(0)
                               or iq_tx_enable_reg(1)
                               or iq_tx_enable_reg(2)) when tx_sample_size_array(i+1) = 3 else
                               (iq_tx_enable_reg(0)
                               or iq_tx_enable_reg(1)
                               or iq_tx_enable_reg(2)
                               or iq_tx_enable_reg(3)) when tx_sample_size_array(i+1) = 4 else
                               (iq_tx_enable_reg(0)
                               or iq_tx_enable_reg(1)
                               or iq_tx_enable_reg(2)
                               or iq_tx_enable_reg(3)
                               or iq_tx_enable_reg(4)) when tx_sample_size_array(i+1) = 5 else
                               (iq_tx_enable_reg(0)
                               or iq_tx_enable_reg(1)
                               or iq_tx_enable_reg(2)
                               or iq_tx_enable_reg(3)
                               or iq_tx_enable_reg(4)
                               or iq_tx_enable_reg(5)) when tx_sample_size_array(i+1) = 6 else
                               (iq_tx_enable_reg(0)
                               or iq_tx_enable_reg(1)
                               or iq_tx_enable_reg(2)
                               or iq_tx_enable_reg(3)
                               or iq_tx_enable_reg(4)
                               or iq_tx_enable_reg(5)
                               or iq_tx_enable_reg(6)) when tx_sample_size_array(i+1) = 7 else
                               (iq_tx_enable_reg(0)
                               or iq_tx_enable_reg(1)
                               or iq_tx_enable_reg(2)
                               or iq_tx_enable_reg(3)
                               or iq_tx_enable_reg(4)
                               or iq_tx_enable_reg(5)
                               or iq_tx_enable_reg(6)
                               or iq_tx_enable_reg(7)) when tx_sample_size_array(i+1) = 8 else
                               '0';
    end generate data_en_gen;

    iq_tx_data_enable_1 <= iq_tx_data_enable_pipe(0);
    iq_tx_data_enable_2 <= iq_tx_data_enable_pipe(1);
    iq_tx_data_enable_3 <= iq_tx_data_enable_pipe(2);
    iq_tx_data_enable_4 <= iq_tx_data_enable_pipe(3);
    iq_tx_data_enable_5 <= iq_tx_data_enable_pipe(4);
    iq_tx_data_enable_6 <= iq_tx_data_enable_pipe(5);
    iq_tx_data_enable_7 <= iq_tx_data_enable_pipe(6);
    iq_tx_data_enable_8 <= iq_tx_data_enable_pipe(7);

    -- Receive side. Recover the received samples of the 8 EUTRA
    -- channels from the single samples in each of the
    -- 48 channels of the IQ module.
    process(clk)
    begin
      if rising_edge(clk) then
        if basic_frame_first_word = '1' then
          count <= (others => '0');
        elsif count < 8 then
          count <= count + 1;
        end if;
        basic_frame_first_word_reg(0) <= basic_frame_first_word;
        basic_frame_first_word_reg(8 downto 1) <= basic_frame_first_word_reg(7 downto 0);
      end if;
    end process;

    -- Connect up the RX output buses from the internal (48 channel) IQ module
    -- to the 8 channel outputs of the EUTRA IQ module.
    -- Sample when basic_frame_first_word is high.
    process(clk)
    begin
      if rising_edge(clk) then
        if basic_frame_first_word = '1' then
          rx_iq_i_bus(0)(rx_calc_widths(1)-1 downto 0)   <= iq_rx_i_1_i;
          rx_iq_q_bus(0)(rx_calc_widths(1)-1 downto 0)   <= iq_rx_q_1_i;
          rx_iq_i_bus(1)(rx_calc_widths(2)-1 downto 0)   <= iq_rx_i_2_i;
          rx_iq_q_bus(1)(rx_calc_widths(2)-1 downto 0)   <= iq_rx_q_2_i;
          rx_iq_i_bus(2)(rx_calc_widths(3)-1 downto 0)   <= iq_rx_i_3_i;
          rx_iq_q_bus(2)(rx_calc_widths(3)-1 downto 0)   <= iq_rx_q_3_i;
          rx_iq_i_bus(3)(rx_calc_widths(4)-1 downto 0)   <= iq_rx_i_4_i;
          rx_iq_q_bus(3)(rx_calc_widths(4)-1 downto 0)   <= iq_rx_q_4_i;
          rx_iq_i_bus(4)(rx_calc_widths(5)-1 downto 0)   <= iq_rx_i_5_i;
          rx_iq_q_bus(4)(rx_calc_widths(5)-1 downto 0)   <= iq_rx_q_5_i;
          rx_iq_i_bus(5)(rx_calc_widths(6)-1 downto 0)   <= iq_rx_i_6_i;
          rx_iq_q_bus(5)(rx_calc_widths(6)-1 downto 0)   <= iq_rx_q_6_i;
          rx_iq_i_bus(6)(rx_calc_widths(7)-1 downto 0)   <= iq_rx_i_7_i;
          rx_iq_q_bus(6)(rx_calc_widths(7)-1 downto 0)   <= iq_rx_q_7_i;
          rx_iq_i_bus(7)(rx_calc_widths(8)-1 downto 0)   <= iq_rx_i_8_i;
          rx_iq_q_bus(7)(rx_calc_widths(8)-1 downto 0)   <= iq_rx_q_8_i;
          rx_iq_i_bus(8)(rx_calc_widths(9)-1 downto 0)   <= iq_rx_i_9_i;
          rx_iq_q_bus(8)(rx_calc_widths(9)-1 downto 0)   <= iq_rx_q_9_i;
          rx_iq_i_bus(9)(rx_calc_widths(10)-1 downto 0)  <= iq_rx_i_10_i;
          rx_iq_q_bus(9)(rx_calc_widths(10)-1 downto 0)  <= iq_rx_q_10_i;
          rx_iq_i_bus(10)(rx_calc_widths(11)-1 downto 0) <= iq_rx_i_11_i;
          rx_iq_q_bus(10)(rx_calc_widths(11)-1 downto 0) <= iq_rx_q_11_i;
          rx_iq_i_bus(11)(rx_calc_widths(12)-1 downto 0) <= iq_rx_i_12_i;
          rx_iq_q_bus(11)(rx_calc_widths(12)-1 downto 0) <= iq_rx_q_12_i;
          rx_iq_i_bus(12)(rx_calc_widths(13)-1 downto 0) <= iq_rx_i_13_i;
          rx_iq_q_bus(12)(rx_calc_widths(13)-1 downto 0) <= iq_rx_q_13_i;
          rx_iq_i_bus(13)(rx_calc_widths(14)-1 downto 0) <= iq_rx_i_14_i;
          rx_iq_q_bus(13)(rx_calc_widths(14)-1 downto 0) <= iq_rx_q_14_i;
          rx_iq_i_bus(14)(rx_calc_widths(15)-1 downto 0) <= iq_rx_i_15_i;
          rx_iq_q_bus(14)(rx_calc_widths(15)-1 downto 0) <= iq_rx_q_15_i;
          rx_iq_i_bus(15)(rx_calc_widths(16)-1 downto 0) <= iq_rx_i_16_i;
          rx_iq_q_bus(15)(rx_calc_widths(16)-1 downto 0) <= iq_rx_q_16_i;
          rx_iq_i_bus(16)(rx_calc_widths(17)-1 downto 0) <= iq_rx_i_17_i;
          rx_iq_q_bus(16)(rx_calc_widths(17)-1 downto 0) <= iq_rx_q_17_i;
          rx_iq_i_bus(17)(rx_calc_widths(18)-1 downto 0) <= iq_rx_i_18_i;
          rx_iq_q_bus(17)(rx_calc_widths(18)-1 downto 0) <= iq_rx_q_18_i;
          rx_iq_i_bus(18)(rx_calc_widths(19)-1 downto 0) <= iq_rx_i_19_i;
          rx_iq_q_bus(18)(rx_calc_widths(19)-1 downto 0) <= iq_rx_q_19_i;
          rx_iq_i_bus(19)(rx_calc_widths(20)-1 downto 0) <= iq_rx_i_20_i;
          rx_iq_q_bus(19)(rx_calc_widths(20)-1 downto 0) <= iq_rx_q_20_i;
          rx_iq_i_bus(20)(rx_calc_widths(21)-1 downto 0) <= iq_rx_i_21_i;
          rx_iq_q_bus(20)(rx_calc_widths(21)-1 downto 0) <= iq_rx_q_21_i;
          rx_iq_i_bus(21)(rx_calc_widths(22)-1 downto 0) <= iq_rx_i_22_i;
          rx_iq_q_bus(21)(rx_calc_widths(22)-1 downto 0) <= iq_rx_q_22_i;
          rx_iq_i_bus(22)(rx_calc_widths(23)-1 downto 0) <= iq_rx_i_23_i;
          rx_iq_q_bus(22)(rx_calc_widths(23)-1 downto 0) <= iq_rx_q_23_i;
          rx_iq_i_bus(23)(rx_calc_widths(24)-1 downto 0) <= iq_rx_i_24_i;
          rx_iq_q_bus(23)(rx_calc_widths(24)-1 downto 0) <= iq_rx_q_24_i;
          rx_iq_i_bus(24)(rx_calc_widths(25)-1 downto 0) <= iq_rx_i_25_i;
          rx_iq_q_bus(24)(rx_calc_widths(25)-1 downto 0) <= iq_rx_q_25_i;
          rx_iq_i_bus(25)(rx_calc_widths(26)-1 downto 0) <= iq_rx_i_26_i;
          rx_iq_q_bus(25)(rx_calc_widths(26)-1 downto 0) <= iq_rx_q_26_i;
          rx_iq_i_bus(26)(rx_calc_widths(27)-1 downto 0) <= iq_rx_i_27_i;
          rx_iq_q_bus(26)(rx_calc_widths(27)-1 downto 0) <= iq_rx_q_27_i;
          rx_iq_i_bus(27)(rx_calc_widths(28)-1 downto 0) <= iq_rx_i_28_i;
          rx_iq_q_bus(27)(rx_calc_widths(28)-1 downto 0) <= iq_rx_q_28_i;
          rx_iq_i_bus(28)(rx_calc_widths(29)-1 downto 0) <= iq_rx_i_29_i;
          rx_iq_q_bus(28)(rx_calc_widths(29)-1 downto 0) <= iq_rx_q_29_i;
          rx_iq_i_bus(29)(rx_calc_widths(30)-1 downto 0) <= iq_rx_i_30_i;
          rx_iq_q_bus(29)(rx_calc_widths(30)-1 downto 0) <= iq_rx_q_30_i;
          rx_iq_i_bus(30)(rx_calc_widths(31)-1 downto 0) <= iq_rx_i_31_i;
          rx_iq_q_bus(30)(rx_calc_widths(31)-1 downto 0) <= iq_rx_q_31_i;
          rx_iq_i_bus(31)(rx_calc_widths(32)-1 downto 0) <= iq_rx_i_32_i;
          rx_iq_q_bus(31)(rx_calc_widths(32)-1 downto 0) <= iq_rx_q_32_i;
          rx_iq_i_bus(32)(rx_calc_widths(33)-1 downto 0) <= iq_rx_i_33_i;
          rx_iq_q_bus(32)(rx_calc_widths(33)-1 downto 0) <= iq_rx_q_33_i;
          rx_iq_i_bus(33)(rx_calc_widths(34)-1 downto 0) <= iq_rx_i_34_i;
          rx_iq_q_bus(33)(rx_calc_widths(34)-1 downto 0) <= iq_rx_q_34_i;
          rx_iq_i_bus(34)(rx_calc_widths(35)-1 downto 0) <= iq_rx_i_35_i;
          rx_iq_q_bus(34)(rx_calc_widths(35)-1 downto 0) <= iq_rx_q_35_i;
          rx_iq_i_bus(35)(rx_calc_widths(36)-1 downto 0) <= iq_rx_i_36_i;
          rx_iq_q_bus(35)(rx_calc_widths(36)-1 downto 0) <= iq_rx_q_36_i;
          rx_iq_i_bus(36)(rx_calc_widths(37)-1 downto 0) <= iq_rx_i_37_i;
          rx_iq_q_bus(36)(rx_calc_widths(37)-1 downto 0) <= iq_rx_q_37_i;
          rx_iq_i_bus(37)(rx_calc_widths(38)-1 downto 0) <= iq_rx_i_38_i;
          rx_iq_q_bus(37)(rx_calc_widths(38)-1 downto 0) <= iq_rx_q_38_i;
          rx_iq_i_bus(38)(rx_calc_widths(39)-1 downto 0) <= iq_rx_i_39_i;
          rx_iq_q_bus(38)(rx_calc_widths(39)-1 downto 0) <= iq_rx_q_39_i;
          rx_iq_i_bus(39)(rx_calc_widths(40)-1 downto 0) <= iq_rx_i_40_i;
          rx_iq_q_bus(39)(rx_calc_widths(40)-1 downto 0) <= iq_rx_q_40_i;
          rx_iq_i_bus(40)(rx_calc_widths(41)-1 downto 0) <= iq_rx_i_41_i;
          rx_iq_q_bus(40)(rx_calc_widths(41)-1 downto 0) <= iq_rx_q_41_i;
          rx_iq_i_bus(41)(rx_calc_widths(42)-1 downto 0) <= iq_rx_i_42_i;
          rx_iq_q_bus(41)(rx_calc_widths(42)-1 downto 0) <= iq_rx_q_42_i;
          rx_iq_i_bus(42)(rx_calc_widths(43)-1 downto 0) <= iq_rx_i_43_i;
          rx_iq_q_bus(42)(rx_calc_widths(43)-1 downto 0) <= iq_rx_q_43_i;
          rx_iq_i_bus(43)(rx_calc_widths(44)-1 downto 0) <= iq_rx_i_44_i;
          rx_iq_q_bus(43)(rx_calc_widths(44)-1 downto 0) <= iq_rx_q_44_i;
          rx_iq_i_bus(44)(rx_calc_widths(45)-1 downto 0) <= iq_rx_i_45_i;
          rx_iq_q_bus(44)(rx_calc_widths(45)-1 downto 0) <= iq_rx_q_45_i;
          rx_iq_i_bus(45)(rx_calc_widths(46)-1 downto 0) <= iq_rx_i_46_i;
          rx_iq_q_bus(45)(rx_calc_widths(46)-1 downto 0) <= iq_rx_q_46_i;
          rx_iq_i_bus(46)(rx_calc_widths(47)-1 downto 0) <= iq_rx_i_47_i;
          rx_iq_q_bus(46)(rx_calc_widths(47)-1 downto 0) <= iq_rx_q_47_i;
          rx_iq_i_bus(47)(rx_calc_widths(48)-1 downto 0) <= iq_rx_i_48_i;
          rx_iq_q_bus(47)(rx_calc_widths(48)-1 downto 0) <= iq_rx_q_48_i;
        end if;
      end if;
    end process;

    -- Construct the output data pipelines for each of the 8 E-UTRA channels.
    c1_rx_if : if C_RX_WIDTH_1 > 0 generate
      ch1_rx : for i in 0 to C_RX_S_1-1 generate
        iq_i_rx_1_pipe(i) <= rx_iq_i_bus(i)(C_RX_WIDTH_1-1 downto 0);
        iq_q_rx_1_pipe(i) <= rx_iq_q_bus(i)(C_RX_WIDTH_1-1 downto 0);
      end generate;
    end generate;
    c2_rx_if : if C_RX_WIDTH_2 > 0 generate
      ch2_rx : for i in 0 to C_RX_S_2-1 generate
        iq_i_rx_2_pipe(i) <= rx_iq_i_bus(C_RX_S_1+i)(C_RX_WIDTH_2-1 downto 0);
        iq_q_rx_2_pipe(i) <= rx_iq_q_bus(C_RX_S_1+i)(C_RX_WIDTH_2-1 downto 0);
      end generate;
    end generate;
    c3_rx_if : if C_RX_WIDTH_3 > 0 generate
      ch3_rx : for i in 0 to C_RX_S_3-1 generate
        iq_i_rx_3_pipe(i) <= rx_iq_i_bus(C_RX_S_1+C_RX_S_2+i)(C_RX_WIDTH_3-1 downto 0);
        iq_q_rx_3_pipe(i) <= rx_iq_q_bus(C_RX_S_1+C_RX_S_2+i)(C_RX_WIDTH_3-1 downto 0);
      end generate;
    end generate;
    c4_rx_if : if C_RX_WIDTH_4 > 0 generate
      ch4_rx : for i in 0 to C_RX_S_4-1 generate
        iq_i_rx_4_pipe(i) <= rx_iq_i_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+i)(C_RX_WIDTH_4-1 downto 0);
        iq_q_rx_4_pipe(i) <= rx_iq_q_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+i)(C_RX_WIDTH_4-1 downto 0);
      end generate;
    end generate;
    c5_rx_if : if C_RX_WIDTH_5 > 0 generate
      ch5_rx : for i in 0 to C_RX_S_5-1 generate
        iq_i_rx_5_pipe(i) <= rx_iq_i_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+C_RX_S_4+i)(C_RX_WIDTH_5-1 downto 0);
        iq_q_rx_5_pipe(i) <= rx_iq_q_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+C_RX_S_4+i)(C_RX_WIDTH_5-1 downto 0);
      end generate;
    end generate;
    c6_rx_if : if C_RX_WIDTH_6 > 0 generate
      ch6_rx : for i in 0 to C_RX_S_6-1 generate
        iq_i_rx_6_pipe(i) <= rx_iq_i_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+C_RX_S_4+C_RX_S_5+i)(C_RX_WIDTH_6-1 downto 0);
        iq_q_rx_6_pipe(i) <= rx_iq_q_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+C_RX_S_4+C_RX_S_5+i)(C_RX_WIDTH_6-1 downto 0);
      end generate;
    end generate;
    c7_rx_if : if C_RX_WIDTH_7 > 0 generate
      ch7_rx : for i in 0 to C_RX_S_7-1 generate
        iq_i_rx_7_pipe(i) <= rx_iq_i_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+C_RX_S_4+C_RX_S_5+C_RX_S_6+i)(C_RX_WIDTH_7-1 downto 0);
        iq_q_rx_7_pipe(i) <= rx_iq_q_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+C_RX_S_4+C_RX_S_5+C_RX_S_6+i)(C_RX_WIDTH_7-1 downto 0);
      end generate;
    end generate;
    c8_rx_if : if C_RX_WIDTH_8 > 0 generate
      ch8_rx : for i in 0 to C_RX_S_8-1 generate
        iq_i_rx_8_pipe(i) <= rx_iq_i_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+C_RX_S_4+C_RX_S_5+C_RX_S_6+C_RX_S_7+i)(C_RX_WIDTH_8-1 downto 0);
        iq_q_rx_8_pipe(i) <= rx_iq_q_bus(C_RX_S_1+C_RX_S_2+C_RX_S_3+C_RX_S_4+C_RX_S_5+C_RX_S_6+C_RX_S_7+i)(C_RX_WIDTH_8-1 downto 0);
      end generate;
    end generate;

    -- This process outputs the samples in the pipelines sequentially
    -- on the 8 EUTRA channel outputs. Which sample is output depends on the
    -- position of the basic_frame_first_word pulse in the
    -- basic_frame_first_word_reg pipeline.
    -- Channel 1
    ch1_rx_pipe_gen : if C_RX_WIDTH_1 > 0 generate
      process(clk)
      begin
        if rising_edge(clk) then
          if basic_frame_first_word_reg(to_integer(count)) = '1' and count < C_RX_S_1 then
            iq_rx_i_1 <= iq_i_rx_1_pipe(to_integer(count));
            iq_rx_q_1 <= iq_q_rx_1_pipe(to_integer(count));
          else
            iq_rx_i_1 <= (others => '0');
            iq_rx_q_1 <= (others => '0');
          end if;
        end if;
      end process;
    end generate ch1_rx_pipe_gen;

    -- Channel 2
    ch2_rx_pipe_gen : if C_RX_WIDTH_2 > 0 generate
      process(clk)
      begin
        if rising_edge(clk) then
          if basic_frame_first_word_reg(to_integer(count)) = '1' and count < C_RX_S_2 then
            iq_rx_i_2 <= iq_i_rx_2_pipe(to_integer(count));
            iq_rx_q_2 <= iq_q_rx_2_pipe(to_integer(count));
          else
            iq_rx_i_2 <= (others => '0');
            iq_rx_q_2 <= (others => '0');
          end if;
        end if;
      end process;
    end generate ch2_rx_pipe_gen;

    -- Channel 3
    ch3_rx_pipe_gen : if C_RX_WIDTH_3 > 0 generate
      process(clk)
      begin
        if rising_edge(clk) then
          if basic_frame_first_word_reg(to_integer(count)) = '1' and count < C_RX_S_3 then
            iq_rx_i_3 <= iq_i_rx_3_pipe(to_integer(count));
            iq_rx_q_3 <= iq_q_rx_3_pipe(to_integer(count));
          else
            iq_rx_i_3 <= (others => '0');
            iq_rx_q_3 <= (others => '0');
          end if;
        end if;
      end process;
    end generate ch3_rx_pipe_gen;

    -- Channel 4
    ch4_rx_pipe_gen : if C_RX_WIDTH_4 > 0 generate
      process(clk)
      begin
        if rising_edge(clk) then
          if basic_frame_first_word_reg(to_integer(count)) = '1' and count < C_RX_S_4 then
            iq_rx_i_4 <= iq_i_rx_4_pipe(to_integer(count));
            iq_rx_q_4 <= iq_q_rx_4_pipe(to_integer(count));
          else
            iq_rx_i_4 <= (others => '0');
            iq_rx_q_4 <= (others => '0');
          end if;
        end if;
      end process;
    end generate ch4_rx_pipe_gen;

    -- Channel 5
    ch5_rx_pipe_gen : if C_RX_WIDTH_5 > 0 generate
      process(clk)
      begin
        if rising_edge(clk) then
          if basic_frame_first_word_reg(to_integer(count)) = '1' and count < C_RX_S_5 then
            iq_rx_i_5 <= iq_i_rx_5_pipe(to_integer(count));
            iq_rx_q_5 <= iq_q_rx_5_pipe(to_integer(count));
          else
            iq_rx_i_5 <= (others => '0');
            iq_rx_q_5 <= (others => '0');
          end if;
        end if;
      end process;
    end generate ch5_rx_pipe_gen;

    -- Channel 6
    ch6_rx_pipe_gen : if C_RX_WIDTH_6 > 0 generate
      process(clk)
      begin
        if rising_edge(clk) then
          if basic_frame_first_word_reg(to_integer(count)) = '1' and count < C_RX_S_6 then
            iq_rx_i_6 <= iq_i_rx_6_pipe(to_integer(count));
            iq_rx_q_6 <= iq_q_rx_6_pipe(to_integer(count));
          else
            iq_rx_i_6 <= (others => '0');
            iq_rx_q_6 <= (others => '0');
          end if;
        end if;
      end process;
    end generate ch6_rx_pipe_gen;

    -- Channel 7
    ch7_rx_pipe_gen : if C_RX_WIDTH_7 > 0 generate
      process(clk)
      begin
        if rising_edge(clk) then
          if basic_frame_first_word_reg(to_integer(count)) = '1' and count < C_RX_S_7 then
            iq_rx_i_7 <= iq_i_rx_7_pipe(to_integer(count));
            iq_rx_q_7 <= iq_q_rx_7_pipe(to_integer(count));
          else
            iq_rx_i_7 <= (others => '0');
            iq_rx_q_7 <= (others => '0');
          end if;
        end if;
      end process;
    end generate ch7_rx_pipe_gen;

    -- Channel 8
    ch8_rx_pipe_gen : if C_RX_WIDTH_8 > 0 generate
      process(clk)
      begin
        if rising_edge(clk) then
          if basic_frame_first_word_reg(to_integer(count)) = '1' and count < C_RX_S_8 then
            iq_rx_i_8 <= iq_i_rx_8_pipe(to_integer(count));
            iq_rx_q_8 <= iq_q_rx_8_pipe(to_integer(count));
          else
            iq_rx_i_8 <= (others => '0');
            iq_rx_q_8 <= (others => '0');
          end if;
        end if;
      end process;
    end generate ch8_rx_pipe_gen;

    -- Generate iq_rx_data_valids to the client
    -- The number of clock cycles these are asserted for corresponds to the
    -- number of samples in the channel.
    data_val_gen : for i in 0 to 7 generate
      basic_frame_first_word_pipe(i) <= basic_frame_first_word_reg(1) when rx_sample_size_array(i+1) = 1 else
                                 (basic_frame_first_word_reg(1)
                               or basic_frame_first_word_reg(2)) when rx_sample_size_array(i+1) = 2 else
                                 (basic_frame_first_word_reg(1)
                               or basic_frame_first_word_reg(2)
                               or basic_frame_first_word_reg(3)) when rx_sample_size_array(i+1) = 3 else
                               (basic_frame_first_word_reg(1)
                               or basic_frame_first_word_reg(2)
                               or basic_frame_first_word_reg(3)
                               or basic_frame_first_word_reg(4)) when rx_sample_size_array(i+1) = 4 else
                               (basic_frame_first_word_reg(1)
                               or basic_frame_first_word_reg(2)
                               or basic_frame_first_word_reg(3)
                               or basic_frame_first_word_reg(4)
                               or basic_frame_first_word_reg(5)) when rx_sample_size_array(i+1) = 5 else
                               (basic_frame_first_word_reg(1)
                               or basic_frame_first_word_reg(2)
                               or basic_frame_first_word_reg(3)
                               or basic_frame_first_word_reg(4)
                               or basic_frame_first_word_reg(5)
                               or basic_frame_first_word_reg(6)) when rx_sample_size_array(i+1) = 6 else
                               (basic_frame_first_word_reg(1)
                               or basic_frame_first_word_reg(2)
                               or basic_frame_first_word_reg(3)
                               or basic_frame_first_word_reg(4)
                               or basic_frame_first_word_reg(5)
                               or basic_frame_first_word_reg(6)
                               or basic_frame_first_word_reg(7)) when rx_sample_size_array(i+1) = 7 else
                               (basic_frame_first_word_reg(1)
                               or basic_frame_first_word_reg(2)
                               or basic_frame_first_word_reg(3)
                               or basic_frame_first_word_reg(4)
                               or basic_frame_first_word_reg(5)
                               or basic_frame_first_word_reg(6)
                               or basic_frame_first_word_reg(7)
                               or basic_frame_first_word_reg(8)) when rx_sample_size_array(i+1) = 8 else
                               '0';
    end generate data_val_gen;

    iq_rx_data_valid_1 <= basic_frame_first_word_pipe(0);
    iq_rx_data_valid_2 <= basic_frame_first_word_pipe(1);
    iq_rx_data_valid_3 <= basic_frame_first_word_pipe(2);
    iq_rx_data_valid_4 <= basic_frame_first_word_pipe(3);
    iq_rx_data_valid_5 <= basic_frame_first_word_pipe(4);
    iq_rx_data_valid_6 <= basic_frame_first_word_pipe(5);
    iq_rx_data_valid_7 <= basic_frame_first_word_pipe(6);
    iq_rx_data_valid_8 <= basic_frame_first_word_pipe(7);


end architecture rtl;
