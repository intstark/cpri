--------------------------------------------------------------------------
-- Title : Tx Alignment
-- Project : CPRI
--------------------------------------------------------------------------
-- File : cpri_slave_0_tx_alignment.vhd
--------------------------------------------------------------------------
-- Description: Multi-lane manual mode phase alignment block performs 
-- the alignment for multiple transceivers.
--------------------------------------------------------------------------

--***********************************Entity Declaration*******************************
library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

library cpri_v8_11_5;
use cpri_v8_11_5.all;

entity cpri_slave_0_tx_alignment is
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
end cpri_slave_0_tx_alignment;

architecture rtl of cpri_slave_0_tx_alignment is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";


  component cpri_slave_0_tx_sync 
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
    
    tx_sync_i : cpri_slave_0_tx_sync
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
