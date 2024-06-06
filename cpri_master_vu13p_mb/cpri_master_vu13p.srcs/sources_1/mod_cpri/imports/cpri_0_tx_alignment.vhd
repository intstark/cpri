-----------------------------------------------------------------------
-- Title      : Tx Alignment
-- Project    : CPRI
-----------------------------------------------------------------------
-- File       : cpri_0_tx_alignment.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: Multi-lane manual mode phase alignment block performs 
--              the alignment for multiple transceivers.
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

library unisim;
use unisim.vcomponents.all;

library cpri_v8_11_17;
use cpri_v8_11_17.all;

entity cpri_0_tx_alignment is
  Generic( 
        MASTER_LANE_ID           : integer range 0 to 31:= 0   -- Number of the lane which is considered the master in manual phase-alignment
    );     
    Port ( stable_clk             : in  std_logic;              --Stable Clock, either a stable clock from the PCB
                                                                --or reference-clock present at startup.
           reset_phalignment      : in  std_logic;
           txphaligndone_vec      : in  std_logic_vector(3 downto 0);
           txphinitdone_vec       : in  std_logic_vector(3 downto 0);
           txdlysresetdone_vec    : in  std_logic_vector(3 downto 0);
           txphinit_vec           : out std_logic_vector(3 downto 0);
           phase_alignment_done   : out std_logic := '0';       -- Manual phase-alignment performed sucessfully  
           txdlysreset_vec        : out std_logic_vector(3 downto 0);
           txphalign_vec          : out std_logic_vector(3 downto 0);
           txdlyen_vec            : out std_logic_vector(3 downto 0)
           );
end cpri_0_tx_alignment;

architecture rtl of cpri_0_tx_alignment is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";


  component cpri_0_tx_sync 
  Generic( NUMBER_OF_LANES          : integer range 1 to 32:= 4;  -- Number of lanes that are controlled using this FSM.
           MASTER_LANE_ID           : integer range 0 to 31:= 0   -- Number of the lane which is considered the master in manual phase-alignment
         );     

    Port ( STABLE_CLOCK             : in  STD_LOGIC;              --Stable Clock, either a stable clock from the PCB
                                                                  --or reference-clock present at startup.
           RESET_PHALIGNMENT        : in  STD_LOGIC;
           RUN_PHALIGNMENT          : in  STD_LOGIC;
           PHASE_ALIGNMENT_DONE     : out STD_LOGIC := '0';       -- Manual phase-alignment performed sucessfully  
           TXDLYSRESET              : out STD_LOGIC_VECTOR(NUMBER_OF_LANES-1 downto 0) := (others=> '0');
           TXDLYSRESETDONE          : in  STD_LOGIC_VECTOR(NUMBER_OF_LANES-1 downto 0);
           TXPHINIT                 : out STD_LOGIC_VECTOR(NUMBER_OF_LANES-1 downto 0) := (others=> '0');
           TXPHINITDONE             : in  STD_LOGIC_VECTOR(NUMBER_OF_LANES-1 downto 0);
           TXPHALIGN                : out STD_LOGIC_VECTOR(NUMBER_OF_LANES-1 downto 0) := (others=> '0');
           TXPHALIGNDONE            : in  STD_LOGIC_VECTOR(NUMBER_OF_LANES-1 downto 0);
           TXDLYEN                  : out STD_LOGIC_VECTOR(NUMBER_OF_LANES-1 downto 0) := (others=> '0')
           );
  end component;

  signal stretch_r                : std_logic_vector(2 downto 0) := "000";
  signal sync1_r                  : std_logic_vector(2 downto 0) := "000";
  signal sync2_r                  : std_logic_vector(2 downto 0) := "000";


begin
    --------------------------- TX Buffer Bypass Logic --------------------
    -- The TX SYNC Module drives the ports needed to Bypass the TX Buffer.
    -- Include the TX SYNC module in your own design if TX Buffer is bypassed.
    
    tx_sync_i : cpri_0_tx_sync
    generic map
    ( NUMBER_OF_LANES     =>  4,
      MASTER_LANE_ID      =>  0
    )
    port map
    (
        STABLE_CLOCK                    =>      stable_clk,
        RESET_PHALIGNMENT               =>      reset_phalignment,
        RUN_PHALIGNMENT                 =>      '1',
        PHASE_ALIGNMENT_DONE            =>      phase_alignment_done,
        TXDLYSRESET                     =>      txdlysreset_vec,
        TXDLYSRESETDONE                 =>      txdlysresetdone_vec,
        TXPHINIT                        =>      txphinit_vec,
        TXPHINITDONE                    =>      txphinitdone_vec,
        TXPHALIGN                       =>      txphalign_vec,
        TXPHALIGNDONE                   =>      txphaligndone_vec,
        TXDLYEN                         =>      txdlyen_vec
    );
 
end rtl;
